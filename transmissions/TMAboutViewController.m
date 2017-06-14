//
//  TMAboutViewController.m
//  transmission-ios
//
//  Created by Johann Diedrick on 9/29/14.
//  Copyright (c) 2014 Johann Diedrick. All rights reserved.
//

#import "TMAboutViewController.h"

#define ABOUT_TEXT "\
ABOUT \
\n \n \n \
Transmissions is an APP designed by Pat Noecker (RAFT) and developed by Johann Diedrick for the act of audience-participation in Raft's \"Transmissions in A and E\".   Raft, the world’s first cellphonist,  believes that APPS and smart phones don’t have to isolate us and that they can facilitate unified and collaborative creative events like Transmissions.  We are a mirror of our ever expanding technologies and therein lies our new consciousness .  Raft hopes that the Transmissions APP and experience leads you to revelations about the potential of technology, the power of sound and the joy of collective expression.  Please use this APP during the performance or put on your own version of Transmissions with this APP as the basis.  Many thanks.      \
    \n \n \n \
INSTRUCTIONS \
\n \n \n \
Download Transmissions from the iOS APP store and follow these instructions.  Tap the \"A\" button.  It will turn red.  Leave it in this on position for the first 30 minutes of Transmissions.  Walk around with your phone, create a vibe, help fill the room w Transmissions.  You’ll notice the flash on your phone camera will begin to strobe.  That’s intended.  You can switch the tone of the A by tapping the wave form buttons to the left of the A button. You can also switch the pitch to a higher or lower tone by tapping the octave buttons directly beneath the A button.  And you can adjust the volume with the slider on the right side of the screen which is independent of your phone’s master volume. \
\n \n \n \
After 30 minutes, a brief pause occurs whereupon the A button should be turned off. When you hear the ensemble come back in, tap the \"E\" button.  Apply the above methods of wave form and octave switching to the E for 20 minutes and then blend the A and E for the last 10 minutes. By the end, we'll achieve perfect harmony.    \
    \n \n \n \
Tips for playing: \
\n \n \n \
-Hold your phone above your head. \
\n \n \
-Swing your phone around in a figure 8. \
\n \
It bends the notes. \
\n \n \
-Tap the speakers on your phone while playing the app.  \
\n \
This creates a tremolo effect. \
\n \n \
-Cup your hands around the speakers and slowly open and close them.  \
\n \
This creates an envelope filter effect. \
\n \n \
-Listen and participate.  \
\n \
This creates a transformative effect.  \
\n \n \
-Amplify your phone with an ⅛” to ¼” adapter and run it through pedals and loopers. \
\n \n \n \
For more about Transmissions, go to http://raftmusic.tumblr.com \
\n \n \n \
Developed by Johann Diedrick \
\n \
http://www.johanndiedrick.com\
\n \
and \
\n \
Public Science\
\n \
http://publicscience.co \
\n \n \n \
\n \n \n \
"

@interface TMAboutViewController ()

@end

@implementation TMAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setupUI{
    
    UIColor* background_color = [UIColor blackColor];
    
    //setup textview
    [self.view setBackgroundColor:background_color];
    _aboutText = [[UITextView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];
    [_aboutText setText:@ABOUT_TEXT];
    [_aboutText setTextColor:[TMConstants greenColor]];
    [_aboutText setEditable:NO];
    [_aboutText setScrollEnabled:YES];
    _aboutText.dataDetectorTypes = UIDataDetectorTypeLink;
    [_aboutText setFont:[TMConstants specialEliteFont:14]];
    [_aboutText setBackgroundColor:background_color];
    [self.view addSubview:_aboutText];
    
    // white top bar
    UIView* whiteTopBar = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 30)];
    [whiteTopBar setBackgroundColor:background_color];
    [self.view addSubview:whiteTopBar];
    
    //back button
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [_backButton setBackgroundColor:background_color];
    [_backButton setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_backButton setTitle:@"<" forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
}

- (void) backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
