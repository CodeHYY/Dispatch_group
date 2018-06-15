//
//  ViewController.m
//  GCD_Group
//
//  Created by toro宇 on 2018/6/15.
//  Copyright © 2018年 CodeYu. All rights reserved.
//

#import "ViewController.h"
#import "NetTask.h"

@interface ViewController ()
@property (nonatomic, weak)UIImageView *imageView0;
@property (nonatomic, weak)UIImageView *imageView1;
@property (nonatomic, weak)UIImageView *imageView2;

@property(nonatomic,strong)NSMutableArray *dataAry;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCustomUI];
    
    // dispatch_group  线程操作之间的顺序关系处理.
    
    /**
     核心代码:
     dispatch_group_t group =   dispatch_group_create();// 创建group
     dispatch_group_enter(group); // 将下一个GCD操作放入改Group
     dispatch_async(queue, ^{
     NSLog(@"线程一");
     dispatch_group_leave(group); // 改GCD操作完成 从Group完成
     
     });
     */
    
    
    // dispatch_group_notify : group中所有的Block执行完成 收到通知
    [self sendReq];
    
    //dispatch_group_wait  : dispatch_group_wait会同步地等待group中所有的block执行完毕后才继续执行
    [self sendReqWait];
    
}
#pragma mark - UI

- (void)initCustomUI
{
    UIImageView *imageOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 370, 200)];
    _imageView0 = imageOne;
    imageOne.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageOne];
    
    UIImageView *imageTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220, 370, 200)];
    _imageView1 = imageTwo;
    imageTwo.backgroundColor = [UIColor grayColor];
    [self.view addSubview:imageTwo];
    
    UIImageView *imageThree = [[UIImageView alloc] initWithFrame:CGRectMake(0, 440, 365, 200)];
    _imageView2 = imageThree;
    imageThree.backgroundColor = [UIColor greenColor];
    [self.view addSubview:imageThree];
    
}

#pragma makr - Req

- (void)sendReq
{
    // 利用 dispath_group
    
    __weak typeof(self) weakSelf = self;

    dispatch_group_t group =   dispatch_group_create();
    
    dispatch_group_enter(group);
    [NetTask netTaskToolWithUrl:@"http://img.zcool.cn/community/0142135541fe180000019ae9b8cf86.jpg@1280w_1l_2o_100sh.png" param:nil sucess:^(NSData * response) {
        [weakSelf.dataAry addObject:response];
        NSLog(@"获取到第一张图片");
        dispatch_group_leave(group);
    } failed:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    
    
    dispatch_group_enter(group);
    [NetTask netTaskToolWithUrl:@"http://img.taopic.com/uploads/allimg/140729/240450-140HZP45790.jpg" param:nil sucess:^(NSData* response) {
        [weakSelf.dataAry addObject:response];
        NSLog(@"获取到第二张图片");

        dispatch_group_leave(group);
    } failed:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [NetTask netTaskToolWithUrl:@"http://img.zcool.cn/community/0117e2571b8b246ac72538120dd8a4.jpg@1280w_1l_2o_100sh.jpg" param:nil sucess:^(NSData* response) {
        [weakSelf.dataAry addObject:response];
        NSLog(@"获取到第三张图片");

        dispatch_group_leave(group);
    } failed:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 3个请求都完成
        
        NSLog(@"三张图片都已获取,刷新UI");

        _imageView0.image = [UIImage imageWithData:self.dataAry[0]];
        _imageView1.image = [UIImage imageWithData:self.dataAry[1]];
        _imageView2.image = [UIImage imageWithData:self.dataAry[2]];

    });
}

-(void)sendReqWait
{
    dispatch_group_t group =   dispatch_group_create();
   __block NSData *data;
    dispatch_group_enter(group);
    [NetTask netTaskToolWithUrl:@"http://img.zcool.cn/community/0142135541fe180000019ae9b8cf86.jpg@1280w_1l_2o_100sh.png" param:nil sucess:^(NSData * response) {
        NSLog(@"获取到第一张图片");
        data = response;
        dispatch_group_leave(group);
    } failed:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    self.imageView0.image = [UIImage imageWithData:data];
    
}

#pragma mark -Lazy
-(NSMutableArray *)dataAry
{
    if (!_dataAry) {
        NSMutableArray *array = [NSMutableArray array];
        _dataAry = array;
    }
    return _dataAry;
}



@end
