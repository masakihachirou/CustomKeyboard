//
//  KeyboardViewController.m
//  Amharic
//
//  Created by Simon Smiley-Andrews on 09/04/2015.
//  Copyright (c) 2015 Simon Smiley-Andrews. All rights reserved.
//

#import "KeyboardViewController.h"
#import "KeepLayout.h"
#import "AppDelegate.h"
#import "Helper.h"
#import <AudioToolbox/AudioToolbox.h>

@interface KeyboardViewController () {
    
    NSDictionary * keyDictionary;
    
    NSMutableArray * keyboardButtons;
    
    UIView * keyboardView; // The view all the rows are added to for constraint purposes
    
    UIView * addedRowView; // Extra row of numbers of extra letters
    UIView * topRowView; // Top row of letters
    UIView * middleRowView; // Middle letter row
    UIView * bottomRowView; // Bottom letter row
    UIView * spaceRowView; // Row with space bar on it
    
    // These are the character arrays of the number view
    
    NSArray * lettersAddedRow;
    NSArray * numbersAddedRow;
    NSArray * shiftAddedRow;
    
    NSArray * numberTopRow;
    NSArray * numberMiddleRow;
    NSArray * numberBottomRow;
    
    NSArray * lettersTopRow;
    NSArray * lettersMiddleRow;
    NSArray * lettersBottomRow;
    
    NSArray * shiftLettersTopRow;
    NSArray * shiftLettersMiddleRow;
    NSArray * shiftLettersBottomRow;
    
    NSArray * spaceArray;
    
    NSDictionary * extraLetters;
    
    NSTimer * timer;
}

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpLetterArrays];
    
    _keyboardType = bKeyboardTypeLetters;
    _deleteLastKey = NO;
    
    [self addViews];
    
 // self.view.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0];
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.mykeyboard.myapp"];
    NSString* value = [shared valueForKey:@"backColor"];
    NSLog(@"%@",value);

  //  NSString *backgroundColor = [[NSUserDefaults standardUserDefaults] stringForKey:@"backgroundColor"];
    self.view.backgroundColor = [Helper colorWithHexString:value];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"plist.plist"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    if (![fileManager fileExistsAtPath: path]) {
//        
//        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"plist.plist"] ];
//    }
//    
//    //To reterive the data from the plist
//    NSMutableDictionary *savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
//    NSString *value = [savedValue objectForKey:@"backgroundColor"];
//    NSLog(@"%@",value);

    
}

- (void)addViews {
    
    keyboardView = [[UIView alloc] init];
    
    spaceRowView = [[UIView alloc] init];
    bottomRowView = [[UIView alloc] init];
    middleRowView = [[UIView alloc] init];
    topRowView = [[UIView alloc] init];
    addedRowView = [[UIView alloc] init];

    [self addView:addedRowView withKeys:lettersAddedRow];
    [self addView:topRowView withKeys:lettersTopRow];
    [self addView:middleRowView withKeys:lettersMiddleRow];
    [self addView:bottomRowView withKeys:lettersBottomRow];
    [self addView:spaceRowView withKeys:spaceArray];
    
    [self setConstraints];
    
    [self.view addSubview:keyboardView];
    
    keyboardView.keepInsets.equal = 0;
}

- (void)addView: (UIView *)view withKeys: (NSArray *)keys {
    
    // Add the buttons for each view to the view
    NSArray * buttons = [self createButtons:keys];
    
    for (UIButton * button in buttons) {
        [view addSubview:button];
    }
    
    // ** This is a very important line when using NSLayoutConstraints **
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [keyboardView addSubview:view];
    
    [self addConstraintsToView:view];
}

// Get an array of the extra letters
- (NSMutableArray *)getArrayInAlteredFormat: (NSArray *)keys {
    
    // We want this array to always be 10 characters long to fill the top view
    if (keys.count) {
        
        NSMutableArray * modifiedKeys = [NSMutableArray new];
        
        // If we have an odd number of keys add an extra one at the beginning
        if (keys.count % 2 != 0) {
            keys = [keys arrayByAddingObject:@""];
        }
        
        for (NSInteger i = 1; i <= 10 - keys.count; i++) {
            [modifiedKeys addObject:@""];
            
            if (i == (10 - keys.count)/2) {
                
                [modifiedKeys addObjectsFromArray:keys];
            }
        }
        
        return modifiedKeys;
    }
    else {
        return nil;
    }
}

// ButtonPressed
- (void)keyPressed: (UIButton *)sender {
    
    // If the timer has got stuck on make sure it is invalidated
    [timer invalidate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Play the key tock sound
        // AudioServicesPlaySystemSound(0x450);
    });
    
    if (sender.currentTitle.length) {
        
        NSString * firstLetter = [sender.currentTitle substringToIndex:1];
        
        // Is the button pressed a letter key or a symbol key
        if ([firstLetter isEqualToString:@"u"] || sender.currentTitle.length == 1) {
            
            NSString * letterString = sender.currentTitle;
            
            // Fetch the unicode version from the plist
            if ([firstLetter isEqualToString:@"u"]) {
                
                NSString * letterRoot = [letterString substringToIndex:4];
                NSDictionary * dict = [keyDictionary objectForKey:letterRoot];
                letterString = [dict objectForKey:letterString];
            }
            
            // If the clicked button is in the added view
            if ([addedRowView.subviews containsObject:sender]) {
                
                if (_deleteLastKey == YES) {
                    [self.textDocumentProxy deleteBackward];
                    [self loadAddedView];
                }
                
                _deleteLastKey = NO;
            }
            else {
                [self showAddedViewForButton:sender];
                _deleteLastKey = YES;
            }
            
            [self.textDocumentProxy insertText:letterString];
        }
        else if ([sender.titleLabel.text isEqualToString:@"CK"]) {
            // Change the keybord
            [self advanceToNextInputMode];
        }
        else if ([sender.titleLabel.text isEqualToString:@"space"]) {
            
            [self loadAddedView];
            [self.textDocumentProxy insertText:@" "];
        }
        else if ([sender.titleLabel.text isEqualToString:@"return"]) {
            
            [self loadAddedView];
            [self.textDocumentProxy insertText:@"\n"];
        }
        else if ([sender.titleLabel.text isEqualToString:@"DEL"]) {
            
            [self loadAddedView];
            [self.textDocumentProxy deleteBackward];
        }
        else if ([sender.titleLabel.text isEqualToString:@"SHFT"]) {
            
            _keyboardType = _keyboardType == bKeyboardTypeShift ? bKeyboardTypeLetters : bKeyboardTypeShift;
            
            [self setShiftButton];
            [self loadAddedView];
        }
        if ([sender.titleLabel.text isEqualToString:@"123"]) {
            
            _keyboardType = _keyboardType == bKeyboardTypeNumbers ? bKeyboardTypeLetters : bKeyboardTypeNumbers;
            
            [self setShiftButton];
            [self loadAddedView];
        }
    }
}

- (void)showAddedViewForButton: (UIButton *)button {
    
    NSString * letterString = button.currentTitle;
    
    NSArray * array = [self getArrayInAlteredFormat: [extraLetters objectForKey:letterString]];
    
    // If we have a unicode we need to insert the back slash
    if ([[letterString substringToIndex:1] isEqualToString:@"u"]) {
        
        NSString * letterRoot = [letterString substringToIndex:4];
        NSDictionary * dict = [keyDictionary objectForKey:letterRoot];
        letterString = [dict objectForKey:letterString];
    }
    
    // If there are no special characters then don't load the added view
    if (array.count) {
        [self loadAddedViewWithKeys:array];
    }
    else {
        [self loadAddedView];
    }
}

// A long press does not count as a normal press
- (void)longPressDelete:(UILongPressGestureRecognizer*)gesture {
    
    if (gesture.state != UIGestureRecognizerStateEnded) {
        
        // Delete once for the long press
        [self.textDocumentProxy deleteBackward];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(deleteKey:) userInfo:nil repeats:YES];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [timer invalidate];
    }
}

-(void)deleteKey:(NSTimer *)timer {

    [self.textDocumentProxy deleteBackward];
}

- (void)addConstraintsToView: (UIView *)view {
    
    NSArray * buttons = view.subviews;
    
    for (UIButton * button in buttons) {
        
        NSInteger index = [view.subviews indexOfObject:button];
        
        NSLayoutConstraint * topConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * bottomConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * leftConstraint;
        
        // If the first button in the row
        if (!index) {
            
            // This makes sure that the left side is 5% inset
            if ([view isEqual:middleRowView]) {
                leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:0.1f constant:0.0f];
            }
            else {
                leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
            }
        }
        else {
            
            leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:buttons[index-1] attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
        }
        
        NSLayoutConstraint * widthConstraint;
        
        if ([button.titleLabel.text isEqualToString:@"SHFT"] || [button.titleLabel.text isEqualToString:@"DEL"]) {
            widthConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:buttons[1] attribute:NSLayoutAttributeWidth multiplier:1.5f constant:0];
        }
        else if ([button.titleLabel.text isEqualToString:@"space"]) {
            widthConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:buttons[1] attribute:NSLayoutAttributeWidth multiplier:3.0f constant:0];
        }
        else if ([button.titleLabel.text isEqualToString:@"return"]) {
            widthConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:buttons[1] attribute:NSLayoutAttributeWidth multiplier:1.666667f constant:0];
        }
        else {
            widthConstraint = [NSLayoutConstraint constraintWithItem:buttons[1] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
        }
        
        [view addConstraint:widthConstraint];
        
        NSLayoutConstraint * rightConstraint;
        
        // If the last button in the row
        if (index == buttons.count - 1) {
            
            // This makes sure that the left side is 5% inset
            if ([view isEqual:middleRowView]) {
                rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:0.95f constant:0.0f];
            }
            else {
                rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
            }
        }
        else {
            
            rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:buttons[index+1] attribute:NSLayoutAttributeLeft multiplier:1.0f constant:.0f];
        }
        
        [view addConstraints:@[topConstraint, bottomConstraint, rightConstraint, leftConstraint]];
    }
}

- (void)setConstraints {
    
    NSArray * views = keyboardView.subviews;
    
    for (UIView * view in views) {
        
        NSInteger index = [views indexOfObject:view];
        
        NSLayoutConstraint * leftConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:keyboardView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * rightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:keyboardView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * topConstraint;
        
        // If the first button in the row
        if (!index) {
            
            topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:keyboardView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
        }
        else {
            
            topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:views[index-1] attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        }
        
        NSLayoutConstraint * heightConstraint;
        
        if ([view isEqual:addedRowView]) {
            heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:views[1] attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
        }
        else {
            heightConstraint = [NSLayoutConstraint constraintWithItem:views[1] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
        }
        
        [keyboardView addConstraint:heightConstraint];
        
        NSLayoutConstraint * bottomConstraint;
        
        // If the last button in the row
        if (index == views.count - 1) {
            
            bottomConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:keyboardView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:.0f];
        }
        else {
            
            bottomConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:views[index+1] attribute:NSLayoutAttributeTop multiplier:1.0f constant:.0f];
        }
        
        [keyboardView addConstraints:@[topConstraint, bottomConstraint, rightConstraint, leftConstraint]];
    }
}

- (void)loadAddedViewWithKeys: (NSArray *)keys {
    
    for (UIButton * button in addedRowView.subviews) {
        
        NSString * keyTitle = keys[[addedRowView.subviews indexOfObject:button]];
        
        //NSData * data = [keyTitle dataUsingEncoding:NSUTF8StringEncoding];
        //NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [button setTitle:keyTitle forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor clearColor];
        
        for (UIImageView * imageView in button.subviews) {
            if ([imageView isKindOfClass:[UIImageView class]]) {
                
                if (keyTitle.length) {
                    
                    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", keyTitle]];
                    [button setBackgroundImage:[UIImage imageNamed:@"icn_key.png"] forState:UIControlStateNormal];
                }
                else {
                    
                    button.titleLabel.text = keyTitle;
                    imageView.image = nil;
                    [button setBackgroundImage:nil forState:UIControlStateNormal];
                }
            }
        }
        
        /*if (keyTitle.length) {

            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", keyTitle]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"icn_key.png"] forState:UIControlStateNormal];
        }
        else {
            [button setBackgroundImage:nil forState:UIControlStateNormal];
        }*/
    }
}

- (void)loadAddedView {
    
    _deleteLastKey = NO;
    
    NSArray * rows = @[addedRowView, topRowView, middleRowView, bottomRowView];
    NSArray * keys;
    
    if (_keyboardType == bKeyboardTypeLetters) {
        keys = @[lettersAddedRow, lettersTopRow, lettersMiddleRow, lettersBottomRow];
    }
    else if (_keyboardType == bKeyboardTypeNumbers) {
        keys = @[numbersAddedRow, numberTopRow, numberMiddleRow, numberBottomRow];
    }
    else {
        keys = @[shiftAddedRow, shiftLettersTopRow, shiftLettersMiddleRow, shiftLettersBottomRow];
    }
    
    for (UIView * view in rows) {
        
        NSArray * keyArray = keys[[rows indexOfObject:view]];
        
        for (UIButton * button in view.subviews) {
            
            NSInteger buttonIndex = [view.subviews indexOfObject:button];
            NSString * newButtonTitle = keyArray[buttonIndex];
            
            if (![button.titleLabel.text isEqualToString:@"SHFT"] && ![button.titleLabel.text isEqualToString:@"DEL"]) {
                
                if (newButtonTitle.length == 1) {
                    [button setTitle:newButtonTitle forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                else {
                    
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                
                for (UIImageView * imageView in button.subviews) {
                    if ([imageView isKindOfClass:[UIImageView class]]) {
                        
                        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", newButtonTitle]];
                    }
                }
                
               // [button setBackgroundImage:[UIImage imageNamed:@"icn_key.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"icn_key.png"] forState:UIControlStateNormal];
            }
            
            [button setTitle:newButtonTitle forState:UIControlStateNormal];
        }
    }
}

- (NSMutableArray *)createButtons: (NSArray *)keys {
    
    NSMutableArray * buttons = [NSMutableArray new];
    
    for (NSString * key in keys) {
        
        UIButton * button = [[UIButton alloc] init];
        
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSLog(@"Keyboard : color ----------------- ");
        [button setTitle:key forState:UIControlStateNormal];
        
        
        NSString *keyTitleColor = [[NSUserDefaults standardUserDefaults] stringForKey:@"keyTitleColor"];
         NSLog(@"%@",keyTitleColor);
        NSString *keyBackColor = [[NSUserDefaults standardUserDefaults] stringForKey:@"keyBackColor"];
         NSLog(@"%@",keyBackColor);
    
            
            
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:[Helper colorWithHexString:keyTitle] forState:UIControlStateNormal];
        
//        [button setBackgroundColor:[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0]];
        
        NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.mykeyboard.myapp"];
        NSString* value = [shared valueForKey:@"backColor"];
        NSLog(@"%@",value);

        [button setBackgroundColor:[Helper colorWithHexString:value]];
        
        
        [button addTarget:self action:@selector(keyPressed:) forControlEvents:UIControlEventTouchUpInside];
    
        if ([key isEqualToString:@"CK"]) {

            [self addImage:[UIImage imageNamed:@"icn_globe.png"] toButton:button];
        
            [button setBackgroundImage:[UIImage imageNamed:@"icn_key_wide_grey.png"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        }
        else if ([key isEqualToString:@"DEL"]) {
            
            [self addImage:[UIImage imageNamed:@"icn_delete_2.png"] toButton:button];
            
            [button setBackgroundImage:[UIImage imageNamed:@"icn_key_grey.png"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            
            UILongPressGestureRecognizer * longPressDelete = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDelete:)];
            [button addGestureRecognizer:longPressDelete];
        }
        else if ([key isEqualToString:@"SHFT"]) {
            
            [self addImage:[UIImage imageNamed:@"icn_shift_white.png"] toButton:button];
            
            [button setBackgroundImage:[UIImage imageNamed:@"icn_key_grey.png"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        }
        else if ([key isEqualToString:@"123"] || [key isEqualToString:@"return"]) {
            
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setBackgroundImage:[UIImage imageNamed:@"icn_key_wide_grey.png"] forState:UIControlStateNormal];
        }
        else if ([key isEqualToString:@"space"]) {
            
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setBackgroundImage:[UIImage imageNamed:@"icn_key_space.png"] forState:UIControlStateNormal];
        }
        else {
            
            if (key.length > 1) {
                [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            }
            
            NSString * imageString = [NSString stringWithFormat:@"%@.png", key];
            UIImage * image = [UIImage imageNamed:imageString];
            
            [self addImage:image toButton:button];
            
            [button setBackgroundImage:[UIImage imageNamed:@"icn_key.png"] forState:UIControlStateNormal];
        }
        
        [buttons addObject:button];
    }
    
    return buttons;
}

- (void)addImage: (UIImage *)image toButton: (UIButton *)button {
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    
    [button addSubview:imageView];
    
    imageView.keepHorizontalCenter.equal = 0.5;
    imageView.keepVerticalCenter.equal = 0.5;
    imageView.keepHeight.equal = 30;
    imageView.keepWidth.equal = 30;
}

- (void)setShiftButton {
    
    UIButton * shiftButton = bottomRowView.subviews.firstObject;
    
    for (UIImageView * imageView in shiftButton.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            
            if (_keyboardType == bKeyboardTypeShift) {
                
                imageView.image = [UIImage imageNamed:@"icn_shift.png"];
                [shiftButton setBackgroundImage:[UIImage imageNamed:@"icn_key.png"] forState:UIControlStateNormal];
            }
            else {
                
                imageView.image = [UIImage imageNamed:@"icn_shift_white.png"];
                [shiftButton setBackgroundImage:[UIImage imageNamed:@"icn_key_grey.png"] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setUpLetterArrays {
    
    NSString * keyPlistString = [[NSBundle mainBundle] pathForResource:@"keyLetters" ofType:@"plist"];
    keyDictionary = [NSDictionary dictionaryWithContentsOfFile:keyPlistString];
    
    NSString * plistString = [[NSBundle mainBundle] pathForResource:@"alternateLetters" ofType:@"plist"];
    extraLetters = [NSDictionary dictionaryWithContentsOfFile:plistString];
    
    // These are the numerals
    // [@"፩", @"፪", @"፫", @"፬", @"፭", @"፮", @"፯", @"፰", @"፱", @"፲"]
    lettersAddedRow = @[@"u1369", @"u136a", @"u136b", @"u136c", @"u136d", @"u136e", @"u136f", @"u1370", @"u1371", @"u1372"];
    // [@"ሀ", @"ለ", @"መ", @"ሠ", @"ረ", @"ሸ", @"ቀ", @"በ", @"ተ", @"ቸ"];
    lettersTopRow = @[@"u1200", @"u1208", @"u1218", @"u1220", @"u1228", @"u1238", @"u1240", @"u1260", @"u1270", @"u1278"];
    // [@"ነ", @"አ", @"ከ", @"ወ", @"ዘ", @"የ", @"ደ", @"ጀ", @"ገ"]
    lettersMiddleRow = @[@"u1290", @"u12a0", @"u12a8", @"u12c8", @"u12d8", @"u12e8", @"u12f0", @"u1300", @"u1308"];
    // [@"SHFT", @"ጠ", @"ጨ", @"ጸ", @"ጰ", @"ሰ", @"ፈ", @"ፐ", @"DEL"]
    lettersBottomRow = @[@"SHFT", @"u1320", @"u1328", @"u1338", @"u1330", @"u1230", @"u1348", @"u1350", @"DEL"];

    // These are more numerals
    // [@"፳", @"፴", @"፵", @"፶", @"፷", @"፸", @"፹", @"፺", @"፻", @"፼"];
    shiftAddedRow = @[@"u1373", @"u1374", @"u1375", @"u1376", @"u1377", @"u1378", @"u1379", @"u137a", @"u137b", @"u137c"];
    // [@"ሐ", @"ኘ", @"ኀ", @"ኸ", @"ዐ", @"ዠ", @"ፀ", @"ቨ", @"ኰ", @"ጐ"]
    shiftLettersTopRow = @[@"u1210", @"u1298", @"u1280", @"u12b8", @"u12d0", @"u12e0", @"u1340", @"u1268", @"u12b0", @"u1310"];
    // [@"ቈ", @"ኈ", @"ዸ", @"ጘ", @"ቘ", @"ዀ", @"፡", @"።", @"፦"]
    shiftLettersMiddleRow = @[@"u1248", @"u1288", @"u12f8", @"u1318", @"u1258", @"u12c0", @"u1361", @"u1362", @"u1366"];
    // [@"SHFT", @"፣", @"፤", @"፥", @"?", @"!", @"(", @")", @"DEL"]
    shiftLettersBottomRow = @[@"SHFT", @"u1363", @"u1364", @"u1365", @"?", @"!", @"(", @")", @"DEL"];
    
    numbersAddedRow = @[@"-", @"/", @":", @";", @"(", @")", @"$", @"&", @"@", @"\""];
    numberTopRow = @[@"[", @"]", @"{", @"}", @"#", @"%", @"^", @"*", @"+", @"="];
    numberMiddleRow = @[@"|", @"~", @"<", @">", @"€", @"£", @"¢", @"¥", @"•"];
    numberBottomRow = @[@"SHFT", @".", @",", @"?", @"!", @"'", @"_", @"\\", @"DEL"];

    spaceArray = @[@"123", @"CK", @"space", @"return"];
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

@end
