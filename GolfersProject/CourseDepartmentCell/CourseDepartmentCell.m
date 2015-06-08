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
    
    self.lblDptDays.text = [NSString stringWithFormat:@"%@-%@", [self dayName:startComponents.weekday], [self dayName:endComponents.weekday]];
    self.lblDptTimings.text = [NSString stringWithFormat:@"(%@ - %@)", [self timeInAMPMfrom24hour:(int)startComponents.hour], [self timeInAMPMfrom24hour:(int)endComponents.hour]];
    
    
    NSDictionary *contactAttributes =@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                     NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:17.0],
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    
    NSAttributedString * dptContact  = [[NSAttributedString alloc] initWithString:departmant.phone attributes:contactAttributes];
    [self.lblDptContact setAttributedText:dptContact];
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
    return @"N/A";
}


-(NSString *)timeInAMPMfrom24hour:(int)hour{
    (hour > 11 && hour <= 23 ? --hour : ++hour);
     if (hour > 11 && hour <= 23 ) {
        return [NSString stringWithFormat:@"%dPM", hour-11];
    }else{
        return [NSString stringWithFormat:@"%dAM", hour];
    }
}

@end
