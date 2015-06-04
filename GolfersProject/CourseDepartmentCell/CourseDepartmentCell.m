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
    
    
    
    NSDateComponents *startComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitHour| NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:departmant.startTime];
    
     NSDateComponents *endComponents = [cal components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour fromDate:departmant.endTime];

    
    NSLog(@"%ld, %ld", startComponents.day, (long)startComponents.hour);
    
    self.lblDptDays.text = [NSString stringWithFormat:@"%@-%@", [self dayName:startComponents.day], [self dayName:endComponents.day]];
    self.lblDptTimings.text = [NSString stringWithFormat:@"(%@-%@)", [self timeInAMPMfrom24hour:startComponents.hour], [self timeInAMPMfrom24hour:endComponents.hour]];

    self.lblDptContact.text = departmant.phone;
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
    return @"Unknown";
}


-(NSString *)timeInAMPMfrom24hour:(int)hour{
    (hour > 11 && hour <= 23 ? --hour : ++hour);
     if (hour > 11 && hour <= 23 ) {
        return [NSString stringWithFormat:@"%d PM", hour-11];
    }else{
        return [NSString stringWithFormat:@"%d AM", hour];
    }
}

@end
