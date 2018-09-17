//
//  ViewController.m
//  WJHoverFlowLayout
//
//  Created by 王杰 on 16/4/22.
//  Copyright © 2016年 王杰. All rights reserved.
//

#import "ViewController.h"
#import "WJHoverFlowLayout.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.collectionView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    } else if (section == 1) {
        return 12;
    }
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
    UILabel *label = [reusableView viewWithTag:10000];
    if (!label) {
        label = [[UILabel alloc] init];
        label.text = @"我是sectionHeaderView,第二个悬浮";
        label.frame = CGRectMake(10, 0, 300, 45);
        label.tag = 10000;
        [reusableView addSubview:label];
    }
    reusableView.backgroundColor = [UIColor redColor];
    return reusableView;
}


#pragma mark setter and Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        WJHoverFlowLayout *layout = [[WJHoverFlowLayout alloc] init];
        layout.section = 1;//section为1那行悬停
        layout.itemSize = CGSizeMake((self.view.frame.size.width - 30) / 2.0, 200);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 45);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    }
    return _collectionView;
}

@end
