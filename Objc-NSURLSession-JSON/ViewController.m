//
//  ViewController.m
//  Objc-NSURLSession-JSON
//
//  Created by verebes on 25/03/2019.
//  Copyright © 2019 A&D Progress. All rights reserved.
//

#import "ViewController.h"
#import "Course.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray<Course *> *courses;

@end

@implementation ViewController

NSString *CELL_ID = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    //setup the navigation controller
    self.navigationItem.title = @"Courses";
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor]; //or UIColor.blueColor
    self.navigationController.navigationBar.prefersLargeTitles = YES; // Bool true can be used as well.
    
    //register the tableViewCell Identifier
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:CELL_ID];
    
    [self fillCoursesWithSampleData];
    [self fetchCourseDataUsingJSON];
    
}

- (void)fillCoursesWithSampleData {
    self.courses = NSMutableArray.new;
    
    Course *course = Course.new;
//    Course *course = [[Course alloc] init]; // same as above just old style Objc
    course.name = @"Firebase Course";
    course.numberOfLessons = @(49); //the @() converts the integer to NSNumber
    
    [self.courses addObject:course];
}

- (void)fetchCourseDataUsingJSON {
    NSLog(@"Fetching courses");
    // https://api.letsbuildthatapp.com/jsondecodable/courses
    
    NSString *urlString = @"https://api.letsbuildthatapp.com/jsondecodable/courses";
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Finished fetching courses....");
        
//        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"JSON String: %@", jsonString);
        
        NSError *err;                                   //&err is the pointer address of err.
        NSArray *courseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err) {
            NSLog(@"Failed to serialize into JSON: %@", err.localizedDescription);
            return;
        }
        
        NSMutableArray<Course *> *courses = NSMutableArray.new;
        for (NSDictionary *courseDict in courseJSON) {
            NSString *name = courseDict[@"name"];
            NSNumber *numberOfLessons = courseDict[@"number_of_lessons"];
//            NSLog(@"%@", name);
//            NSLog(@"%@", numberOfLessons);
            
            Course *course = Course.new;
            course.name = name;
            course.numberOfLessons = numberOfLessons;
            [courses addObject:course];
        }
        
        self.courses = courses;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }] resume];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    UITableViewCell *cell = [[tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID];
//    if(cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID];
//    }
    
    Course *course = self.courses[indexPath.row];
    
//    cell.textLabel.text = [NSString stringWithFormat:@"Cel number %ld", (long) indexPath.row];
    NSString *title = course.name;
    cell.textLabel.text = title;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ lessons", course.numberOfLessons];
    cell.detailTextLabel.text = course.numberOfLessons.stringValue; //Shorter option
    
    return cell;
}


@end
