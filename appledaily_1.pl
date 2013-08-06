#!/usr/bin/perl
use LWP::UserAgent;

my $URL = 'http://www.appledaily.com.tw/appledaily/todayapple';

my $ua = LWP::UserAgent->new;
my $response = $ua->get($URL);
die $response->status_line unless $response->is_success;

my @lines = split(/\n/, $response->decoded_content);

foreach my $line (@lines)
{
	next unless $line =~ /<a href="(\/appledaily\/article\/headline\/\d+\/\d+\/)[^"]*" title="[^"]*">([^<*]*)<\/a>/;
	my ($uri, $anchor) = ($1, $2);
	printf "http://www.appledaily.com.tw%s\t%s\n", $uri, $anchor;
}
