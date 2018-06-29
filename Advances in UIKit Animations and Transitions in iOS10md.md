#Advances in UIKit Animations and Transitions in iOS10

##UIViewPropertyAnimator
`NS_CLASS_AVAILABLE_IOS(10_0) @interface UIViewPropertyAnimator : NSObject <UIViewImplicitlyAnimating, NSCopying>`

Implicit Animation 

timing function easeInOut  easeIn  linear easeOut

spring Function 

if we want to change the animation in the midst, in iOS8

UIViewPropertyAnimator, if you are familiar with the existing UIViewAnimationsWithDuation, it is interruptible ,scrubbable,reversible,
new timing funciton,spring in x and y direction.

UITimingCUrveProvider
UIViewImplicitylyAnimating
UIViewAnimatingPosition
UIViewAnimatingState

Transitions

UIViewControllerTransitioningDelegate
UIViewControllerAnimatedTransitioning
UIViewControllerContextTransitiong

When creating a property animator object, you specify the following:
A block containing code that modifies the properties of one or more views.
The timing curve that defines the speed of the animation over the course of its run.
The duration (in seconds) of the animation.
An optional completion block to execute when the animations finish.


If you create your animator using one of the standard initialization methods, you must explicitly start your animations by calling the startAnimation() method. If you want to start the animations immediately after the creation of your animator, use the runningPropertyAnimator(withDuration:delay:options:animations:completion:) method instead of the standard initializers.

##附录
[WWDC2016链接](https://developer.apple.com/videos/play/wwdc2016/216/)