//
//  InputsFormViewController.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2014 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "XLFormTextDetailViewController.h"
#import "RegExCategories.h"
@interface XLFormTextDetailViewController ()
@property XLFormRowDescriptor* row;
@property BOOL alreadyInit;

@end



@implementation XLFormTextDetailViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;


-(id)initWithRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    self.rowDescriptor=rowDescriptor;
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:rowDescriptor.title];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSectionWithTitle:nil];
    //section.footerTitle = @"This is a long text that will appear on section footer";
    [formDescriptor addFormSection:section];
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"name" rowType:rowDescriptor.pushInnerRowType title:@""];
    row.required = YES;
    row.value=self.rowDescriptor.value;
    row.validators=self.rowDescriptor.validators;
    
    self.row=row;
    [section addFormRow:row];
    
    self.alreadyInit=YES;
    self.title=self.rowDescriptor.pushInnerTitle;
    return [super initWithForm:formDescriptor];
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(savePressed:)];
    if(!self.alreadyInit){
        [self initWithRowDescriptor:self.rowDescriptor];
    }
}




-(IBAction)savePressed:(UIBarButtonItem * __unused)button
{
    button.enabled = NO;
    NSLog(@"button :%@", button);
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        button.enabled=YES;
        return;
    }

    NSString *s=self.row.value;
    if(self.rowDescriptor.rowType==XLFormRowDescriptorTypeDecimal){
        if([s isMatch:RX(@"^\\-?\\d(\\.\\d*)?$")]){
            //continue
        }else{
            button.enabled=YES;
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"错误"
                                                           message:@"请输入合法的数字"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }else if(self.rowDescriptor.rowType==XLFormRowDescriptorTypeInteger){
        if([s isMatch:RX(@"^\\-?\\d$")]){
            //continue
        }else{
            button.enabled=YES;
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"错误"
                                                           message:@"请输入合法的整数"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }

    [self.tableView endEditing:YES];
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Valid Form", nil) message:@"No errors found" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
//    [alertView show];
    
    [self.rowDescriptor setValue :self.row.value ];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
