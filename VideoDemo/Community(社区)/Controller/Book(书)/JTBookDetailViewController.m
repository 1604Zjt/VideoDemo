//
//  JTBookDetailViewController.m
//  VideoDemo
//
//  Created by 张俊涛 on 2018/9/21.
//  Copyright © 2018年 张俊涛. All rights reserved.
//

#import "JTBookDetailViewController.h"
#import "DCFileTool.h"
#import "DCBookListView.h"
#import "DCContentVC.h"
#import "DCPageTopView.h"
#import "DCPageBottomView.h"
#import "JTNetworking.h"
#import "JTCommentCell.h"
#import "JTCommunityCountCell.h"

@interface JTBookDetailViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, DCBookListViewDelgate, DCPageTopViewDelegate, DCPageBottomViewDelegate>
{
    CGSize _contentSize;
}
@property (nonatomic) UIPageViewController *pageViewController;

@property (nonatomic,strong) NSDictionary *attributeDict;

@property (nonatomic,strong) NSArray *list; //目录
@property (nonatomic,assign) NSInteger currentIndex; //
@property (nonatomic,assign) NSInteger currentChapter;//当前章节
@property (nonatomic,strong) NSArray *chapterArr;//拆分成章节的数组
@property (nonatomic, strong) NSArray<NSMutableAttributedString *> *pageContentArray;
@property (nonatomic) NSString *textFontSize;

@property (nonatomic,strong) DCPageTopView *topView;
@property (nonatomic,strong) DCPageBottomView *bottomView;
@property (nonatomic,strong) DCBookListView *listView;//目录视图

@property (nonatomic,strong) DCContentVC *currentVC;

@property (nonatomic) UIView *brightnessView;
@property (nonatomic) UIView *communityView;
@property (nonatomic) UIView *fontView;

//评论
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSMutableArray<JTCommentDataInfoModel *> *dataModel;
@property (nonatomic) UIView *textView;
@property (nonatomic) UIView *lineView;
@property (nonatomic) UITextField *bottomTF;
@property (nonatomic) UIButton *bottomBtn;
@property (nonatomic) UIImageView *backIV;
@property (nonatomic) UIImageView *communityIV;
@property (nonatomic) JTCommentCell *cell;
//亮度UISlider
@property (nonatomic) UISlider *brightnessSlider;
@property (nonatomic) UIImageView *brightnessLeftIV;
@property (nonatomic) UIImageView *brightnessRightIV;
//字体UISlider
@property (nonatomic) UISlider *fontSlider;
@property (nonatomic) UIImageView *fontLeftIV;
@property (nonatomic) UIImageView *fontRightIV;

//返回按钮是否隐藏
@property (nonatomic,assign) BOOL toolViewShow;

@end

@implementation JTBookDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    if (self.toolViewShow) {
        return NO;
    }else {
        return YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化
    [self initialization];
    //加载数据
    [self loadData];
    
    //添加UI
    DCContentVC *contentVC = [self viewControllerAtIndex:_currentIndex];
    [self.pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    self.parentViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.listView];
    [self.view addSubview:self.communityView];
    [self.view addSubview:self.fontView];
    [self.view addSubview:self.brightnessView];
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JTCommentCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JTCommunityCountCell" bundle:nil] forCellReuseIdentifier:@"countCell"];
    [self textView];
    [self lineView];
    [self bottomTF];
    [self bottomBtn];
    [self data];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}
//初始化视图
- (void)initialization {
    self.textFontSize = [[NSUserDefaults standardUserDefaults] objectForKey: DCTextFontSize];
    if (!self.textFontSize) {
        self.textFontSize = [NSString stringWithFormat:@"%d", DCDefaultTextFontSize];
        [[NSUserDefaults standardUserDefaults] setObject:self.textFontSize forKey:DCTextFontSize];
    }
    
    _attributeDict = @{NSFontAttributeName : [UIFont fontWithName:DCDefaultTextFontName size:DCDefaultTextFontSize]};
    _currentIndex = 0;
    _currentChapter = 0;
    _contentSize = kContentSize;
    self.toolViewShow = NO;
}
//数据加载
- (void)loadData {
    NSString *string;
    if (self.filePath) {
        string = [DCFileTool transcodingWithPath:self.filePath];
    }
    self.list = [DCFileTool getBookListWithText:string];
    self.chapterArr = [DCFileTool getChapterArrWithString:string];
    self.listView.list = self.list;
    //加载第一章文字
    [self loadChapterContentWithIndex:_currentChapter];
}

- (void)loadChapterContentWithIndex:(NSInteger)index {
    NSArray *arr = [self pagingWithContentString:self.chapterArr[index] contentSize:_contentSize textAttribute:self.attributeDict];
    
    self.pageContentArray = arr;
}

- (NSArray *)pagingWithContentString:(NSString *)contentString contentSize:(CGSize)contentSize textAttribute:(NSDictionary *)textAttribute {
    NSMutableArray *pageArray = [NSMutableArray array];
    NSMutableAttributedString *orginAttributeString = [[NSMutableAttributedString alloc] initWithString:contentString attributes:textAttribute];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:orginAttributeString];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    int i = 0;
    while (YES) {
        i++;
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:contentSize];
        [layoutManager addTextContainer:textContainer];
        NSRange rang = [layoutManager glyphRangeForTextContainer:textContainer];
        
        if (rang.length <= 0) {
            break;
        }
        NSString *str = [contentString substringWithRange:rang];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:textAttribute];
        [pageArray addObject:attStr];
    }
    return pageArray;
}

- (DCContentVC *)viewControllerAtIndex:(NSInteger)index {
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        return nil;
    }
    //创建一个新的控制器类，并且分配给相应的数据
    DCContentVC *contentVC = [[DCContentVC alloc] init];
    contentVC.content = [self.pageContentArray objectAtIndex:index];
    [contentVC setIndex:index totalPages:self.pageContentArray.count];
    
    self.currentVC = contentVC;
    
    return contentVC;
}

//手势
- (void)tap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.view];
    if (point.x < kScreenW * 0.2 || point.x > kScreenW * 0.8 || point.y < kScreenH * 0.2 || point.y > kScreenH * 0.8) {
        return;
    }
    [self.view endEditing:YES];
    if (self.toolViewShow) {
        //显示了则退回去
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.transform = CGAffineTransformIdentity;
            self.bottomView.transform = CGAffineTransformIdentity;
            self.brightnessView.transform = CGAffineTransformIdentity;
            self.fontView.transform = CGAffineTransformIdentity;
            self.communityView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.topView.hidden = YES;
            self.bottomView.hidden = YES;
            self.fontView.hidden = YES;
            self.brightnessView.hidden = YES;
            self.communityView.hidden = YES;
            self.tableView.hidden = YES;
            self.textView.hidden = YES;
        }];
    }else {
        //没显示则显示出来
        self.topView.hidden = NO;
        self.bottomView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.transform = CGAffineTransformMakeTranslation(0, toolH);
            self.bottomView.transform = CGAffineTransformMakeTranslation(0, -(toolH));
            self.topView.backgroundColor = [UIColor whiteColor];
            self.bottomView.backgroundColor = [UIColor whiteColor];
        }];
    }
    self.toolViewShow = !self.toolViewShow;
    //更新状态栏是不是显示
    [self setNeedsStatusBarAppearanceUpdate];
}

//手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 若为UITableViewCellContentView（就是击了tableViewCell），则不截获Touch事件（就是继续执行Cell的点击方法）
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (void)bookListView:(DCBookListView *)bookListView didSelectRowAtIndex:(NSInteger)index {
    //跳转到对应章节
    _currentIndex = 0;
    _currentChapter = index;
    
    [self loadChapterContentWithIndex:_currentChapter];
    self.currentVC.content = self.pageContentArray[_currentIndex];
}

- (void)backInDCPageTopView:(DCPageTopView *)topView {
    [self.navigationController popViewControllerAnimated:YES];
}

//评论
- (void)communityBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        //评论显示出来
        self.communityView.hidden = NO;
        self.tableView.hidden = NO;
        self.textView.hidden = NO;
        //隐藏其他View
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
        self.fontView.hidden = YES;
        self.brightnessView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.communityView.transform = CGAffineTransformMakeTranslation(0, -500);
            self.communityView.backgroundColor = [UIColor whiteColor];
        }];
    }
}

//亮度
- (void)brightnessBtnClick:(UIButton *)btn {
    CGFloat height = 0;
    if (IS_IPHONE_X) {
        height = - 168;
    }else {
        height = - 128;
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        //亮度显示出来
        self.brightnessView.hidden = NO;
        //其他隐藏
        self.communityView.hidden = YES;
        self.fontView.hidden = YES;
        self.tableView.hidden = YES;
        self.textView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.brightnessView.transform = CGAffineTransformMakeTranslation(0, height);
            self.brightnessView.backgroundColor = [UIColor whiteColor];
        }];
    }else {
        //亮度退出去
        self.brightnessView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.brightnessView.transform = CGAffineTransformIdentity;
        }];
    }
}

//修改字体
- (void)fontBtnClick:(UIButton *)btn {
    CGFloat height = 0;
    if (IS_IPHONE_X) {
        height = - 168;
    }else {
        height = - 128;
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        //字体显示出来
        self.fontView.hidden = NO;
        //隐藏其他View
        self.communityView.hidden = YES;
        self.brightnessView.hidden = YES;
        self.tableView.hidden = YES;
        self.textView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.fontView.transform = CGAffineTransformMakeTranslation(0, height);
            self.fontView.backgroundColor = [UIColor whiteColor];
        }];
    }else {
        //字体退出去
        self.fontView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.fontView.transform = CGAffineTransformIdentity;
        }];
    }
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (_currentIndex == 0 && _currentChapter == 0) {
        //第一章第一页
        return nil;
    }else if (_currentIndex == 0 && _currentChapter > 0) {
        //非第一章第一页，加载上一张内容
        _currentChapter--;
        [self loadChapterContentWithIndex:_currentChapter];
        _currentIndex = self.pageContentArray.count - 1;
    }else {
        //不是第一页，则页码减一
        _currentIndex--;
    }
    return [self viewControllerAtIndex:_currentIndex];
}

//返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (_currentIndex >= self.pageContentArray.count - 1 && _currentChapter <= self.chapterArr.count) {
        [MBProgressHUD showOnlyTextToView:kWindow title:@"已经到底了!"];
        //最后一章最后一页
        return nil;
    }else if (_currentIndex >= self.pageContentArray.count - 1 && _currentChapter < self.chapterArr.count) {
        //非最后一章的最后一页，加载下一章内容
        _currentChapter++;
        [self loadChapterContentWithIndex:_currentChapter];
        _currentIndex = 0;
    }else {
        //不是最后一页
        _currentIndex++;
    }
    return [self viewControllerAtIndex:_currentIndex];
}

- (void)setToolViewShow:(BOOL)toolViewShow {
    _toolViewShow = toolViewShow;
    self.pageViewController.view.userInteractionEnabled = !toolViewShow;
}

- (UIPageViewController *)pageViewController {
    if (_pageViewController == nil) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}

- (DCPageTopView *)topView {
    if (_topView == nil) {
        _topView = [[DCPageTopView alloc] initWithFrame:CGRectMake(0, -(toolH), kScreenW, toolH)];
        _topView.hidden = YES;
        _topView.delegate = self;
    }
    return _topView;
}

- (DCPageBottomView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[DCPageBottomView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, toolH)];
        _bottomView.hidden = YES;
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (DCBookListView *)listView {
    if (_listView == nil) {
        _listView = [[DCBookListView alloc] initWithFrame:CGRectMake(-kScreenW * 0.8, 0, kScreenW, kScreenH)];
        _listView.hidden = YES;
        _listView.delegate = self;
    }
    return _listView;
}

- (UIView *)fontView {
    if (_fontView == nil) {
        _fontView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, toolH)];
        _fontView.hidden = YES;
        [self fontSlider];
        [self fontLeftIV];
        [self fontRightIV];
    }
    return _fontView;
}

- (UIView *)brightnessView {
    if (_brightnessView == nil) {
        _brightnessView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenH, toolH)];
        _brightnessView.hidden = YES;
        [self brightnessSlider];
        [self brightnessLeftIV];
        [self brightnessRightIV];
    }
    return _brightnessView;
}

- (UIView *)communityView {
    if (_communityView == nil) {
        _communityView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 500)];
        _communityView.hidden = YES;
    }
    return _communityView;
}

//亮度
- (UISlider *)brightnessSlider {
    if (_brightnessSlider == nil) {
        _brightnessSlider = [[UISlider alloc] init];
        _brightnessSlider.frame = CGRectMake((kScreenW - 225) / 2, 20, 225, 30);
        _brightnessSlider.minimumValue = 0;
        _brightnessSlider.maximumValue = 1;
        _brightnessSlider.value = 0.5;
        [_brightnessSlider setContinuous:YES];
        _brightnessSlider.minimumTrackTintColor = kColor(98, 155, 255);
        _brightnessSlider.maximumTrackTintColor = kColor(223, 235, 255);
        [_brightnessSlider setThumbImage:[UIImage imageNamed:@"kongzhiqi"] forState:UIControlStateNormal];
        [self.brightnessView addSubview:_brightnessSlider];
        
        [_brightnessSlider addTarget:self action:@selector(brightnessSlider:) forControlEvents:UIControlEventValueChanged];
    }
    return _brightnessSlider;
}

- (UIImageView *)brightnessLeftIV {
    if (_brightnessLeftIV == nil) {
        _brightnessLeftIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.brightnessSlider.left - 40, self.brightnessSlider.centerY - 10, 22, 22)];
        _brightnessLeftIV.image = [UIImage imageNamed:@"liangduxiao"];
        [self.brightnessView addSubview:_brightnessLeftIV];
    }
    return _brightnessLeftIV;
}

- (UIImageView *)brightnessRightIV {
    if (_brightnessRightIV == nil) {
        _brightnessRightIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.brightnessSlider.right + 20, self.brightnessSlider.centerY - 10, 22, 22)];
        _brightnessRightIV.image = [UIImage imageNamed:@"liangduda"];
        [self.brightnessView addSubview:_brightnessRightIV];
    }
    return _brightnessRightIV;
}

- (void)brightnessSlider:(UISlider *)slider {
    [UIScreen mainScreen].brightness = slider.value;
}

//字体
- (UISlider *)fontSlider {
    if (_fontSlider == nil) {
        _fontSlider = [[UISlider alloc] init];
        _fontSlider.frame = CGRectMake((kScreenW - 225) / 2, 20, 225, 30);
        _fontSlider.minimumValue = 14;
        _fontSlider.maximumValue = 26;
        _fontSlider.value = 20;
        [_fontSlider setContinuous:YES];
        _fontSlider.minimumTrackTintColor = kColor(98, 155, 255);
        _fontSlider.maximumTrackTintColor = kColor(223, 235, 255);
        [_fontSlider setThumbImage:[UIImage imageNamed:@"kongzhiqi"] forState:UIControlStateNormal];
        [self.fontView addSubview:_fontSlider];
        
        [_fontSlider addTarget:self action:@selector(fontSlider:) forControlEvents:UIControlEventValueChanged];
    }
    return _fontSlider;
}

- (UIImageView *)fontLeftIV {
    if (_fontLeftIV == nil) {
        _fontLeftIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.fontSlider.left - 40, self.fontSlider.centerY - 10, 11.1, 12.4)];
        _fontLeftIV.image = [UIImage imageNamed:@"xiao"];
        [self.fontView addSubview:_fontLeftIV];
    }
    return _fontLeftIV;
}

- (UIImageView *)fontRightIV {
    if (_fontRightIV == nil) {
        _fontRightIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.fontSlider.right + 20, self.fontSlider.centerY - 10, 17.9, 19.8)];
        _fontRightIV.image = [UIImage imageNamed:@"da"];
        [self.fontView addSubview:_fontRightIV];
    }
    return _fontRightIV;
}

- (void)fontSlider:(UISlider *)slider {
    int fontSize = self.textFontSize.intValue;
    fontSize = slider.value;
    self.textFontSize = [NSString stringWithFormat:@"%d", fontSize];
    _attributeDict = @{NSFontAttributeName : [UIFont fontWithName:DCDefaultTextFontName size:fontSize]};
    
    //存储字体大小
    [[NSUserDefaults standardUserDefaults] setObject:self.textFontSize forKey:DCTextFontSize];
    
    //重新计算分页
    [self loadChapterContentWithIndex:_currentChapter];
    self.currentVC.content = self.pageContentArray[_currentIndex];
    
    [MBProgressHUD showOnlyTextToView:kWindow title:[NSString stringWithFormat:@"字体\n%@", self.textFontSize]];

}

//评论
- (UIView *)textView {
    if (_textView == nil) {
        CGFloat height = 0;
        if (IS_IPHONE_X) {
            height = 80;
        }else {
            height = 60;
        }
        _textView = [[UIView alloc] initWithFrame:CGRectMake(0, self.communityView.height - height, kScreenW, height)];
        _textView.backgroundColor = [UIColor whiteColor];
        
        [self.communityView addSubview:_textView];
    }
    return _textView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.5)];
        _lineView.backgroundColor = [UIColor blackColor];
        _lineView.alpha = 0.1;
        [_textView addSubview:_lineView];
    }
    return _lineView;
}

- (UITextField *)bottomTF {
    if (_bottomTF == nil) {
        _bottomTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, kScreenW - 98, 40)];
        _bottomTF.layer.cornerRadius = 20;
        _bottomTF.layer.masksToBounds = YES;
        _bottomTF.placeholder = @"  说点什么吧～";
        _bottomTF.backgroundColor = kColor(242, 242, 242);
        _bottomTF.delegate = self;
        [self.textView addSubview:_bottomTF];
        
        [[NSNotificationCenter
          defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:)
         name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return _bottomTF;
}

- (UIButton *)bottomBtn {
    if (_bottomBtn == nil) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_bottomBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_bottomBtn setBackgroundColor:SYBgColor];
        _bottomBtn.layer.cornerRadius = 17.5;
        _bottomBtn.layer.masksToBounds = YES;
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _bottomBtn.backgroundColor = SYBgColor;
        _bottomBtn.frame = CGRectMake(kScreenW - 68, 7.5, 58, 35);
        [self.textView addSubview:_bottomBtn];
        
        [_bottomBtn addTarget:self action:@selector(ceacllBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.textView.y = self.view.height - self.bottomView.height;//这里的<span style="background-color: rgb(240, 240, 240);">self.toolbar就是我的输入框。</span>
            
        } else {
            self.textView.y = keyboardF.origin.y - self.textView.height * 5 + 4;
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        
        CGFloat height = 0;
        if (IS_IPHONE_X) {
            height = 80;
        }else {
            height = 60;
        }
        self.textView.frame = CGRectMake(0, kScreenH - self.textView.height, kScreenW, height);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self ceacllBtn:nil];
    
    return YES;
}

- (void)ceacllBtn:(id)sender {
    
    if ([self.bottomTF isFirstResponder]) {
        [self.bottomTF resignFirstResponder];
    }
    
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLoginKey];
    if (isLogin) {
        
    } else {
        UIAlertController *alerC = [UIAlertController alertControllerWithTitle:@"登录才可以评论哦!" message:@"要先登录才能发表评论" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:[[JTLoginViewController alloc] init] animated:YES completion:nil];
        }];
        UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        [alerC addAction:alert1];
        [alerC addAction:alert2];
        [self presentViewController:alerC animated:YES completion:nil];
        return;
    }
    
    [_bottomTF resignFirstResponder];
    if (_bottomTF.text.length > 0) {
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:2];
        muDic[@"flowImage"] = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPic];
        muDic[@"flowName"] = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        muDic[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
        muDic[@"flowTitle"] = self.bottomTF.text;
        muDic[@"appId"] = commentID;
        
        NSString *url = [NSString stringWithFormat:@"%@appCommentWeb/insert", PORTURL];
        
        [[JTNetworking shareManager] POST:url paramters:muDic success:^(NSURLSessionDataTask *task, id responseObject) {
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else {
        UIAlertController *alerC = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论不可以为空哦！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alerC addAction:alert1];
        [alerC addAction:alert2];
        [self presentViewController:alerC animated:YES completion:nil];
        return;
    }
    self.bottomTF.text = @"";
    [self data];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [self.communityView addSubview:_tableView];
        
        CGFloat height = 0;
        if (IS_IPHONE_X) {
            height = 80;
        }else {
            height = 60;
        }
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.bottom.equalTo(-height);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 60;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableView)];
        [_tableView addGestureRecognizer:tap];
    }
    return _tableView;
}

- (void)tapTableView {
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.dataModel.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JTCommunityCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countCell" forIndexPath:indexPath];
        cell.countLB.text = [NSString stringWithFormat:@"%ld条评论", self.dataModel.count];
        
        return cell;
    }else {
        _cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        NSInteger count = self.dataModel.count - 1 - indexPath.row;
        [_cell.flowImage sd_setImageWithURL:self.dataModel[count].flowImage.zjt_URL];
        _cell.flowName.text = self.dataModel[count].flowName;
        _cell.flowTitle.text = self.dataModel[count].flowTitle;
        [_cell.zanBtn setImage:[UIImage imageNamed:@"dianzan_weixuanzhong"] forState:UIControlStateNormal];
        [_cell.zanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cell.timerLB.text = [self convertTimestampsAccordingToTheLengthOfThePresentTime:[NSString stringWithFormat:@"%ld", self.dataModel[count].createdTime]];
        
        return _cell;
    }
}

- (void)zanBtnClick:(UIButton *)sender {
    sender.selected =! sender.selected;
    if (sender.selected) {//赞
        [sender setImage:[UIImage imageNamed:@"dianzan_xuanzhong"] forState:UIControlStateNormal];
    }else {//取消
        [sender setImage:[UIImage imageNamed:@"dianzan_weixuanzhong"] forState:UIControlStateNormal];
    }
}

- (void)data {
    
    //获取评论数据
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderRefresh:^{
        [JTNetworking get:[NSString stringWithFormat:@"http://119.23.38.106:80/video/appCommentWeb/%@", commentID] parameters:nil CompletionHandler:^(JTCommentModel *model, NSError *error) {
            if (error) {
                [weakSelf.dataModel removeAllObjects];
                [weakSelf.tableView endHeaderRefresh];
                [weakSelf.tableView reloadData];
                weakSelf.backIV = [[UIImageView alloc] init];
                [weakSelf.tableView addSubview:weakSelf.backIV];
                
                [weakSelf.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(0);
                    make.size.equalTo(CGSizeMake(weakSelf.tableView.width, weakSelf.tableView.height));
                }];
                weakSelf.backIV.image = [UIImage imageNamed:@"NOWiFi"];
            }else {
                [weakSelf.dataModel removeAllObjects];
                [weakSelf.dataModel addObjectsFromArray:model.dataInfo];
                [weakSelf.tableView endHeaderRefresh];
                [weakSelf.tableView reloadData];
                
                if (weakSelf.dataModel.count == 0) {
                    weakSelf.communityIV = [[UIImageView alloc] init];
                    [weakSelf.tableView addSubview:weakSelf.communityIV];
                    
                    [weakSelf.communityIV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.equalTo(0);
                        make.size.equalTo(CGSizeMake(weakSelf.tableView.width, weakSelf.tableView.height));
                    }];
                    weakSelf.communityIV.image = [UIImage imageNamed:@"NOCommunity"];
                }
            }
        }];
    }];
    [self.tableView beginHeaderRefresh];
}

- (NSMutableArray<JTCommentDataInfoModel *> *)dataModel {
    if (_dataModel == nil) {
        _dataModel = [[NSMutableArray alloc] init];
    }
    return _dataModel;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/**
 * 将时间戳（服务器获取）转换成时间 并计算发出的时间
 * 如果超过12小时  则返回时间格式为 年-月-日 时：分：秒
 * 否则，返回时间格式：
 *                如果，大于一小时，则为 -时-分钟前
 *                否则，返回   -分钟前
 **/
- (NSString *)convertTimestampsAccordingToTheLengthOfThePresentTime:(NSString *)timestamps {
    
    //NSString *nowTime = [self getCurrentTime:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = [timestamps doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    // 获取时间差 单位为秒
    NSTimeInterval secondDifference = [nowDate timeIntervalSinceDate:date];
    NSLog(@"secondDifference == %f, %@", secondDifference, [formatter stringFromDate:date]);
    if (secondDifference < 60) {
        // 几秒前发送
        return [NSString stringWithFormat:@"%.lf秒前", roundf(secondDifference)];
    } else if (secondDifference >= 60 && secondDifference < 60 * 60) {
        return [NSString stringWithFormat:@"%.lf分钟前", roundf(secondDifference/60)];
    } else if (secondDifference >= 60 * 60 && secondDifference < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%.lf小时前", roundf(secondDifference / 3600)];
    } else if (secondDifference >= 60 * 60 * 24 && secondDifference < 60 * 60 * 24 * 28) {
        return [NSString stringWithFormat:@"%.lf天前", roundf(secondDifference / (60 * 60 * 24))];
    }
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}
@end
