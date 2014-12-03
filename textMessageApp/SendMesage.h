//
//  SendMesage.h
//  textMessageApp
//
//  Created by Blake Shetter on 12/2/14.
//  Copyright (c) 2014 Blake Shetter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendMesage : NSObject

-(void)sendMessageTo:(NSString *)to from:(NSString *)from message:(NSString *)message date:(NSDate *)date withCompletionHandler:(void (^)(void))completionHandler;
-(void)cancelMessageSendingwithCompletionHandler:(void (^)(void))completionHandler;

@property (nonatomic) BOOL failedMessage;
@property (strong,nonatomic) NSString *errorMessage;

@end
