# odroidc2-3.14.y-rt
This is meant to ease the process of building the real-time kernel v3.14 for the odroidc2.

Based on the work of moon.linux (http://forum.odroid.com/viewtopic.php?f=136&t=23052).

Simply run the build.sh script.

After the system reboots, test the build with the following:

----
root@odroid64:~# uname -a
Linux odroid64 3.14.65-rt68-xhkc2rtn #3 SMP PREEMPT RT Thu Aug 11 11:27:14 EDT 2016 aarch64 aarch64 aarch64 GNU/Linux
root@odroid64:~#
root@odroid64:~# cat /sys/kernel/realtime
1
root@odroid64:~#

----
