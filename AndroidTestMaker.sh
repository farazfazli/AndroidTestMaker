printf "Enter a command or test name (SlidingTest/create/run): "
read -r testname

if [ $testname == "create" ]; then
	adb shell getevent | grep --line-buffered ^/ | tee touch-events.sh
	exit 0
fi

if [ $testname == "run" ]; then
	adb shell ls /sdcard/AndroidTestMaker
	printf "Enter a test to run (TestName): "
	read -r testfile
	clear
	adb shell sh /sdcard/AndroidTestMaker/$testfile.sh
	exit 0
fi

printf "User story: "
read -r userstory
printf "App filter (enter for default): "
read -r filter
if [ -z "$filter" ]; then
	filter=contap
fi
gawk '{printf "%s %d %d %d\n", substr($1, 1, length($1) -1), strtonum("0x"$2), strtonum("0x"$3), strtonum("0x"$4)}' touch-events.sh > touch-events-new.sh
sed -i -e 's/^/sendevent /' touch-events-new.sh
sed '/0 0 0/ a\
sleep 0\
' touch-events-new.sh > test1.sh
{ printf "echo $testname\n"; printf "echo $userstory\n";cat test1.sh; } > test2.sh
rm test1.sh
mv test2.sh $testname.sh
nohup adb shell logcat '*:E' | grep $filter >> $testname.txt &
clear
adb push -p $testname.sh /sdcard/AndroidTestMaker/$testname.sh
adb shell sh /sdcard/AndroidTestMaker/$testname.sh
adb shell screencap /sdcard/AndroidTestMaker/$testname.png
adb pull /sdcard/AndroidTestMaker/$testname.png
kill $!
wait $! 2>/dev/null
crashtext=`wc -m $testname.txt | awk '{print $1}'`

if [ $crashtext -eq 0 ]; then
	echo "[PASS]"
	echo "See $testname.png and $testname.txt"
else
	echo "[FAIL]"
	open $testname.png
	open $testname.txt
fi
