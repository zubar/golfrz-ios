//
//  NSDate+convenience.m
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "UIImageView+RoundedImage.h"

@implementation UIImageView (RoundedImage)

-(void)setRoundedImage:(UIImage *)image{
    
    [self setImage:image];
    [self.layer setCornerRadius:(CGRectGetWidth(self.frame) / 2)];
    [self setClipsToBounds:YES];
    
}
@end
