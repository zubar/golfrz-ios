//
//  CourseDepartmentCell.m
//  GolfersProject
//
//  Created by Abdullah Saeed on 5/28/15.
//  Copyright (c) 2015 Abdullah Saeed. All rights reserved.
//

#import "CourseDepartmentCell.h"
#import "Department.h"
#import "CalendarUtilities.h"
#import "Constants.h"

@interface CourseDepartmentCell ()

- (IBAction)departmentButtonSelected:(UIButton *)sender;

@end

@implementation CourseDepartmentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)configureViewForDepartment:(Department *)departmant{
    self.currentDepartment = departmant;
    
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"EEEE"];
//    NSString *dayName = [dateFormatter stringFromDate:departmant.endTime];
    
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [cal setLocale:[NSLocale currentLocale]];
    
    
    
    NSDateComponents *startComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitWeekday | NSCalendarUnitHour| NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:departmant.startTime];
    
     NSDateComponents *endComponents = [cal components: NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour fromDate:departmant.endTime];

    
    NSLog(@"%ld, %ld", startComponents.day, (long)startComponents.hour);
    
    if(startComponents != nil && endComponents != nil){
        self.lblDptDays.text = [NSString stringWithFormat:@"%@-%@", [self dayName:startComponents.weekday], [self dayName:endComponents.weekday]];
        self.lblDptTimings.text = [NSString stringWithFormat:@"(%@ - %@)", [self timeInAMPMfrom24hour:(int)startComponents.hour], [self timeInAMPMfrom24hour:(int)endComponents.hour]];
    }else{
        [self.lblDptDays setText:@""];
        [self.lblDptTimings setText:@""];
    }
    
    
    NSDictionary *contactAttributes =@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                     NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:17.0],
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    
    NSAttributedString * dptContact  = [[NSAttributedString alloc] initWithString:departmant.phone attributes:contactAttributes];
    [self.departmentContactButton setAttributedTitle:dptContact forState:UIControlStateNormal];
    
    self.lblDptName.text = departmant.name;
}


-(NSString *)dayName:(NSInteger)num{
    
    switch (num) {
        case 1:
           return @"Sun";
        case 2:
            return @"Mon";
        case 3:
            return @"Tue";
        case 4:
            return @"Wed";
        case 5:
            return @"Thu";
        case 6:
            return @"Fri";
            break;
        case 7:
            return @"Sat";
        default:
            break;
    }
    return @" ";
}


-(NSString *)timeInAMPMfrom24hour:(int)hour
{
     if (hour >= 12 && hour <= 23 ) {
         if (hour == 12){
             return [NSString stringWithFormat:@"%dPM", hour];
         }else{
             return [NSString stringWithFormat:@"%dPM", hour-12];
         }
    }else{
        if (hour == 0){
            return [NSString stringWithFormat:@"%dAM", hour + 12];
        }else{
        return [NSString stringWithFormat:@"%dAM", hour];
        }
    }
}

- (IBAction)departmentButtonSelected:(UIButton *)sender {
    
    NSString *contact = [sender attributedTitleForState:UIControlStateNormal].string;
    NSString *condensedPhoneno = [[contact componentsSeparatedByCharactersInSet:
                                   [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"]
                                    invertedSet]]
                                  componentsJoinedByString:@""];
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]) {
        if (contact.length) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", condensedPhoneno]]];
        }
        else {
            UIAlertView *notAvaliable=[[UIAlertView alloc] initWithTitle:kError message:NumberNotAvaliableErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil];
            [notAvaliable show];
        }
        
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:kError message:CallSupportErrorMessage delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil];
        [notPermitted show];
    }
}
@end
