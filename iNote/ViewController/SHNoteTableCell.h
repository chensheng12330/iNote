//
//  SHNoteTableCell.h
//  MM
//
//  Created by sherwin.chen on 12-02-22.
//  Copyright 2012 Clochase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHNoteTableCell : UITableViewCell {
}

@property(nonatomic,readonly,retain)UILabel *labTitle;
@property(nonatomic,readonly,retain)UILabel *labDetail;
@property(nonatomic,readonly,retain)UILabel *labTime;
@property(nonatomic,readonly,retain)UILabel *labSourceUrl;
@property(nonatomic,readonly,retain)UIImageView   *ivImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(int) n_height; 
@end
