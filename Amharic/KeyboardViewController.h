//
//  KeyboardViewController.h
//  Amharic
//
//  Created by Simon Smiley-Andrews on 09/04/2015.
//  Copyright (c) 2015 Simon Smiley-Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    bKeyboardTypeLetters,
    bKeyboardTypeNumbers,
    bKeyboardTypeShift,
} bKeyboardType;

@interface KeyboardViewController : UIInputViewController {
    
    bKeyboardType _keyboardType;
    
    BOOL _deleteLastKey;
}

@end
