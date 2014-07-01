//
//  HXCacheManager.m
//  HXAssessment
//
//  Created by Felix_Y on 14-6-23.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXCacheManager.h"
#import <ConciseKit/ConciseKit.h>

@interface HXCacheManager ()

@property (nonatomic, strong) NSString *mainUserPath;

@end

@implementation HXCacheManager
SYNTHESIZE_SINGLETON_FOR_CLASS(HXCacheManager)

- (BOOL)__checkIsExist:(NSString *)path{

    // 判断用户文件夹是否存在，不存在则创建对应文件夹

    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL isDir = FALSE;

    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];

    if(!(isDirExist && isDir))
    {

        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];

        if(!bCreateDir){
            DLog(@"Create Audio Directory Failed.");
        }
        return NO;
    }

    return YES;

}

- (void)loadUserPath:(NSString *)userName{

    NSString *userPath = [[ConciseKit documentPath] stringByAppendingPathComponent:userName];

    [self __checkIsExist:userPath];
    self.mainUserPath = userPath;
}

- (NSString *)saveExam:(NSString *)examID withExamMudelID:(NSString *)mudelID{

    NSString *mudelPath = [self.mainUserPath stringByAppendingPathComponent:mudelID];
    [self __checkIsExist:mudelPath];
    NSString *examPath = [mudelPath stringByAppendingPathComponent:examID];
    [self __checkIsExist:examPath];

    return examPath;
}

@end
