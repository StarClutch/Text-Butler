//
//  ViewController.h
//  textMessageApp
//
//  Created by Blake Shetter on 12/2/14.
//  Copyright (c) 2014 Blake Shetter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *charactersRemaining;
@property (strong, nonatomic) IBOutlet UITextField *sendToTextField;
@property (strong, nonatomic) IBOutlet UITextField *sendFromTextField;
@property (strong, nonatomic) IBOutlet UITextView *sendMessageTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;

- (IBAction)sendMessageButtonTapped:(id)sender;

@property (nonatomic) BOOL pendingMessage;
@end

