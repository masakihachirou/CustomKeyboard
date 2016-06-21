//
//  Helper.h
//  Restaurant
//
//  Created by 3Embed on 14/09/12.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Helper : NSObject
{
   
}
@property(nonatomic,assign)float _latitude;
@property(nonatomic,assign)float _longitude;

+ (id)sharedInstance;


+ (UIColor*)colorWithHexString:(NSString*)hex;
@end
