#!/usr/bin/perl

#****************************************************************#
#********                 Stanley Vossler                ********#
#********                 Class: COP 4342                ********#
#********               Assigment 5: Part 2              ********#
#********             Due: November 13, 2021             ********#
#****************************************************************#

# echo client
# user server and port number

use strict;
use warnings;
use IO::Socket;

@ARGV == 2 || die "Usage: $0 server port\n";
my ($server, $port) = @ARGV;
my $username;
my $password;

print "$server $port\n";

my $socket = IO::Socket::INET->new
(
	PeerAddr	=> $server,
	PeerPort 	=> $port,
	Proto		=> 'tcp'
);

die "socket: $!\n" unless defined($socket);

#$socket->autoflush(1);

print "Username: ";
$username = <STDIN>;
chomp $username;
$socket->send($username);

print "Password: ";
system ("stty -echo");
$password = <STDIN>;
system("stty echo");
chomp $password;
$socket->send($password);

my $password_response;
$socket->recv($password_response, 1);

if ( $password_response == 1)
{
	print "\nPassword is OK\n";
	print "MSG TO SERVER: ";
	my $msg = <STDIN>;
	print $socket $msg;
	print "MSG FROM SERVER: ";
	while (<$socket>)
	{
		print "$_";
	}
}
else
{
	print "Password or username is incorrect, the client will now close.\n";
	$socket->close();
}
