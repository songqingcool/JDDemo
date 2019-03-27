
//
//  JDMialDetailContactViewController.m
//  JDMail
//
//  Created by 千阳 on 2019/3/11.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDMialDetailContactViewController.h"
#import <Masonry.h>
#import "JDMailPerson.h"

@interface JDMialDetailContactViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSDictionary *dataDic;

@end

@implementation JDMialDetailContactViewController

-(instancetype)initWithContactDic:(NSDictionary *)contactDic
{
    if(self = [super init])
    {
        self.dataDic = contactDic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"邮件相关人";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
}


-(void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self tableViewConstraints];
}

-(void)tableViewConstraints
{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        
    }];
}

-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SystemDefaultCellIdentifier"];
    }
    return _tableView;
}

#pragma mark - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger number = self.dataDic.allKeys.count;
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    NSString *key = @"";
    switch (section) {
        case 0:
            key = @"from";
            break;
        case 1:
            key = @"recipient";
            break;
        case 2:
            key = @"ccRecipient";
            break;
        default:
            break;
    }
    NSArray *array = self.dataDic[key];
    if(array)
    {
        number = array.count;
    }
    return number;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *result = @"";
    switch (section) {
        case 0:
            result = @"发件人";
            break;
        case 1:
            result = @"收件人";
            break;
        case 2:
            result = @"抄送人";
            break;
            
        default:
            break;
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemDefaultCellIdentifier"];
    
    if(cell ==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SystemDefaultCellIdentifier"];
    }
    
    JDMailPerson *person = [self getCellDataWithIndex:indexPath];
    
    if(person)
    {
        cell.textLabel.text = person.name;
        cell.detailTextLabel.text = person.emailAddress;
        cell.imageView.image = [self imageWithColor:[UIColor lightGrayColor] withText:person.name];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (JDMailPerson *)getCellDataWithIndex:(NSIndexPath *)indexPath
{
    JDMailPerson *result = nil;
    NSArray *tmpArray = nil;
    switch (indexPath.section) {
        case 0:
            tmpArray = self.dataDic[@"from"];
            break;
        case 1:
            tmpArray = self.dataDic[@"recipient"];
            break;
        case 2:
            tmpArray = self.dataDic[@"ccRecipient"];
            break;
        default:
            break;
    }
    if(tmpArray && tmpArray.count)
    {
        result = tmpArray[indexPath.row];
    }
    return result;
}

- (void)reloadDataWith:(NSDictionary *)dic
{
    self.dataDic = dic;
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImage *)imageWithColor:(UIColor *)color withText:(NSString *)text
{
    CGRect rect = CGRectMake(0, 0, 50, 50);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, rect);
    CGRect textFrame = CGRectMake(10,5, 40, 40);
    UIFont *font = [UIFont systemFontOfSize:30];
    NSDictionary *attributeDic = @{NSFontAttributeName:font};
    [text drawInRect:textFrame withAttributes:attributeDic];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
