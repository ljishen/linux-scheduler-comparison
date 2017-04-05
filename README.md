# Linux Scheduler Comparison

This work compares the performance and power consumption of 7 different scheduling policies including two real-time policies with 5 benchmark utilities.


## Scheduling Policies

* SCHED_IDLE
* SCHED_OTHER and nice=20
* SCHED_OTHER and nice=-19
* SCHED_FIFO and prio=49
* SCHED_RR and prio=49
* SCHED_RT_FIFO* and prio=49
* SCHED_RT_RR* and prio=49

<sub>* *SCHED_RT_X policy is the policy SCHED_X used in real-time kernel*</sub>


## Benchmarks

| Benchmark         | Introduction                                                                                  |
| -------------     | --------------------------------------------------------------------------------------------- |
| [Latt](http://openbenchmarking.org/test/ljishen/latt)                   | Simple latency tester that combines multiple processes                                             |
| [Hackbench](http://openbenchmarking.org/test/ljishen/hackbench)         | Scheduler stress tester by creating pairs of entities communicate via either sockets or pipes |
| [FFmpeg](http://openbenchmarking.org/test/pts/ffmpeg)                   | Test the systemss audio/video encoding performance                                                 |
| [7-Zip Compression](http://openbenchmarking.org/test/pts/compress-7zip) | A built-in LZMA benchmark                                                                           |
| [John The Ripper](http://openbenchmarking.org/test/pts/john-the-ripper) | A password cracker and performance measured in c/s                                                 |


## Results

### Current Change Example (FFmpeg)
![alt text](https://raw.githubusercontent.com/ljishen/linux-scheduler-comparison/master/images/current_change_ffmpeg.png "Current Change Example (FFmpeg)")

Click [here](https://github.com/ljishen/linux-scheduler-comparison/blob/master/scripts/parser/current/current_change.ipynb) to view more figures.

Full benchmark result [scheduler-comparison](http://openbenchmarking.org/result/1703190-RI-SCHEDULER56) on OpenBenchmarking.org

The [paper](https://drive.google.com/file/d/0B9Q3i4Vp4rm2SEZjcUIzY3FLczA/view?usp=sharing) for this project.


## References

 * Molnar, Ingo. "[CFS scheduler.](https://www.kernel.org/doc/Documentation/scheduler/sched-design-CFS.txt)" Linux. Vol. 2. 2007.
 * Jones, M. Tim. "[Inside the linux 2.6 completely fair scheduler.](https://www.ibm.com/developerworks/library/l-completely-fair-scheduler/)" IBM Developer Works Technical Report 2009 (2009).
 * [sched - overview of CPU scheduling](http://man7.org/linux/man-pages/man7/sched.7.html)
