#!/usr/bin/perl

use POSIX;

$num_args = $#ARGV + 1;
my @processids;

$parts = 72;

$hostname="hdc";
$hostnum = "1";
$username="amitpend";

if ($num_args != 1)
{
    print "\nThe format is \n\n\taprunmultmachines script_name \n\n"; 
    exit;
}

$lines = `wc $ARGV[0] | awk '{print $1}'`;
$eachpart = int($lines/$parts + 1);
$parts = ceil($lines/$eachpart);

$cmdlg = "mv $ARGV[0]_log $ARGV[0]_log~ 2>/dev/null\n";
$cmd1  = "cat $ARGV[0] > $ARGV[0]_log \n";
$cmd2  = "echo \"\n\n-------------------------- Log Starts ----------`date`----------------\n\" >> $ARGV[0]_log;";
$cmd3  = "echo \"\n\n-------------------------- Log Ends ----------`date`----------------\n\" >> $ARGV[0]_log;";

system($cmdlg); system($cmd1); system($cmd2);
$time1=`date +%s`;

my $logfile = "$ARGV[0]_log";

open(my $fh, '>>', $logfile) or die "Could not open file '$logfile'";

printf ("\nRunning script parallely....\n\n");
printf $fh "Running script parallely....\n\n";

foreach $part (1 .. $parts)
{
    $nodenum = (($part-1) % 72) + 1;
    $machnum = int(($part-1)/72);
    $machine = sprintf("%s%03s-%03s",$hostname,$hostnum + $machnum, $nodenum);
    printf("Logging in ..... %s\n",$machine);
    printf $fh "Logging in ..... %s\n",$machine;

    $low = ($part-1) * $eachpart+1;
    $high = ($part) * $eachpart;
    $cmd = "";
    for (my $i=$low; $i <= $high; $i++)
    {
        $tmpcmd = `sed -n "${i},${i}p" $ARGV[0]`;
        chomp($tmpcmd);
        $cmd = $cmd . $tmpcmd . ' 2>&1 ' . "\n";
    }

    $cmd = "cd " . `pwd` . $cmd;

    print $cmd;
    print $fh $cmd;

    if (defined ($pid = fork))
    {
        if ($pid)
        { #parent    printf ("\nRunning \n%s",$pid);
            push @processids, $pid;
        }
        else
        { #child
            $cmdrsh  = "rsh $machine \"$cmd\"";
            @output = qx($cmdrsh);#rsh $machine $cmd);

            print @output;
            print $fh @output;
            printf ("\n\tDone. Ran %4d to %4d = %3d commands on %s..\n",$low,$high,$high-$low+1,$machine);
            printf $fh "\n\tDone. Ran %4d to %4d = %3d commands on %s..\n",$low,$high,$high-$low+1,$machine;
            exit;
        }
    }
}


for my $pid (@processids)
{
    waitpid $pid, 0;
}

printf ("\nDone. No of scripts run:  %2d\n\n",$num_args);
printf $fh "\nDone. No of scripts run:  %2d\n\n",$num_args;

$time2=`date +%s`; 

$diff = $time2 - $time1;
$hours = int($diff/3600); $minutes = int(($diff%3600)/60); $seconds = $diff%60;
printf ("\nTotal run time: $hours hours $minutes minutes $seconds seconds\n\n");
printf $fh "\nTotal run time: $hours hours $minutes minutes $seconds seconds\n";

close ($fh);

system($cmd3); 
