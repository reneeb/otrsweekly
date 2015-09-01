package OTRSWeekly::Controller::Guest;

use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
    my $self = shift;

    $self->render;
}

sub archive {
    my $self = shift;

    my $id = shift // $self->param('id');

    $template = 'archive';

    if ( $id ) {
        $self->stash( nlid => $id );
        $template = 'newsletter';
    }

    $self->render( "guest/$template" );
}

sub subscribe {
    my $self = shift;
}

sub unsubscribe {
    my $self = shift;
}

sub confirm {
    my $self = shift;
}

1;
