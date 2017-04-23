//
//  ViewController.m
//  SillyCalPractice
//
//  Created by Logan on 2017/4/23.
//  Copyright © 2017年 com.Logan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    SEL operatorSelector;
    BOOL resetTextLabelOnNextAppending;//更新顯示textLabel的布爾值
}

@end

@implementation ViewController

@synthesize leftOperand,rightOperand,memory,textLabel,operatorLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textLabel.text = @"0";
    self.operatorLabel.text = @"";
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)appendDigit:(UIButton *)sender {
    //加上新數字時，先判斷resetTextLabel布爾值
    if (resetTextLabelOnNextAppending) {
        self.textLabel.text = @"0";
        resetTextLabelOnNextAppending = NO;
    }
    
    NSString *s = [(UIButton*)sender titleLabel].text;
    if ([s isEqualToString:@"."]) {
        if ([self.textLabel.text rangeOfString:@"."].location == NSNotFound) {
            self.textLabel.text = [self.textLabel.text stringByAppendingString:s];
        }
        return;
    }
    if ([self.textLabel.text isEqualToString:@"0"]) {
        if ([s isEqualToString:@"0"]) {
            return;
        }
        self.textLabel.text = s;
    }
    else {
        self.textLabel.text = [self.textLabel.text stringByAppendingString:s];
    }
}

- (IBAction)setOperator:(UIButton *)sender {
    //先檢查左運算元是否存在
    if (!self.leftOperand) {
        self.leftOperand = [NSDecimalNumber decimalNumberWithString:self.textLabel.text];
        self.rightOperand = nil;
    }
    //只有運算後才會改變resetTextLabel，還沒按=之前resetTextLabel都是ＮＯ
    else if (!resetTextLabelOnNextAppending) {
        self.rightOperand = [NSDecimalNumber decimalNumberWithString:self.textLabel.text];
        
    }
    
    
    NSString *s = [(UIButton*)sender titleLabel].text;
    NSDictionary *keySelectorMap = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"decimalNumberByAdding:",@"+",
                                    @"decimalNumberBySubtracting:", @"−",
                                    @"decimalNumberByMultiplyingBy:", @"×",
                                    @"decimalNumberByDividingBy:", @"∕", nil];
    operatorSelector = NSSelectorFromString([keySelectorMap objectForKey:s]);
    self.operatorLabel.text = s;
    resetTextLabelOnNextAppending = YES;//選了運算子後，把resetTextLabel設為ＹＥＳ
}

- (IBAction)doCalculate:(id)sender {
    if (operatorSelector == NULL || !self.leftOperand) {
        return;
    }
    self.rightOperand = [NSDecimalNumber decimalNumberWithString:self.textLabel.text];
    if (operatorSelector == @selector(decimalNumberByDividingBy:) && [rightOperand floatValue]==0.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unable to divide 0." message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSDecimalNumber *result = [leftOperand performSelector:operatorSelector withObject:rightOperand];
    
    resetTextLabelOnNextAppending = YES;
    operatorSelector = NULL;
    self.textLabel.text = [result stringValue];
    self.leftOperand = result; //每次結果都給leftOperand
    self.rightOperand = nil;
    self.operatorLabel.text = @"";
}

- (IBAction)doClear:(id)sender {
    self.rightOperand = nil;
    self.leftOperand = nil;
    self.textLabel.text = @"0";
    self.operatorLabel.text = @"";
}

- (IBAction)doMemoryClear:(id)sender {
    self.memory = [NSDecimalNumber decimalNumberWithString:@"0"];
}

- (IBAction)doMemoryPlus:(id)sender {
    if (!self.memory) {
        self.memory = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    self.memory = [self.memory decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:self.textLabel.text]];
    
}

- (IBAction)doMemoryMinus:(id)sender {
    if (!self.memory) {
        self.memory = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    self.memory = [self.memory decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:self.textLabel.text]];
}

- (IBAction)doMemoryRecall:(id)sender {
    if (!self.memory) {
        self.memory = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    self.textLabel.text = [self.memory stringValue];
}

- (IBAction)togglePositiveNegative:(id)sender {
    //先檢查resetTextLabel
    if (resetTextLabelOnNextAppending) {
        self.leftOperand = nil; //為了在setOperator:更新leftOperand，設為nil
        resetTextLabelOnNextAppending = YES;
    }
    //operatorSelector = NULL;
    //self.operatorLabel.text = @"";
    NSString *s = self.textLabel.text;
    self.textLabel.text = [s hasPrefix:@"-"] ? [s substringFromIndex:1] : [@"-" stringByAppendingString:s];
}
@end
