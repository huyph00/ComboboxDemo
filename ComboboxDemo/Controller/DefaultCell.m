//
//  DefaultCell.m
//  ComboboxDemo
//
//  Created by NCXT on 09/05/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import "DefaultCell.h"

@implementation DefaultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  //  self = [[[NSBundle mainBundle] loadNibNamed:@"CustomViewCell" owner:self options:nil] objectAtIndex:0] ;

    if (self) {
        
        // Initialization code
        UIView *containerView = [[[NSBundle mainBundle] loadNibNamed:@"CustomViewCell"  owner:self    options:nil] lastObject];
        self.frame = containerView.frame;

        [self addSubview:containerView];
        


    }
    return self;
}
//- (id)init {
//    
//    UITableViewCellStyle style = UITableViewCellStyleDefault;
//    NSString *identifier = NSStringFromClass([self class]);
//    
//    if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
//        
//        NSString *nibName = [[self class] nibName];
//        if (nibName) {
//            
//            [[NSBundle mainBundle] loadNibNamed:nibName
//                                          owner:self
//                                        options:nil];
//            
//            NSAssert(self.content != nil, @"NIB file loaded but content property not set.");
//            [self addSubview:self.content];
//        }
//    }
//    return self;
//}

- (void)awakeFromNib
{
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
