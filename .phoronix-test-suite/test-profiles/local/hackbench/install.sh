#!/bin/sh

tar -xvf rt-tests_1.0.orig.tar.xz
cd rt-tests-1.0/src/hackbench
gcc -g -Wall -O2 -o hackbench hackbench.c -lpthread
echo $? > ~/install-exit-status

cd ~
echo "#!/bin/sh
./rt-tests-1.0/src/hackbench/hackbench -s 512 -l 200 -g 15 -f 25 -P > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > hackbench
chmod +x hackbench
