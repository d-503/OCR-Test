//
//  ImageViewController.m
//  TesseractTest
//
//  Created by Edward Khorkov on 07.02.13.
//  Copyright (c) 2013 Polecat. All rights reserved.
//

#import "ImageViewController.h"
#import "RecognizerViewController.h"
#import <BlocksKit/BlocksKit.h>

@interface ImageViewController () <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *addPictureButton;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Select Image";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setAddPictureButton:nil];
    [super viewDidUnload];
}

#pragma mark - Actions

- (void)recognizeNavItemPressed:(UIBarButtonItem *)sender {
    RecognizerViewController *textVC = [[RecognizerViewController alloc] initWithImage:self.imageView.image];
    [self.navigationController pushViewController:textVC animated:YES];
}

- (IBAction)addPictureButton:(id)sender {
    void (^handler)(UIImagePickerControllerSourceType) = ^(UIImagePickerControllerSourceType sourceType) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        imagePickerController.delegate = self;

        [self presentModalViewController:imagePickerController animated:YES];
    };

    UIActionSheet *actionSheet = [UIActionSheet actionSheetWithTitle:nil];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [actionSheet addButtonWithTitle:@"Photo Library"
                                handler:^{
                                    handler(UIImagePickerControllerSourceTypePhotoLibrary);
                                }];
    }

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:@"Camera"
                                handler:^{
                                    handler(UIImagePickerControllerSourceTypeCamera);
                                }];
    }

    if (self.imageView.image) {
        [actionSheet setDestructiveButtonWithTitle:@"Delete Photo"
                                           handler:^{
                                               self.imageView.image = nil;
                                               self.navigationItem.rightBarButtonItem = nil;
                                               [self.addPictureButton setTitle:@"Add Picture" forState:UIControlStateNormal];
                                           }];
    }

    [actionSheet setCancelButtonWithTitle:@"Cancel" handler:nil];

    [actionSheet showInView:self.view];
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    if (! image) {
        return;
    }

    self.imageView.image = image;
    [self.addPictureButton setTitle:nil forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Recognize"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(recognizeNavItemPressed:)];




    [picker dismissModalViewControllerAnimated:YES];
}

@end
