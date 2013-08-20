#!/usr/bin/perl
use LWP::UserAgent;

my $URL = 'http://news.ftv.com.tw/';

my $ua = LWP::UserAgent->new;
my $response = $ua->get($URL);
die $response->status_line unless $response->is_success;

my @lines = split(/\n/, $response->decoded_content);

foreach my $line (@lines)
{
	next unless $line =~ /<li><a href="(NewsContent\.aspx\?[^"]+)">(.*)<\/a><\/li>/;
	my ($uri, $anchor) = ($1, $2);
	printf "http://news.ftv.com.tw/%s\t%s\n", $uri, $anchor;
}
