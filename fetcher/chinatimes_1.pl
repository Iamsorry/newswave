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
	foreach my $line (@lines)
	{
		next unless $line =~ /<a href="(\/newspapers\/)(.*)(-\d+-\d+)" class=".*">/;
		my ($uri1, $anchor, $uri2) = ($1, $2, $3);
		printf "http://www.chinatimes.com%s0%s\t%s\n", $uri1, $uri2, $anchor;
		$link_count++;
	}
	$page++;
} while $link_count > 0;
