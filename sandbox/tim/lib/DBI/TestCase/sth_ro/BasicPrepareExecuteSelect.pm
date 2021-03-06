package DBI::TestCase::sth_ro::BasicPrepareExecuteSelect;

# Test the basic prepare + execute + fetchrow sequence
# of a valid select statement that returns 1 row.
#
# Other tests needed (just noting here for reference):
# select returning 0 rows
# select with syntax error (may be detected at prepare or execute)
# all fetch* methods
#
# Need to consider structure and naming conventions for test modules.
# Need to consider a library of test subroutines

use Test::Most;
use DBI::Test::CheckUtil;
use base 'DBI::Test::CaseBase';



sub basic_prepare_execute_select_ro {
    my $self = shift;

    my $fx = $self->fixture_provider->get_ro_stmt_select_1r2c_si;
    # XXX this needs to be abstracted
    return warn "aborting: no get_ro_stmt_select_1r2c_si fixture"
        unless $fx;

    my $sth = $self->dbh->prepare($fx->statement);
    sth_ok $sth
        or return warn "aborting subtest after prepare failed";
    h_no_err $sth;

    note "testing attributes for select sth prior to execute";
    # specific prepared sth attributes
    TODO: {
        local $TODO = "issues with pureperl - fixed in DBI 1.632";
    ok !$sth->{Active}, 'should not be Active before execute is called';
    }
    ok !$sth->{Executed};

    # generic sth attributes
    is $sth->{Type}, 'st';

    # generic attributes
    ok $sth->{Warn};
    is $sth->{Kids}, 0;


    ok $sth->execute;
    h_no_err $sth;

    note "testing attributes for select sth after execute";
    # specific attributes
    TODO: {
        local $TODO = "issues with gofer TBD";
    ok $sth->{Active}, 'should be Active if rows are fetchable';
    }
    ok $sth->{Executed};
    is $sth->{Kids}, 0;

    # generic attributes
    ok $sth->{Warn};
}


sub get_subtest_method_names {
    return qw(basic_prepare_execute_select_ro);
}

1;
