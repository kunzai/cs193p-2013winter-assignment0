//
//  PlayingCard.m
//  Matchismo
//
//  Created by Chris Johnson Bidler on 2/8/13.
//  Copyright (c) 2013 Chris Johnson Bidler. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int) match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] == 1) {
        id otherCard = [otherCards lastObject];
        if([otherCard isKindOfClass:[PlayingCard class]]) {
            PlayingCard *otherPlayingCard = (PlayingCard *)otherCard;
            if ([otherPlayingCard.suit isEqualToString:self.suit]) {
                score = 1;
            } else if (otherPlayingCard.rank == self.rank) {
                score = 4;
            }
        }
    } else {
        for (Card *otherCard in otherCards) {
            score += [self match:@[otherCard]];
        }
    }
    
    return score;
}

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;
+ (NSArray *) validSuits {
    return @[@"♥", @"♦", @"♠", @"♣"];
}
- (NSString *) suit {
    return _suit ? _suit : @"?";
}
- (void) setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

+ (NSArray *) rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}
+ (NSUInteger) maxRank { return [self rankStrings].count -1; }

- (void) setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
