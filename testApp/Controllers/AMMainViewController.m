//
//  AMMainViewController.m
//  testApp
//
//  Created by admin on 9/28/15.
//  Copyright © 2015 Alex Markevich. All rights reserved.
//

#import "AMMainViewController.h"

@interface AMMainViewController ()

@property (weak, nonatomic) IBOutlet UITextField *limitTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultsTextView;
@property (weak, nonatomic) IBOutlet UIView *activityIndicatorView;
@property (strong, nonatomic) NSMutableArray *cachedNumbersArray;
@property (strong, nonatomic) NSArray *numbersForDisplayingArray;

@end

@implementation AMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cachedNumbersArray = [NSMutableArray new];
    self.limitTextField.delegate = self;
    self.resultsTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.resultsTextView.layer.borderWidth = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)goButtonPressed:(id)sender {
    if ([self.limitTextField.text integerValue]) {
        [self generatePrimeNumbersWithLimit:[self.limitTextField.text integerValue]];
    }
}

- (void)generatePrimeNumbersWithLimit:(NSInteger)limit {
    
    self.activityIndicatorView.hidden = NO;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        if ([[self.cachedNumbersArray lastObject] integerValue] >= limit) {
            for (int i = 0; i < self.cachedNumbersArray.count; i++) {
                if ((NSInteger)self.cachedNumbersArray[i] >= limit) {
                    NSRange subArrayRange = NSMakeRange(0, i);
                    self.numbersForDisplayingArray = [self.cachedNumbersArray subarrayWithRange:subArrayRange];
                }
            }
        }
        else {
            if (limit > 1) {
                for (NSInteger i = [[self.cachedNumbersArray lastObject] integerValue] ?: 2; i < limit; i++) {
                    BOOL isPrime = YES;
                    for (NSNumber *primeNumber in self.cachedNumbersArray) {
                        if (i % [primeNumber integerValue] == 0) {
                            isPrime = NO;
                            break;
                        }
                    }
                    if (isPrime) {
                        [self.cachedNumbersArray addObject:[NSNumber numberWithInteger:i]];
                    }
                }
                self.numbersForDisplayingArray = [self.cachedNumbersArray copy];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self updateContent];
            self.activityIndicatorView.hidden = YES;
        });
    });
}

- (void)updateContent {
    NSMutableString *result = [NSMutableString new];
    for (NSNumber *primeNumber in self.numbersForDisplayingArray) {
        [result appendFormat:@"\n%li", (long)[primeNumber integerValue]];
    }
    self.resultsTextView.text = result;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self generatePrimeNumbersWithLimit:[self.limitTextField.text integerValue]];
}

@end
