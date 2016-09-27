//
//  EMTableVC.m
//  customRefreshHeader
//
//  Created by xwwang_0102 on 16/9/11.
//  Copyright © 2016年 xwwang_0102. All rights reserved.
//

#import "EMTableVC.h"

@implementation EMTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 370, 44)];
    view.backgroundColor = [UIColor redColor];
   // self.tableView.legendHeader = view;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
    }];
    
//    UIEdgeInsets inset = self.tableView.contentInset;
//    inset.top = 100;
//    self.tableView.contentInset = inset;
 
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"xyz";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

@end
