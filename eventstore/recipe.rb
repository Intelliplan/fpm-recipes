class EventStore < FPM::Cookery::Recipe
  description 'The open-source, functional database with Complex Event Processing in JavaScript.'
  homepage    'http://geteventstore.com/'

  name        'eventstore'
  version     '3.0.0'
  revision    1
  arch        'noarch'
  section     'databases'

  source      'http://download.geteventstore.com/binaries/EventStore-OSS-Linux-v3.0.0.tar.gz', :quiet => true
  sha1        '8616b3a4342c30ba3434359106ac0bfb5df2c956'

  maintainer  'Henrik Feldt <henrik@haf.se>'

  depends     'mono'

  def build
    # just to unzip!
  end

  def install
    (opt/'eventstore').mkdir
    opt('eventstore').install Dir['**/*']
  end
end
