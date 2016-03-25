//
//  MasterViewController.m
//  SwipeToSelect
//
//  Created by leon on 3/21/16.
//  Copyright © 2016 leon. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "UIStoryboard+Addition.h"
#import "TableViewCell.h"
#import "WordSource.h"
#import "UISearchView.h"
#import "UIView+Extension.h"
#import "YCXMenu.h"
#import "NSArray+Random.h"
#import "GFView.h"
#import "NSArray+SloveString.h"


@interface MasterViewController () <UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *rightButton;
//返回给tableview的数据，可修改
@property (nonatomic, strong) NSArray *words;
//从文档中读出来的词，未修改
@property (nonatomic,strong) NSArray *wordSourceArray;
//左上角弹出视图的选项
@property (nonatomic,strong) NSMutableArray *items;
//选中的内容
@property (nonatomic,strong) NSMutableArray *selectWordArray;

@property (nonatomic,strong) UITextField *inputSentenceTextField;

@property (nonatomic,strong) UIView *bottomMaskView;
/**
 *  暂存cell
 */
@property (nonatomic,strong) TableViewCell *tmpCell;

@end
#define THEME_COLOR [[UIColor blueColor] colorWithAlphaComponent:0.5]

@implementation MasterViewController

#pragma mark lazy load
-(NSMutableArray *)items {
    if(!_items) {
        _items = [NSMutableArray array];
        _items = [@[
                    [YCXMenuItem menuItem:@" 去除重复"
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@" 排序"
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@" 选中的数据"
                                    image:nil
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@" 随机排序"
                                    image:nil
                                      tag:103
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@" 匹配句子"
                                    image:nil
                                      tag:104
                                 userInfo:@{@"title":@"Menu"}]
                    
                    ] mutableCopy];
    }
    return _items;
}

-(NSMutableArray *)selectWordArray {
    if (!_selectWordArray) {
        _selectWordArray = [NSMutableArray array];
    }
    return _selectWordArray;
}

#pragma mark system

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/**
 *  筛选button事件
 */
- (void)rightButtonAction {
    
    [YCXMenu setTintColor:[UIColor grayColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.width - 50, 64, 0, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
            if (item.tag == 100) {
                NSSet *sloveWordData = [NSSet setWithArray:_wordSourceArray];
                _words = [sloveWordData allObjects];
                _wordSourceArray = _words;
                [self.tableView reloadData];
            } else if (item.tag == 101) {
                NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:YES]];
                NSArray *sortArray = [_wordSourceArray sortedArrayUsingDescriptors:sortDesc];
                _words = sortArray;
                _wordSourceArray = _words;
                [self.tableView reloadData];
                
            } else if (item.tag == 102) {
                _words = _selectWordArray;
                [self.tableView reloadData];
            } else if (item.tag == 103) {
                _words = [NSArray arrayForRandom:_words];
                [self.tableView reloadData];
            } else if (item.tag == 104) {
                NSLog(@"___________%s",__func__);
                [UIView animateWithDuration:0.7 animations:^{
                    self.bottomMaskView.frame = CGRectMake(0, 64, self.view.width, 50);
                    self.tableView.y = 50;
                }];
                
            }

        }];
    }
}

/**
 *  cell滑动
 *
 *  @param location 滑动到的位置
 */
-(void)cellSwipe:(CGPoint )location
{
    //找出相对于tableview的位置
    CGPoint locationForTableView = CGPointMake(location.x, location.y + self.tableView.contentOffset.y);
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:locationForTableView];
    TableViewCell *swipedCell  = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
    if (swipedCell != self.tmpCell) {
        self.tmpCell = swipedCell;
        if (!swipedCell.indicator.highlighted) {
            //已经选中的再次滑动，取消
            [self.selectWordArray addObject:swipedCell.wordLabel.text];
            swipedCell.indicator.highlighted = YES;
            swipedCell.indicator.backgroundColor = THEME_COLOR;
        } else {
            [self.selectWordArray removeObject:swipedCell.wordLabel.text];
            swipedCell.indicator.highlighted = NO;
            swipedCell.indicator.backgroundColor = [UIColor clearColor];
        }
    }
    
    
}

- (void)confirmSelection {
    //选中的单词
    NSLog(@"%@",_selectWordArray);

}

#pragma mark init 
- (void)initView {
    self.words = [WordSource data];
    self.wordSourceArray = [WordSource data];
    UINib *cellNib =[UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.rightButton.target = self;
    self.rightButton.action = @selector(rightButtonAction);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ok" style:UIBarButtonItemStylePlain target:self action:@selector(confirmSelection)];
    UISearchView *searchBar = [UISearchView searchBar];
    searchBar.width = 200;
    searchBar.height = 30;
    searchBar.tag = 40;
    searchBar.delegate = self;
    [searchBar addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    self.navigationItem.titleView = searchBar;
    
    //底部输入框
    self.bottomMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, self.view.width, 50)];
    _bottomMaskView.backgroundColor = [UIColor grayColor];
    [self.navigationController.view addSubview:_bottomMaskView];
    self.inputSentenceTextField = [[UITextField alloc]initWithFrame:CGRectMake(30, 10, self.view.width - 60, 30)];
    _inputSentenceTextField.tag = 50;
    _inputSentenceTextField.delegate = self;
    _inputSentenceTextField.backgroundColor = [UIColor whiteColor];
    _inputSentenceTextField.placeholder = @"请输入句子做匹配单词";
    [_inputSentenceTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [_bottomMaskView addSubview:_inputSentenceTextField];

    [self initSwipSelect];
}

- (void)initSwipSelect {
    GFView *view = [[GFView alloc]initWithFrame:CGRectMake(0, 64, 50, self.view.height - 64)];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:view];
    
    view.swipSelectPointArrayBlock = ^(CGPoint point) {
        NSLog(@"%f",point.y);
        if (point.y > 64) {
            //滑动到某一个cell选项
            [self cellSwipe:point];
        } else {
            
        }
    };
}


#pragma mark function

- (void)textFieldEditChanged:(UITextField *)textField
{
    //    条件动态匹配
    if (textField.tag == 40) {
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",textField.text];
        NSLog(@"%@",[_wordSourceArray filteredArrayUsingPredicate:pred]);
        _words = [_wordSourceArray filteredArrayUsingPredicate:pred];
        [self.tableView reloadData];
        
    } else if (textField.tag == 50) {
        
        NSArray *inputSingleWordArray = [textField.text componentsSeparatedByString:@" "];
        /**
         *  存放各个单词的各种类型 inputSingleWordTotal
         */
        NSMutableArray *inputSingleWordTotal = [NSMutableArray array];
        [inputSingleWordTotal addObjectsFromArray:[NSArray initWithArrayToLower:inputSingleWordArray]];
        [inputSingleWordTotal addObjectsFromArray:[NSArray initWithArrayToCapital:inputSingleWordArray]];
        [inputSingleWordTotal addObjectsFromArray:[NSArray initWithArrayToFirstWordCap:inputSingleWordArray]];

        NSMutableSet *inputSingleWordSet = [[NSMutableSet alloc]initWithArray:inputSingleWordTotal];
        NSSet *sourceWordSet = [[NSSet alloc]initWithArray:_wordSourceArray];
        [inputSingleWordSet intersectSet:sourceWordSet];
        _words = [inputSingleWordSet allObjects];
        [self.tableView reloadData];
    }
    
    if (textField.text == nil||[textField.text  isEqual: @""]) {
        _words = _wordSourceArray;
        [self.tableView reloadData];
    }
    
    
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = (TableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    cell.cellContentArray = _words;
    cell.row = indexPath.row;
    cell.wordLabel.text = [NSString stringWithFormat:@"%@",_words[indexPath.row]];
    
    __weak typeof(self) weakSelf = self;
    cell.customSelectedBlock = ^ (BOOL selected, NSString *string)
    {
        if (selected) {
            [weakSelf.selectWordArray addObject:string];
        }else
        {
            [weakSelf.selectWordArray removeObject:string];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *vc = [UIStoryboard detailViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(TableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectWordArray containsObject:_words[cell.row]]) {
        cell.indicator.backgroundColor = THEME_COLOR;
        cell.indicator.highlighted = YES;
    }else
    {
        cell.indicator.highlighted = NO;
        cell.indicator.backgroundColor = [UIColor clearColor];
    }
}


#pragma mark TextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    _words = _wordSourceArray;
    [self.tableView reloadData];
    if (textField.tag == 50) {
        [UIView animateWithDuration:0.7 animations:^{
            self.bottomMaskView.frame = CGRectMake(0, - 50, self.view.width, 50);
            self.tableView.y = 0;
        }];
        
    }
    return YES;
}

@end
