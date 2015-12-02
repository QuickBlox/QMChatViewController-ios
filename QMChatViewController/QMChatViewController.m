//
//  QMChatViewController.m
//  QMChatViewController
//
//  Created by Andrey Ivanov on 06.04.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "QMChatViewController.h"
#import "QMChatCollectionView.h"
#import "QMKeyboardController.h"
#import "QMToolbarContentView.h"
#import "QMChatCollectionViewFlowLayout.h"
#import "QMChatSection.h"
#import "QMDateUtils.h"

#import "QMCollectionViewFlowLayoutInvalidationContext.h"
#import "NSString+QM.h"
#import "UIColor+QM.h"
#import "UIImage+QM.h"
#import "QMHeaderCollectionReusableView.h"
#import "TTTAttributedLabel.h"

static NSString *const kQMSectionsInsertKey = @"kQMSectionsInsertKey";
static NSString *const kQMItemsInsertKey    = @"kQMItemsInsertKey";

static void * kChatKeyValueObservingContext = &kChatKeyValueObservingContext;

@interface QMChatViewController () <QMInputToolbarDelegate, QMKeyboardControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet QMChatCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet QMInputToolbar *inputToolbar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomLayoutGuide;

@property (nonatomic, readonly) UIImagePickerController* pickerController;
@property (weak, nonatomic) UIView *snapshotView;
@property (strong, nonatomic) QMKeyboardController *keyboardController;
@property (strong, nonatomic) NSIndexPath *selectedIndexPathForMenu;
@property (assign, nonatomic) BOOL isObserving;

@property (strong, nonatomic) NSMutableArray *chatSections;
@property (strong, nonatomic) NSTimer* timer;

@end

@implementation QMChatViewController

@synthesize pickerController = _pickerController;

+ (UINib *)nib {
    
    return [UINib nibWithNibName:NSStringFromClass([QMChatViewController class]) bundle:[NSBundle bundleForClass:[QMChatViewController class]]];
}

+ (instancetype)messagesViewController {
    
    return [[[self class] alloc] initWithNibName:NSStringFromClass([QMChatViewController class]) bundle:[NSBundle bundleForClass:[QMChatViewController class]]];
}


- (void)dealloc {
    
    [self registerForNotifications:NO];
    [self removeObservers];
    
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
    self.collectionView = nil;
    
    self.inputToolbar.contentView.textView.delegate = nil;
    self.inputToolbar.delegate = nil;
    self.inputToolbar = nil;
    
    self.toolbarHeightConstraint = nil;
    self.toolbarBottomLayoutGuide = nil;
    
    self.senderDisplayName = nil;
    
    [self.keyboardController endListeningForKeyboard];
    self.keyboardController = nil;
    
    self.chatSections = nil;
}

#pragma mark - Initialization

- (void)configureMessagesViewController {
    
    self.isObserving = NO;
    
    self.toolbarHeightConstraint.constant = self.inputToolbar.preferredDefaultHeight;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.inputToolbar.delegate = self;
    self.inputToolbar.contentView.textView.delegate = self;
    self.automaticallyScrollsToMostRecentMessage = YES;
    self.topContentAdditionalInset = 0.0f;
    [self updateCollectionViewInsets];
    
    self.keyboardController =
    [[QMKeyboardController alloc] initWithTextView:self.inputToolbar.contentView.textView
                                       contextView:self.view
                              panGestureRecognizer:self.collectionView.panGestureRecognizer
                                          delegate:self];
    
    [self registerCells];
}

- (void)registerCells {
    /**
     *  Register header view
     */
    UINib *headerNib = [QMHeaderCollectionReusableView nib];
    NSString *headerView = [QMHeaderCollectionReusableView cellReuseIdentifier];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:headerView];
    /**
     *  Register contact request cell
     */
    UINib *requestNib = [QMChatContactRequestCell nib];
    NSString *requestIdentifier = [QMChatContactRequestCell cellReuseIdentifier];
    [self.collectionView registerNib:requestNib forCellWithReuseIdentifier:requestIdentifier];
    /**
     *  Register Notification  cell
     */
    UINib *notificationNib = [QMChatNotificationCell nib];
    NSString *notificationIdentifier = [QMChatNotificationCell cellReuseIdentifier];
    [self.collectionView  registerNib:notificationNib forCellWithReuseIdentifier:notificationIdentifier];
    /**
     *  Register outgoing cell
     */
    UINib *outgoingNib = [QMChatOutgoingCell nib];
    NSString *ougoingIdentifier = [QMChatOutgoingCell cellReuseIdentifier];
    [self.collectionView  registerNib:outgoingNib forCellWithReuseIdentifier:ougoingIdentifier];
    /**
     *  Register incoming cell
     */
    UINib *incomingNib = [QMChatIncomingCell nib];
    NSString *incomingIdentifier = [QMChatIncomingCell cellReuseIdentifier];
    [self.collectionView  registerNib:incomingNib forCellWithReuseIdentifier:incomingIdentifier];
    /**
     *  Register attachment incoming cell
     */
    UINib *attachmentIncomingNib  = [QMChatAttachmentIncomingCell nib];
    NSString *attachmentIncomingIdentifier = [QMChatAttachmentIncomingCell cellReuseIdentifier];
    [self.collectionView registerNib:attachmentIncomingNib forCellWithReuseIdentifier:attachmentIncomingIdentifier];
    /**
     *  Register outgoing incoming cell
     */
    UINib *attachmentOutgoingNib  = [QMChatAttachmentOutgoingCell nib];
    NSString *attachmentOutgoingIdentifier = [QMChatAttachmentOutgoingCell cellReuseIdentifier];
    [self.collectionView registerNib:attachmentOutgoingNib forCellWithReuseIdentifier:attachmentOutgoingIdentifier];
}

#pragma mark - Getters

- (UIImagePickerController *)pickerController
{
    if (_pickerController == nil) {
        _pickerController = [UIImagePickerController new];
        _pickerController.delegate = self;
    }
    return _pickerController;
}

#pragma mark - Setters

- (void)setTopContentAdditionalInset:(CGFloat)topContentAdditionalInset {
    
    _topContentAdditionalInset = topContentAdditionalInset;
    [self updateCollectionViewInsets];
}

#pragma mark - Messages items

- (void)insertMessagesToTheTopAnimated:(NSArray *)messages {
    NSParameterAssert(messages);

    NSDictionary *sectionsAndItems = [self prepareSectionsForMessages:messages];
    NSArray *sectionsToInsert = sectionsAndItems[kQMSectionsInsertKey];
    NSArray *itemsToInsert = sectionsAndItems[kQMItemsInsertKey];
    
    NSMutableIndexSet *sectionsIndexSet = [NSMutableIndexSet indexSet];
    if ([sectionsToInsert count] > 0) {
        for (NSNumber *sectionIndex in sectionsToInsert) {
            [sectionsIndexSet addIndex:[sectionIndex integerValue]];
        }
    }

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    __weak __typeof(self)weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        //
        __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([[itemsToInsert firstObject] section] == [strongSelf.collectionView numberOfSections] - 1) {
            // reloading last section cause layout changed
            [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[strongSelf.collectionView numberOfSections] - 1]];
        }
        
        if ([sectionsIndexSet count] > 0) [strongSelf.collectionView insertSections:sectionsIndexSet];
        [strongSelf.collectionView insertItemsAtIndexPaths:itemsToInsert];
        
    } completion:^(BOOL finished) {
        //
        __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.collectionView.collectionViewLayout invalidateLayout];
        [CATransaction commit];
    }];
}

- (NSDictionary *)prepareSectionsForMessages:(NSArray *)messages
{
    NSMutableArray *sectionsToAdd = [NSMutableArray arrayWithArray:self.chatSections];
    
    NSMutableArray *sectionsToInsert = [NSMutableArray array];
    NSMutableArray *indexPathToInsert = [NSMutableArray array];
    
    if (self.chatSections == nil) {
        [sectionsToAdd addObject:[QMChatSection chatSectionWithMessage:[messages lastObject]]];
        [sectionsToInsert addObject:@(0)];
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
    
    self.chatSections = sectionsToAdd;
    
    return @{kQMSectionsInsertKey : sectionsToInsert,
             kQMItemsInsertKey    : indexPathToInsert};
}

- (void)insertMessageToTheBottomAnimated:(QBChatMessage *)message {
    NSParameterAssert(message);
    [self insertMessagesToTheBottomAnimated:@[message]];
}

- (void)insertMessagesToTheBottomAnimated:(NSArray *)messages {
    NSAssert([messages count] > 0, @"Array must contain messages!");
    
    if (self.chatSections == nil) {
        [self prepareSectionsForMessages:messages];
        [self.collectionView reloadData];
        return;
    }
    
    NSMutableArray *sectionsToInsert = [NSMutableArray array];
    NSMutableArray *indexPathToInsert = [NSMutableArray array];
    
    for (QBChatMessage *message in messages) {
        NSAssert(message.dateSent != nil, @"Message must have dateSent!");
        
        if ([self indexPathForMessage:message] != nil) continue;
        
        QMChatSection *firstSection = [self.chatSections firstObject];
        
        NSUInteger sectionIndex = [self.chatSections indexOfObject:firstSection];
        
        if ([message.dateSent timeIntervalSinceDate:[firstSection firstMessageDate]] > self.timeIntervalBetweenSections || firstSection == nil) {
            
            QMChatSection* newSection = [QMChatSection chatSectionWithMessage:message];
            [self.chatSections insertObject:newSection atIndex:0];
            
            sectionIndex = [self.chatSections indexOfObject:newSection];
            [sectionsToInsert addObject:@(sectionIndex)];
        } else {
            [firstSection.messages insertObject:message atIndex:0];
        }
        
        [indexPathToInsert addObject:[NSIndexPath indexPathForRow:0
                                                        inSection:sectionIndex]];

    }
    
    NSMutableIndexSet *sectionsIndexSet = [NSMutableIndexSet indexSet];
    for (NSNumber *sectionIndex in sectionsToInsert) {
        [sectionsIndexSet addIndex:[sectionIndex integerValue]];
    }
    __weak __typeof(self)weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        //
        __typeof(weakSelf)strongSelf = self;
        
        if ([sectionsIndexSet count] > 0) [strongSelf.collectionView insertSections:sectionsIndexSet];
        [strongSelf.collectionView insertItemsAtIndexPaths:indexPathToInsert];
    } completion:^(BOOL finished) {
        //
        __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.collectionView.collectionViewLayout invalidateLayout];
        [strongSelf scrollToBottomAnimated:NO];
    }];
}

- (void)updateMessage:(QBChatMessage *)message {
    [self updateMessages:@[message]];
}

- (void)updateMessages:(NSArray *)messages {
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (QBChatMessage *message in messages) {
        NSIndexPath *indexPath = [self indexPathForMessage:message];
        if (indexPath == nil) continue;
        
        [indexPaths addObject:indexPath];
        [self.collectionView.collectionViewLayout removeSizeFromCacheForItemID:message.ID];
        
        QMChatSection *chatSection = self.chatSections[indexPath.section];
        [chatSection.messages replaceObjectAtIndex:indexPath.item withObject:message];
    }
    
    if ([indexPaths count] > 0) {
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
        [self.collectionView.collectionViewLayout invalidateLayout];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[[self class] nib] instantiateWithOwner:self options:nil];
    
    [self configureMessagesViewController];
    [self registerForNotifications:YES];
    
    //Customize your toolbar buttons
    self.inputToolbar.contentView.leftBarButtonItem = [self accessoryButtonItem];
    self.inputToolbar.contentView.rightBarButtonItem = [self sendButtonItem];
    
    self.collectionView.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSParameterAssert(self.senderID != 0);
    NSParameterAssert(self.senderDisplayName != nil);
    NSParameterAssert(self.timeIntervalBetweenSections != 0);
    
    [super viewWillAppear:animated];
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    [self updateKeyboardTriggerPoint];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self addObservers];
    [self addActionToInteractivePopGestureRecognizer:YES];
    [self.keyboardController beginListeningForKeyboard];
    
    if ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        [self.snapshotView removeFromSuperview];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self addActionToInteractivePopGestureRecognizer:NO];
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
	
	[self removeObservers];
	[self.keyboardController endListeningForKeyboard];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARNING: %s", __PRETTY_FUNCTION__);
}

#pragma mark - Tool bar

- (UIButton *)accessoryButtonItem {
    
    UIImage *accessoryImage = [UIImage imageNamed:@"attachmentBtn"];
    UIImage *normalImage = [accessoryImage imageMaskedWithColor:[UIColor lightGrayColor]];
    UIImage *highlightedImage = [accessoryImage imageMaskedWithColor:[UIColor darkGrayColor]];
    
    UIButton *accessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, accessoryImage.size.width, 32.0f)];
    [accessoryButton setImage:normalImage forState:UIControlStateNormal];
    [accessoryButton setImage:highlightedImage forState:UIControlStateHighlighted];
    
    accessoryButton.contentMode = UIViewContentModeScaleAspectFit;
    accessoryButton.backgroundColor = [UIColor clearColor];
    accessoryButton.tintColor = [UIColor lightGrayColor];
    
    return accessoryButton;
}

- (UIButton *)sendButtonItem {
    
    NSString *sendTitle = NSLocalizedString(@"Send", nil);
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [sendButton setTitle:sendTitle forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[[UIColor blueColor] colorByDarkeningColorWithValue:0.1f] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    sendButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    sendButton.titleLabel.minimumScaleFactor = 0.85f;
    sendButton.contentMode = UIViewContentModeCenter;
    sendButton.backgroundColor = [UIColor clearColor];
    sendButton.tintColor = [UIColor blueColor];
    
    CGFloat maxHeight = 32.0f;
    
    CGRect sendTitleRect = [sendTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, maxHeight)
                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:@{ NSFontAttributeName : sendButton.titleLabel.font }
                                                   context:nil];
    
    sendButton.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(CGRectIntegral(sendTitleRect)), maxHeight);
    
    return sendButton;
}


#pragma mark - View rotation

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.collectionView.collectionViewLayout invalidateLayoutWithContext:[QMCollectionViewFlowLayoutInvalidationContext context]];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - Messages view controller

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSUInteger)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

- (void)didPressAccessoryButton:(UIButton *)sender {
    
    [self.inputToolbar.contentView.textView resignFirstResponder];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    [actionSheet showInView:self.view];
}

- (void)didPickAttachmentImage:(UIImage *)image {
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

- (void)finishSendingMessage {
    
    [self finishSendingMessageAnimated:YES];
}

- (void)finishSendingMessageAnimated:(BOOL)animated {
    
    UITextView *textView = self.inputToolbar.contentView.textView;
    textView.text = nil;
    [textView.undoManager removeAllActions];
    
    [self.inputToolbar toggleSendButtonEnabled];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:textView];
    
    [self.collectionView.collectionViewLayout invalidateLayoutWithContext:[QMCollectionViewFlowLayoutInvalidationContext context]];
    [self.collectionView reloadData];
    
    if (self.automaticallyScrollsToMostRecentMessage) {
        [self scrollToBottomAnimated:animated];
    }
}

- (void)finishReceivingMessage {
    
    [self finishReceivingMessageAnimated:YES];
}

- (void)finishReceivingMessageAnimated:(BOOL)animated {
    
    [self.collectionView.collectionViewLayout invalidateLayoutWithContext:[QMCollectionViewFlowLayoutInvalidationContext context]];
    [self.collectionView reloadData];
    
    if (self.automaticallyScrollsToMostRecentMessage && ![self isMenuVisible]) {
        [self scrollToBottomAnimated:animated];
    }
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    if (self.chatSections.count > 0) {
        NSIndexPath* topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:topIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    // disabling scrolll to bottom when tapping status bar
    return NO;
}

#pragma mark - Collection view data source

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0.0f, self.heightForSectionHeader);
}

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
    headerView.transform = self.collectionView.transform;
    
    return headerView;
}

- (UICollectionReusableView *)collectionView:(QMChatCollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionFooter) {
        // due to collection view being reversed, section header is actually footer
        return [self collectionView:collectionView sectionHeaderAtIndexPath:indexPath];
    }
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(QMChatCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QBChatMessage *messageItem = [self messageForIndexPath:indexPath];
    
    Class class = [self viewClassForItem:messageItem];
    NSString *itemIdentifier = [class cellReuseIdentifier];
    
    QMChatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    cell.transform = self.collectionView.transform;
    
    [self collectionView:collectionView configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(QMChatCollectionView *)collectionView configureCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[QMChatContactRequestCell class]]) {
        
        QMChatContactRequestCell *conatactRequestCell = (id)cell;
        conatactRequestCell.actionsHandler = self.actionsHandler;
    }
    
    if ([cell isKindOfClass:[QMChatCell class]]) {
        
        QMChatCell *chatCell = (QMChatCell *)cell;
        
        QBChatMessage *messageItem = [self messageForIndexPath:indexPath];
        
        chatCell.textView.text = [self attributedStringForItem:messageItem];
        chatCell.topLabel.attributedText = [self topLabelAttributedStringForItem:messageItem];
        chatCell.bottomLabel.attributedText = [self bottomLabelAttributedStringForItem:messageItem];
    }
}

- (NSAttributedString *)topLabelAttributedStringForItem:(QBChatMessage *)messageItem {
    NSAssert(NO, @"Have to be overriden in subclasses!");
    return nil;
}

- (NSAttributedString *)attributedStringForItem:(QBChatMessage *)messageItem {
    NSAssert(NO, @"Have to be overriden in subclasses!");
    return nil;
}

- (NSAttributedString *)bottomLabelAttributedStringForItem:(QBChatMessage *)messageItem {
    NSAssert(NO, @"Have to be overriden in subclasses!");
    return nil;
}

#pragma mark - Collection view delegate

- (BOOL)collectionView:(QMChatCollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {

    self.selectedIndexPathForMenu = indexPath;
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    if (action == @selector(copy:)) {
        
        return YES;
    }
    
    return NO;
}

- (void)collectionView:(QMChatCollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSAssert(NO, @"Have to be overriden in subclasses.");
}

- (Class)viewClassForItem:(QBChatMessage *)item {
    NSAssert(NO, @"Have to be overriden in subclasses.");
    return nil;
}

#pragma mark - Collection view delegate flow layout

- (CGSize)collectionView:(QMChatCollectionView *)collectionView
                  layout:(QMChatCollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

- (NSString *)collectionView:(QMChatCollectionView *)collectionView itemIdAtIndexPath:(NSIndexPath *)indexPath {
    
    QBChatMessage *message = [self messageForIndexPath:indexPath];
    
    return message.ID;
}

- (QMChatCellLayoutModel)collectionView:(QMChatCollectionView *)collectionView layoutModelAtIndexPath:(NSIndexPath *)indexPath {
    
    QBChatMessage *item = [self messageForIndexPath:indexPath];
    Class class = [self viewClassForItem:item];
    
    return [class layoutModel];
}

#pragma mark - Input toolbar delegate

- (void)messagesInputToolbar:(QMInputToolbar *)toolbar didPressLeftBarButton:(UIButton *)sender {
    
    if (toolbar.sendButtonOnRight) {
        
        [self didPressAccessoryButton:sender];
    }
    else {
        
        [self didPressSendButton:sender
                 withMessageText:[self currentlyComposedMessageText]
                        senderId:self.senderID
               senderDisplayName:self.senderDisplayName
                            date:[NSDate date]];
    }
}

- (void)messagesInputToolbar:(QMInputToolbar *)toolbar didPressRightBarButton:(UIButton *)sender {
    
    if (toolbar.sendButtonOnRight) {
        
        [self didPressSendButton:sender withMessageText:[self currentlyComposedMessageText] senderId:self.senderID
               senderDisplayName:self.senderDisplayName
                            date:[NSDate date]];
    }
    else {
        
        [self didPressAccessoryButton:sender];
    }
}

- (NSString *)currentlyComposedMessageText {
    //  auto-accept any auto-correct suggestions
    [self.inputToolbar.contentView.textView.inputDelegate selectionWillChange:self.inputToolbar.contentView.textView];
    [self.inputToolbar.contentView.textView.inputDelegate selectionDidChange:self.inputToolbar.contentView.textView];
    
    return [self.inputToolbar.contentView.textView.text stringByTrimingWhitespace];
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (textView != self.inputToolbar.contentView.textView) {
        return;
    }
    
    [textView becomeFirstResponder];
    
    if (self.automaticallyScrollsToMostRecentMessage) {
        [self scrollToBottomAnimated:YES];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView != self.inputToolbar.contentView.textView) {
        return;
    }
    
    [self.inputToolbar toggleSendButtonEnabled];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView != self.inputToolbar.contentView.textView) {
        return;
    }
    
    [textView resignFirstResponder];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.pickerController animated:YES completion:nil];
    } else if (buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.pickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    
    [self didPickAttachmentImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Notifications

- (void)handleDidChangeStatusBarFrameNotification:(NSNotification *)notification {
    
    if (self.keyboardController.keyboardIsVisible) {
        [self setToolbarBottomLayoutGuideConstant:CGRectGetHeight(self.keyboardController.currentKeyboardFrame)];
    }
}

- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification {
    
    if (!self.selectedIndexPathForMenu) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    UIMenuController *menu = [notification object];
    [menu setMenuVisible:NO animated:NO];
    
    QMChatCell *selectedCell = (QMChatCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPathForMenu];
    CGRect selectedCellMessageBubbleFrame = [selectedCell convertRect:selectedCell.containerView.frame toView:self.view];
    
    [menu setTargetRect:selectedCellMessageBubbleFrame inView:self.view];
    [menu setMenuVisible:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
}

- (void)didReceiveMenuWillHideNotification:(NSNotification *)notification {
    
    if (!self.selectedIndexPathForMenu) {
        return;
    }
    
    //  per comment above in 'shouldShowMenuForItemAtIndexPath:'
    //  re-enable 'selectable', thus re-enabling data detectors if present
    //    QMChatCollectionViewCell *selectedCell = (id)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPathForMenu];
    //    selectedCell.textView.selectable = YES;
    self.selectedIndexPathForMenu = nil;
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == kChatKeyValueObservingContext) {
        
        if (object == self.inputToolbar.contentView.textView
            && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
            
            CGSize oldContentSize = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
            CGSize newContentSize = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
            
            CGFloat dy = newContentSize.height - oldContentSize.height;
            
            [self adjustInputToolbarForComposerTextViewContentSizeChange:dy];
            [self updateCollectionViewInsets];
            
            if (self.automaticallyScrollsToMostRecentMessage) {
                
                [self scrollToBottomAnimated:NO];
            }
        }
    }
}

#pragma mark - Keyboard controller delegate

- (void)keyboardController:(QMKeyboardController *)keyboardController keyboardDidChangeFrame:(CGRect)keyboardFrame {
    
    if (![self.inputToolbar.contentView.textView isFirstResponder] && self.toolbarBottomLayoutGuide.constant == 0.0f) {
        return;
    }
    
    CGFloat heightFromBottom = CGRectGetMaxY(self.collectionView.frame) - CGRectGetMinY(keyboardFrame);
    
    heightFromBottom = MAX(0.0f, heightFromBottom);
    
    [self setToolbarBottomLayoutGuideConstant:heightFromBottom];
}

- (void)setToolbarBottomLayoutGuideConstant:(CGFloat)constant {
	
	if (fabs(self.toolbarBottomLayoutGuide.constant - constant) < 0.01) {
		return;
	}
	
    self.toolbarBottomLayoutGuide.constant = constant;
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
    
    [self updateCollectionViewInsets];
}

- (void)updateKeyboardTriggerPoint {
    
    self.keyboardController.keyboardTriggerPoint = CGPointMake(0.0f, CGRectGetHeight(self.inputToolbar.bounds));
}

#pragma mark - Gesture recognizers

- (void)handleInteractivePopGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
    BOOL ios8 = [[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending;
    
    switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            if (ios8) {
                
                [self.snapshotView removeFromSuperview];
            }
            
            [self.keyboardController endListeningForKeyboard];
            
            if (ios8) {
                
                [self.inputToolbar.contentView.textView resignFirstResponder];
                [UIView animateWithDuration:0.0
                                 animations:^
                 {
                     [self setToolbarBottomLayoutGuideConstant:0.0f];
                 }];
                
                UIView *snapshot = [self.view snapshotViewAfterScreenUpdates:YES];
                [self.view addSubview:snapshot];
                self.snapshotView = snapshot;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
            [self.keyboardController beginListeningForKeyboard];
            
            if (ios8) {
                [self.snapshotView removeFromSuperview];
            }
            
            break;
        default:
            break;
    }
}

#pragma mark - Input toolbar utilities

- (BOOL)inputToolbarHasReachedMaximumHeight {
    
    return CGRectGetMinY(self.inputToolbar.frame) == (self.topLayoutGuide.length + self.topContentAdditionalInset);
}

- (void)adjustInputToolbarForComposerTextViewContentSizeChange:(CGFloat)dy {
    
    BOOL contentSizeIsIncreasing = (dy > 0);
    
    if ([self inputToolbarHasReachedMaximumHeight]) {
        
        BOOL contentOffsetIsPositive = (self.inputToolbar.contentView.textView.contentOffset.y > 0);
        
        if (contentSizeIsIncreasing || contentOffsetIsPositive) {
            [self scrollComposerTextViewToBottomAnimated:YES];
            
            return;
        }
    }
    
    CGFloat toolbarOriginY = CGRectGetMinY(self.inputToolbar.frame);
    CGFloat newToolbarOriginY = toolbarOriginY - dy;
    
    //  attempted to increase origin.Y above topLayoutGuide
    if (newToolbarOriginY <= self.topLayoutGuide.length + self.topContentAdditionalInset) {
        
        dy = toolbarOriginY - (self.topLayoutGuide.length + self.topContentAdditionalInset);
        [self scrollComposerTextViewToBottomAnimated:YES];
    }
    
    [self adjustInputToolbarHeightConstraintByDelta:dy];
    
    [self updateKeyboardTriggerPoint];
    
    if (dy < 0) {
        
        [self scrollComposerTextViewToBottomAnimated:NO];
    }
}

- (void)adjustInputToolbarHeightConstraintByDelta:(CGFloat)dy {
    
    self.toolbarHeightConstraint.constant += dy;
    
    if (self.toolbarHeightConstraint.constant < self.inputToolbar.preferredDefaultHeight) {
        self.toolbarHeightConstraint.constant = self.inputToolbar.preferredDefaultHeight;
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
}

- (void)scrollComposerTextViewToBottomAnimated:(BOOL)animated {
    
    UITextView *textView = self.inputToolbar.contentView.textView;
    CGPoint contentOffsetToShowLastLine = CGPointMake(0.0f, textView.contentSize.height - CGRectGetHeight(textView.bounds));
    
    if (!animated) {
        textView.contentOffset = contentOffsetToShowLastLine;
        return;
    }
    
    [UIView animateWithDuration:0.01 delay:0.01 options:UIViewAnimationOptionCurveLinear animations:^{
        
        textView.contentOffset = contentOffsetToShowLastLine;
    }
                     completion:nil];
}

#pragma mark - Collection view utilities

- (void)updateCollectionViewInsets {

    [self setCollectionViewInsetsTopValue:CGRectGetMaxY(self.collectionView.frame) - CGRectGetMinY(self.inputToolbar.frame)
                              bottomValue:self.topLayoutGuide.length + self.topContentAdditionalInset];
}

- (void)setCollectionViewInsetsTopValue:(CGFloat)top bottomValue:(CGFloat)bottom {
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, 0.0f, bottom, 0.0f);
    self.collectionView.contentInset = insets;
    self.collectionView.scrollIndicatorInsets = insets;
}

- (BOOL)isMenuVisible {
    //  check if cell copy menu is showing
    //  it is only our menu if `selectedIndexPathForMenu` is not `nil`
    return self.selectedIndexPathForMenu != nil && [[UIMenuController sharedMenuController] isMenuVisible];
}

#pragma mark - Utilities

- (NSUInteger)totalMessagesCount {
    NSUInteger totalMessagesCount = 0;
    NSArray *chatSections = [self.chatSections copy];
    for (QMChatSection *chatSection in chatSections) {
        totalMessagesCount += [chatSection.messages count];
    }
    
    return totalMessagesCount;
}

- (NSString *)nameForSectionWithDate:(NSDate *)date {
    
    return [QMDateUtils formattedStringFromDate:date];
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

- (void)addObservers {
    
    if (self.isObserving) {
        return;
    }
    
    [self.inputToolbar.contentView.textView addObserver:self
                                             forKeyPath:NSStringFromSelector(@selector(contentSize))
                                                options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                                context:kChatKeyValueObservingContext];
    
    self.isObserving = YES;
}

- (void)removeObservers {
    
    if (!self.isObserving) {
        return;
    }
    
    @try {
        [_inputToolbar.contentView.textView removeObserver:self
                                                forKeyPath:NSStringFromSelector(@selector(contentSize))
                                                   context:kChatKeyValueObservingContext];
    }
    @catch (NSException * __unused exception) {
        
    }
    
    self.isObserving = NO;
}

- (void)registerForNotifications:(BOOL)registerForNotifications {
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    if (registerForNotifications) {
        
        [defaultCenter addObserver:self
                          selector:@selector(handleDidChangeStatusBarFrameNotification:)
                              name:UIApplicationDidChangeStatusBarFrameNotification
                            object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(didReceiveMenuWillShowNotification:)
                              name:UIMenuControllerWillShowMenuNotification
                            object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(didReceiveMenuWillHideNotification:)
                              name:UIMenuControllerWillHideMenuNotification
                            object:nil];
    }
    else {
        
        [defaultCenter removeObserver:self
                                 name:UIApplicationDidChangeStatusBarFrameNotification
                               object:nil];
        
        [defaultCenter removeObserver:self
                                 name:UIMenuControllerWillShowMenuNotification
                               object:nil];
        
        [defaultCenter removeObserver:self
                                 name:UIMenuControllerWillHideMenuNotification
                               object:nil];
    }
}

- (void)addActionToInteractivePopGestureRecognizer:(BOOL)addAction {
    
    if (self.navigationController.interactivePopGestureRecognizer) {
        
        [self.navigationController.interactivePopGestureRecognizer removeTarget:nil
                                                                         action:@selector(handleInteractivePopGestureRecognizer:)];
        
        if (addAction) {
            
            [self.navigationController.interactivePopGestureRecognizer addTarget:self
                                                                          action:@selector(handleInteractivePopGestureRecognizer:)];
        }
    }
}

@end
