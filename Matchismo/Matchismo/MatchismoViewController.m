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
#import "CardMatchingGame.h"

@interface MatchismoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipMessageLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSelector;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) Deck *cardDeck;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation MatchismoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Wire up the selector UISegmentedControl to create a new game
    [self.gameTypeSelector addTarget:self
                              action:@selector(dealNewGame)
                    forControlEvents:UIControlEventValueChanged];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Getters and setters

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (Deck *)cardDeck
{
    if (!_cardDeck) {
        _cardDeck = [[PlayingCardDeck alloc] init];
    }
    return _cardDeck;
}

/*
 * If we are making a new game, either from 
 */
- (CardMatchingGame *)game
{
    if (!_game) {
        NSLog(@"Game type selector is at index %d, title is %@",
              self.gameTypeSelector.selectedSegmentIndex,
              [self.gameTypeSelector titleForSegmentAtIndex:self.gameTypeSelector.selectedSegmentIndex]);
        NSString *selectedSegmentTitle = [self.gameTypeSelector titleForSegmentAtIndex:self.gameTypeSelector.selectedSegmentIndex];
        if (!selectedSegmentTitle || [selectedSegmentTitle isEqualToString:@"Match 2"]) {
            // default to a match-2 game
            NSLog(@"Creating a match-2 game");
            _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                      usingDeck:[[PlayingCardDeck alloc]init]
                                                     matchCount:2];
        } else if ([selectedSegmentTitle isEqualToString:@"Match 3"]) {
            NSLog(@"Creating a match-3 game");
            _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                           usingDeck:[[PlayingCardDeck alloc] init]
                                                     matchCount:3];
        } else { // Game type selector could be extended for match-4, etc. here
            NSLog(@"Selected index was: %d, creating match-%d game",
                  self.gameTypeSelector.selectedSegmentIndex,
                  self.gameTypeSelector.selectedSegmentIndex + 1);
            _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                      usingDeck:[[PlayingCardDeck alloc] init]
                                                     matchCount:self.gameTypeSelector.selectedSegmentIndex + 1];
        }
    }
    return _game;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"Flip count set to: %d", self.flipCount);
}

#pragma mark UI interaction

- (void) updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        [cardButton setBackgroundImage:nil forState:UIControlStateNormal];
        if (!card.faceUp) {
            [cardButton setBackgroundImage:cardBackImage forState:UIControlStateNormal];
        }
        cardButton.selected = card.faceUp;
        cardButton.enabled = !card.unplayable;
        cardButton.alpha = (card.unplayable ? 0.3: 1.0);
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipMessageLabel.text = self.game.lastFlipMessage;
    
}

- (IBAction)flipCard:(UIButton *)sender
{
    if (self.gameTypeSelector.enabled) {
        self.gameTypeSelector.enabled = NO;
    }
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)dealNewGame {
    self.gameTypeSelector.enabled =YES;
    self.flipCount = 0;
    self.game = nil;
    [self updateUI];
}

@end
