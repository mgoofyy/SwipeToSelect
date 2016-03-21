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


@interface MasterViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *rightButton;
@property (nonatomic, strong) NSArray *words;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.words = [WordSource data];
    UINib *cellNib =[UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.rightButton.target = self;
    self.rightButton.action = @selector(confirmSelection);
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)confirmSelection {
#warning not implemented
    /**
     *  log all selected words in console
     */
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
    cell.wordLabel.text = self.words[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *vc = [UIStoryboard detailViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
