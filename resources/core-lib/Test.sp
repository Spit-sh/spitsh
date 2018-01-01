# basic assertions to be used outside of test files
my $TEST_COUNT = 0;
my $TEST_PLAN = 0;
sub plan(Int $n) is export  {
    $TEST_PLAN = $n;
    say "1..$n";
}

sub ok (Bool $res,$msg?) is export {
    $res
        ?? say "ok {++$TEST_COUNT} - $msg"
        !! say "not ok {++$TEST_COUNT} - $msg";
}

sub is  ($got ,$expected, $msg?) is export {
    $got eq $expected
        ?? say "ok {++$TEST_COUNT} - $msg"
        !! say "not ok {++$TEST_COUNT} - $msg. Expected '$expected' but got '$got'";
}

sub nok (Bool $res,$msg?) is export { ok !$res,$msg }
sub pass ($msg?) is export          { ok True,$msg  }
sub flunk ($msg?) is export         { ok False,$msg }

sub skip-rest($reason?) is export {
    while ++$TEST_COUNT <= $TEST_PLAN  {
        say "ok $TEST_COUNT - # SKIP $reason";
    }
}

sub skip($reason,Int $count) is export {
    for 1..$count {
        say "ok {++$TEST_COUNT} - # SKIP $reason";
    }
}
