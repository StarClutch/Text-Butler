//
//  SendMesage.h
//  textMessageApp
//
//  Created by Blake Shetter on 12/2/14.
//  Copyright (c) 2014 Blake Shetter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendMessage : NSObject

-(void)sendMessageTo:(NSString *)toNumber from:(NSString *)fromNumber message:(NSString *)message date:(NSDate *)date withCompletionHandler:(void (^)(void))completionHandler;
@property (nonatomic) BOOL failedMessage;

@end
