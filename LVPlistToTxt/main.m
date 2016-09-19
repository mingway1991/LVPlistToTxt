//
//  main.m
//  LVPlistToTxt
//
//  Created by 石茗伟 on 16/9/19.
//  Copyright © 2016年 驴妈妈. All rights reserved.
//

#import <Foundation/Foundation.h>

const char* stringFromDate(NSDate * date) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return [destDateString cStringUsingEncoding:NSASCIIStringEncoding];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc - 1 < 2) {
            printf("参数不匹配\n");
            return 0;
        }
        NSString *plistFilePath = [NSString stringWithFormat:@"%s", argv[1]];
        NSString *txtFilePath = [NSString stringWithFormat:@"%s", argv[2]];
        NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:plistFilePath];
        if (!plistDic) {
            printf("plist文件未发现内容\n");
            return 0;
        }
        NSString *appIdName = [plistDic objectForKey:@"AppIDName"];
        NSDate *createDate = [plistDic objectForKey:@"CreationDate"];
        NSArray *platform = [plistDic objectForKey:@"Platform"];
        NSDate *expirationDate = [plistDic objectForKey:@"ExpirationDate"];
        NSString *name = [plistDic objectForKey:@"Name"];
        NSArray *provisionedDevices = [plistDic objectForKey:@"ProvisionedDevices"];
        NSArray *teamIdentifier = [plistDic objectForKey:@"TeamIdentifier"];
        NSString *teamName = [plistDic objectForKey:@"TeamName"];
        NSString *uuid = [plistDic objectForKey:@"UUID"];
        NSNumber *version = [plistDic objectForKey:@"Version"];
        
        NSMutableString *content = [NSMutableString string];
        if (appIdName) {
            [content appendFormat:@"AppIDName:%@\n", appIdName];
        }
        if (name) {
            [content appendFormat:@"Name:%@\n", name];
        }
        if (teamName) {
            [content appendFormat:@"TeamName:%@\n", teamName];
        }
        if (uuid) {
            [content appendFormat:@"UUID:%@\n", uuid];
        }
        if (version) {
            [content appendFormat:@"Version:%@\n", version];
        }
        if (createDate) {
            [content appendFormat:@"CreateDate:%s\n", stringFromDate(createDate)];
        }
        if (expirationDate) {
            [content appendFormat:@"ExpirationDate:%s\n", stringFromDate(expirationDate)];
        }
        if (platform) {
            [content appendFormat:@"Platform:%@\n", [platform componentsJoinedByString:@","]];
        }
        if (provisionedDevices) {
            [content appendFormat:@"ProvisionedDevices:%@\n", [provisionedDevices componentsJoinedByString:@","]];
        }
        if (teamIdentifier) {
            [content appendFormat:@"TeamIdentifier:%@\n", [teamIdentifier componentsJoinedByString:@","]];
        }
        
        NSError *error;
        [content writeToFile:txtFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            printf("导出txt文件失败:%s\n", [error.localizedDescription cStringUsingEncoding:NSASCIIStringEncoding]);
        }else{
            printf("导出成功\n");
        }
    }
    return 0;
}
