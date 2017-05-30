//
//  QMChatModel.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 5/30/17.
//
//

#import "QMChatModel.h"
@interface QMChatModel()

@end

@implementation QMChatModel

@synthesize message = _message;
@synthesize modelID = _modelID;
@synthesize modelContentType = _modelContentType;

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<%@: %p; model = %@>",
            NSStringFromClass([self class]),
            self,
            self.message];
}

@end
