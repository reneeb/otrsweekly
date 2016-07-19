#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Time::Piece;
use Path::Tiny;

my $week = $ARGV[0];

if ( !$week ) {
    my $now  = localtime;
    $now += 7 * 24 * 60 * 60;
    $week = sprintf "%04d-%02d", $now->year, $now->week;
}

if ( $week !~ m{\A[0-9]{4}-[0-9]{2}\z} ) {
    die "invalid week: $week!";
}

# create file in drafts directory
my $content;
{
    local $/;
    $content = <DATA>;
}

my $base_dir = path( __FILE__ )->parent(2)->stringify;
path( $base_dir . '/drafts/' . $week . '.md' )->touchpath->spew_utf8( $content );

__DATA__
Date: # TODO
Editor: Renée Bäcker
Title: # TODO


#TODO: Intro

If you find anything that
might fit in this weekly newsletter, please drop me a line at

`hints@otrsweekly.info`

If you want to join me editing this newsletter, please drop me a line at

`help@otrsweekly.info`

Let's start with the news

<hr>

# Announcements

<hr>

# Events

<hr>

# Blogposts

<hr>

# Interesting Otterhub threads

<hr>

# Addon updates

## New OPAR addons

## New commercial addons
