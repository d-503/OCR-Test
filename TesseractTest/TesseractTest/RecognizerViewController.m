//
//  TextViewController.m
//  TesseractTest
//
//  Created by Edward Khorkov on 07.02.13.
//  Copyright (c) 2013 Polecat. All rights reserved.
//

#import "RecognizerViewController.h"
#import "Tesseract.h"
#import "UserDefaultsKeys.h"

@interface RecognizerViewController ()

@property(weak, nonatomic) IBOutlet UITextView *textView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(weak, nonatomic) IBOutlet UILabel *recognitionTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *recognitionEngineLabel;

@property(strong, nonatomic) UIImage *imageToRecognize;
@property(strong, nonatomic) Tesseract *tesseract;

@property(assign, nonatomic) NSTimeInterval startTimeInterval;
@property(assign, nonatomic) NSTimeInterval stopTimeInterval;

@end

@implementation RecognizerViewController

- (id)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.imageToRecognize = image;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Recognized Text";

    self.tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    [self.tesseract setImage:self.imageToRecognize];

    void (^success)(NSString *) = ^(NSString *recognizedText) {
        self.stopTimeInterval = [[NSDate date] timeIntervalSince1970];
        [self.activityIndicator stopAnimating];
        self.textView.text = recognizedText;
        self.recognitionTimeLabel.text = [NSString stringWithFormat:@"recognition time %f seconds", self.stopTimeInterval - self.startTimeInterval];
        self.recognitionEngineLabel.text = @"OCR Engine - Tesseract";

        [self saveRecognitionStatistic];
    };

    void (^failure)() = ^{
        [self.activityIndicator stopAnimating];
    };

    [self.activityIndicator startAnimating];
    self.startTimeInterval = [[NSDate date] timeIntervalSince1970];

    [self recognizeImageWithSuccess:success failure:failure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [self setActivityIndicator:nil];
    [self setRecognitionTimeLabel:nil];
    [self setRecognitionEngineLabel:nil];
    [super viewDidUnload];
}

#pragma mark - support

- (void)recognizeImageWithSuccess:(void (^)(NSString *recognizedString))success
                          failure:(void (^)())failure {
    dispatch_queue_t recognitionQueue = dispatch_queue_create("Recognition Queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t currentQueue = dispatch_get_current_queue();

    dispatch_async(recognitionQueue, ^{
        BOOL isRecognitionSuccess = [self.tesseract recognize];

        if (isRecognitionSuccess) {
            dispatch_sync(currentQueue, ^{
                if (success) {
                    success([self.tesseract recognizedText]);
                }
            });
        }
        else {
            dispatch_sync(currentQueue, ^{
                if (failure) {
                    failure();
                }
            });
        }
    });
}

- (void)saveRecognitionStatistic {
    NSMutableDictionary *recognitionStatistic = [NSMutableDictionary dictionary];
     NSString *recognizedImageName = @"1.png";
    [recognitionStatistic setObject:recognizedImageName forKey:K_RECOGNIZED_IMAGE_NAME];
    [recognitionStatistic setObject:self.textView.text forKey:K_RECOGNIZED_TEXT];
    NSNumber *recognitionTime = [NSNumber numberWithDouble:self.stopTimeInterval - self.startTimeInterval];
    [recognitionStatistic setObject:recognitionTime forKey:K_RECOGNITION_TIME];
    [recognitionStatistic setObject:@"Tesseract" forKey:K_RECOGNITION_ENGINE];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *recentlyRecognizedImages = [defaults objectForKey:K_RECENTLY_RECOGNIZED];
    NSMutableArray *recognizedImages = [NSMutableArray arrayWithArray:recentlyRecognizedImages];
    [recognizedImages addObject:recognitionStatistic];

    [defaults setObject:recognizedImages forKey:K_RECENTLY_RECOGNIZED];
    [defaults synchronize];
}

@end
