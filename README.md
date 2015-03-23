# GSFastPass

Objective-C library for Get Satisfaction's FastPass authentication

## Usage

```ruby
platform :ios, '6.0'
pod "GSFastPass", "~> 0.0"
```

```objective-c
#import <GSFastPass/GSFastPass.h>
```

```objective-c
GSFastPass *fastPass = [[GSFastPass alloc] initWithHost:@"getsatisfaction.com"
                                               protocol:@"https"
                                            consumerKey:@"consumerKey"
                                         consumerSecret:@"consumerSecret"];

NSURL *fastPassURL = [fastPass loginUrlForCommunity:@"community-name"
                                              email:@"user-email@company.com"
                                               name:@"username"
                                                uid:@"12345"];

[[UIApplication sharedApplication] openURL:fastPassURL];
```
