//
//  MasterViewController.m
//  CoreDataConcurencyTest
//
//  Created by Scott Newman on 9/23/14.
//

#import "MasterViewController.h"
#import "DataManager.h"

#import "SNCoreDataStack.h"
#import "SNContact.h"

@interface MasterViewController ()

@property NSMutableArray *objects;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MasterViewController

#pragma mark - View Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up a date formatter for use in the cells
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MM/dd/yyyy"];

    [self.fetchedResultsController performFetch:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User Interface Methods

- (IBAction)refreshPressed:(id)sender
{
    [[DataManager sharedManager] loadDataWithCompletion:^(NSError *error)
    {
        NSLog(@"loadDataWithCompletion returned");
    }];
}

#pragma mark - Core Data methods

- (NSFetchRequest *)contactListFetchRequest
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SNContact"];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"uniqueID" ascending:NO];
    fetchRequest.sortDescriptors = @[sd];
    return fetchRequest;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        SNCoreDataStack *coreDataStack = [SNCoreDataStack defaultStack];
        NSFetchRequest *fetchRequest = [self contactListFetchRequest];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:coreDataStack.mainQueueContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        _fetchedResultsController.delegate = self;

    }
    return _fetchedResultsController;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    SNContact *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:contact.birthday];
    
    return cell;
}

#pragma mark - Fetched Results Controller Delegate Methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
