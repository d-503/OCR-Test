//
//  RecognizedImageViewController.m
//  TesseractTest
//
//  Created by Edward Khorkov on 08.02.13.
//  Copyright (c) 2013 Polecat. All rights reserved.
//

#import "RecognizedImageViewController.h"
#import "UserDefaultsKeys.h"
#import "UILabel+RequiredHeight.h"
#import "FrameTransformations.h"

@interface RecognizedImageViewController ()

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UILabel *recognizedTextLabel;
@property(weak, nonatomic) IBOutlet UILabel *recognitionTimeLabel;
@property(weak, nonatomic) IBOutlet UILabel *recognitionEngineLabel;

@property(strong, nonatomic) NSDictionary *dataDict;

@end

@implementation RecognizedImageViewController

- (id)initWithRecognizedImageData:(NSDictionary *)dataDictionary {
    if (self = [super init]) {
        self.dataDict = dataDictionary;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Recognized Image";

    NSString *imageName = [self.dataDict objectForKey:K_RECOGNIZED_IMAGE_NAME];
    self.imageView.image = [UIImage imageNamed:imageName];

    NSString *recognizedText = [self.dataDict objectForKey:K_RECOGNIZED_TEXT];
    self.recognizedTextLabel.text = recognizedText;

    NSNumber *recognitionTime = [self.dataDict objectForKey:K_RECOGNITION_TIME];
    self.recognitionTimeLabel = [NSString stringWithFormat:@"recognition time = %f seconds",
                                                           [recognitionTime doubleValue]];

    NSString *recognitionEngine = [self.dataDict objectForKey:K_RECOGNITION_ENGINE];
    self.recognitionEngineLabel.text = [NSString stringWithFormat:@"recognition engine: %@",
                                                                      recognitionEngine];

    [self adjustSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setImageView:nil];
    [self setRecognizedTextLabel:nil];
    [self setRecognitionTimeLabel:nil];
    [self setRecognitionEngineLabel:nil];
    [super viewDidUnload];
}

#pragma mark - support

- (void)adjustSubviews {

    CGSize imageSize = [self.imageView.image size];
    CGFloat imageViewHeight = imageSize.height * self.imageView.frame.size.height / imageSize.width;

    CGRect frame = self.imageView.frame;
    frame.size.height = imageViewHeight;
    self.imageView.frame = frame;

    const int kContentVerticalIndent = 10;

    [self.recognizedTextLabel resizeToRequireHeight];
    placeViewBelowView(self.recognizedTextLabel, self.imageView, kContentVerticalIndent);

    [self.recognitionTimeLabel resizeToRequireHeight];
    placeViewBelowView(self.recognitionTimeLabel, self.recognizedTextLabel, kContentVerticalIndent);

    [self.recognitionEngineLabel resizeToRequireHeight];
    placeViewBelowView(self.recognitionEngineLabel, self.recognitionTimeLabel, kContentVerticalIndent);

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
            self.recognitionEngineLabel.frame.origin.y + self.recognitionEngineLabel.frame.size.height);
}

@end
