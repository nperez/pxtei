{package POEx::Trait::ExtraInitialization;}

#ABSTRACT: Provides a initialization behaviors for POEx::Role::SessionInstantiation objects

use MooseX::Declare;

role POEx::Trait::ExtraInitialization
{
    with 'POEx::Role::SessionInstantiation::Meta::Session::Events';
    use MooseX::Types::Moose('CodeRef');

=attr initialization_method is: ro, isa: CodeRef, required: 1

This attribute stores the code ref that will be called as method on the
composed class.

=cut

    has initialization_method => ( is => 'ro', isa => CodeRef, required => 1 );

=method after _start

_start is advised to run the initialization method during the 'after' phase.
The method receives no arguments other than the invocant

=cut

    after _start
    {
        $self->${\$self->initialization_method}();
    }
}

1;
__END__

=head1 SYNOPSIS

    class My::Session
    {
        use POEx::Trait::ExtraInitialization;
        use POEx::Role::SessionInstantiation
            traits => [ 'POEx::Trait::ExtraInitialization' ];

        with 'POEx::Role::SessionInstantiation';

        ....
    }

    My::Session->new(initialization_method => $some_external_coderef);

    POE::Kernel->run();

=head1 DESCRIPTION

POEx::Trait::ExtraInitialization is a simple trait for SessionInstantiation to
enable passing in an arbitrary coderef for execution just after other
normal initialization

This role could also be applied upon an instance but there are some caveats. 
Your class must also consume POEx::Trait::DeferredRegistration, which will 
prevent instances from immediately being registered with POE after BUILD. 
Otherwise, _start has already been fired, and too late for extra 
initialization to execute (BUILD is advised by SessionInstantiate to do Session
allocation within POE which immediately calls _start).

