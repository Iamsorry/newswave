#!/usr/bin/perl
#binmode STDOUT, ":utf8";
use warnings;
use strict;

my $INTDIR = 'int';
my $MAXRANK = 2;
my $MINCOUNT = 2;

opendir(DH, $INTDIR) || die "failed to open $INTDIR: $!";
my @files = sort {$a cmp $b} grep {/^\d+\.list$/} readdir(DH);
closedir(DH);

my %lists;
my %topdict;
foreach my $file (@files)
{
	next unless open(FH, "<", "$INTDIR/$file");

	my $dict = ();
	my $totalcount = 0;
	my $linenum = 1;
	while(my $line = <FH>)
	{
		chomp($line);
		my ($token, $count) = split(/\t/, $line);
		next unless $count > $MINCOUNT;
		if($linenum <= $MAXRANK)
		{
			$topdict{$token} = $file;
		}
		$dict->{$token} = $count;
		$totalcount += $count;
		$linenum += 1;
	}

	close(FH);

	foreach my $token (keys $dict)
	{
		$dict->{$token} = $dict->{$token} * 1000 / $totalcount;
	}

	#my $list = ();
	#$list->{dict} = $dict;
	#$lists{$file} = $list;
	$lists{$file} = $dict;
}

my @tops = keys %topdict;
print "date,", join(',', @tops), "\n";
foreach my $file (@files)
{
	$file =~ /(\d{4})(\d{2})(\d{2})/;
	print "$1/$2/$3";
	foreach my $token (@tops)
	{
		my $count = 0;
		$count = $lists{$file}->{$token} if defined $lists{$file}->{$token};
		printf(",%d", $count);
	}
	print "\n";
}
