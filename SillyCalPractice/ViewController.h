//
//  ViewController.h
//  SillyCalPractice
//
//  Created by Logan on 2017/4/23.
//  Copyright © 2017年 com.Logan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *operatorLabel;
- (IBAction)appendDigit:(UIButton *)sender;
- (IBAction)setOperator:(UIButton *)sender;
- (IBAction)doCalculate:(id)sender;
- (IBAction)doClear:(id)sender;
- (IBAction)doMemoryClear:(id)sender;
- (IBAction)doMemoryPlus:(id)sender;
- (IBAction)doMemoryMinus:(id)sender;
- (IBAction)doMemoryRecall:(id)sender;
- (IBAction)togglePositiveNegative:(id)sender;

@property (retain,nonatomic) NSDecimalNumber *leftOperand;
@property (retain,nonatomic) NSDecimalNumber *rightOperand;
@property (retain, nonatomic) NSDecimalNumber *memory;


@end

