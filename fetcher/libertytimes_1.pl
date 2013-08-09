#!/usr/bin/perl
use LWP::UserAgent;

my $URL = 'http://iservice.libertytimes.com.tw/IService3/TodayNews.php';

my $ua = LWP::UserAgent->new;
my $response = $ua->get($URL);
die $response->status_line unless $response->is_success;

my @lines = split(/(\n|<br>|<\/li>|<\/dd>)/, $response->decoded_content);

foreach my $line (@lines)
{
	next unless $line =~ /<a href="(http:\/\/www\.libertytimes\.com\.tw\/[^"]+)".*title="([^"]*)"[^>]*>.*<\/a>/;
	my ($url, $title) = ($1, $2);
	printf "%s\t%s\n", $url, $title;
}
