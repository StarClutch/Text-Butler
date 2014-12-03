//
//  ViewController.h
//  textMessageApp
//
//  Created by Blake Shetter on 12/2/14.
//  Copyright (c) 2014 Blake Shetter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *charcterRemaining;
@property (strong, nonatomic) IBOutlet UITextField *sendTo;
@property (strong, nonatomic) IBOutlet UITextField *sendFrom;
@property (strong, nonatomic) IBOutlet UITextField *sendMessage;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)sendMessageAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;

@property (nonatomic) BOOL pendingMessage;
@end

