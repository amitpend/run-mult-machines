# run-mult-machines
Running commands parallelly on multiple machines

#### Introduction
This perl script forks multiple processes and each process logs in to different machine and runs the command. The parent process waits for pseudo-process to finish, prints out statistics on the screen and exits.

It also saves the log file of everything printed on the screen.

'command_file' has contents 
```
  md5sum file1  
  md5sum file2  
  md5sum file3  
  md5sum file4  
  md5sum file5  
``` 
Each command should run on different machine. Thus 'md5sum file1' should run on hdc001-001, 'md5sum file2' should run on hdc001-002 and so on. The machine name can be changed depending on your center.

To run each command from command_file on different machine, simply run \
```
run_mult_machines.pl command_file
```
This will run each line from 'command_file' on different machine. The parent process will wait for each pseudo-process to finish. It will then print the statistics in the log file 'command_file_log'

#### Detailed Explanation
https://medium.com/@amitpen/running-commands-parallelly-on-multiple-machines-85266fea5914
