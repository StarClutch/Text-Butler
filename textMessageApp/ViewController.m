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
    
    self.sendTo.delegate=self;
    self.sendFrom.delegate=self;
    self.sendMessage.delegate=self;
    if(self.pendingMessage){
        self.sendTo.enabled=NO;
        self.sendFrom.enabled=NO;
        self.sendMessage.enabled=NO;
        self.datePicker.enabled=NO;

        [self.sendMessageButton setTitle:@"Cancel Message" forState:UIControlStateNormal];
        
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    
    if(textField==self.sendMessage){
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        self.charcterRemaining.text=[NSString stringWithFormat:@"%li/160 charcters",textField.text.length-range.length];

        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 160) ? NO : YES;
    }
    
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
    if(self.pendingMessage){
        [self.sendMessageButton setTitle:@"Send Message" forState:UIControlStateNormal];
        self.sendTo.text=@"";
        self.sendMessage.text=@"";
        self.sendTo.enabled=YES;
        self.sendFrom.enabled=YES;
        self.sendMessage.enabled=YES;
        self.datePicker.enabled=YES;
        self.pendingMessage=NO;
        
    }
    else{
    SendMessage *sendMessage=[[SendMessage alloc] init];
    
    [sendMessage sendMessageTo:self.sendTo.text from:self.sendFrom.text message:self.sendMessage.text date:[self.datePicker date] withCompletionHandler:^{
        
        if(sendMessage.failedMessage){
            // error
        }
        else{
            self.sendTo.enabled=NO;
            self.sendFrom.enabled=NO;
            self.sendMessage.enabled=NO;
            self.datePicker.enabled=NO;
            [self.sendMessageButton setTitle:@"Cancel Message" forState:UIControlStateNormal];
            self.pendingMessage=YES;
        }
        
        
    }];
    
    }
}



@end
