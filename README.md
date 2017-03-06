# AnimationTransitioning
##转场动画,为了方便使用,整理了 [VCTransitionsLibrary](https://github.com/ColinEberhardt/VCTransitionsLibrary) 的一些动画
有 10 种转场动画,详见 `demo`, 由于附带 `.gif` ,所以文件有点大.
##1.cube 
<img src="Sasuke/Gif/cube.gif" alt="cube">
##2.fold 
<img src="Sasuke/Gif/fold.gif" alt="fold">
##3.card
<img src="Sasuke/Gif/card.gif" alt="card">
##4.bomb
<img src="Sasuke/Gif/bomb.gif" alt="bomb">
##5.filp
<img src="Sasuke/Gif/filp.gif" alt="filp">
##6.turn
<img src="Sasuke/Gif/turn.gif" alt="turn">
##7.crossfade
<img src="Sasuke/Gif/crossfade.gif" alt="crossfade">
##8.natgeo
<img src="Sasuke/Gif/natgeo.gif" alt="natgeo">
##9.portal
<img src="Sasuke/Gif/portal.gif" alt="portal">
##10.pan
<img src="Sasuke/Gif/pan.gif" alt="pan">

#How to use?
1.遵循代理 `UINavigationControllerDelegate` </br>
  `self.navigationController.delegate = self;` </br>
  
2.代理方法 
```Objective-c
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController 
animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC 
toViewController:(UIViewController *)toVC
{
	CubeTransitioning *cubeTransitioning = [[CubeTransitioning alloc]init];
    return cubeTransitioning;
}
```