//
//  BaseViewController.m
//  JMNavigationBarTransitionDemo
//
//  Created by lxb on 2018/5/23.
//  Copyright © 2018年 lxb. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBackButton];
    [self addTableView];
    [self createSlider];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)addBackButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    backButton.imageEdgeInsets = UIEdgeInsetsMake(14, 14, 14, 14);
    backButton.adjustsImageWhenHighlighted = NO;
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44 * 5) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"push";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"pop";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIViewController *viewC;
        if ([NSStringFromClass([self class]) isEqualToString:@"ViewController"]) {
            viewC = [[NSClassFromString(@"NextViewController") alloc] init];
        } else {
            viewC = [[NSClassFromString(@"ViewController") alloc] init];
        }
        viewC.jm_navBarBackgroundColor = self.nextNavBarDifferentColor ? [UIColor colorWithRed:(arc4random() % 255) / 255.0 green:(arc4random() % 255) / 255.0 blue:(arc4random() % 255) / 255.0 alpha:1] : self.jm_navBarBackgroundColor;
        viewC.jm_isNavigationBarHidden = self.nextNavBarHidden;
        viewC.jm_navBarAlpha = self.nextNavBarAlpha;
        [self.navigationController pushViewController:viewC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createSlider {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_tableView.frame) + 50, 230, 50)];
    title.text = @"Next Controller Different Color";
    title.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:title];

    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 75, CGRectGetMinY(title.frame), 50, 50)];
    switchView.center = CGPointMake(switchView.center.x, title.center.y);
    switchView.tag = 1;
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchView];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame) + 10, 230, 50)];
    title1.text = @"Next Controller NavBar hidden";
    title1.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:title1];
    
    UISwitch *switchView1 = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 75, CGRectGetMinY(title1.frame), 50, 50)];
    switchView1.center = CGPointMake(switchView1.center.x, title1.center.y);
    switchView1.tag = 2;
    [switchView1 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchView1];
    
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(title1.frame) + 10, 230, 50)];
    title2.text = @"Next Controller NavBar Alpha";
    title2.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:title2];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(title2.frame) + 10, [UIScreen mainScreen].bounds.size.width - 150, 15)];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    slider.value = self.nextNavBarAlpha = 1;
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];

}

- (void)switchAction:(UISwitch *)sender {
    if (sender.tag == 1) {
        self.nextNavBarDifferentColor = sender.isOn;
    } else {
        self.nextNavBarHidden = sender.isOn;
    }
}

- (void)sliderAction:(UISlider *)slider {
    self.nextNavBarAlpha = slider.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
