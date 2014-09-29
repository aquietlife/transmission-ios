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
    Transmissions is an APP for audience members to play during the performance of Raft's 'Transmissions in A and E'.   It was designed by Pat Noecker (Raft) and Johann Diedrick with the intention that all who are present during Transmissions should be able to take part in the experience of this very simple and transformative collaboration. We believe our connected world can help manifest amazing human-moments that positively reflect our ever expanding and technology-influenced consciousness.  We hope this APP leads you to realizations about the potential of sound and the power of the possible, especially when technology is used to facilitate similar experiences like Transmissions. \
    INSTRUCTIONS \
    To join the performance, tap the A button and let it run for the first 30 minutes of Transmissions.  You can switch the tone of the A by tapping the wave form buttons to the left of the A button. You can also switch the pitch by tapping the octave buttons directly beneath the A button. \
    After 30 minutes, a brief pause occurs whereupon the A button should be turned off. When you hear the ensemble start back up, tap the E button.  Apply the above methods of wave form and octave switching to the E for 20 minutes and then blend the A and E for the last 10 minutes. By the end, we'll achieve perfect harmony. \
    Tips: \
        --Hold your phone above your head. \
        --Swing your phone around in a figure 8.  It bends the notes. \
        --Tap the speakers on your phone while playing the app.  This creates a tremolo effect. \
        --Cup your hands around the speakers and slowly open and close them.  This creates an envelope effect. \
        --Listen and participate.  This creates a transformative effect :) \
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
    //setup textview
    _aboutText = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [_aboutText setText:@ABOUT_TEXT];
    [_aboutText setEditable:NO];
    [_aboutText setScrollEnabled:YES];
    [self.view addSubview:_aboutText];
    
    //back button
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
    [_backButton setBackgroundColor:[TMConstants greenColor]];
    [_backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
}

- (void) backButtonPressed:(id)sender{
    NSLog(@"going back!");
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
