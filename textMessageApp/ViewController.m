//
//  ViewController.m
//  textMessageApp
//
//  Created by Blake Shetter on 12/2/14.
//  Copyright (c) 2014 Blake Shetter. All rights reserved.
//

#import "ViewController.h"
#import "SendMessage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.datePicker setMinimumDate: [NSDate date]];
    self.errorMessage.hidden=YES;
    
    
    
    self.sendTo.delegate=self;
    self.sendFrom.delegate=self;
    self.sendMessage.delegate=self;
    
    NSString *sendFrom = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"sendFrom"];
    self.sendFrom.text=sendFrom;
    
    NSString *sendTo = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"sendTo"];
    self.sendTo.text=sendTo;
    
    NSString *sendMessage = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"sendMessage"];
    self.sendMessage.text=sendMessage;

    NSString *pendingMessage = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"pendingMessage"];
    self.pendingMessage=pendingMessage;

    NSString *sendDate = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"sendDate"];
    if(sendDate){
        NSTimeInterval timeInterval = [sendDate  doubleValue];
        [self.datePicker setDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    
    if(self.pendingMessage){
        self.sendTo.enabled=NO;
        self.sendFrom.enabled=NO;
        self.sendMessage.editable=NO;
        self.datePicker.enabled=NO;
        
        [self.sendMessageButton setTitle:@"Cancel Message" forState:UIControlStateNormal];
        
    }
    

    



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    self.charcterRemaining.text=[NSString stringWithFormat:@"%li/160 charcters",textView.text.length-range.length];
    
    NSUInteger newLength = [textView.text length] - range.length;
    return (newLength >= 160) ? NO : YES;

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    
    int length = [self getLength:textField.text];
    //NSLog(@"Length  =  %d ",length);


    
    if(length == 10)
    {
        if(range.length == 0)
            return NO;
    }
    
    if(length == 3)
    {
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6)
    {
        NSString *num = [self formatNumber:textField.text];
        //NSLog(@"%@",[num  substringToIndex:3]);
        //NSLog(@"%@",[num substringFromIndex:3]);
        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    
    return mobileNumber;
}


-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    
    return length;
    
    
}


- (IBAction)sendMessageAction:(id)sender {
    self.errorMessage.hidden=YES;

    SendMessage *sendMessage=[[SendMessage alloc] init];

    if(self.pendingMessage){
        [sendMessage cancelMessageSendingwithCompletionHandler:^{
            if(sendMessage.failedMessage){
                self.errorMessage.text=sendMessage.errorMessage;
                self.errorMessage.hidden=NO;
            }
            else{
            [self.sendMessageButton setTitle:@"Send Message" forState:UIControlStateNormal];
            self.sendTo.text=@"";
            self.sendMessage.text=@"";
            self.sendTo.enabled=YES;
            self.sendFrom.enabled=YES;
            self.sendMessage.editable=YES;
            self.datePicker.enabled=YES;
            self.pendingMessage=NO;
            [self.datePicker setDate:[NSDate date]];
            }
        }];
        
    }
    else{
        NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval timeToSendMessage = [self.datePicker.date timeIntervalSince1970];
        NSTimeInterval delay = timeToSendMessage - timeNow;
        
        [self performSelector:@selector(sendMessageAfterDelay:) withObject:sendMessage afterDelay:delay];
    }
}

- (void)sendMessageAfterDelay:(SendMessage *)sendMessage
{
    [sendMessage sendMessageTo:self.sendTo.text from:self.sendFrom.text message:self.sendMessage.text date:[self.datePicker date] withCompletionHandler:^{
        
        if(sendMessage.failedMessage){
            self.errorMessage.text=sendMessage.errorMessage;
            self.errorMessage.hidden=NO;
        }
        else{
            
            NSTimeInterval timeToSendMessage = [self.datePicker.date timeIntervalSince1970];
            
            NSString *dateString=[NSString stringWithFormat:@"%f", timeToSendMessage];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.sendFrom.text forKey:@"sendFrom"];
            [[NSUserDefaults standardUserDefaults] setObject:self.sendTo.text forKey:@"sendTo"];
            [[NSUserDefaults standardUserDefaults] setObject:self.sendMessage.text forKey:@"sendMessage"];
            [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"pendingMessage"];
            
            [[NSUserDefaults standardUserDefaults] setObject:dateString  forKey:@"sendDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            self.sendTo.enabled=NO;
            self.sendFrom.enabled=NO;
            self.sendMessage.editable=NO;
            self.datePicker.enabled=NO;
            [self.sendMessageButton setTitle:@"Cancel Message" forState:UIControlStateNormal];
            self.pendingMessage=YES;
        }
    }];
}



@end
