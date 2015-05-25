//
//  PresentationServices.m
//  GolfersProject
//
//  Created by Zubair on 5/25/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PresentationServices.h"

@implementation PresentationServices

+(void)getCourseLogo{

}


+(void)getCourseTheme{

}


+(void)getBackgroundImage{

}




#pragma mark - Helper Methods

+(NSString *)backgroundImagePathNonRetina{
    return [NSString stringWithFormat:@"%@/background_image.png", [PresentationServices applicationDocumentsDirectory]];
}

+(NSString *)backgroundImagePath2x{
    return [NSString stringWithFormat:@"%@/background_image@2x.png", [PresentationServices applicationDocumentsDirectory]];
}

+(NSString *)backgroundImagePath3x{
    return [NSString stringWithFormat:@"%@/background_image@3x.png", [PresentationServices applicationDocumentsDirectory]];
}

+(NSString *)logoImagePathNonRetina{
    return [NSString stringWithFormat:@"%@/golfcourse_logo.png", [PresentationServices applicationDocumentsDirectory]];
}


+(NSString *)logoImagePath2x{
    return [NSString stringWithFormat:@"%@/golfcourse_logo@2x.png", [PresentationServices applicationDocumentsDirectory]];

}

+(NSString *)logoImagePath3x{
    return [NSString stringWithFormat:@"%@/golfcourse_logo@3x.png", [PresentationServices applicationDocumentsDirectory]];
}

+(NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
