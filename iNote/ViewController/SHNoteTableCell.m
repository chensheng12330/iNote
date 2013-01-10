//
//  CustomTableCell.m
//  MM
//
//  Created by sherwin.chen on 12-02-22.
//  Copyright 2012 Clochase. All rights reserved.
//

#import "SHNoteTableCell.h"

@implementation SHNoteTableCell

@synthesize labTitle    = _labTitle;
@synthesize labDetail   = _labDetail;
@synthesize labTime     = _labTime;
@synthesize labSourceUrl= _labSourceUrl;
@synthesize ivImageView = _ivImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(int) n_height
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"workOrders_cell_bk.PNG"]] autorelease];
        //self.selectedBackgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fg2.png"]] autorelease];
        
        [self setOpaque:YES];
        [self setAlpha:1.0];
        
        //设置ImageView
//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, n_height-15, n_height-15)];
//        [imageView setImage:[UIImage imageNamed:@"workOrders_cell_bk.PNG"]];
//        [self.contentView addSubview:imageView];
        
        //设置Title
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 1, 280,20)];
        _labTitle.numberOfLines=1;
        _labTitle.font=[UIFont systemFontOfSize:15.0f];
        _labTitle.textColor=[UIColor blackColor];
        _labTitle.textAlignment=UITextAlignmentLeft;
        _labTitle.lineBreakMode=UILineBreakModeWordWrap;
        [_labTitle setBackgroundColor:[UIColor clearColor]];
        //[_labTitle setHighlighted:YES];
        [_labTitle setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_labTitle];
        
    
        //设置Detail
        _labDetail = [[UILabel alloc] initWithFrame:CGRectMake(20,21,280,27)];
        _labDetail.numberOfLines=2;
        _labDetail.font=[UIFont boldSystemFontOfSize:12.0f];
        _labDetail.textColor=[UIColor blackColor];
        _labDetail.textAlignment=UITextAlignmentLeft;
        _labDetail.lineBreakMode=UILineBreakModeWordWrap;
        [_labDetail setBackgroundColor:[UIColor clearColor]];
        [_labDetail setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_labDetail];
        
        //设置time
        _labTime = [[UILabel alloc] initWithFrame:CGRectMake(20,48,71,15)];
        _labTime.numberOfLines=1;
        _labTime.font=[UIFont boldSystemFontOfSize:12.0f];
        _labTime.textColor=[UIColor blackColor];
        _labTime.textAlignment=UITextAlignmentLeft;
        _labTime.lineBreakMode=UILineBreakModeWordWrap;
        [_labTime setBackgroundColor:[UIColor clearColor]];
        [_labTime setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_labTime];
        
        //设置sourth url
        _labSourceUrl = [[UILabel alloc] initWithFrame:CGRectMake(99,48,201,15)];
        _labSourceUrl.numberOfLines=1;
        _labSourceUrl.font=[UIFont boldSystemFontOfSize:12.0f];
        _labSourceUrl.textColor=[UIColor blackColor];
        _labSourceUrl.textAlignment=UITextAlignmentLeft;
        _labSourceUrl.lineBreakMode=UILineBreakModeWordWrap;
        [_labSourceUrl setBackgroundColor:[UIColor clearColor]];
        [_labSourceUrl setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_labSourceUrl];
    }
    return self;
}


- (void)layoutSubviews
{
	[super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [super dealloc];
    [_labTitle  release];
    [_labDetail release];
    [_labTime   release];
    [_labSourceUrl release];
    [_ivImageView release];
}

@end
