package OTRSWeekly;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('guest#welcome');
  $r->post('/subscribe')->to('guest#subscribe');
  $r->get('/unsubscribe')->to('guest#unsubscribe');
  $r->get('/confirm')->to('guest#confirm');

  $r->get('/archive/:id' => { id => 0 } )->to( 'guest#archive' );
  $r->get('/latest' )->to( 'guest#latest' );

  my $admin = $r->under('/admin')->to( 'auth#admin' );
  $admin->get('/')->to( 'admin-newsletter#start' );

  my $article = $admin->under('/article');
  $article->get('/')->to( 'admin-article#start' );
  $article->get('/new/:id' => { id => 0 } )->to( 'admin-article#form' );
  $article->post('/new')->to( 'admin-article#save' );

  my $nl = $admin->under('/newsletter');
  $nl->get('/')->to('admin-newsletter#start');
  $nl->get('/new/:id' => { id => 0 } )->to( 'admin-newsletter#form' );
  $nl->post('/new')->to( 'admin-newsletter#save' );
  $nl->post('/send/:id')->to('admin-newsletter#send');

  my $user = $admin->under('/recipients');
  $user->get('/overview')->to( 'admin-recipients#start' );
  $user->post('/add')->to( 'admin-recipients#add' );
  $user->post('/delete')->to( 'admin-recipients#delete' );
}

1;
