//
//  HXNetworkManager.m
//  HXAssessment
//
//  Created by Felix_Y on 14-5-28.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXNetworkManager.h"
#import "HXCacheManager.h"

#import <ConciseKit.h>

NSString * const kService = @"http://eplatform.edu-edu.com.cn/exam-admin/cas_security_check";

NSString * const kCasCheck = @"cas/client/get_tgt";   //Login
NSString * const kGetST   = @"cas/client/get_st";
NSString * const kCheckST =  @"exam-admin/cas_security_check";

NSString * const kRegister = @"cas/web/register/save";
NSString * const kCheckCode = @"cas/captcha.png?";


NSString * const kExmaMudels = @"exam-admin/home/my/exams/list";
NSString * const kCheckExmaMudel  = @"my/module/exams/check/access";
NSString * const kLastExams = @"exam-admin/home/my/module/exams/latest";


//eplatform.edu-edu.com.cn/exam-admin/home/my/module/exams/list/1?moduleId=2&pageCount=5&site_preference=mobile&ct=clien
NSString * const kExmaInfo  = @"exam-admin/home/my/module/exams/list";
NSString * const kCheckExam = @"my/exam/view/result/json";
NSString * const kStartExam = @"exam-admin/home/my/exam/start/json";

NSString * const kFinishExam = @"student/exam/finished/json";

NSString * const kRestartExam = @"my/exam/restart/json";

NSString * const kRightAnswer = @"student/exam/answer";
NSString * const kUserAnswer  = @"student/exam/myanswer/list";
NSString * const kSaveAnswer  = @"student/exam/myanswer/save";

NSString * const kSubmitExam = @"student/exam/submit";

NSString * const kGetExamList = @"my/exam/view/result/json";
NSString * const kGetExamRecord = @"exam-admin/home/my/exam/view/result/json";

@implementation HXNetworkManager
SYNTHESIZE_SINGLETON_FOR_CLASS(HXNetworkManager)

+ (NSString *)makePaper:(NSString *)question{

    NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
    NSString *csspath=[mainBundleDirectory stringByAppendingPathComponent:@"html/paper_cellphone.css"];
    NSString *jspath=[mainBundleDirectory stringByAppendingPathComponent:@"html/paper_cellphone.js"];
    NSString *mathpath=[mainBundleDirectory stringByAppendingPathComponent:@"html/ASCIIMathML.js"];
    NSString *jquerypath=[mainBundleDirectory stringByAppendingPathComponent:@"html/jquery.min.js"];

    NSString *tocsspath=[[ConciseKit documentPath] stringByAppendingPathComponent:@"paper_cellphone.css"];
    NSString *tojspath=[[ConciseKit documentPath] stringByAppendingPathComponent:@"paper_cellphone.js"];
    NSString *tomathpath=[[ConciseKit documentPath] stringByAppendingPathComponent:@"ASCIIMathML.js"];
    NSString *tojquerypath=[[ConciseKit documentPath] stringByAppendingPathComponent:@"jquery.min.js"];

    [[NSString stringWithContentsOfFile:csspath encoding:NSUTF8StringEncoding error:nil]writeToFile:tocsspath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [[NSString stringWithContentsOfFile:jspath encoding:NSUTF8StringEncoding error:nil]writeToFile:tojspath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [[NSString stringWithContentsOfFile:mathpath encoding:NSUTF8StringEncoding error:nil]writeToFile:tomathpath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [[NSString stringWithContentsOfFile:jquerypath encoding:NSUTF8StringEncoding error:nil]writeToFile:tojquerypath atomically:YES encoding:NSUTF8StringEncoding error:nil];

//    NSString *cssString = [NSString stringWithContentsOfFile:csspath encoding:NSUTF8StringEncoding error:nil];
//    NSString *jsString = [NSString stringWithContentsOfFile:jspath encoding:NSUTF8StringEncoding error:nil];
//    NSString *mathString = [NSString stringWithContentsOfFile:mathpath encoding:NSUTF8StringEncoding error:nil];
//    NSString *jqueryString = [NSString stringWithContentsOfFile:jquerypath encoding:NSUTF8StringEncoding error:nil];
//
//
//
//    csspath = [NSString stringWithFormat:@"file://%@",csspath];
//    jspath = [NSString stringWithFormat:@"file://%@",jspath];
//    mathpath = [NSString stringWithFormat:@"file://%@",mathpath];
//    jquerypath = [NSString stringWithFormat:@"file://%@",jquerypath];



//    NSString *htmlString = [NSString stringWithFormat:@"<head><META http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><link href=\"%@\" rel=\"stylesheet\" type=\"text/css\" /><script src=\"%@\" type=\"text/javascript\"></script><script src=\"%@\" type=\"text/javascript\"></script><script src=\"%@\" type=\"text/javascript\"></script></head><div class=\"ui-paper-wrapper\">",csspath,jspath,mathpath,jquerypath];

    NSString *htmlString = [NSString stringWithFormat:@"<head><META http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><script src=\"jquery.min.js\" type=\"text/javascript\"></script><link href=\"paper_cellphone.css\" rel=\"stylesheet\" type=\"text/css\" /><script src=\"ASCIIMathML.js\" type=\"text/javascript\"></script><script src=\"paper_cellphone_ios.js\" type=\"text/javascript\"></script></head><div class=\"ui-paper-wrapper\">"];

//    NSString *htmlString = [NSString stringWithFormat:@"<!DOCTYPE html>\n<html>\n<head>\n<style type=\"text/css\">\n%@\n</style>\n<script type=\"text/javascript\">\n%@\n</script>\n<script type=\"text/javascript\">\n%@\n</script>\n<script type=\"text/javascript\">\n%@\n</script>\n</head>\n<body>\n<div class=\"ui-paper-wrapper\">\n",cssString,jsString,mathString,jqueryString];
    
    question = [question stringByReplacingOccurrencesOfString:@"&#13;" withString:@""];
    question = [question substringToIndex:([question length] - 16)];
    htmlString = [htmlString stringByAppendingString:question];
    htmlString = [htmlString stringByAppendingString:@"\n<script type=\"text/javascript\">function connectWebViewJavascriptBridge(callback) {"
                  "if (window.WebViewJavascriptBridge) {"
                      "callback(WebViewJavascriptBridge)"
                  "} else {"
                      "document.addEventListener('WebViewJavascriptBridgeReady', function() {"
                          "callback(WebViewJavascriptBridge)"
                      "}, false)"
                  "}"
                  "}"
                  "connectWebViewJavascriptBridge(function(bridge) {"

        "bridge.init(function(message, responseCallback) {"
            "alert('Received message: ' + message)"
            "if (responseCallback) {"
                "responseCallback(\"Right back atcha\")"
            "}"
        "})"
        "bridge.send('Hello from the javascript')"
        "bridge.send('Please respond to this', function responseCallback(responseData) {"
            "console.log(\"Javascript got its response\", responseData)"
        "})"
    "})</script>"
    "<script type=\"text/javascript\">(function(){$(document).ready(function(){__Exam_PaperInit();});})();</script>"];


    // 判断用户文件夹是否存在，不存在则创建对应文件夹

    NSFileManager *fManager = [NSFileManager defaultManager];

    BOOL isDir = FALSE;

    NSString *path = [[ConciseKit documentPath]stringByAppendingPathComponent:@"index.html"];;

    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NO];

    if(!(isDirExist && isDir))
    {

        BOOL bCreateDir = [fManager createFileAtPath:path contents:nil attributes:nil];

        if(!bCreateDir){
            DLog(@"Create Audio Directory Failed.");
        }

    }else{
        [fManager removeItemAtPath:path error:nil];
        BOOL bCreateDir = [fManager createFileAtPath:path contents:nil attributes:nil];

        if(!bCreateDir){
            DLog(@"Create Audio Directory Failed.");
        }
    }

    [htmlString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];

    return htmlString;
}


#pragma mark - ——初始化NetworkManager
- (instancetype)init{
    self = [super initWithBaseURL:[NSURL URLWithString:kHXDomain]];
    self.requestSerializer.HTTPShouldHandleCookies = YES;

    return self;
}


#pragma mark - ——登陆注册验证相关
#pragma mark 注册请求
/**
 *  注册请求
 *  userid ---- 注册账户名
 *  password---- 密码
 *  passwordConfirm---确认密码
 *  nick ---- 用户昵称，默认账号名
 *  __captcha_str_key ---- 验证码
 *  service ----- cas认证URL kServive
 *
 *  http://eplatform.edu-edu.com.cn/cas/web/register/save?site_preference=mobile&ct=client
 *  @param paramsDic 见接口描述
 {
 entityID = "<null>";
 fields =     (
 {
 hidden = 0;
 name = userid;
 value = test2;
 },
 {
 hidden = 0;
 name = email;
 value = "<null>";
 },
 {
 hidden = 0;
 name = password;
 value = 111111;
 },
 {
 hidden = 0;
 name = passwordConfirm;
 value = 111111;
 },
 {
 hidden = 0;
 name = nick;
 value = test2;
 }
 );
 isCreate = 1;
 success = 1;
 }

 */
- (void)registerWithParams:(NSDictionary *)paramsDic success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure{

    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:paramsDic];
    [muDic addEntriesFromDictionary:@{@"service":kService,@"site_preference":@"mobile",@"ct":@"client"}];

    [self POST:kRegister parameters:muDic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        DLog(@"success:%@",responseObject);

        if (responseObject[@"success"]) {
            success(responseObject);
        }else{
            NSError *er = [[NSError alloc]init];
            failure(er);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

#pragma mark 登陆请求
/**
 *  登陆请求
 *  userid ---- 用户账户名
 *  password ------ 账户密码
 *  service ------ 认证appid, 如http://eplatform.edu-edu.com.cn/exam-admin/cas_security_check。
 *  :http://eplatform.edu-edu.com.cn/cas/client/get_tgt?site_preference=mobile&ct=clien
 *  @param paramsDic 见接口描述
 */
- (void)loginWithParams:(NSDictionary *)paramsDic success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure{
    //NSDictionary *testDic = @{@"userid": @"chenx@edu-edu.com.cn",@"password":@"chenxi",@"service":kService,@"site_preference":@"mobile",@"ct":@"client"};


    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:paramsDic];
    [muDic addEntriesFromDictionary:@{@"service":kService,@"site_preference":@"mobile",@"ct":@"clien"}];

//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[kHXDomain stringByAppendingPathComponent:kCasCheck]]];
//
//    for (id key in [muDic allKeys]) {
//        if ([key isEqualToString:@"userid"]) {
//            [request setValue:[paramsDic[@"userid"] stringValue] forKey:@"userid"];
//            break;
//        }
//        [request setValue:muDic[key] forUndefinedKey:key];
//    }
//
//    [request setHTTPMethod: @"POST"];
//
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//        DLog(@"success:%@",responseObject);
//
//
//        if (responseObject[@"success"]) {
//
//            success(responseObject);
//        }else{
//            NSError *er = [[NSError alloc]init];
//            failure(er);
//        }
//
//    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
//        DLog(@"error:%@",error);
//        HXAlert(nil, error.description, @"OK");
//        
//    }];
//    [operation start];

    AFHTTPRequestOperation *loginOperation  = [self POST:kCasCheck parameters:muDic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        DLog(@"success:%@",responseObject);


        if (responseObject[@"success"]) {
            [[HXCacheManager sharedHXCacheManager]loadUserPath:muDic[@"userid"]];
            success(responseObject);
        }else{
            NSError *er = [[NSError alloc]init];
            failure(er);
        }

    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        HXAlert(nil, error.description, @"OK");

    }];

    [loginOperation start];

}

#pragma mark 获取ST请求
/**
 *  该接口主要用于跨多个客户端程序实现单点登录。
 *  如果有多个客户端应用使用同一单点登录服务器时，如果有一个应用登录成功了，
 *  可以将tgt保存在移动端设备关联的账号信息中，
 *  其他应用可以从账号中读取tgt属性，直接通过tgt获得st，再st的验证，完成单点登录。
 *
 *  @param paramsDic @{tgt:value}
 */
- (void)getSTCodeParams:(NSDictionary *)paramsDic success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure{

    [self GET:kGetST parameters:paramsDic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

#pragma mark 验证ST
/**
 *  验证st值是否有效，从而判断应用服务器的登录是否成功。
 *
 *  @param ST      @{st:value}
 */
- (void)verifyST:(NSString *)ST success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure{

    [self GET:kCheckST parameters:@{@"st":ST,@"site_preference":@"mobile",@"ct":@"client"} success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {

        if (responseObject[@"success"]) {
            success(responseObject);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        failure(error);
    }];
}

#pragma mark - ——模块考试
#pragma mark 获取模块考试数据
/**
 *  获取大模块考试数据
 *
 *  @param page      请求的数据页码
 *  @param pageCount 每页请求数据个数
 *///http://eplatform.edu-edu.com.cn/exam-admin/home/my/exams/list/1?pageCount=10&site_preference=mobile&ct=clien
- (void)getExmaModulesWithPage:(NSInteger )page andPageCount:(NSInteger )pageCount success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure{

    NSString *urlString = [kExmaMudels stringByAppendingPathComponent:[@(page) stringValue]];

    [self GET:urlString parameters:@{@"pageCount":@(pageCount),@"site_preference":@"mobile",@"ct":@"client"} success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {

        if (responseObject[@"success"]) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

}


/**
 *  用于判断此考试是否授权禁用、授权过期、模块关闭
 *
 *  @param moduleid 考试模块id
 */
- (void)checkExmaModelStatusWithModuleid:(NSInteger )moduleid success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure{

}


- (void)getLastExams:(NSInteger)count success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure{

    NSString *urlString = [kLastExams stringByAppendingPathComponent:[@(count) stringValue]];

    [self GET:urlString parameters:@{@"site_preference":@"mobile",@"ct":@"client"} success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {

        if (responseObject[@"success"]) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - --考试列表
//eplatform.edu-edu.com.cn/exam-admin/home/my/module/exams/list/1?moduleId=2&pageCount=5&site_preference=mobile&ct=clien
- (void)getExmas:(NSInteger)mudoleId withPage:(NSInteger )page andPageCount:(NSInteger )count success:(HXArrayBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure {

    NSString *urlString = [kExmaInfo stringByAppendingPathComponent:[@(page) stringValue]];

    [self GET:urlString parameters:@{@"moduleId":@(mudoleId),@"count":@(count),@"site_preference":@"mobile",@"ct":@"client"} success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {

        if (responseObject[@"success"]) {
            success(responseObject[@"body"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

}

#pragma mark - 初始化考试，获取考试信息
//home/my/exam/start/json/
- (void)getExamStartInfo:(NSInteger )examId success:(HXObjectBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure{
    NSString *urlString = [kStartExam stringByAppendingPathComponent:[@(examId) stringValue]];

    [self GET:urlString parameters:@{@"site_preference":@"mobile",@"ct":@"client"} success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
//        context = "http://eplatform.edu-edu.com.cn/exam";
//        success = 1;
//        url = "http://eplatform.edu-edu.com.cn/exam/student/exam/start/json/202/46/222/193/1402754656817?lt=100&cj=0&cc=0&co=0&m=9f020991a46ada0ee2d57329c82943b8&et=1402760656842&asr=1&asa=0&ss=0&ps=1&s=1&sc=1";

        if (responseObject[@"success"] && !responseObject[@"errMsg"]) {
            success(responseObject[@"url"]);
            //[weakSelf __downloadExamFile:responseObject[@"url"]];
        }else{
            HXAlert(@"提示", responseObject[@"errMsg"], @"确认");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)loadExamInfo:(NSURL *)url success:(HXObjectBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure{

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject[@"success"]) {
            success(responseObject);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        DLog(@"Error: %@", error);
    }];
    
    [operation start];
}

- (AFHTTPRequestOperation *)downloadExamFile:(NSString *)urlString examMudelId:(NSInteger)mudelId withExamId:(NSInteger)examId success:(HXObjectBlock)success error:(HXIndexBlock)error{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];



//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *examPath = [[HXCacheManager sharedHXCacheManager]saveExam:[@(mudelId) stringValue] withExamMudelID:[@(examId) stringValue]];
    NSString *path = [examPath stringByAppendingPathComponent:@"exam.html"];

    BOOL bCreateDir = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NO];
    if (bCreateDir) {
        success(path);
        return nil;
    }

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:YES];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"Successfully downloaded file to %@", path);
        success(path);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
    
    [operation start];

    return operation;
}

#pragma mark - 获取考试记录
- (void)getExamRecord:(NSInteger )examID success:(HXObjectBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure{
    [self GET:kGetExamRecord parameters:@{@"examId":@(examID)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject[@"success"]) {
            success(responseObject);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}



@end
