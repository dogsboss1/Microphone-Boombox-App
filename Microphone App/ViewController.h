//
//  ViewController.h
//  Microphone App
//
//  Created by felix king on 13/10/2015.
//  Copyright © 2015 Felix King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

- (IBAction)startButtonPressed:(UIButton *)sender;
- (IBAction)stopButtonPressed:(UIButton *)sender;
- (IBAction)testButtonPressed:(UIButton *)sender;
- (IBAction)playBackButtonPressed:(UIButton *)sender;

- (IBAction)infomatinButtonPressed:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *playBackButton;

@property (weak, nonatomic) IBOutlet UIButton *infomationButton;

@property (weak, nonatomic) IBOutlet UILabel *speakersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *speakersImage;

@property (weak, nonatomic) IBOutlet UILabel *micLabel;
@property (weak, nonatomic) IBOutlet UIImageView *micImage;

@property (weak, nonatomic) IBOutlet UIView *informationView;

@property BOOL shouldInfoViewDisplay;

@end

