//
//  ComboboxView.h
//  ComboboxDemo
//
//  Created by NCXT on 08/05/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DOWN,
	UP
} dropBoxShowMode;
typedef enum {
    AND,
	OR
} search_type;
@protocol ComboboxViewDelegate

-(void)cellSelected:(id )returnCell;

@end
@interface ComboboxView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *tbvDropBox;
    
    NSArray *dataArray; //all data
    
    NSArray *resultArray; //data to show

    BOOL isCheckBoxSelected;
    
    CGRect dropBoxRect;
    
    dropBoxShowMode showMode;
    
    CGFloat cellHeight;
    
    Class cellView;
    
    UIView *dropBoxView;
    
    id<ComboboxViewDelegate> delegate;

    UIButton * clearButton;
    
    UITextField * textInput;
    
    search_type searchType;
 
    NSArray * searchVariable;
    
    NSString * customViewCell;//class customviewcell
    
    id selectedObj;//selected dictionary
    
    NSTimer * disapearButtonTimer;
    
    NSDictionary *dicProperties;

    NSArray * arrObjProperties;

}
//@property(nonatomic) CGRect dropBoxRect;

@property(nonatomic) dropBoxShowMode showMode;
@property(nonatomic) CGFloat cellHeight;
@property(nonatomic) BOOL isCheckBoxSelected;
@property(nonatomic,strong) id selectedObj;

//@property(nonatomic,strong) UIView * dropBoxView;
@property (nonatomic,strong) id<ComboboxViewDelegate> delegate;

//set dropbox x and width
-(void)setDropBoxWidth:(CGFloat)width;
-(void)setDropBoxOrogin_x:(CGFloat)origin_x;

-(void)setDicProperties:(NSDictionary *)dic;

//this array must be dictionary
-(void)setDataArray:(NSArray *)data;

-(void)setSearchType:(NSDictionary*)searchTypeDic;//searchtype must contain :array "variables" and
                                                //"type"
                                                //

-(id)initWithFrame:(CGRect)frame dataArray:(NSArray*)data  isCheckBox:(BOOL)isCheckBox cell:(NSString *)cell font:(UIFont*)font textPlaceHolder:(NSString*)textPlaceHolder;
@end
