//
//  ComboboxView.m
//  ComboboxDemo
//
//  Created by NCXT on 08/05/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import "ComboboxView.h"
@implementation ComboboxView
@synthesize showMode,dropBoxView,delegate,cellHeight;

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
-(id)initWithFrame:(CGRect)frame dataArray:(NSArray*)data  isCheckBox:(BOOL)isCheckBox cell:(NSString *)cell font:(UIFont*)font textPlaceHolder:(NSString*)textPlaceHolder;
{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        dataArray = data;
        resultArray = [NSArray arrayWithArray:dataArray];
        
        cellView = NSClassFromString(cell);
        cellHeight = 44;
        
        id cell = [[cellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UIView *view = (UIView *)cell;
        
        NSLog(@"height %f",view.frame.size.height);
        
        cellHeight = view.bounds.size.height;
        //  if(containerView)
        
        
        
        CGFloat btnHeight = frame.size.height;
        CGRect textRect = CGRectMake(0, 0, self.frame.size.width - btnHeight, btnHeight);
        CGRect btnDropRect;

        if (isCheckBox) {
            //setup checkBoxbtn
            textRect.origin.x =btnHeight;
            textRect.size.width =self.frame.size.width - btnHeight*2;
            
            UIButton *checkBox = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnHeight, btnHeight)];
            checkBox.backgroundColor = [UIColor whiteColor];
            [checkBox setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checkBox-normal" ofType:@"png"]] forState:UIControlStateNormal];
            [checkBox addTarget:self action:@selector(selectCheckBox:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:checkBox];
            
        }
        btnDropRect= CGRectMake(textRect.origin.x + textRect.size.width, 0,btnHeight, btnHeight);
        
        //setup textfield
        textInput = [[UITextField alloc]initWithFrame:textRect];
        
        textInput.placeholder = textPlaceHolder;
        textInput.borderStyle = UITextBorderStyleNone;
        textInput.delegate = self;
        textInput.background = [self standarScaleWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"textBackGround" ofType:@"png"]]];
        [self addSubview:textInput];
        //drop button
        UIButton *dropBtn = [[UIButton alloc]initWithFrame:btnDropRect];
        dropBtn.backgroundColor = [UIColor whiteColor];
        [dropBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dropBtn-normal" ofType:@"png"]] forState:UIControlStateNormal];
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
        [clearButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button-clear" ofType:@"png"]] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(unselectOption) forControlEvents:UIControlEventTouchUpInside];
        clearButton.backgroundColor = [UIColor whiteColor];
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
    if(!dropBoxView) [self showDropBox:YES];
    else [self showDropBox:dropBoxView.isHidden];
}
-(void)setDataArray:(NSArray *)data
{
    dataArray = data;
}
-(void)selectCheckBox:(UIButton*)sender
{
    isCheckBoxSelected = !isCheckBoxSelected;
    if (isCheckBoxSelected) {
        [sender setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checkBox-active" ofType:@"png"]] forState:UIControlStateNormal];
    }
    else
    {
        
        [sender setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checkBox-normal" ofType:@"png"]] forState:UIControlStateNormal];
    }
    
}
-(void)showDropBox:(BOOL)isShow
{
    if (!dropBoxView)
    {
        //resetup dropbox frame
        CGRect dropBoxFrame =self.frame;
        dropBoxFrame.size.height = cellHeight*5+10;
        CGFloat tableHeight = cellHeight*5 ;
        CGFloat tableWidth = self.frame.size.width - 10 ;
        tbvDropBox = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, tableWidth, tableHeight)];
        tbvDropBox.backgroundColor = [UIColor whiteColor];
        tbvDropBox.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbvDropBox.delegate = self;
        tbvDropBox.dataSource = self;
        switch (showMode) {
            case UP:
            {
                dropBoxFrame.origin.y -= (cellHeight * 5 + 10);
            }
                break;
            case DOWN:
            {
                dropBoxFrame.origin.y += self.frame.size.height;
                
            }
                break;
            default:
                break;
        }
        dropBoxView = [[UIView alloc]init];
        dropBoxView.frame = dropBoxFrame;

        UIImageView *bgImage = [[UIImageView alloc]initWithFrame:dropBoxView.bounds] ;
        bgImage.image = [self standarScaleWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dropbox-bg" ofType:@"png"]]];
        [dropBoxView addSubview:bgImage];
        [dropBoxView addSubview:tbvDropBox];
        dropBoxView.backgroundColor = [UIColor whiteColor];
        [self.superview addSubview:dropBoxView];
        dropBoxView.hidden = !isShow;
        return;
    }
    CGRect boxRect = self.frame;
    boxRect.size.height = cellHeight*5+10;
    switch (showMode) {
        case UP:
        {
            boxRect.origin.y -=(cellHeight * 5 + 10);
        }
            break;
        case DOWN:
        {
            boxRect.origin.y += self.frame.size.height;
            
        }
            break;
        default:
            break;
    }
    dropBoxView.frame = boxRect;
    dropBoxView.hidden = !isShow;
}
-(NSArray*)resultWithKey:(NSString *)key
{
    
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i< dataArray.count; i++) {
        
        NSDictionary * cellDic = [dataArray objectAtIndex:i];
        for (NSString *  cellKey in cellDic) {
            BOOL result = false;
            for (NSString * variable in searchVariable) {
                if ([variable isEqualToString:cellKey]) {

                    result = [self searchInString:[cellDic valueForKey:variable] withKey:key];

                }
                if(result && searchType == OR) break;
                else if(!result && searchType == AND) break;
            }
            
            if(result)
                
            {
                [resultArr addObject:[dataArray objectAtIndex:i]];
                break;
            }

        }
        
        

    }
    
    
    return resultArr;
}


-(BOOL)searchInString:(NSString *)string withKey:(NSString *)key
{
    if ([string rangeOfString:key].location == NSNotFound) {
        //NSLog(@"string does not contain bla");
        
    } else {
        //NSLog(@"string contains bla!");

        return true;
    }
    return false;
}

-(void)setSearchType:(NSDictionary *)searchTypeDic
{
    
    searchVariable = [searchTypeDic objectForKey:@"variable"];
  
    NSString * type = [searchTypeDic objectForKey:@"type"];
    if ([type isEqualToString:@"and"]) {
        searchType = AND;
    
    }
    else searchType = OR;
}
#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    NSString * key = [NSString stringWithFormat:@"%@%@",textField.text,string];
    [self showDropBox:YES];
    //auto search
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        resultArray = [self resultWithKey:key];
        dispatch_async( dispatch_get_main_queue(), ^{

            [tbvDropBox reloadData];
        });
    });    return YES;
}
#pragma mark - table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [textInput resignFirstResponder];

 //   [delegate cellSelected:indexPath.row];
    textInput.text = [resultArray objectAtIndex:indexPath.row];
    [self showDropBox:NO];
}

#pragma mark - table database
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return resultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return cellHeight;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
		cell = [[cellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		
    }

    NSDictionary * data = [resultArray objectAtIndex:indexPath.row];
    
    for (NSString *key in data.allKeys) {
        id obj;
        @try {
            obj = [cell valueForKey:key];
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
        @finally {
            // Added to show finally works as well
        }
        if(obj)
        {
            
            if ([obj isKindOfClass:[UILabel class]]) {
                [obj setText:[data objectForKey:key]];

            }
            else if ([obj isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)obj).image = [data objectForKey:key];
            }
        }
    }
    return cell;
}
#pragma mark - swipe method
- (void)unselectOption
{
    textInput.text = @"";
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
    clearButton.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:4.0
                                     target:self
                                   selector:@selector(hiddenClearBtn)
                                   userInfo:nil
                                    repeats:NO];
    
    
//    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
//        NSLog(@"Left Swipe");
//    }
//    
//    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
//        NSLog(@"Right Swipe");
//    }
    
}
@end
