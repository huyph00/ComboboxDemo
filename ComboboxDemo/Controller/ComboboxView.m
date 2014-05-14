//
//  ComboboxView.m
//  ComboboxDemo
//
//  Created by NCXT on 08/05/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import "ComboboxView.h"
#import "objc/runtime.h"

@implementation ComboboxView
@synthesize showMode,delegate,cellHeight,isCheckBoxSelected,selectedObj;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame dataArray:(NSArray*)data  isCheckBox:(BOOL)isCheckBox cell:(NSString *)cellName font:(UIFont*)font textPlaceHolder:(NSString*)textPlaceHolder;
{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        arrData = data;
        if (arrData.count > 0) {
            arrObjProperties = [self allPropertyNamesWithClass:[[arrData objectAtIndex:0] class]];
        }
        lineSeparator = 5.0;
        arrDataToShow = [NSArray arrayWithArray:arrData];
        strCustomCellName = cellName;
        cellView = NSClassFromString(cellName);
        cellHeight = 44;
        dropBoxRect = self.frame;
        //get cell's height
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:strCustomCellName owner:self options:nil];
        id cell = [topLevelObjects objectAtIndex:0];
        cellHeight = ((UIView *)cell).frame.size.height;
        
        
        CGFloat btnHeight = frame.size.height;
        CGRect textRect = CGRectMake(0, 0, self.frame.size.width - btnHeight, btnHeight);
        CGRect btnDropRect;

        UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.bounds];
        bgView.image = [self standarScaleWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"combo-box-bg" ofType:@"png"]]];
        
        [self addSubview:bgView];
        if (isCheckBox) {
            //setup checkBoxbtn
            textRect.origin.x =btnHeight;
            textRect.size.width =self.frame.size.width - btnHeight*2;
            
            UIButton *checkBox = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnHeight, btnHeight)];
            [checkBox setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"combo-check-icon-normal" ofType:@"png"]] forState:UIControlStateNormal];
            [checkBox addTarget:self action:@selector(selectCheckBox:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:checkBox];
            
        }
        btnDropRect= CGRectMake(textRect.origin.x + textRect.size.width, 0,btnHeight, btnHeight);
        
        //setup textfield
        textInput = [[UITextField alloc]initWithFrame:textRect];
        //fix text size
        CGRect txtRect = textInput.frame;
        txtRect.origin.x += 5;
        txtRect.size.width -=10;
        textInput.frame =txtRect;
        textInput.placeholder = textPlaceHolder;
        textInput.borderStyle = UITextBorderStyleNone;
        textInput.delegate = self;
//      textInput.background = [self standarScaleWithImage:[UIImage imageWithContentsOfFile:    [[NSBundle mainBundle] pathForResource:@"textBackGround" ofType:@"png"]]];
        [self addSubview:textInput];
//      drop button
        UIButton *dropBtn = [[UIButton alloc]initWithFrame:btnDropRect];
//      dropBtn.backgroundColor = [UIColor whiteColor];
        [dropBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"combo-down-icon" ofType:@"png"]] forState:UIControlStateNormal];
        [dropBtn addTarget:self action:@selector(selectDropBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dropBtn];

        //add swipe event
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        
        // Setting the swipe direction.
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        
        // Adding the swipe gesture on view view
        [self addGestureRecognizer:swipeLeft];
        [self addGestureRecognizer:swipeRight];
        
        //add clear button
        
        CGRect clearRect = self.bounds;
        clearRect.origin.x = clearRect.size.width - 2*clearRect.size.height;
        clearRect.size.width = clearRect.size.height;
        clearButton = [[UIButton alloc]initWithFrame:clearRect];
        [clearButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"combo-delete-icon" ofType:@"png"]] forState:UIControlStateNormal];
//      [clearButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button-clear" ofType:@"png"]] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clearOption) forControlEvents:UIControlEventTouchUpInside];
        clearButton.hidden = YES;
        [self addSubview:clearButton];
    }
    return self;
    
}

-(UIImage*)standarScaleWithImage:(UIImage *)imgStandar
{

    return [imgStandar resizableImageWithCapInsets:UIEdgeInsetsMake(imgStandar.size.height/2, imgStandar.size.width/2, imgStandar.size.height/2,imgStandar.size.width/2)];
  
}


-(void)selectDropBtn
{
    if(!dropBoxView)
    {
        arrDataToShow = [NSArray arrayWithArray:arrData];
        [self showDropBox:YES];
    }
    else  [self showDropBox:dropBoxView.isHidden];
}
-(void)setDataArray:(NSArray *)data
{
    arrData = data;
}
-(void)selectCheckBox:(UIButton*)sender
{
    isCheckBoxSelected = !isCheckBoxSelected;
    if (isCheckBoxSelected) {
        [sender setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"combo-check-icon" ofType:@"png"]] forState:UIControlStateNormal];
    }
    else
    {
        
        [sender setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"combo-check-icon-normal" ofType:@"png"]] forState:UIControlStateNormal];
    }
    
}
-(void)showDropBox:(BOOL)isShow
{
    if (!dropBoxView)
    {
        //resetup dropbox frame
        
        CGRect dropBoxFrame =dropBoxRect;
        dropBoxFrame.size.width = dropBoxRect.size.width;
        dropBoxFrame.size.height = cellHeight*5+10;
        CGFloat tableHeight = cellHeight*5 ;
        CGFloat tableWidth = dropBoxFrame.size.width - 10 ;
        // init dropdown list tableview
        tbvDropBox = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, tableWidth, tableHeight)];
        tbvDropBox.backgroundColor = [UIColor clearColor];
        tbvDropBox.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbvDropBox.delegate = self;
        tbvDropBox.dataSource = self;
        [tbvDropBox registerNib:[UINib nibWithNibName:strCustomCellName
                                                   bundle:nil]
             forCellReuseIdentifier:strCustomCellName];
        UIImage * dropBoxBg ;
        //set frame for dropview
        switch (showMode) {
            case UP:
            {
                dropBoxFrame.origin.y -= (cellHeight * 5 + 10) + lineSeparator;
                dropBoxBg =[self standarScaleWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"combo-box-bg" ofType:@"png"]]];
            }
                break;
            case DOWN:
            {
                dropBoxFrame.origin.y += self.frame.size.height + lineSeparator;
                dropBoxBg =[self standarScaleWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"combo-box-bg" ofType:@"png"]]];
            }
                break;
            default:
                break;
        }
        dropBoxView = [[UIView alloc]init];
        dropBoxView.frame = dropBoxFrame;
        
        UIImageView *bgImage = [[UIImageView alloc]initWithFrame:dropBoxView.bounds] ;
        bgImage.image = dropBoxBg;
        bgImage.tag = 1111;
        [dropBoxView addSubview:bgImage];
        [dropBoxView addSubview:tbvDropBox];
        dropBoxView.backgroundColor = [UIColor whiteColor];
        [self.superview addSubview:dropBoxView];
        dropBoxView.hidden = !isShow;
        return;
    }
    CGRect boxRect = dropBoxRect;
    boxRect.size.height = cellHeight*5+10;
    UIImageView * imgBg = (UIImageView*)[dropBoxView viewWithTag:1111];

    switch (showMode) {
        case UP:
        {
            boxRect.origin.y -=(cellHeight * 5 + 10)+lineSeparator;
            imgBg.image =[self standarScaleWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"combo-box-bg" ofType:@"png"]]];
        }
            break;
        case DOWN:
        {
            boxRect.origin.y += self.frame.size.height + lineSeparator;
            imgBg.image =[self standarScaleWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"combo-box-bg" ofType:@"png"]]];
        }
            break;
        default:
            break;
    }
    dropBoxView.frame = boxRect;
    dropBoxView.hidden = !isShow;
}

- (NSArray *)allPropertyNamesWithClass:(Class )class
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

-(NSArray*)resultWithKey:(NSString *)key
{
    
    NSMutableArray *arrObjResult = [NSMutableArray array];
    for (int i = 0; i< arrData.count; i++) {
        id obj = [arrData objectAtIndex:i];

        NSMutableArray *arrValueObj = [NSMutableArray array];
        
        for (NSString *  property in arrSearchVariable) {
            if(property)[arrValueObj addObject:[obj valueForKey:property]];
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",key]; // if you need case sensitive search avoid '[c]' in the predicate
        
        NSArray *results = [arrValueObj filteredArrayUsingPredicate:predicate];
        
        if ((searchType == OR && results.count > 0 )||(searchType == AND && results.count == arrSearchVariable.count) ) {
            [arrObjResult addObject:obj];
        }
       
        
    }
    
  /*
    NSMutableArray *arrObjResult = [NSMutableArray array];
    for (int i = 0; i< dataArray.count; i++) {
        
        id obj = [dataArray objectAtIndex:i];
        
        for (NSString *  cellKey in arrObjProperties) {
            BOOL result = false;
            for (NSString * variable in searchVariable) {
                if ([variable isEqualToString:cellKey]) {

                    result = [self searchInString:[obj valueForKey:variable] withKey:key];
                    NSLog(@"%@",[obj valueForKey:variable]);
                }
                if(result && searchType == OR) break;
                else if(!result && searchType == AND) break;
                result = NO;
            }
            
            if(result)
            {
                [arrObjResult addObject:[dataArray objectAtIndex:i]];
                break;
            }
        }
    }
    */
    return arrObjResult;
}


-(BOOL)searchInString:(NSString *)string withKey:(NSString *)key
{
    if ([string rangeOfString:key].location == NSNotFound) {
        //NSLog(@"string does not contain key");
        
    } else {
        //NSLog(@"string contains key!");

        return true;
    }
    return false;
}

-(void)setSearchType:(NSDictionary *)searchTypeDic
{
    NSString * strArrayVariable = [searchTypeDic objectForKey:@"variable"];
    arrSearchVariable = [strArrayVariable componentsSeparatedByString:@","];
  
    NSString * type = [searchTypeDic objectForKey:@"searchType"];
    type = [type lowercaseStringWithLocale:[NSLocale currentLocale]];
    if ([type isEqualToString:@"and"]) {
        searchType = AND;
    
    }
    else if([type isEqualToString:@"or"])
    {
        searchType = OR;
    }
}
-(void)setDropBoxWidth:(CGFloat)width;
{
    dropBoxRect.size.width = width;
}
-(void)setDropBoxOrigin_x:(CGFloat)origin_x;
{
    dropBoxRect.origin.x = origin_x;

}
-(void)setCellView:(NSString *)className;
{
    strCustomCellName = className;
    cellView = NSClassFromString(className);
    cellHeight = 44;
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:strCustomCellName owner:self options:nil];
    id cell = [topLevelObjects objectAtIndex:0];
    cellHeight = ((UIView *)cell).frame.size.height;

}
-(void)setLineSeparator:(CGFloat)lineHeight;
{
    lineSeparator = lineHeight;
}
#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    NSString * key;
    if ([string isEqualToString:@""]&&[textField.text length] >0) {
        key = [textField.text substringToIndex:[textField.text length] - 1];

    }
    else key = [NSString stringWithFormat:@"%@%@",textField.text,string];
    [self showDropBox:YES];
    if ([key isEqualToString:@""]) {
        arrDataToShow = [NSArray arrayWithArray:arrData];
        [tbvDropBox reloadData];

        return YES;
    }
    //auto search in background
    if(bgThread && bgThread.isExecuting)  [bgThread cancel];
    bgThread = [[NSThread alloc] initWithTarget:self selector:@selector(startSearching:) object:key];
    [bgThread start];
    
//    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        @try {
//            resultArray = [self resultWithKey:key];
//
//        }
//        @catch (NSException *exception) {
//            
//        }
//        @finally {
//            
//        }
//
//        dispatch_async( dispatch_get_main_queue(), ^{
//
//            [tbvDropBox reloadData];
//        });
//    });
    return YES;
}

-(void)startSearching:(NSString *)strKeySearch
{
        @try {
            arrDataToShow = [self resultWithKey:strKeySearch];

        }
        @catch (NSException *exception) {

        }
        @finally {
            [tbvDropBox reloadData];
        }
    
}



-(void)setDicProperties:(NSDictionary *)dic;
{
    dicProperties = dic;
}
#pragma mark - table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{

    selectedObj = [arrDataToShow objectAtIndex:indexPath.row];
    [delegate cellSelected:selectedObj];
    [self showDropBox:NO];
    textInput.text = @"";
    [textInput resignFirstResponder];
}

#pragma mark - table database
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return arrDataToShow.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return cellHeight;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCustomCellName];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:strCustomCellName owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];

    }
    id  data ;
    @try {
        
        data = [arrDataToShow objectAtIndex:indexPath.row];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }

    
    for (NSString *key in dicProperties.allKeys) {
        id value;
        id cellProperty;
        @try {

            value = [data valueForKey:[dicProperties objectForKey:key]]; //get value from obj
            cellProperty = [cell valueForKey:key]; //get cell's property
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
        @finally {
            // Added to show finally works as well
            if(cellProperty)
            {
                
                if ([cellProperty isKindOfClass:[UILabel class]]) {
                    [cellProperty setText:value];
                    
                }
                else if ([cellProperty isKindOfClass:[UIImageView class]]) {
                    ((UIImageView *)cellProperty).image = value;
                }
                else if ([cellProperty isKindOfClass:[UIButton class]]) {
                    ((UIButton *)cellProperty).titleLabel.text = value;
                }
            }
        }
        
    }
    return cell;
}
#pragma mark - swipe method
- (void)clearOption
{
    [disapearButtonTimer invalidate];
    selectedObj = nil;
    arrDataToShow = [NSArray arrayWithArray:arrData];
    [tbvDropBox reloadData];
    textInput.text = @"";
    clearButton.hidden = YES;
    [delegate btnDeleteSelected];

//    [self startTimerToDisapearClearButton];
}
-(void)hiddenClearBtn
{

    [UIView transitionWithView:clearButton
                  duration:2.0
                   options:UIViewAnimationOptionTransitionCrossDissolve
                animations:NULL
                completion:NULL];

    clearButton.hidden = YES;
    
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    //handle swipe event
    if(!clearButton.hidden) return;
    [self startTimerToDisapearClearButton];
    
//    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
//        NSLog(@"Left Swipe");
//    }
//    
//    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
//        NSLog(@"Right Swipe");
//    }
    
}
-(void)startTimerToDisapearClearButton
{
    clearButton.hidden = NO;
    //set time to hide button
    disapearButtonTimer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                     target:self
                                   selector:@selector(hiddenClearBtn)
                                   userInfo:nil
                                    repeats:NO];

}
@end
