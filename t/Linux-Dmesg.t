use strict;
use warnings;

use Test::More tests => 24;
BEGIN { use_ok('Linux::Dmesg', ':all') };

my $dmesg = dmesg();
is($!, '', 'dmesg allowed');
isnt ($dmesg, undef);

my $raw = read_buffer();
isnt($dmesg, $raw, 'read_buffer');

if ($< == 0) {
    test_as_root();
} else {
    test_not_root();
}
printf STDERR "Buffer Size: %d\n", buffer_size();

is (KERN_EMERG,   0, 'KERN_EMERG');
is (KERN_ALERT,   1, 'KERN_ALERT');
is (KERN_CRIT,    2, 'KERN_CRIT');
is (KERN_ERR,     3, 'KERN_ERR');
is (KERN_WARNING, 4, 'KERN_WARNING');
is (KERN_NOTICE,  5, 'KERN_NOTICE');
is (KERN_INFO,    6, 'KERN_INFO');
is (KERN_DEBUG,   7, 'KERN_DEBUG');


sub test_not_root {
    $! = 0;
    is(clear_buffer(), -1, 'clear_buffer');
    is($!, 'Operation not permitted');

    $! = 0;
    is(disable_printk(), -1, 'disable_printk');
    is($!, 'Operation not permitted');

    $! = 0;
    is(enable_printk(), -1, 'enable_printk');
    is($!, 'Operation not permitted');

    $! = 0;
    is(printk_level(KERN_NOTICE), -1, 'printk_level');
    is($!, 'Operation not permitted');

    $! = 0;
    is(unread_count(), -1, 'unread_count');
    is($!, 'Operation not permitted');

    $! = 0;
    isnt(buffer_size(), 0, 'buffer_size');
    is($!, '');
}


sub test_as_root {
    $! = 0;
    is(clear_buffer(), 0, 'clear_buffer');
    is($!, '');

    is(disable_printk(), 0, 'disable_printk');
    is($!, '');

    is(enable_printk(), 0, 'enable_printk');
    is($!, '');

    is(printk_level(KERN_DEBUG), 0, 'printk_level');
    is($!, '');

    isnt(unread_count(), 0, 'unread_count');
    is($!, '');

    isnt(buffer_size(), 0, 'buffer_size');
    is($!, '');
}
