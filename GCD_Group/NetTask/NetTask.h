//
//  NetTask.h
//  GCD_Group
//
//  Created by toro宇 on 2018/6/15.
//  Copyright © 2018年 CodeYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetTask : NSObject

+(void)netTaskToolWithUrl:(NSString *)urlStr param:(NSDictionary *)param sucess:(void(^)(NSData  * response))successBlock failed:(void(^)(NSError *error))failedBlock;

@end
