//
//  QMMessagesDataSource.m
//  Pods
//
//  Created by Vitaliy Gorbachov on 12/28/15.
//
//

#import "QMMessagesDataSource.h"
#import "QMChatSection.h"
#import "QMHeaderCollectionReusableView.h"
#import "QMChatCollectionView.h"
#import "QMDateUtils.h"
#import <Quickblox/Quickblox.h>

static NSString *const kQMSectionsInsertKey = @"kQMSectionsInsertKey";
static NSString *const kQMItemsInsertKey    = @"kQMItemsInsertKey";

@interface QMMessagesDataSource()

@property (nonatomic, assign, readwrite, getter=isEmpty) BOOL empty;
@property (nonatomic, assign, readwrite) NSUInteger totalMessagesCount;

@property (strong, nonatomic) NSArray *chatSections;

@end

@implementation QMMessagesDataSource

- (NSDictionary *)addMessagesToTop:(NSArray *)messages {
    NSMutableArray *sectionsToAdd = [NSMutableArray arrayWithArray:self.chatSections];
    
    NSMutableArray *sectionsToInsert = [NSMutableArray array];
    NSMutableArray *indexPathToInsert = [NSMutableArray array];
    
    if (self.chatSections == nil) {
        [sectionsToAdd addObject:[QMChatSection chatSectionWithMessage:[messages lastObject]]];
        [sectionsToInsert addObject:@(0)];
        [indexPathToInsert addObject:[NSIndexPath indexPathForRow:0
                                                        inSection:0]];
    }
    
    for (QBChatMessage *message in [messages reverseObjectEnumerator]) {
        NSAssert(message.dateSent != nil, @"Message must have dateSent!");
        
        QMChatSection* currentSection = [sectionsToAdd lastObject];
        NSUInteger sectionIndex = [sectionsToAdd indexOfObject:currentSection];
        
        if (fabs([[currentSection firstMessageDate] timeIntervalSinceDate:message.dateSent]) > self.timeIntervalBetweenSections) {
            QMChatSection *newSection = [QMChatSection chatSectionWithMessage:message];
            [sectionsToAdd addObject:newSection];
            sectionIndex = [sectionsToAdd indexOfObject:newSection];
            
            [sectionsToInsert addObject:@(sectionIndex)];
            [indexPathToInsert addObject:[NSIndexPath indexPathForRow:0
                                                            inSection:sectionIndex]];
        } else {
            if (![currentSection.messages containsObject:message]) {
                [currentSection.messages addObject:message];
                
                [indexPathToInsert addObject:[NSIndexPath indexPathForRow:[currentSection.messages count] - 1
                                                                inSection:sectionIndex]];
            }
        }
    }
    
    self.chatSections = [sectionsToAdd copy];
    
    return @{kQMSectionsInsertKey : sectionsToInsert,
             kQMItemsInsertKey    : indexPathToInsert};
}

- (NSDictionary *)addMessagesToBottom:(NSArray *)messages {
    NSMutableArray *sectionsToAdd = [NSMutableArray arrayWithArray:self.chatSections];
    
    NSMutableArray *sectionsToInsert = [NSMutableArray array];
    NSMutableArray *indexPathToInsert = [NSMutableArray array];
    
    for (QBChatMessage *message in messages) {
        NSAssert(message.dateSent != nil, @"Message must have dateSent!");
        
        if ([self messageExists:message]) continue;
        
        QMChatSection *firstSection = [sectionsToAdd firstObject];
        NSUInteger sectionIndex = [sectionsToAdd indexOfObject:firstSection];
        
        if ([message.dateSent timeIntervalSinceDate:[firstSection firstMessageDate]] > self.timeIntervalBetweenSections || firstSection == nil) {
            
            // move previous sections
            NSArray *indexPathToInsert_t = [indexPathToInsert copy];
            for (NSIndexPath *indexPath in indexPathToInsert_t) {
                NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
                [indexPathToInsert replaceObjectAtIndex:[indexPathToInsert indexOfObject:indexPath] withObject:updatedIndexPath];
            }
            
            QMChatSection* newSection = [QMChatSection chatSectionWithMessage:message];
            [sectionsToAdd insertObject:newSection atIndex:0];
            
            sectionIndex = [sectionsToAdd indexOfObject:newSection];
            [sectionsToInsert addObject:@(sectionIndex)];
            
        } else {
            [firstSection.messages insertObject:message atIndex:0];
        }
        
        [indexPathToInsert addObject:[NSIndexPath indexPathForRow:0
                                                        inSection:sectionIndex]];
        
    }
    
    self.chatSections = [sectionsToAdd copy];

    return @{kQMSectionsInsertKey : sectionsToInsert,
             kQMItemsInsertKey    : indexPathToInsert};
}

- (NSIndexPath *)replaceMessage:(QBChatMessage *)message {
    return [[self replaceMessages:@[message]] firstObject];
}

- (NSArray *)replaceMessages:(NSArray *)messages {
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (QBChatMessage *message in messages) {
        NSIndexPath *indexPath = [self indexPathForMessage:message];
        if (indexPath == nil) continue;
        
        [indexPaths addObject:indexPath];
        QMChatSection *chatSection = self.chatSections[indexPath.section];
        [chatSection.messages replaceObjectAtIndex:indexPath.item withObject:message];
    }
    
    return [indexPaths copy];
}

- (NSDictionary *)removeMessages:(NSArray *)messages {
    NSMutableArray *itemsToDelete    = [NSMutableArray array];
    NSMutableArray *sectionsToDelete = [NSMutableArray array];
    NSMutableArray *sections = [self.chatSections mutableCopy];
    
    for (QBChatMessage *message in messages) {
        NSIndexPath *indexPath = [self indexPathForMessage:message];
        if (indexPath == nil) continue;
        
        QMChatSection *chatSection = self.chatSections[indexPath.section];
        [chatSection.messages removeObjectAtIndex:indexPath.item];
        
        if ([chatSection.messages count] == 0) {
            [sectionsToDelete addObject:@(indexPath.section)];
            [sections removeObjectAtIndex:indexPath.section];
            
            // no need to remove elements whose section will be removed
            NSArray *items = [itemsToDelete copy];
            for (NSIndexPath *index in items) {
                if (index.section == indexPath.section) {
                    [itemsToDelete removeObject:index];
                }
            }
        } else {
            [itemsToDelete addObject:indexPath];
        }
    }
    
    self.chatSections = [sections copy];
    
    return @{kQMSectionsInsertKey : sectionsToDelete,
             kQMItemsInsertKey    : itemsToDelete};
}

#pragma mark Properties

- (BOOL)isEmpty {
    return [self.chatSections count] > 0 ? NO : YES;
}

#pragma mark QMChatCollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    QMChatSection *currentSection = self.chatSections[section];
    return [currentSection.messages count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [self.chatSections count];
}

- (UICollectionReusableView *)collectionView:(QMChatCollectionView *)collectionView
                    sectionHeaderAtIndexPath:(NSIndexPath *)indexPath {
    QMHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                    withReuseIdentifier:[QMHeaderCollectionReusableView cellReuseIdentifier] forIndexPath:indexPath];
    
    QMChatSection *chatSection = self.chatSections[indexPath.section];
    headerView.headerLabel.text = [self nameForSectionWithDate:[chatSection lastMessageDate]];
    headerView.transform = collectionView.transform;
    
    return headerView;
}

#pragma mark - Helpers

- (NSString *)nameForSectionWithDate:(NSDate *)date {
    
    return [QMDateUtils formattedStringFromDate:date];
}

- (BOOL)messageExists:(QBChatMessage *)message {
    
    for (QMChatSection *section in self.chatSections) {
        if ([section.messages containsObject:message]) return YES;
    }
    
    return NO;
}

- (NSUInteger)totalMessagesCount {
    NSUInteger totalMessagesCount = 0;
    NSArray *chatSections = [self.chatSections copy];
    for (QMChatSection *chatSection in chatSections) {
        totalMessagesCount += [chatSection.messages count];
    }

    return totalMessagesCount;
}

- (QBChatMessage *)messageForIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.item == NSNotFound) {
        // If the update item's index path has an "item" value of NSNotFound, it means it was a section update, not an individual item.
        return nil;
    }

    QMChatSection *currentSection = self.chatSections[indexPath.section];
    return currentSection.messages[indexPath.item];
}

- (NSIndexPath *)indexPathForMessage:(QBChatMessage *)message {

    NSIndexPath *indexPath = nil;
    for (QMChatSection *chatSection in self.chatSections) {
        if ([chatSection.messages containsObject:message]) {
            indexPath = [NSIndexPath indexPathForItem:[chatSection.messages indexOfObject:message] inSection:[self.chatSections indexOfObject:chatSection]];
        }
    }

    return indexPath;
}

@end
