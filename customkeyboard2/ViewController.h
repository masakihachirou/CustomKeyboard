//
//  ViewController.h
//  CustomKeyboard2
//
//  Created by Simon Smiley-Andrews on 09/04/2015.
//  Copyright (c) 2015 Simon Smiley-Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewWithBlock.h"
#import "THSegmentedPageViewControllerDelegate.h"
#import "SGPopSelectView.h"
#import "THSegmentedPager.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface ViewController : UIViewController<THSegmentedPageViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    BOOL isOpened;
    NSMutableArray *m_pColorArray;
    
    BOOL isEnglish;
    
}

@property (weak, nonatomic) IBOutlet UIButton *btnStep1;
@property (weak, nonatomic) IBOutlet UIButton *btnStep2;
@property (weak, nonatomic) IBOutlet UILabel *lblPref;
@property (weak, nonatomic) IBOutlet UILabel *lblThemeName;
@property (weak, nonatomic) IBOutlet UILabel *lblOption;
@property (weak, nonatomic) IBOutlet UIButton *btnVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnTheme;
@property (weak, nonatomic) IBOutlet UIButton *btnFbLike;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *tblColorView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollPage;

@property(nonatomic,strong)NSString *viewTitle;
@property(nonatomic,strong)THSegmentedPager* m_pParent;
@property (nonatomic, strong) SGPopSelectView *popView;

- (IBAction)OnClickStep1:(id)sender;
- (IBAction)OnClickStep2:(id)sender;
- (IBAction)OnClickTheme:(id)sender;
- (IBAction)OnClickVideo:(id)sender;
- (IBAction)OnClickFbLike:(id)sender;

@end

