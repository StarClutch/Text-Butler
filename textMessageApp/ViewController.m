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
    
    [self setFieldsEditable:YES];
    
    self.sendMessageTextView.layer.borderColor = [[UIColor colorWithRed:231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0] CGColor];
    self.sendMessageTextView.layer.borderWidth = 2.0f;
    self.sendMessageTextView.layer.backgroundColor = [[UIColor clearColor] CGColor];

    [self.datePicker setMinimumDate: [NSDate date]];
    
    self.sendToTextField.delegate = self;
    self.sendFromTextField.delegate = self;
    self.sendMessageTextView.delegate = self;
    
    NSString *sendFrom = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"sendFrom"];
    self.sendFromTextField.text=sendFrom;
    
    NSString *sendTo = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"sendTo"];
    self.sendToTextField.text=sendTo;
    
    NSString *sendMessage = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"sendMessage"];
    self.sendMessageTextView.text=sendMessage;

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
        self.sendToTextField.enabled=NO;
        self.sendFromTextField.enabled=NO;
        self.sendMessageTextView.editable=NO;
        self.datePicker.enabled=NO;
        
        [self.sendMessageButton setTitle:@"Cancel Message" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    self.charactersRemaining.text = [NSString stringWithFormat:@"%li/30", 30 - textView.text.length];
    
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = textView.text.length + text.length - range.length;
    return (newLength <= 30);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int length = [self getLength:textField.text];
    
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


- (IBAction)sendMessageButtonTapped:(id)sender
{
    SendMessage *sendMessage = [[SendMessage alloc] init];

    if (self.pendingMessage){
        [sendMessage cancelMessageSendingwithCompletionHandler:^{
            if(sendMessage.failedMessage){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:sendMessage.errorMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
                
            }
            
            else
            {
                [self.sendMessageButton setTitle:@"Send Message" forState:UIControlStateNormal];
                [self setFieldsEditable:NO];
                self.pendingMessage = NO;
                [self.datePicker setDate:[NSDate date]];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message canceled" message:[NSString stringWithFormat:@"This message will not be sent"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
        
    }
    else {
        [self setFieldsEditable:NO];
        [self.sendMessageButton setTitle:@"Cancel Message" forState:UIControlStateNormal];
        self.pendingMessage=YES;
        
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"h:mma"]; //24hr time format
        NSString *timeString = [outputFormatter stringFromDate:self.datePicker.date];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message scheduled" message:[NSString stringWithFormat:@"Your message will be delivered at %@", timeString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval timeToSendMessage = [self.datePicker.date timeIntervalSince1970];
        NSTimeInterval delay = timeToSendMessage - timeNow;
        
        [self performSelector:@selector(sendMessageAfterDelay:) withObject:sendMessage afterDelay:delay];
    }
}

- (void)sendMessageAfterDelay:(SendMessage *)sendMessage
{
    [sendMessage sendMessageTo:self.sendToTextField.text from:self.sendFromTextField.text message:self.sendMessageTextView.text date:[self.datePicker date] withCompletionHandler:^{
        
        if(sendMessage.failedMessage){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not send message" message:@"Please try again later" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }
        
        else{
            NSTimeInterval timeToSendMessage = [self.datePicker.date timeIntervalSince1970];
            
            NSString *dateString=[NSString stringWithFormat:@"%f", timeToSendMessage];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.sendFromTextField.text forKey:@"sendFrom"];
            [[NSUserDefaults standardUserDefaults] setObject:self.sendToTextField.text forKey:@"sendTo"];
            [[NSUserDefaults standardUserDefaults] setObject:self.sendMessageTextView.text forKey:@"sendMessage"];
            [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"pendingMessage"];
            [[NSUserDefaults standardUserDefaults] setObject:dateString  forKey:@"sendDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}

- (void)setFieldsEditable:(BOOL)editable
{
    self.sendToTextField.enabled = editable;
    self.sendFromTextField.enabled = editable;
    self.sendMessageTextView.editable = editable;
    self.datePicker.enabled = editable;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.sendToTextField resignFirstResponder];
    [self.sendFromTextField resignFirstResponder];
    [self.sendMessageTextView resignFirstResponder];
}

@end
