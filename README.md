#AHLaunchCtl
Objective-C library for managing launchd
Daemons / Agents.

##Usage:
####Domains
There are five domain constants representing the common locations of LaunchDaemons/LaunchAgents

1. _kAHUserLaunchAgent_
   User Launch Agents **~/Library/LaunchAgents**
  loaded by the console user

2. _kAHGlobalLaunchAgent_
  Administrator provided LaunchAgents **/Library/LaunchAgents/**
	loaded by the console user

3. _kAHSystemLaunchAgent_
  Apple provided LaunchDaemons **/System/Library/LaunchAgents/**
 loaded by root user

4. _kAHGlobalLaunchDaemon_
  Administrator provided LaunchAgents **/Library/LaunchDaemons/**
  loaded by root user

5. _kAHSystemLaunchDaemon_
   Apple provided LaunchDaemons **/System/Library/LaunchDaemons/**
 loaded by root user


####Add Job
This will load a job and create the launchd.plist file in the appropriate location.

```objective-c
AHLaunchJob* job = [AHLaunchJob new];
job.Program = @"/bin/echo";
job.Label = @"com.eeaapps.echo";
job.ProgramArguments = @[@"/bin/echo", @"hello world!"];
job.StandardOutPath = @"/tmp/hello.txt";
job.RunAtLoad = YES;
job.StartCalendarInterval = [AHLaunchJobSchedule dailyRunAtHour:2 minute:00];

[[AHLaunchCtl sharedController] add:job
                          toDomain:kAHUserLaunchAgent
                             error:&error];


}];
```

####Remove Job
This will unload a job and remove associated launchd.plist file.
```Objective-C
[[AHLaunchCtl sharedController] remove:@"com.eeaapps.echo"
                           fromDomain:kAHUserLaunchAgent
                                error:&error];
}];
```

####Load Job
Simply load a job, this is good for one off jobs you need executed.
It will not create a launchd file, but it will run the specified launchd job as long as the user in logged in (for LaunchAgents) or until the system is rebooted (LaunchDaemons).
```objective-c
AHLaunchJob* job = [AHLaunchJob new];
...(build the job as you would for adding one)...
[[AHLaunchCtl sharedController] load:job inDomain:kAHGlobalLaunchDaemon error:&error];

```

####Unload Job
Unload a job temporarily, this will not remove the launchd.plist file
```objective-c
[[AHLaunchCtl sharedController] unload:@"com.eeaapps.echo.helloworld"
                             inDomain:kAHGlobalLaunchDaemon
                                error:&error];
```

####Scheduling
To set the StartCalendarInterval key in the job, use the AHLaunchJobSchedule class.

```Objective-c
+ (instancetype)scheduleWithMinute:(NSInteger)minute
                              hour:(NSInteger)hour
                               day:(NSInteger)day
                           weekday:(NSInteger)weekday
                             month:(NSInteger)month
```
_Passing ```AHUndefinedScheduleComponent``` to any of the above parameters will make it behave like a wildcard for that parameter._

**There are also some convenience methods**
```
+ (instancetype)dailyRunAtHour:(NSInteger)hour minute:(NSInteger)minute;
+ (instancetype)weeklyRunOnWeekday:(NSInteger)weekday hour:(NSInteger)hour;
+ (instancetype)monthlyRunOnDay:(NSInteger)day hour:(NSInteger)hour;

```


####Install PrivilegedHelperTool (Uses SMJobBless)
Your helper tool must be properly code signed, and have an embedded Info.plist and Launchd.plist file.**
```objective-c
	NSError *error;
    [AHLaunchCtl installHelper:kYourHelperToolReverseDomain
    					prompt:@"Install Helper?"
   						 error:&error];
    if(error)
    	NSLog(@"error: %@",error);
```

**_See the HelperTool-CodeSign.py script at the root of this repo, for more details, it's extremely helpful for getting the proper certificate name and .plists created._


####There are many more convenience methods; see the AHLaunchCtl.h for what's available.
