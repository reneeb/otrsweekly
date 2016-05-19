#!/usr/bin/perl

use strict;
use warnings;

use XML::RSS;
use Time::Piece;
use Path::Tiny;

my $rss      = XML::RSS->new( version => '1.0' );
my $now      = localtime;
my $base_dir = path( __FILE__ )->parent(2)->stringify;
my $base_url = 'http://otrsweekly.info/';

$rss->channel(
    title        => 'OTRS Weekly',
    link         => $base_url,
    description  => 'weekly news about OTRS and addons',
    dc => {
        date       => ( sprintf "%sT%s", $now->ymd, $now->hms ),
        subject    => 'otrsweekly.info',
        creator    => 'otrsweekly.info',
        publisher  => 'otrsweekly.info',
        rights     => 'Copyright ' . $now->year . ', otrsweekly.info',
        language   => 'en-EN',
    },
    syn => {
        updatePeriod     => 'weekly',
        updateFrequency  => 1,
        updateBase       => '1901-01-01T00:00+00:00',
    },
);

my @files = path( $base_dir . '/markdown/' )->children( qr/\.md$/ );

for my $file ( sort{ $b->basename cmp $a->basename }@files ) {
    my $content = $file->slurp_utf8;

    my ($title)   = $content =~ m{^Title: \s+ (.*?) $}xms; 
    my ($author)  = $content =~ m{^Editor: \s+ (.*?) $}xms; 
    my $path_info = $file->basename( '.md' );

    $rss->add_item(
        title       => $title,
        link        => $base_url . '/' . $path_info,
        description => $title,
        dc => {
            subject  => $title,
            creator  => $author,
        },
    );
}

$rss->save( path( $base_dir . '/public/rss/rss.xml' )->stringify ); 
