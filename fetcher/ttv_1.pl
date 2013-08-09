#!/usr/bin/perl
use LWP::UserAgent;

my $URL = 'http://www.ttv.com.tw/RSS/RSSHandler.ashx?d=news';

my $ua = LWP::UserAgent->new;
my $response = $ua->get($URL);
die $response->status_line unless $response->is_success;

my @lines = split(/\n/, $response->decoded_content);

my ($title, $link);
foreach my $line (@lines)
{
	if($line =~ /<title>(.*)<\/title>/)
	{
		$title = $1;
	}
	elsif($line =~ /<link>(.*)<\/link>/)
	{
		$link = $1;
	}
	elsif($line =~ /<\/item>/)
	{
		printf "%s\t%s\n", $link, $title;
	}
}
