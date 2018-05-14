
//  ViewController.m
//  IUNetworks
//
//  Created by Artashes Ghazaryan on 5/12/18.
//  Copyright © 2018 Artashes Ghazaryan. All rights reserved.
//

#import "ViewController.h"
#import "InfoTableViewCell.h"
#import "RequestManager.h"
#import "Item.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (nonatomic) NSMutableArray *globalItemArray;
@property (nonatomic) NSArray *sortedDatesArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.globalItemArray = [NSMutableArray array];
    self.sortedDatesArray = [NSArray array];
    [self getresponseWithJSON];
    [self getresponseWithXML];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.infoTableView reloadData];
}

- (void)sortedArrayWithDate {
    self.sortedDatesArray = [self.globalItemArray sortedArrayUsingComparator: ^(Item *a, Item *b) {
        
        return [ b.createdDate compare:a.createdDate ];
    }];
}

- (void)getresponseWithJSON {
    [RequestManager getInfoWithJSONCompletion:^(id response, NSError *error) {
        if(!error) {
            
            NSMutableArray *item = response[@"articles"];;
            for (int i = 0; i< item.count; i++) {
                NSDictionary *examp = item[i];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                NSString *cratedAt = examp[@"publishedAt"];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                NSDate *cratedAtDate = [dateFormatter dateFromString:cratedAt];
                
                Item *item = [[Item alloc] init];
                item.createdDate = cratedAtDate;
                item.title = examp[@"title"];
                item.imageUrl = examp[@"urlToImage"];
                item.desc = examp[@"description"];
                item.link = examp[@"url"];
                [self.globalItemArray addObject: item];
                
            }
            [self sortedArrayWithDate];
            [self.infoTableView reloadData];
        }else {
            [self showAlertInControllerWithTitle:@"Error"
                                     withMessage:error.description];
        }
    }];
    
}

- (void)getresponseWithXML {
    [RequestManager getInfoWithXMLCompletion:^(id response, NSError *error) {
        if(!error) {
            NSDictionary *resp = response[@"rss"];
            NSDictionary *chanel = resp[@"channel"];
            NSMutableArray *item = chanel[@"item"];
            for (int i = 0; i< item.count; i++) {
                NSDictionary *examp = item[i];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                NSString *cratedAt = examp[@"pubDate"];
                
                [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
                NSDate *cratedAtDate = [dateFormatter dateFromString:cratedAt];
                NSDictionary *exampImageUrl = examp[@"media:thumbnail"];
                Item *item = [[Item alloc] init];
                item.createdDate = cratedAtDate;
                item.title = examp[@"title"];
                item.imageUrl = exampImageUrl[@"-url"];
                item.desc = examp[@"description"];
                item.link = examp[@"link"];
                [self.globalItemArray addObject: item];
                
            }
            [self sortedArrayWithDate];
            [self.infoTableView reloadData];
        }else {
            [self showAlertInControllerWithTitle:@"Error"
                                     withMessage:error.description];
        }
    }];
}

#pragma mark - Show Alert
- (void)showAlertInControllerWithTitle:(NSString *)title withMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)saveFilesButtonAction:(UIButton *)sender {
    [self saveFileFromJSONOrXML];
    
}

-(void)saveFileFromJSONOrXML{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takeAPhoto = [UIAlertAction actionWithTitle:@"Save JSON File"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self saveJSON];
                                                       }];
    UIAlertAction *chooseAPhoto = [UIAlertAction actionWithTitle:@"Save XML File"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             [self saveXML];
                                                         }];
    UIAlertAction *cencel = [UIAlertAction actionWithTitle:@"cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                   }];
    
    
    [cencel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    
    [alert addAction:chooseAPhoto];
    [alert addAction:takeAPhoto];
    [alert addAction:cencel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)saveJSON {
    NSMutableArray *jsonArray = [NSMutableArray array];
    for (int i = 0; i < self.sortedDatesArray.count; i++) {
        Item *items = self.sortedDatesArray[i];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/d/yy HH:mm"];
        NSString *fromeDateString = [dateFormatter stringFromDate:items.createdDate];
        NSDictionary *dict = @{@"desc":items.desc,
                               @"title":items.title,
                               @"link":items.link,
                               @"imageUrl":items.imageUrl,
                               @"createdDate":fromeDateString
                               };
        [jsonArray addObject:dict];
    }
    NSError *error = nil;
    NSData *json = [ NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // Generate the file path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFIle.json"];
        
        // Save it into file system
        [json writeToFile:dataPath atomically:YES];
    });
}

- (void)saveXML {
    NSMutableArray *jsonArray = [NSMutableArray array];
    for (int i = 0; i < self.sortedDatesArray.count; i++) {
        Item *items = self.sortedDatesArray[i];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/d/yy HH:mm"];
        NSString *fromeDateString = [dateFormatter stringFromDate:items.createdDate];
        NSDictionary *dict = @{@"desc":items.desc,
                               @"title":items.title,
                               @"link":items.link,
                               @"imageUrl":items.imageUrl,
                               @"createdDate":fromeDateString
                               };
        [jsonArray addObject:dict];
    }
    NSError *error = nil;
    NSData *XML = [NSPropertyListSerialization dataWithPropertyList:jsonArray format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // Generate the file path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFIle.XML"];
        
        // Save it into file system
        [XML writeToFile:dataPath atomically:YES];
    });
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedDatesArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *infoTableViewCell = @"InfoTableViewCell";
    
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoTableViewCell];
    if (cell == nil) {
        cell = [[InfoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:infoTableViewCell];
    }
    Item *item = self.sortedDatesArray[indexPath.row];
    [cell.infoImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl]];
    cell.infoTitleLabel.text = item.title;
    cell.infoDescriptionLabel.text = item.desc;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/d/yy HH:mm"];
    NSString *fromeDateString = [dateFormatter stringFromDate:item.createdDate];
    cell.dates.text = fromeDateString;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item = self.sortedDatesArray[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: item.link] options:@{} completionHandler:nil];
}




@end
