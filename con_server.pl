#!/usr/bin/perl 

#****************************************************************#
#********                 Stanley Vossler                ********#
#********                 Class: COP 4342                ********#
#********               Assigment 5: Part 2              ********#
#********             Due: November 13, 2021             ********#
#****************************************************************#

# echo server
# use port number and text file containing password/username credentials

use strict;
use warnings;
use IO::Socket;

my @credentials; # array that of username/password credentials that are sorted into a hash.
my %credentials_hash; # hash that assigns username as key and password as value.
my $key = 0; # index used in sorting algorithm for username.
my $value = 1; # ^, password index
my $i = 0; # iterator used in sorting algorithm.
my $port = $ARGV[0]; # 1st parameter passed from command line, 
my $file_name = $ARGV[1]; # 2nd parameter passed from command line, the filename that contains credentials.

my $socket = IO::Socket::INET->new
(
        LocalPort       => $port,
        Proto           => 'tcp',
        Listen          => 5
);

open my $FH, '<', $file_name or die "can't open file : $_";

while(my $line = <$FH>)
{
        my @temp = split/\s/, $line;
	push (@credentials, @temp);
}

while ( $i < scalar(@credentials) )
{	

	$credentials_hash{$credentials[$key]} = $credentials[$value];
	$i++;
	$key+=2;
	$value += 2;

}

my @array = %credentials_hash;

while ( my $con_socket = $socket->accept() ) 
{
	print "Connection established\n";
	my $pid = fork();
	if ($pid == 0)
	{
   		# child process

		my $msg;
		my $username = "";
		my $password = "";
		$con_socket->recv($username, 1024);
		$con_socket->recv($password, 1024);		
		
		# print "\nThe username given: $username\n";
				
		while (my ($key, $value)= each %credentials_hash)
		{	
			if ( $username eq $key )
			{
				if ( $password eq $value )
				{
					$password = 1;
					$con_socket->send($password);
				}
				else
				{
					$password = 0;
					$con_socket->send($password);
				}	
			}
			#else
			#{ this part of program did not function properly.
			#	$password = 0;
			#	$con_socket->send($password);
			#} 
		}
		
		# print "The password given: $password\n";
		
		while (defined($msg = <$con_socket>))
                {
			
                        my $command = `$msg`;
                        print $con_socket $command;

                }
		exit(0);
   	} 
   	else 
   	{	
   		# parent process
   		close $con_socket;
		
	}
}
