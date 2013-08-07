#!/usr/bin/perl
use LWP::UserAgent;

my $URL = 'http://news.tvbs.com.tw/todaynews/%04d%%2F%02d%%2F%02d/%d';

my $ua = LWP::UserAgent->new;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
$mon += 1;

my $page = 1;
my $link_count;
do
{
	my $url_list = sprintf $URL, $year, $mon, $mday, $page;
	my $response = $ua->get($url_list);
	die $response->status_line unless $response->is_success;

	my @lines = split(/\n/, $response->decoded_content);

	$link_count = 0;
	foreach my $line (@lines)
	{
		#<a href="/entry/224615">捐腎不能生育？　本土劇誤導挨批</a>
		next unless $line =~ /<h5 class="slogan"><a href="(\/entry\/[^"]+)">(.*)<\/a>/;
		my ($uri, $anchor) = ($1, $2);
		printf "http://news.tvbs.com.tw%s\t%s\n", $uri, $anchor;
		$link_count++;
	}
	$page++;
} while $link_count > 0;
