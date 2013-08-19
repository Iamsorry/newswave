#!/usr/bin/perl
#binmode STDOUT, ":utf8";
use warnings;
use strict;

my $RAWDIR = 'raw';
my $INTDIR = 'int';

mkdir $RAWDIR unless -d $RAWDIR;
mkdir $INTDIR unless -d $INTDIR;

# fetch all
my @sites = (
	'appledaily',
	'chinatimes',
	'cna',
	'cti',
	'ftv',
	'libertytimes',
	'nownews',
	'pts',
	'ttv',
	'tvbs',
	'udn',
);

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $TODAYSTR = sprintf "%04d%02d%02d", $year + 1900, $mon + 1, $mday;

# fetch if not exist today
if(not -e get_rawname($RAWDIR, $sites[0], $TODAYSTR))
{
	foreach my $site (@sites)
	{
		my $tmpfile = get_rawname($RAWDIR, $site, $TODAYSTR);
		my $cmd = sprintf "fetcher/%s_1.pl > %s", $site, $tmpfile;
		system($cmd);
	}
}

# process one by one
my %tokencnt;
foreach my $site (@sites)
{
	my $tmpfile = get_rawname($RAWDIR, $site, $TODAYSTR);
	next unless open(FH, "<:encoding(UTF-8)", $tmpfile);
	my @lines = <FH>;
	close(FH);
	foreach my $line (@lines)
	{
		chomp($line);
		my ($url, $title) = split(/\t/, $line);
		my @tokens = tokenize($title);
		foreach my $token (@tokens)
		{
			$tokencnt{$token}++;
		}
	}
}

# output to a file
my $result = get_intname($INTDIR, $TODAYSTR);
open(FH, ">", $result) or die "failed to open $result: $!\n";
my @ranking = sort {$tokencnt{$b} <=> $tokencnt{$a}} keys %tokencnt;
foreach my $token (@ranking)
{
	printf(FH "%s\t%s\n", $token, $tokencnt{$token});
}
close(FH);

exit;

sub get_rawname
{
	my ($RAWDIR, $site, $timestr) = @_;
	return "$RAWDIR/$site.$timestr.list";
}

sub get_intname
{
	my ($INTDIR, $timestr) = @_;
	return "$INTDIR/$timestr.list";
}

sub tokenize
{
	my $title = shift;
	my @tokens;
	my @chars = split(//, $title);
	for(my $i = 0; $i < scalar(@chars) - 1; $i++)
	{
		my $token = $chars[$i] . $chars[$i+1];
		if($token ne "..")
		{
			push(@tokens, $token);
		}
	}
	return @tokens;
}
