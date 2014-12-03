//
//  SendMesage.m
//  textMessageApp
//
//  Created by Blake Shetter on 12/2/14.
//  Copyright (c) 2014 Blake Shetter. All rights reserved.
//

#import "SendMessage.h"

@implementation SendMessage
-(void)sendMessageTo:(NSString *)toNumber from:(NSString *)fromNumber message:(NSString *)message date:(NSDate *)date withCompletionHandler:(void (^)(void))completionHandler{
    
    NSLog(@"Sending Twilio request");
    
    // Common constants
    NSString *kTwilioSID = @"AC50273d51b55ec6a2a64e152c3706a900";
    NSString *kTwilioSecret = @"5a16f683b0c2a9de8e5581ad845ec64b";
    NSString *kFromNumber = @"+12014250094";
    NSString *kToNumber = [@"+" stringByAppendingString:toNumber];
    NSString *kMessage = message;
    
    // Build request
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", kTwilioSID, kTwilioSecret, kTwilioSID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    // Set up the body
    NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", kFromNumber, kToNumber, kMessage];
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSError *error;
    NSURLResponse *response;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Handle the received data
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        NSString *receivedString = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"Request sent. %@", receivedString);
        completionHandler();
    }
}

@end
