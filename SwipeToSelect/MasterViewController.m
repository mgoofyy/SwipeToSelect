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


@interface MasterViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *rightButton;
//返回给tableview的数据，可修改
@property (nonatomic, strong) NSArray *words;
//从文档中读出来的词，未修改
@property (nonatomic,strong) NSArray *wordSourceArray;
//左上角弹出视图的选项
@property (nonatomic,strong) NSMutableArray *items;
//选中的内容
@property (nonatomic,strong) NSMutableArray *selectWordArray;

@end
#define THEME_COLOR [[UIColor blueColor] colorWithAlphaComponent:0.5]

@implementation MasterViewController

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

- (void)confirmSelection {
    
    /**
     *  log all selected words in console
     */
}

- (void)leftBarButtonItemAction {
    [YCXMenu setTintColor:[UIColor grayColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(10, 64, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
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
            }
        }];
    }

}

#pragma mark init 
- (void)initView {
    self.words = [WordSource data];
    self.wordSourceArray = [WordSource data];
    UINib *cellNib =[UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.rightButton.target = self;
    self.rightButton.action = @selector(confirmSelection);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    UISearchView *searchBar = [UISearchView searchBar];
    searchBar.width = 200;
    searchBar.height = 30;
    searchBar.delegate = self;
    [searchBar addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    self.navigationItem.titleView = searchBar;
    
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
    NSLog(@"%ld",indexPath.row);
    
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

- (void)textFieldEditChanged:(UITextField *)textField
{
    //    条件动态匹配
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",textField.text];
    NSLog(@"%@",[_wordSourceArray filteredArrayUsingPredicate:pred]);
    _words = [_wordSourceArray filteredArrayUsingPredicate:pred];
    [self.tableView reloadData];
    if (textField.text == nil||[textField.text  isEqual: @""]) {
        _words = _wordSourceArray;
        [self.tableView reloadData];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    _words = _wordSourceArray;
    [self.tableView reloadData];
    return YES;
}





@end
