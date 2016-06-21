//
//  ViewController.m
//  CustomKeyboard2
//
//  Created by Simon Smiley-Andrews on 09/04/2015.
//  Copyright (c) 2015 Simon Smiley-Andrews. All rights reserved.
//

#import "SelectionCell.h"
#import "ViewController.h"
#import "PopupViewController.h"

@interface ViewController ()<MFMessageComposeViewControllerDelegate>
{
    PopupViewController *vc;
}

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray  *obj1 = [[NSArray alloc] initWithObjects:@"Please select Theme",@"Default",@"Peru",@"SaddleGreen",@"Purple",@"Grey",@"Pink",@"Green",@"Blue",@"Golden",@"Agere",@"Metal",@"Rasta",@"Rasta1",@"Rasta2",@"Yellow",nil];
    
    m_pColorArray = [[NSMutableArray alloc] initWithArray:obj1];
    
    isEnglish = YES;
    [self.scrollPage setContentSize:CGSizeMake(self.scrollPage.frame.size.width, 700)];
    
    self.popView = [[SGPopSelectView alloc] init];
    self.popView.selections = m_pColorArray;
    __weak typeof(self) weakSelf = self;
    self.popView.selectedHandle = ^(NSInteger selectedIndex){
        
        [weakSelf setTextArea:selectedIndex];
    };
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setTextArea:(NSInteger) selectedIndex{

    self.lblThemeName.text = [m_pColorArray objectAtIndex:selectedIndex];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.lblThemeName.text forKey:@"theme_style_eng"];

    NSString *keyTitleColor = @"A71C1C";
    NSString *keyBackColor = @"C28171";
    NSString *backgroundColor = @"272727";
    
    switch (selectedIndex) {
        case 1:
            keyTitleColor = @"A71C1C";
            keyBackColor = @"C28171";
            backgroundColor = @"d4d4d4";
            break;
        case 2:
            keyTitleColor = @"5D8538";
            keyBackColor = @"108544";
            backgroundColor = @"a11b1f";
            break;
        case 3:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"228e52";
            break;
        case 4:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"b43c3c";
            break;
        case 5:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"cecece";
            break;
        case 6:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"f9689c";
            break;
        case 7:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"50b150";
            break;
        case 8:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"7b9cde";
            break;
        case 9:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"dcc27f";
            break;
        case 10:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"bafd04";    //
            break;
        case 11:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"c9c9c9";
            break;
        case 12:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"3073cc";
            break;
        case 13:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"405781";
            break;
        case 14:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"e5e6e7";
            break;
        case 15:
            keyTitleColor = @"000000";
            keyBackColor = @"d4d4d4";
            backgroundColor = @"bdbf00";
            break;
            
        default:
            break;
    }
    
    [prefs setObject:keyTitleColor forKey:@"keyTitleColor"];
    [prefs setObject:keyBackColor forKey:@"keyBackColor"];
    [prefs setObject:backgroundColor forKey:@"backgroundColor"];
    
    [prefs synchronize];
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.mykeyboard.myapp"];
    [shared setObject:backgroundColor forKey:@"backColor"];
    [shared synchronize];
    
//    //To reterive the data from the plist
//    NSMutableDictionary *savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
//    NSString *value = [savedValue objectForKey:@"backgroundColor"];
//    NSLog(@"%@",value);
    
    [self.popView hide:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)viewControllerTitle
{
    return self.viewTitle ? self.viewTitle : self.title;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.viewTitle isEqualToString:@"Amharic Write Plus"]) {
        
        [self.btnStep1 setTitle:@"Step I. Configure Keyboard" forState:UIControlStateNormal];
        [self.btnStep2 setTitle:@"Step II. Select Amharic Write Keyboard" forState:UIControlStateNormal];
        self.lblPref.text = @"Preferences:";
        self.lblThemeName.text = @"Default";
        self.lblOption.text = @"Theme Options";
        [self.btnVideo setTitle:@"Video Guidance on How to Setup Keyboard" forState:UIControlStateNormal];
        [self.btnFbLike setTitle:@"Like Us on Facebook"  forState:UIControlStateNormal];

    }
    else
    {
        [self.btnStep1 setTitle:@"፩  - ቋንቋውን፡ ሴታፕ (\"Amharic Write\"-ይምረጡ)" forState:UIControlStateNormal];
        [self.btnStep2 setTitle:@"፪ - ኪባርድ፡ምርጫ (\"Amharic Write\"-ይምረጡ )" forState:UIControlStateNormal];
        self.lblPref.text = @"ተጨማሪ፦";
        self.lblThemeName.text = @"Default";
        self.lblOption.text = @"የኪባርድ፡ግድግዳ፡ምርጫ";
        [self.btnVideo setTitle:@"ሴታፕ፡እንዴት፡እንደሚደረግ፡መመርያ፡ቪዲዬ፡" forState:UIControlStateNormal];
        [self.btnFbLike setTitle:@"በፌስ፡ቡክ፡ላይ፡ወደድኩት፡ለማለት"  forState:UIControlStateNormal];
        
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:@"theme_style_eng"];
    
    if (!value)
    {
        value = @"Default";
        [defaults setValue:value forKey: @"theme_style_eng"];
        [defaults synchronize];
    }
    
    self.lblThemeName.text = value;
    
    [self reloadEnglishThemeState];
    
}

- (void)reloadEnglishThemeState{
    
    [self.tblColorView initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView, NSInteger section) {
        return m_pColorArray.count;
    } setCellForIndexPathBlock:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:[m_pColorArray objectAtIndex:indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        //        inputTextField.text=cell.lb.text;
        self.lblThemeName.text = cell.lb.text;
        [self.btnTheme sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        [[NSUserDefaults standardUserDefaults] setObject:cell.lb.text forKey:@"theme_style_eng"];
    }];
    
    [self.tblColorView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.tblColorView.layer setBorderWidth:2];
    
}

- (IBAction)OnClickStep1:(id)sender
{
    [self.popView hide:YES];
    
    vc =[self.storyboard instantiateViewControllerWithIdentifier:@"PopupViewController"];
    [self.m_pParent.view addSubview:vc.view];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnView)];
    [vc.view addGestureRecognizer:tapGesture];
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)touchOnView
{
    [vc.view removeFromSuperview];
}

- (IBAction)OnClickStep2:(id)sender {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    NSString *message = @"";
    for (UILabel *v in [self.view subviews]) {
        if (v.tag == 20001) {
            message = v.text;
        }
    }
    
    message = [NSString stringWithFormat:@"%@", message];
    
    [picker setMessageBody:message isHTML:NO];
    NSString *myemail = @"schedulepin@gmail.com";
    NSArray *toRecipients = [NSArray arrayWithObject:myemail];
    [picker setToRecipients:toRecipients];
    [picker setSubject:@"Contact us!"];
    
    [self presentViewController:picker animated:YES completion:nil];
    
//    [self.popView hide:YES];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result != MFMailComposeResultCancelled)    {
        
        NSString *message = @"";
        
        if (result ==  MFMailComposeResultSaved)        {
            message = @"Mail saved.";
        }
        else if (result == MFMailComposeResultSent)        {
            message = @"Mail sent.";
        }
        else if (result == MFMailComposeResultFailed)        {
            message = @"Mail sending failed.";
        }
        else        {
            message = @"Mail not sent.";
        }
        
        UIAlertView *stop = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [stop show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)OnClickTheme:(id)sender {
    
    CGPoint pt;
    
    pt.x = self.lblThemeName.frame.origin.x + self.lblThemeName.frame.size.width/4;
    pt.y = self.lblThemeName.frame.origin.y + self.lblThemeName.frame.size.height;
    
    [self.popView showFromView:self.view atPoint:pt animated:YES];

    
//    if (isOpened) {
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            CGRect frame=self.tblColorView.frame;
//            
//            frame.size.height=0;
//            [self.tblColorView setFrame:frame];
//            
//        } completion:^(BOOL finished){
//            
//            isOpened=NO;
//        }];
//    }else{
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            CGRect frame=self.tblColorView.frame;
//            
//            frame.size.height=160;
//            [self.tblColorView setFrame:frame];
//            [self.view bringSubviewToFront:self.tblColorView];
//            
//        } completion:^(BOOL finished){
//            
//            isOpened=YES;
//        }];
//    }
}

- (IBAction)OnClickVideo:(id)sender {
    [self.popView hide:YES];
    NSURL *url = [NSURL URLWithString:@"https://www.youtube.com/watch?v=1-7ABIM2qjU"];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (IBAction)OnClickFbLike:(id)sender {
    [self.popView hide:YES];
    NSURL *url = [NSURL URLWithString:@"https://www.facebook.com/unowalk.iamhariccal/likes"];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

@end
