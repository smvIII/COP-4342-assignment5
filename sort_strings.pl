#!/usr/bin/perl

#****************************************************************#
#********                 Stanley Vossler                ********#
#********                 Class: COP 4342                ********#
#********               Assigment 5: Part 1              ********#
#********             Due: November 13, 2021             ********#
#****************************************************************#

use strict;
use warnings;

my $file_name = $ARGV[0];
my @word_arr; #array of words from .input file
my @vow_arr; #initially holds vowels but then are translated into numbers
my %word_hash; #hash where the words are the keys filled with vowel values

my $highest; #highest value vowel string
my $tens = 10; #to find how many digits to add to a vowel string this variable is used to compare its current value with that vowel string.
my $tensplace = 1; #how many tens place 
my $extra_digits = 0; #determined by subtracting itself from n
my $n = 1; #the number of digits of the highest value vowel string.
my $j = 0; #a iterator used in a while loop.

open my $FH, '<', $file_name or die "can't open file : $_";

while(my $line = <$FH>)
{
        my @words = split/\n/, $line;
        push(@word_arr, @words);
}

@vow_arr = @word_arr;
%word_hash = @word_arr;
tr/bcdfghjklmnpqrstvwxyz//d for (@vow_arr);
#deletes all consonants from every element in the array.
#my @cp_vow_arr = @vow_arr;

tr/aeiou/54321/ for (@vow_arr);
#the vowel strings are translated into the numbers respectively

$highest = $vow_arr[0];


for my $i (@vow_arr)
{
	if ( $i > $highest )
	{
		$highest = $i;
	}
}

while ( $highest >= $tens )
{
	$tens = $tens * 10;
	$n++;
}

$tens = 10;

for my $i (@vow_arr)
{ #nested loop goes through all vowel values and adds extra numbers for proper sorting
	while ( $j < scalar(@word_arr) ) 
	{
		while ( $i >= $tens )
		{	 
			$tens = $tens * 10;
			$tensplace++;
    		}
    		$extra_digits = $n - $tensplace;
		while ( $extra_digits != 0 )
			{				
				$i = $i . 6;
				$extra_digits--;
			}
	$word_hash{$word_arr[$j]} = $i; #assigns correct element to the proper key
	last;
	}
	
    	$j++;
	#reset all variables for next element
   	$tens = 10; 
	$tensplace = 1;
	$extra_digits = 0;
}

foreach my $i ( sort { $word_hash{$b} <=> $word_hash{$a} } keys %word_hash )
{ 
	print "$i\n";
}
