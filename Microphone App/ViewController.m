//
//  ViewController.m
//  Microphone App
//
//  Created by felix king on 13/10/2015.
//  Copyright © 2015 Felix King. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@end

@implementation ViewController
@synthesize stopButton, startButton, testButton, playBackButton, infomationButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [stopButton setEnabled:NO];
    [playBackButton setEnabled:NO];
    self.informationView.hidden = YES;
    
    self.shouldInfoViewDisplay = NO;
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject], @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSMutableDictionary *recordingSetting = [[NSMutableDictionary alloc] init];
    
    [recordingSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordingSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordingSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordingSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    [self updateOutlets];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
    if (self.informationView.isHidden == NO) {
        self.informationView.hidden = YES;
    }
    [self updateOutlets];
}

- (void) updateOutlets {
    [stopButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateDisabled];
    [stopButton setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    
    [startButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateDisabled];
    [startButton setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
    
    [testButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateDisabled];
    [testButton setBackgroundImage:[UIImage imageNamed:@"orange"] forState:UIControlStateNormal];
    
    [playBackButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateDisabled];
    [playBackButton setBackgroundImage:[UIImage imageNamed:@"orange"] forState:UIControlStateNormal];
    
    if (self.shouldInfoViewDisplay == YES) {
        [infomationButton setEnabled:NO];
        self.informationView.hidden = NO;
        self.shouldInfoViewDisplay = NO;
        self.micLabel.text = @"";
        self.speakersLabel.text = @"";
    }
    else {
        [infomationButton setEnabled:YES];
        self.informationView.hidden = YES;
        self.micLabel.text = @"Mic";
        self.speakersLabel.text = @"Speaker";
    }
}

- (void) deviceOrientationDidChangeNotification:(NSNotification *)note {
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
        self.micImage.image = [UIImage imageNamed:@"left"];
        self.speakersImage.image = [UIImage imageNamed:@"right"];
    }
    else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        self.micImage.image = [UIImage imageNamed:@"right"];
        self.speakersImage.image = [UIImage imageNamed:@"left"];
    }
    else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        self.micImage.image = [UIImage imageNamed:@"up"];
        self.speakersImage.image = [UIImage imageNamed:@"down"];
    }
    else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown) {
        self.micImage.image = [UIImage imageNamed:@"down"];
        self.speakersImage.image = [UIImage imageNamed:@"up"];
    }
}

- (void)playSound {
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/testing audio.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    player.numberOfLoops = 0;
    
    if (player == nil) {
        NSLog([error description]);
    }
    else {
        [player play];
    }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [stopButton setEnabled:NO];
    [startButton setEnabled:YES];
    [self updateOutlets];
}

- (IBAction)startButtonPressed:(UIButton *)sender {
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        [recorder record];
        [startButton setEnabled:NO];
    }
    
    [stopButton setEnabled:YES];
    [playBackButton setEnabled:NO];
    [self updateOutlets];
}

- (IBAction)stopButtonPressed:(UIButton *)sender {
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    [stopButton setEnabled:NO];
    [startButton setEnabled:YES];
    [playBackButton setEnabled:YES];
    [self updateOutlets];
}

- (IBAction)testButtonPressed:(UIButton *)sender {
    [self playSound];
    [self updateOutlets];
}

- (IBAction)playBackButtonPressed:(UIButton *)sender {
    if (!recorder.recording) {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
    [self updateOutlets];
}

- (IBAction)infomatinButtonPressed:(UIButton *)sender {
    self.shouldInfoViewDisplay = YES;
    [self updateOutlets];
}
@end
