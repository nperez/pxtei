use Test::More;
use MooseX::Declare;
use POE;

use POEx::Trait::ExtraInitialization;
use POEx::Role::SessionInstantiation
    traits => [ 'POEx::Trait::ExtraInitialization' ];


my $sub = sub
{
    pass('Our extra init was fired');
    isa_ok(shift, 'My::Session', 'Got the right self');
};

class My::Session
{
    with 'POEx::Role::SessionInstantiation';
}

My::Session->new(initialization_method => $sub, options => { trace => 1 });
POE::Kernel->run();
done_testing();
1;
