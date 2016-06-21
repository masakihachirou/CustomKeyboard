//
//  SGPopSelectView.h
//  SGPopSelectView
//

#import <UIKit/UIKit.h>

typedef void (^PopViewSelectedHandle) (NSInteger selectedIndex);

@interface SGPopSelectView : UIView
@property (nonatomic, strong) NSArray *selections;
@property (nonatomic, copy) PopViewSelectedHandle selectedHandle;
@property (nonatomic, readonly) BOOL visible;

- (instancetype)init;
- (void)showFromView:(UIView*)view atPoint:(CGPoint)point animated:(BOOL)animated;
- (void)hide:(BOOL)animated;
@end

