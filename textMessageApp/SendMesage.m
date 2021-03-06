//
//  SendMesage.m
//  textMessageApp
//
//  Created by Blake Shetter on 12/2/14.
//  Copyright (c) 2014 Blake Shetter. All rights reserved.
//

#import "SendMesage.h"

@implementation SendMesage
-(void)sendMessageTo:(NSString *)to from:(NSString *)from message:(NSString *)message date:(NSDate *)date withCompletionHandler:(void (^)(void))completionHandler{
    
    
    completionHandler();
    
}

-(void)cancelMessageSendingwithCompletionHandler:(void (^)(void))completionHandler{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pendingMessage"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sendTo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sendMessage"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sendDate"];

    [[NSUserDefaults standardUserDefaults] synchronize];

    completionHandler();
    
}


@end
