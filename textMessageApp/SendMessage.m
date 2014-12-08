//
//  SendMesage.m
//  textMessageApp
//
//  Created by Blake Shetter on 12/2/14.
//  Copyright (c) 2014 Blake Shetter. All rights reserved.
//

#import "SendMessage.h"
#import <XMLDictionary.h>
#import <AFNetworking/AFNetworking.h>

@implementation SendMessage
-(void)sendMessageTo:(NSString *)toNumber from:(NSString *)fromNumber message:(NSString *)message date:(NSDate *)date withCompletionHandler:(void (^)(void))completionHandler{
    
    NSLog(@"Sending Twilio request");
    
    // Constants
    NSString *kTwilioSID = @"AC50273d51b55ec6a2a64e152c3706a900";
    NSString *kTwilioSecret = @"5a16f683b0c2a9de8e5581ad845ec64b";
    NSString *kFromNumber = @"+12014250094";
    NSString *kToNumber = @"+17329665576";
//    [@"+1" stringByAppendingString:toNumber];
    NSString *kMessage = message;
    
    // Set up Twilio request
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", kTwilioSID, kTwilioSecret, kTwilioSID];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:  @"From", kFromNumber,
                                                                            @"To", kToNumber,
                                                                            @"Body", kMessage, nil];
    
    // AFNetworking
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer =
    [manager POST:@"https://AC50273d51b55ec6a2a64e152c3706a900:5a16f683b0c2a9de8e5581ad845ec64b@api.twilio.com/2010-04-01/Accounts/AC50273d51b55ec6a2a64e152c3706a900/SMS/Messages" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"XML: %@", responseObject);
        self.failedMessage = NO;
        completionHandler();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.failedMessage = YES;
        completionHandler();
    }];
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
