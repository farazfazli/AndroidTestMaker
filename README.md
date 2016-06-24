# AndroidTestMaker
Automated Android Blackbox Testing. Save a dump of kernel input events, and replay them. Tests are saved on the device, so you can run them later.


## To record a test
```
./AndroidTestMaker.sh
Enter a command or test name (SlidingTest/create/run): TestNameHere
```

## To transfer a recorded test and run it
First press CTRL-C to stop recording touch input
Go back to the initial screen
```
./AndroidTestMaker.sh
Enter a command or test name (SlidingTest/create/run): create
```

## To run an existing test available on the device
```
./AndroidTestMaker.sh
Enter a command or test name (SlidingTest/create/run): run
# list of test files here
Enter a test to run (TestName): EnterNameOfTestFromList
```

If a test succeeds, Terminal will say "[PASS]", otherwise Terminal will say "[FAIL]" and open up crash log. Edit "default" in ./AndroidTestMaker.sh to make test creation faster, as otherwise you'll have to enter the package name each time. The way it works is that it reads log files and searches for the package name of the app you're testing.

Released under the GNU GPLv2 license. Open an issue if you have any questions or need help, fork & submit a PR if you can make any improvements.
