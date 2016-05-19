#!/usr/bin/perl

use strict;
use warnings;

use Path::Tiny;

my $base_dir = path( __FILE__ )->parent(2)->stringify;
my $archive  = path( $base_dir . '/doc/archive.html' );
my $iter     = path( $base_dir . '/markdown' )->iterator;

my @files;
while ( my $file = $iter->() ) {
    if ( $file->basename =~ m{\A[0-9]{4}-[0-9]{2}\.md\z} ) {
        push @files, $file;
    }
}

my @archive;

FILE:
for my $file ( sort { $b->basename cmp $a->basename } @files ) {
    my $content = $file->slurp_utf8;
    my ($title) = $content =~ m{ ^ Title: \s+ (.*?) $ }xms;

    my ($week) = $file->basename('.md');
    push @archive, sprintf q~<li><a href="/%s">%s - %s</a></li>~, $week, $week, $title;
}

$archive->spew_utf8( '<ol>', @archive, '</ol>' );
