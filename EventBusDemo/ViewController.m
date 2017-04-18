//
//  ViewController.m
//  EventBusDemo
//
//  Created by mac on 2017/2/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"
#import "SHEventBus.h"
#import "SHTextField.h"
#import "SHButton.h"
#import "FMDatabase.h"
#import "UserModel.h"

@interface ViewController ()

@property (nonatomic ,strong) FMDatabase *db;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SHTextField *textField = [[SHTextField alloc] initWithFrame:CGRectMake(100, 60.0f, 200, 40.0f)];
    textField.placeholder = @"输入内容";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    
    SHButton *button = [[SHButton alloc] initWithFrame:CGRectMake(textField.frame.origin.x, textField.frame.origin.y + textField.frame.size.height + 50.f, textField.frame.size.width, 40)];
    [self.view addSubview:button];
    

    [self creatDataPath];
}

- (void)creatDataPath{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"test2.sqlite"];
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:fileName];
    if ([dataBase open]) {
        BOOL result = [dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS user_db (userId integer NOT NULL, name text NOT NULL, city text NOT NULL, boy bool NOT NULL);"];
        if (result) {
            NSLog(@" 创建表成功 ");
            self.db = dataBase;
            return;
        }
        NSLog(@" 创建表失败 ");
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self insert];
    
//    [self update];
    
//    [self delete];
    
    [self query];
    
    [self update];
//    [self dropDataBase];
}

- (void)insert{
    for (int i = 0; i < 10; i++) {
        UserModel *model = [UserModel new];
        model.userId = i;
        model.name = [NSString stringWithFormat:@"name%d",i];
        model.city = [NSString stringWithFormat:@"city%d",i];
        
        BOOL result = [self.db executeUpdate:@"INSERT INTO user_db (userId , name ,city ,boy ) VALUES (?,?,?,?);",@(model.userId),model.name,model.city ,@(YES)];
        NSLog(@" insert result %d ",result);
    }
}

- (void)query{
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM user_db"];
    
    resultSet = [self.db executeQuery:@"SELECT * FROM user_db where userId = 8"];
    while ([resultSet next]) {
        
        int uid = [resultSet intForColumn:@"userId"];
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *city = [resultSet stringForColumn:@"city"];
        NSLog(@" %d  %@  %@  %@",uid, name , city, [resultSet stringForColumn:@"country"]);
    }
    

    
}

- (void)update{
//   BOOL result = [self.db executeUpdate:@"update user_db set name = ? where name = ? ;",@"小明",@"name3"];
   
   BOOL result2 = [self.db executeUpdate:@"update user_db set country = ? where userId = 8",@"china"];
    NSLog(@" update %d",result2);
}


- (void)delete{
    BOOL result = [self.db executeUpdate:@"delete from user_db where userId = ? ;",@(6)];
    NSLog(@" delete %d ",result);
}

- (void)dropDataBase{
    BOOL result = [self.db executeUpdate:@"drop table if exists user_db;"];
    NSLog(@" drop %d",result);
}


/**
 表新加字段
 */
- (void)alter{
    BOOL result = [self.db executeUpdate:@"alter table user_db add country text"];
    NSLog(@" alter %d", result);
}

//- (void)insert
//{
//    for (int i = 0; i<10; i++) {
//        NSString *name = [NSString stringWithFormat:@"jack-%d", arc4random_uniform(100)];
//        // executeUpdate : 不确定的参数用?来占位，参数都必须是对象
//        [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);", name, @(arc4random_uniform(40))];
//        //        [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);" withArgumentsInArray:@[name, @(arc4random_uniform(40))]]; // ?方式，参数要是对象，不是对象要包装为对象
//        
//        // executeUpdateWithFormat : format方式拼接，不确定的参数用%@、%d等来占位
//        //        [self.db executeUpdateWithFormat:@"INSERT INTO t_student (name, age) VALUES (%@, %d);", name, arc4random_uniform(40)];
//        // 注意：如果直接写%@不用加单引号两边，会自动加单引号两边，如果'jack_%d'的两边不加单引号就会报错，所以要注意
//        [self.db executeUpdateWithFormat:@"INSERT INTO t_student (name, age) VALUES ('jack_%d', %d);", name, arc4random_uniform(40)];
//    }
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
