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
    Transmissions is an APP for audience members to play during the performance of Raft's \"Transmissions in A and E\".   It was designed by Pat Noecker (Raft) and Johann Diedrick with the intention that all who are present during Transmissions should be able to take part in the experience of this very simple and transformative collaboration.  Raft believes our connected world can help manifest amazing human-moments that positively reflect our ever expanding and technology-influenced consciousness.  Together, the designers hope that this APP leads you to realizations about the potential of sound and the power of the possible, especially when technology is used to facilitate similar group experiences like Raft’s Transmissions.     \
    \n \n \n \
    INSTRUCTIONS \
    \n \n \n \
    To join the performance, tap the \"A\" button.  It will turn red.  Leave it in this on position for the first 30 minutes of Transmissions.  Walk around with your phone, create a vibe, help fill the room w Transmissions.  You’ll notice the flash on your phone camera will begin to strobe.  That’s intended.  You can switch the tone of the A by tapping the wave form buttons to the left of the A button. You can also switch the pitch to a higher or lower tone by tapping the octave buttons directly beneath the A button.  And you can adjust the volume with the slider on the right side of the screen. \
    \n \n \n \
    After 30 minutes, a brief pause occurs whereupon the A button should be turned off. When you hear the ensemble come back in, tap the \"E\" button.  Apply the above methods of wave form and octave switching to the E for 20 minutes and then blend the A and E for the last 10 minutes. By the end, we'll achieve perfect harmony. \
    \n \n \n \
    After 30 minutes, a brief pause occurs whereupon the A button should be turned off. When you hear the ensemble start back up, tap the E button.  Apply the above methods of wave form and octave switching to the E for 20 minutes and then blend the A and E for the last 10 minutes. By the end, we'll achieve perfect harmony. \
    \n \n \n \
    Tips: \
    \n \n \n \
        --Hold your phone above your head. \
    \n \n \
        --Swing your phone around in a figure 8.  It bends the notes. \
    \n \n \
        --Tap the speakers on your phone while playing the app.  This creates a tremolo effect. \
    \n \n \
        --Cup your hands around the speakers and slowly open and close them.  This creates an envelope effect. \
    \n \n \
        --Listen and participate.  This creates a transformative effect :)  \
    \n \n \n \
    for more about Transmissions, go to http://raftmusic.tumblr.com \
    \n \n \n \
    developed by Johann Diedrick http://www.johanndiedrick.com \
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
    _aboutText = [[UITextView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
    [_aboutText setText:@ABOUT_TEXT];
    [_aboutText setTextColor:[TMConstants greenColor]];
    [_aboutText setEditable:NO];
    [_aboutText setScrollEnabled:YES];
    [_aboutText setFont:[TMConstants specialEliteFont:14]];
    [_aboutText setBackgroundColor:background_color];
    [self.view addSubview:_aboutText];
    
    // white top bar
    UIView* whiteTopBar = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 30)];
    [whiteTopBar setBackgroundColor:background_color];
    [self.view addSubview:whiteTopBar];
    
    //back button
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
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
