//
//  ViewController.m
//  FMPopViewDiffDirection
//
//  Created by zhufaming on 2016/10/28.
//  Copyright © 2016年 zhufaming. All rights reserved.
//

#import "ViewController.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

@interface ViewController ()

@property (nonatomic, strong) UIView * alertBackgroundView;
@property (nonatomic, strong) UIView * operateView; //操作视图

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (IBAction)upAction:(id)sender {
    [self createBgView];
   
    [self moveScaleWithPoint:CGPointMake(ScreenWidth/2, 0)];
    
}

- (IBAction)downAction:(id)sender {
    [self createBgView];
    
    [self moveScaleWithPoint:CGPointMake(ScreenWidth/2, ScreenHeight)];
    
}

- (IBAction)leftAction:(id)sender {
    [self createBgView];
    
    [self moveScaleWithPoint:CGPointMake(0, ScreenHeight/2)];
    
}

- (IBAction)rightAction:(id)sender {
    
     [self createBgView];
    
    [self moveScaleWithPoint:CGPointMake(ScreenWidth, ScreenHeight/2)];

}

- (IBAction)centerAction:(id)sender {
    
    [self createBgView];
    
   [self shakeToShow:_operateView];
    
}

 //MARK: 创建 背景View
-(void)createBgView{
    /**
     *  背景视图
     */
    _alertBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _alertBackgroundView.backgroundColor = RGBA(40, 40, 53, 1);
    [[UIApplication sharedApplication].keyWindow addSubview:_alertBackgroundView];
    _alertBackgroundView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        _alertBackgroundView.alpha = 0.6;
    }];
    
    [_alertBackgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleBgViewAction) ]];
    
    [self.view addSubview:_alertBackgroundView];
    
    /**
     *  操作区背景
     */
    _operateView = [[UIView alloc] init];
    _operateView.center = CGPointMake(ScreenWidth/2., ScreenHeight/2.);
    _operateView.bounds = CGRectMake(0, 0, ScreenWidth - 32, 208);
    _operateView.backgroundColor = [UIColor whiteColor];
    _operateView.layer.cornerRadius = 6;
    _operateView.clipsToBounds = YES;
    [_alertBackgroundView addSubview:_operateView];
    
    
}

/**
 取消弹窗及背景视图
 */
-(void)cancleBgViewAction
{
    CAKeyframeAnimation *popAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration=0.4;
    popAnimation.values=@[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0001f, 0.0001f, 1.0f)]];
    popAnimation.keyTimes=@[@0.0f,@0.1f];
    popAnimation.timingFunctions=@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    popAnimation.removedOnCompletion=NO;
    popAnimation.fillMode=kCAFillModeRemoved;
    
    [_operateView.layer addAnimation:popAnimation forKey:nil];

    
   
   
    [UIView animateWithDuration:0.4 animations:^{
        
        _alertBackgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        
         [_operateView removeFromSuperview];
        [_alertBackgroundView removeFromSuperview];

    }];
    
    
   
}

 //MARK: 弹性动画

- (void)shakeToShow:(UIView *)aView
{
   
    
    CAKeyframeAnimation *popAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration=0.4;
    
    
    popAnimation.values=@[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes=@[@0.0f,@0.5f,@0.8f];
    popAnimation.timingFunctions=@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [aView.layer addAnimation:popAnimation forKey:nil];
    
}

 //MARK: 缩放移动
-(void)moveScaleWithPoint:(CGPoint )fromValue
{
    
    CABasicAnimation *ydanimation=[CABasicAnimation animationWithKeyPath:@"position"];
    ydanimation.fromValue=[NSValue valueWithCGPoint:fromValue];
    ydanimation.toValue=[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2, ScreenHeight/2)];
    
    CABasicAnimation *scaleAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue=@(0.1);
    scaleAnimation.toValue = @(1);
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
    animationGroup.duration=0.4;
    animationGroup.repeatCount=1;
    animationGroup.animations=@[ydanimation,scaleAnimation];
    [_operateView.layer addAnimation:animationGroup forKey:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
