//
//  InfoTableViewCell.h
//  IUNetworks Task
//
//  Created by Artashes Ghazaryan on 5/12/18.
//  Copyright © 2018 Artashes Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dates;

@end
