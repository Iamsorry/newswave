#!/usr/bin/perl
use LWP::UserAgent;

my $URL = 'http://www.chinatimes.com/newspapers/%E4%B8%AD%E5%9C%8B%E6%99%82%E5%A0%B1-%E7%84%A6%E9%BB%9E%E8%A6%81%E8%81%9E-260102?page=';

my $ua = LWP::UserAgent->new;

my $page = 1;
my $link_count;
do
{
	my $response = $ua->get($URL . $page);
	die $response->status_line unless $response->is_success;

	my @lines = split(/\n/, $response->decoded_content);

	$link_count = 0;
	for(my $i = 0; $i <= $#lines; $i++)
	{
		my $line = $lines[$i];
		next unless $line =~ /<a href="(\/newspapers\/[^"]+)" class=".*">/;
		my $uri = $1;
		$line = $lines[++$i];
		$line =~ /^\s+(.*)<\/a>/;
		my $anchor = $1;
		printf "http://www.chinatimes.com%s\t%s\n", $uri, $anchor;
		$link_count++;
	}
	$page++;
} while $link_count > 0;
