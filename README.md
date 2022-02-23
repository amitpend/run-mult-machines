# run-mult-machines
Running commands parallelly on multiple machines

This perl script forks multiple processes and each process logs in to different machine and runs the command. The parent process waits for pseudo-process to finish, prints out statistics on the screen and exits.

It also saves the log file of everything printed on the screen.

command_file has contents
  md5sum file1
  
  md5sum file2
  
  md5sum file3
  
  md5sum file4
  
  md5sum file5
  
  
Each command should run on different machine. Thus 'md5sum file1' would run on hdc-001, 'md5sum file2' would run on hdc-002 and so on. The machine name could depend on your center.

It is run like
run_mult_machines.pl command_file
