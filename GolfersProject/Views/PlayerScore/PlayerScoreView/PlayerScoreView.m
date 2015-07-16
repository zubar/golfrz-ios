//
//  EventHeader.m
//  GolfersProject
//
//  Created by Zubair on 6/1/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "PlayerScoreView.h"
#import "UIImageView+RoundedImage.h"
#import <SDWebImage/UIImageView+WebCache.h>



@implementation PlayerScoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PlayerScoreView" owner:self options:nil] lastObject];
        //[self setBackgroundColor:[UIColor blackColor]];

    }
    return self;
}

- (IBAction)btnDropDownTap:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownTapped)]) {
        [self.delegate dropDownTapped];
    }
}
- (IBAction)btnEditScoreTap:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editScoreTappedForPlayer:Player:view:)]) {
        [self.delegate editScoreTappedForPlayer:sender Player:player view:self];
    }
}

-(void)configureViewForPlayer:(id)mPlayer hideDropdownBtn:(BOOL)yesNo{
    
    player = mPlayer;
    [self.btnShowTable setHidden:yesNo];
    
    //[self setBackgroundColor:[UIColor clearColor]];
    // Setting player name.
   // NSDictionary *playNameAttr =@{
      //                               NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
    //                                 NSForegroundColorAttributeName : [UIColor whiteColor]
     //                                };
   // NSAttributedString * txtLblName = [[NSAttributedString alloc]initWithString:@"Abdullah " attributes:playNameAttr];
    //[self.lblUserName setAttributedText:txtLblName];
    
    // Setting in-out label.
   // NSDictionary *lblInAttr =@{
    //                              NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:12.0],
    //                              NSForegroundColorAttributeName : [UIColor whiteColor]
     //                             };
   // NSAttributedString * txtLblInOut = [[NSAttributedString alloc]initWithString:@"In 12" attributes:lblInAttr];
   // [self.lblInOut setAttributedText:txtLblInOut];

    
    // Setting score label.
   // NSDictionary *scoreAttr =@{
    //                           NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:12.0],
    //                           NSForegroundColorAttributeName : [UIColor whiteColor]
     //                          };
   // NSAttributedString * txtLblScore = [[NSAttributedString alloc]initWithString:@"In 12" attributes:scoreAttr];
   // [self.btnEditScore.titleLabel setAttributedText:txtLblScore];

    
    
    //TODO: set iamge
    //[self.btnShowTable.titleLabel setText:@"+"];
    //[self.btnEditScore.titleLabel setText:@"0"];
    
}
@end
