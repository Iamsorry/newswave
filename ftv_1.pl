#!/usr/bin/perl
use LWP::UserAgent;

my $URL = 'http://news.ftv.com.tw/NewsIframe.aspx';

my $ua = LWP::UserAgent->new;
my $response = $ua->get($URL);
die $response->status_line unless $response->is_success;

my @lines = split(/\n/, $response->decoded_content);

foreach my $line (@lines)
{
	#<a href="NewsContent.aspx?ntype=class&amp;sno=2013807L04M1" target="_parent">狂犬病延燒 學者疑誤判病毒來源</a>
	next unless $line =~ /<a href="(NewsContent.aspx[^"]+)" target="_parent">(.*)<\/a>/;
	my ($uri, $anchor) = ($1, $2);
	$uri =~ s/&amp;/&/g;
	printf "http://news.ftv.com.tw/%s\t%s\n", $uri, $anchor;
}