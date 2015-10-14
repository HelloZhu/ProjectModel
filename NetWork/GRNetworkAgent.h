//
//  GRNetworkAgent.h
//  GRNetworkDemo
//
//  Created by YiLiFILM on 14/11/25.
//  Copyright (c) 2014年 YiLiFILM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRBaseRequest.h"
#import "AFNetworking.h"

typedef void(^SuccessBlcok)(id object);
typedef void(^FailBlcok)(id object);

@interface GRNetworkAgent : NSObject


+ (GRNetworkAgent *)sharedInstance;


- (void)requestUrl:(NSString *)url param:(NSDictionary *)requestArgument baseUrl:(NSString *)baseUrl withRequestMethod:(GRRequestMethod)requestMethod withCompletionBlockWithSuccess:(void (^)(GRBaseRequest *request, id reponeObject))success failure:(void (^)(GRBaseRequest *request, NSError *error))failure withTag:(NSInteger)tag;

/**
 *  表单式上传文件
 *
 *  @param url
 *  @param baseUrl
 *  @param filePath  需要上传的文件的路径
 *  @param requestArgument 参数
 *  @param success
 *  @param failure
 *  @param tag             
 */
- (void)uploadFile:(NSString *)url
           baseUrl:(NSString *)baseUrl
          filePath:(NSString *)filePath
          fileName:(NSString *)fileName
             param:(NSDictionary *)requestArgument
           Success:(void (^)(GRBaseRequest *request, id reponeObject))success
           failure:(void (^)(GRBaseRequest *request, NSError *error))failure withTag:(NSInteger)tag;

- (void)uploadFile:(NSData *)date
           baseUrl:(NSString *)relativeUrl
          fileName:(NSString *)fileName
             param:(NSDictionary *)requestArgument
           Success:(void (^)(GRBaseRequest *request, id reponeObject))success
           failure:(void (^)(GRBaseRequest *request, NSError *error))failure withTag:(NSInteger)tag;

- (void)addRequest:(GRBaseRequest *)request;
- (void)cancelRequest:(NSInteger)tag;
- (void)cancelAllRequests;
@end
