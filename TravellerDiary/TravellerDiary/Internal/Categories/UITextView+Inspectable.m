//
//  UITextView+Inspectable.m
//  TravellerDiary
//
//  Created by admin on 04/08/16.
//  Copyright © 2016 Saveliy. All rights reserved.
//

#import "UITextView+Inspectable.h"

@implementation UITextView (Inspectable)

@dynamic cornerRadius;

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

@end
