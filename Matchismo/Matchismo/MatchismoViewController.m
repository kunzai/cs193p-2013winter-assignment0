//
//  MatchismoViewController.m
//  Matchismo
//
//  Created by Chris Johnson Bidler on 1/28/13.
//  Copyright (c) 2013 Chris Johnson Bidler. All rights reserved.
//

#import "MatchismoViewController.h"
#import "PlayingCardDeck.h"
#import "Card.h"

@interface MatchismoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;

// Model
@property (strong, nonatomic) PlayingCardDeck *cardDeck;

@end

@implementation MatchismoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PlayingCardDeck *)cardDeck
{
    if (!_cardDeck) {
        _cardDeck = [[PlayingCardDeck alloc] init];
    }
    return _cardDeck;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"Flip count set to: %d", self.flipCount);
}

- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = (!sender.isSelected);
    if (sender.selected) {
        NSLog(@"Showing new card");
        Card *newCard = [self.cardDeck drawRandomCard];
        if(newCard) {
            NSLog(@"New card is %@", newCard.contents);
            [sender setTitle:newCard.contents forState:UIControlStateSelected];
        }
    }
    self.flipCount++;
}


@end
