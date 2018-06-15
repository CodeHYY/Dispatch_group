//
//  NetTask.m
//  GCD_Group
//
//  Created by toro宇 on 2018/6/15.
//  Copyright © 2018年 CodeYu. All rights reserved.
//

#import "NetTask.h"

@implementation NetTask

+(void)netTaskToolWithUrl:(NSString *)urlStr param:(NSDictionary *)param sucess:(void(^)(NSData  * response))successBlock failed:(void(^)(NSError *error))failedBlock;

{
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
    [req setURL:[NSURL URLWithString:urlStr]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *task =   [session downloadTaskWithRequest:req completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
      if (!error) {
          if (successBlock) {
              NSData *data = [NSData dataWithContentsOfURL:location];
              successBlock(data);
          }
      }else
      {
          if (failedBlock) {
              failedBlock(error);
          }
      }
    }];
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [task resume];

    });
    
    
}

@end
