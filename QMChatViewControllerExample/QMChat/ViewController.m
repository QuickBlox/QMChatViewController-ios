//
//  ViewController.m
//  QMChat
//
//  Created by Andrey Ivanov on 06.04.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "ViewController.h"
#import <Quickblox/Quickblox.h>
#import "UIColor+QM.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *array;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.senderID = 1;
    self.senderDisplayName = @"hello";
    self.title = @"Chat";
    // Do any additional setup after loading the view, typically from a nib.
    

    self.showLoadEarlierMessagesHeader = YES;
    
    self.array = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        
        QBChatMessage *msg = [QBChatMessage message];
        msg.ID = [NSString stringWithFormat:@"%tu", i];
        msg.senderID = i+1;
        msg.senderNick = [NSString stringWithFormat:@"user %tu", i];
        msg.text = @"Q-municate ☺️☺️☺️☺️☺️☺️ text cell has a `height` delegate method that corresponds to its text dataSource method";
        [self.array addObject:msg];
    }
}

- (CGSize)collectionView:(QMChatCollectionView *)collectionView dynamicSizeAtIndexPath:(NSIndexPath *)indexPath maxWidth:(CGFloat)maxWidth {
    
    return CGSizeMake(150, 200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.collectionView.collectionViewLayout.springResistanceFactor = 1000;
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.array count];
}


@end
