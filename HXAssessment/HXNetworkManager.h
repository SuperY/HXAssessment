//
//  HXNetworkManager.h
//  HXAssessment
//
//  Created by Felix_Y on 14-5-28.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import <AFNetworking.h>
#import "HXRequestMacro.h"

@interface HXNetworkManager : AFHTTPRequestOperationManager
SYNTHESIZE_SINGLETON_FOR_HEADER(HXNetworkManager)

#pragma mark - 登陆注册、验证状态
/**
 *  注册请求
 *  userid ---- 注册账户名
 *  password---- 密码
 *  passwordConfirm---确认密码
 *  nick ---- 用户昵称，默认账号名
 *  __captcha_str_key ---- 验证码
 *  service ----- cas认证URL kServive
 *
 *  @param paramsDic 见接口描述
 */
- (void)registerWithParams:(NSDictionary *)paramsDic success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure;

/**
 *  登陆请求
 *  userid ---- 用户账户名
 *  password ------ 账户密码
 *  service ------ 认证appid, 如http://eplatform.edu-edu.com.cn/exam-admin/cas_security_check。
 *
 *  @param paramsDic 见接口描述
 */
- (void)loginWithParams:(NSDictionary *)paramsDic success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure;

/**
 *  该接口主要用于跨多个客户端程序实现单点登录。
 *  如果有多个客户端应用使用同一单点登录服务器时，如果有一个应用登录成功了，
 *  可以将tgt保存在移动端设备关联的账号信息中，
 *  其他应用可以从账号中读取tgt属性，直接通过tgt获得st，再st的验证，完成单点登录。
 *
 *  @param paramsDic @{tgt:value}
 */
- (void)getSTCodeParams:(NSDictionary *)paramsDic success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure;

/**
 *  验证st值是否有效，从而判断应用服务器的登录是否成功。
 *
 *  @param ST      @{st:value}
 */
- (void)verifyST:(NSString *)ST success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure;

#pragma mark - 模块信息获取
/**
 *  获取大模块考试数据
 *
 *  @param page      请求的数据页码
 *  @param pageCount 每页请求数据个数
 */
- (void)getExmaModulesWithPage:(NSInteger )page andPageCount:(NSInteger )pageCount success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure;

/**
 *  用于判断此考试是否授权禁用、授权过期、模块关闭
 *
 *  @param moduleid 考试模块id
 */
- (void)checkExmaModelStatusWithModuleid:(NSInteger )moduleid success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure;

- (void)getLastExams:(NSInteger)count success:(HXDictionaryBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure;

#pragma mark - 考试列表
- (void)getExmas:(NSInteger)mudoleId withPage:(NSInteger )page andPageCount:(NSInteger )count success:(HXArrayBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure;


#pragma mark - 初始化考试，获取考试信息
- (void)getExamStartInfo:(NSInteger )examId success:(HXObjectBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure;

- (void)loadExamInfo:(NSURL *)url success:(HXObjectBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure;

- (AFHTTPRequestOperation *)downloadExamFile:(NSString *)urlString examMudelId:(NSInteger)mudelId withExamId:(NSInteger )examId success:(HXObjectBlock)success error:(HXIndexBlock)error;



+(NSString *)makePaper:(NSString *)question;


#pragma mark - 获取考试记录
- (void)getExamRecord:(NSInteger )examID success:(HXObjectBlock)success error:(HXIndexBlock)error failure:(HXErrorBlock)failure;
@end
