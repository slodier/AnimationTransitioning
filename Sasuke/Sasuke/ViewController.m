//
//  ViewController.m
//  Sasuke
//
//  Created by CC on 2016/12/20.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "ViewController.h"
#import "SecondVC.h"
#import "ConstStr.h"
#import "CubeTransitioning.h"
#import "FoldTransitioning.h"
#import "CardTransitioning.h"
#import "BombTransitioning.h"
#import "FilpTransitioning.h"
#import "TurnTransitioning.h"
#import "CrossfadeTransitioning.h"
#import "NatGeoTransitioning.h"
#import "PortalTransitioning.h"
#import "PanTransitioning.h"

static NSString *cellId = @"cell";

@interface ViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSIndexPath *seleteIndexPath; //记录点击的 indexPath

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _seleteIndexPath = indexPath;
    SecondVC *secondVC = [[SecondVC alloc]init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.backgroundColor = [UIColor cyanColor];
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    switch (_seleteIndexPath.row) {
        case 0:
        {
            CubeTransitioning *cubeTransitioning = [[CubeTransitioning alloc]init];
            return cubeTransitioning;
        }
            break;
            
        case 1:
        {
            FoldTransitioning *foldTransitioning = [[FoldTransitioning alloc]init];
            return foldTransitioning;
        }
            break;
            
        case 2:
        {
            CardTransitioning *cardTransitioning = [[CardTransitioning alloc]init];
            cardTransitioning.duration = 2;
            cardTransitioning.reverse = YES;
            return cardTransitioning;
        }
            break;
           
        case 3:
        {
            BombTransitioning *bombTransitioning = [[BombTransitioning alloc]init];
            return bombTransitioning;
        }
            break;
         
        case 4:
        {
            FilpTransitioning *filpTransitioning = [[FilpTransitioning alloc]init];
            return filpTransitioning;
        }
            break;
           
        case 5:
        {
            TurnTransitioning *turnTransitioning = [[TurnTransitioning alloc]init];
            return turnTransitioning;
        }
            break;
            
        case 6:
        {
            CrossfadeTransitioning *crossfadeTransitioning = [[CrossfadeTransitioning alloc]init];
            return crossfadeTransitioning;
        }
            break;
            
        case 7:
        {
            NatGeoTransitioning *natGeoTransitioning = [[NatGeoTransitioning alloc]init];
            natGeoTransitioning.duration = 1.5;
            natGeoTransitioning.reverse = YES;
            return natGeoTransitioning;
        }
            break;
            
        case 8:
        {
            PortalTransitioning *protalTransitioning = [[PortalTransitioning alloc]init];
            return protalTransitioning;
        }
            break;
            
        case 9:
        {
            PanTransitioning *panTransitioning = [[PanTransitioning alloc]init];
            panTransitioning.duration = 1;
            return panTransitioning;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor cyanColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray arrayWithObjects:cube, fold, card, bomb, filp, turn, crossfade, natGeo, portal, pan, nil];
    }
    return _dataSource;
}

@end
