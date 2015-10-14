

#import "GRNetworkAgent.h"
#import "AFHTTPRequestOperationManager.h"
#import "WSProgressHUD.h"
#import "BaseHandler.h"
#import "MBProgressHUD+Add.h"
#import "NSObject+ValidateObject.h"

@implementation GRNetworkAgent {
    AFHTTPRequestOperationManager *_manager;
    NSMutableDictionary * _requestsRecord;
}

+ (GRNetworkAgent *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (id)init {
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
    }
    return self;
}
- (void)addRequest:(GRBaseRequest *)request
{
    GRRequestMethod method = request.requestMethod;
    NSString * url = [NSString stringWithFormat:@"%@%@",request.baseUrl,request.requestUrl];
    NSDictionary * param = request.requestParam;
    
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    
    if (request.requestSerializerType == GRRequestSerializerTypeHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }else if (request.requestSerializerType == GRRequestSerializerTypeJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    if (method == GRRequestMethodGet) {
        request.requestOperation = [_manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation responeObejct:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation responeObejct:error];
        }];
    }else if (method == GRRequestMethodPost) {
        request.requestOperation = [_manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation responeObejct:responseObject];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation responeObejct:error];
        }];
    }
    [self addOperation:request];
}

//初步处理
- (void)handleRequestResult:(AFHTTPRequestOperation *)operation responeObejct:(id)responeObejct {
    NSString * key = [self requestHashKey:operation];
    GRBaseRequest *request = _requestsRecord[key];
    
    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed) {
            
            if ([responeObejct isDictionary])
            {
              
               
            }
    
        }else {
            
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request,responeObejct);
            }
        }
    }else{
    }
        
    [self removeOperation:operation];
    [request clearCompletionBlock];
}

////再次处理
//- (void)handleRequest:(GRBaseRequest *)request
//{
//    if (request) {
//        BOOL succeed = [self checkResult:request];
//        if (succeed) {
//            if (request.successCompletionBlock) {
//                request.successCompletionBlock(request);
//            }
//        }else {
//            if (request.failureCompletionBlock) {
//                request.failureCompletionBlock(request);
//            }
//        }
//    }
//}

- (BOOL)checkResult:(GRBaseRequest *)request
{
    BOOL result = [request statusCodeValidator];
    return result;
}

- (void)addOperation:(GRBaseRequest *)request {
    if (request.requestOperation != nil) {
        NSString * key = [self requestHashKey:request.requestOperation];
        _requestsRecord[key] = request;
    }
}
- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation
{
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;
}
- (void)removeOperation:(AFHTTPRequestOperation *)operation {
    NSString * key = [self requestHashKey:operation];
    [_requestsRecord removeObjectForKey:key];
}

- (void)requestUrl:(NSString *)url param:(NSDictionary *)requestArgument baseUrl:(NSString *)baseUrl withRequestMethod:(GRRequestMethod)requestMethod withCompletionBlockWithSuccess:(void (^)(GRBaseRequest *, id))success failure:(void (^)(GRBaseRequest *, NSError *))failure withTag:(NSInteger)tag

{
    GRBaseRequest * base = [[GRBaseRequest alloc] init];
    base.baseUrl = baseUrl;
    base.requestUrl = url;
    base.tag = tag;
    base.requestParam = requestArgument;
    base.requestMethod = requestMethod;
    base.successCompletionBlock = success;
    base.failureCompletionBlock = failure;
    base.requestSerializerType = GRRequestSerializerTypeHTTP;
    
    [self addRequest:base];
    
  
}

- (void)uploadFile:(NSData *)date
           baseUrl:(NSString *)relativeUrl
          fileName:(NSString *)fileName
             param:(NSDictionary *)requestArgument
           Success:(void (^)(GRBaseRequest *request, id reponeObject))success
           failure:(void (^)(GRBaseRequest *request, NSError *error))failure withTag:(NSInteger)tag
{
    GRBaseRequest * base = [[GRBaseRequest alloc] init];
    base.requestUrl = relativeUrl;
    base.tag = tag;
    base.requestParam = requestArgument;
    base.requestMethod = GRRequestMethodPost;
    base.successCompletionBlock = success;
    base.failureCompletionBlock = failure;
    base.requestSerializerType = GRRequestSerializerTypeHTTP;
    //[self addRequest:base];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"image/jpeg"];
    [_manager POST:relativeUrl parameters:requestArgument constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:date name:fileName];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self handleRequestResult:operation responeObejct:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleRequestResult:operation responeObejct:error];
    }];
    [self addOperation:base];
}

- (void)uploadFile:(NSString *)url
           baseUrl:(NSString *)baseUrl
          filePath:(NSString *)filePath
          fileName:(NSString *)fileName
             param:(NSDictionary *)requestArgument
           Success:(void (^)(GRBaseRequest *request, id reponeObject))success
           failure:(void (^)(GRBaseRequest *request, NSError *error))failure withTag:(NSInteger)tag
{
    NSString * requrl = [NSString stringWithFormat:@"%@%@",baseUrl, url];
    
    GRBaseRequest * base = [[GRBaseRequest alloc] init];
    base.baseUrl = baseUrl;
    base.requestUrl = url;
    base.tag = tag;
    base.requestParam = requestArgument;
    base.requestMethod = GRRequestMethodPost;
    base.successCompletionBlock = success;
    base.failureCompletionBlock = failure;
    base.requestSerializerType = GRRequestSerializerTypeHTTP;
    //[self addRequest:base];
    
    [_manager POST:requrl parameters:requestArgument constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSURL *fileUrl  = [NSURL fileURLWithPath:filePath];
        [formData appendPartWithFileURL:fileUrl name:fileName error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self handleRequestResult:operation responeObejct:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleRequestResult:operation responeObejct:error];
    }];
    [self addOperation:base];
}

- (void)cancelRequest:(NSInteger)tag {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        GRBaseRequest *request = copyRecord[key];
        if (request.tag == tag) {
            [request.requestOperation cancel];
            [self removeOperation:request.requestOperation];
            [request clearCompletionBlock];
        }
    }
}
- (void)cancelAllRequests {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        GRBaseRequest *request = copyRecord[key];
        [request stop];
    }
}

+ (void)showHint:(NSString *)hint
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

@end
