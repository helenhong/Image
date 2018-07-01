#Advanced Debugging with Xcode and LLDB_WWDC 2018 Xcode的一些调试技巧
整个session有两部分。第一部分是lldb命令行调试，可以在不重新编译和重新运行Project的条件下修复bug。第二部分是界面调试。

##Advanced Debugging Tips and Tricks LLDB命令行调试
发布会上配合solar system demo来演示这些技巧。

首先展示了moon jumper这个游戏里的bugs, 这是一个模拟宇航员在月球上起跳的游戏。游戏截图如下：
![1](https://ws3.sinaimg.cn/large/006tNc79gy1fsuqclt8u8j30ah0ldgom.jpg)

bug如下：

* 1. Jump failed animation does not match spec.
	起跳达不到图中指定的高度后，人物落地动画和预期不相符合。
* 2. "Attempt" and "Score" label values flash but do not change
	Attempt 表示起跳次数，Score表示得分，这两个UILabel的text在展示完动画之后并没有刷新。
* 3. Games dose not end after 10 attempts
	游戏预期要在10次尝试后结束，测试结果却是没有结束。
* 4. Layout of "Attempt" and "Score" labels needs work
	Attempt 和 Score 的位置不正确。

在不重新编译和运行project的前提下，复现bug, 并且解决问题。使用了如下这些技巧, 每一个技巧都用demo里列出来的bug做演示。
###1、Configure behaviors to dedicate a tab for debugging
Xcode 可以在偏好设置里设置出来debug view。
![2](https://ws4.sinaimg.cn/large/006tNc79gy1fsuqcqiguwj30ma0fbk0k.jpg)

###2、LLDB expressions can modify program state 变更数值

首先是bug列表里的第一项：在需要调试的方法里打上断点后，需要判断 didReachSelectHeight来做if-else判断，为了让代码走到 fasle 分支里符合bug描述的 jump failed 情景，可以在控制台使用 expressiong 命令：

`(lldb)expression didReachSelectHeight = false`

这个方法只能在进入断点的时候生效一次, 当下一次重新进入断点的时候又会执行编译过的代码。此时，可以右键点击断点，选择 Edit breakpoint...会弹出断点编辑浮窗口。在Action里加上刚才的命令，勾上options，就会每次到断点后继续执行，这样就模拟了一个每次都能进入false分支的情景。
![3](https://ws2.sinaimg.cn/large/006tNc79gy1fsuqctysomj30jp074n1k.jpg)

###3、Use auto-continuing breakpoints with debugger commands to inject code live 注入代码

进入false分支之后，定位到动画演示失败的代码，发现没有设置动画的代理，所以没有执行预期的动画。注入代码：
`dynamicAnimator.delegate = self`
并且打上断点，使用Edit breakpoint...的方法，在Action里使用
`expression dynamicAnimator.delegate = self`
![4](https://ws1.sinaimg.cn/large/006tNc79gy1fsuqcyrmwej30l10f9wmw.jpg)

成功注入代码，解决问题。

###4、“po $arg1” ($arg2, etc) in assembly frames to print function arguments 获取寄存器数据

解决掉第一个bug之后，来看第二个bug，这是一个关于UILabel里text显示不正确的问题。如果不知道这个UILabel的命名，通过代码来查找是非常浪费时间的，可以在XCode的左下角——>点击+号——>点击Symbolic Breakpoint...
![5](https://ws4.sinaimg.cn/large/006tNc79gy1fsuqh8eqjmj309404xgnn.jpg)

在Symbol里添加要设置的断点的类名和方法，格式如图所示，这是Objective-C的格式，因为UIKit是Objective-C framework
![6](https://ws3.sinaimg.cn/large/006tNc79gy1fsuqiwy7y0j30jc073tcw.jpg)

这样就可以在不定位到代码的情况下，自动进入断点方法。但是，我们只能进入到汇编界面，因为我们获取不到UIKit framework的源码。不过，我们可以查看寄存器的情况。因为Objective-C的msgSend机制，我们知道arg2是这个方法的名称，而arg3是传入这个方法的第一个参数。
` po $(SEL)arg2`这样就能看方法名。
` po $arg3`这样就能看传入这个方法的第一个参数。
截图里显示有三个UILabel，而中间的数字是随着高度的变化而变化的，会频繁进入，而这个不是我们要观察的对象，所以去掉这个断点或者仅让这个断点调用一次。
![7](https://ws3.sinaimg.cn/large/006tNc79gy1fsuqkxipytj30se0k17ht.jpg)

###5、Create dependent breakpoints using “breakpoint set --one-shot true”

根据游戏流程，Attempt的数值要在动画演示完成之后才会执行，使用其他的方法打断点。找到演示完成动画的地方，使用刚才的方法打断点，但是这次用`breakpoint set --one-shot true "-[UILabel setText:]"`让代码仅执行一次。这次获得的内存地址和刚才获得的内存地址不一样，应该就是我们要找的UILabel，通过堆栈信息找到调用setText：的地方，修复。
![8](https://ws4.sinaimg.cn/large/006tNc79gy1fsuqm3utlwj30jt07978v.jpg)

###6、Skip lines of code by dragging Instruction Pointer or “thread jump --by 1” 跳过流程
解决掉第二个问题，现在来看第三个问题。这是逻辑判断出错，没有进入正确流程。由于执行一个动作都有动画和时间，消耗时间，可以通过调试直接跳过这些过程。

有两个方法：

* 1. 跳过执行步骤，直接移动breakpoint，这是一个具有风险的操作。
	![9](https://ws4.sinaimg.cn/large/006tNc79gy1fsurz1bn8hj30sg0kaqel.jpg)

* 2. thread jump --by 1
	![10](https://ws1.sinaimg.cn/large/006tNc79gy1fsurzm8ojuj30jq0a0n3n.jpg)

###7、Pause when variables are modified by using watchpoints 添加观察点
* 1.po 操作是打印对象的描述信息，这个是可以自定义的。

* 2.p 指令则是lldb built-in命令，用lldb默认的格式打印。

以上这两个指令都是可以打印对象数据。

添加watch point：在要观察的对象被改变的时候暂停，可以快速定位代码。
![11](https://ws1.sinaimg.cn/large/006tNc79gy1fsus1eddhsj30s50hi13z.jpg)


###8、Evaluate Obj-C code in Swift frames with “expression -l objc -O -- <expr>” 在swift编译的工程里用Objectiv-C方法
第四个bug是关于UI布局的。使用命令`po [self.view recursiveDescription]`可以获得self.view的subviews。

然而recursivDescription不是一个public方法，整个moon jumper demo是用swift语言写的，调用不到这个方法，但是Objective-C可以做到。所以，可以通过 `expression -l objc -O -- <expr>`命令行执行Objective-C的这个方法。

###9、Flush view changes to the screen using “expression CATransaction.flush()” 更新正在调试中的UI

实际调试的时候会发现有些命令比较长，想简略，这时候可以自定义一个同名操作。
![12](https://ws4.sinaimg.cn/large/006tNc79gy1fsus5hga41j30sh07gjw7.jpg)
在swift里还可以用unsafeBitCase方法达到一样的效果。
![13](https://ws4.sinaimg.cn/large/006tNc79gy1fsus6p093qj30sf07jaf4.jpg)

获得这个UILabel对象，修改对象的UI参数之后，发现模拟器里没有更新。这时候要用`expression CATransaction.flush()`去刷新。

###10、Add custom LLDB commands using aliases and scripts. 用同名和脚本自定义 lldb 命令
Alias examples: 
	
	command alias poc expression -l objc -O --
	command alias 🚽 expression -l objc -- (void)	[CATransaction flush]

由于lldb支持python，所以可以编写python脚本实现扩展lldb命令。
可以在[https://developer.apple.com/wwdc18/412]()中下载这个视频里演示用的脚本。

巧于使用这些命令可以免除重新编译和重新运行，节省很多debug时间，并且可以用于检查一些难以复现的bug。

##Advanced View Debugging 界面调试技巧
###1、Reveal in Debug Navigator 在导航栏里找到具体的界面对象
在XCode里可以使用第7个按钮捕获运行时的Project的图层状况，如图所示：

![14](https://ws2.sinaimg.cn/large/006tNc79gy1fsus9yfj20j30p30gc7d9.jpg)
在操作界面里点击想要观察的对象，选择菜单栏里的Navigate——>Reveal in Debug Navigator,就能在左边的导航栏里定位到当前操作界面里对应的对象，来查看层级关系。

![15](https://ws4.sinaimg.cn/large/006tNc79gy1fsus8wlu7pj309t0b1myv.jpg)
###2、View clipped content 查看在屏幕外被裁减的内容
如果界面中有元素超出屏幕，屏幕之外的内容是被裁减掉的。

![16](https://ws3.sinaimg.cn/large/006tNc79gy1fsuse8ras1j309p0f7dfu.jpg)

此时，点击上图所示的第一个按钮，就可以观察到被裁减的部分。

![17](https://ws2.sinaimg.cn/large/006tNc79gy1fsusea75ljj30ap0f0t8q.jpg)

当前选中的界面对象的相关信息可以在右边的窗口中看到，比如类名，颜色，内存地址。

![18](https://ws1.sinaimg.cn/large/006tNc79gy1fsusr03cq6j307b0g0jsf.jpg)
###3、Access object pointers (copy casted expressions) 通过复制直接获取界面对象的内存地址
点击操作界面里的元素，在菜单栏里选择Edit——>Copy，就可以在控制台里粘贴了。这里完选择上图里的橙色图片，可以看到在控制台里打印如下信息。

	(lldb) po ((UIView *)0x7f84e7537b30)
	<UIView: 0x7f84e7537b30; frame = (-31.1667 476; 64 64); clipsToBounds = YES; gestureRecognizers = <NSArray: 0x60000044d200>; layer = <CALayer: 0x6000002318c0>>
	
###4、Creation backtraces in the inspector 
这个方法可以获得界面元素的alloc状况，并且迅速定位代码。点击Project的Edit Scheme...到如下窗口。勾上malloc stack

![19](https://ws2.sinaimg.cn/large/006tNc79gy1fsusl3r3rwj30ox0e1mzd.jpg)

此时我们可以在右边的窗口里看到backtraces，可以看到创建对象的堆栈。

![20](https://ws1.sinaimg.cn/large/006tNc79gy1fsusphhllsj30790cwjsg.jpg)

点击上图显示的AnimationDisplayController就可以定位到这个橙色UIView创建的代码位置。

