use strict;
use warnings;
use Test::More;

use MooX::Cmd::Tester;

use FindBin qw($Bin);
use lib "$Bin/lib";

use FirstTestApp;
use SecondTestApp;
use ThirdTestApp;
use FailTestApp;

my @tests = (
        [ 'test', [ "FirstTestApp::Cmd::Test", [], [ "FirstTestApp" ] ] ],
        [ 'test test', [ "FirstTestApp::Cmd::Test::Cmd::Test", [], [ "FirstTestApp","FirstTestApp::Cmd::Test" ] ] ],
        [ 'test this', [ "FirstTestApp::Cmd::Test", [ "this" ], [ "FirstTestApp" ] ] ],
        [ 'this test test this', [ "FirstTestApp::Cmd::Test::Cmd::Test", [ "this" ], [ "FirstTestApp","FirstTestApp::Cmd::Test" ] ] ],
        [ 'test this test', [ "FirstTestApp::Cmd::Test::Cmd::Test", [], [ "FirstTestApp","FirstTestApp::Cmd::Test" ] ] ],
        [ 'ifc', [ "SecondTestApp::Cmd::ifc", [], [ "SecondTestApp" ] ] ],
        [ 'cwo', [ "SecondTestApp::Cmd::cwo", [], [ "SecondTestApp" ] ] ],
);

for (@tests) {
        my ( $args, $result ) = @{$_};
        ref $args or $args = [split(' ', $args)];
        my $rv = test_cmd_ok( $result->[2]->[0] => $args );
        # my $app = FirstTestApp->new_with_cmd;
        # isa_ok($app,'FirstTestApp');
        #my @execute_return = @{$app->execute_return};
        "ARRAY" eq ref $rv->execute_rv or diag(explain($rv));
        my @execute_return = @{$rv->execute_rv};
        my @moox_cmd_chain = map { ref $_ } @{$execute_return[2]};
        push @{$result->[2]}, $result->[0];
        my $execute_result = [ref $execute_return[0],$execute_return[1],\@moox_cmd_chain];
        is_deeply($execute_result,$result,'Checking result of "'.join(" ", @$args).'"');
}

...

done_testing;
