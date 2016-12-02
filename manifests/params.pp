class logrotate::params {

  case $::osfamily {
    'Debian': {
      $default_su_group = versioncmp($::operatingsystemmajrelease, '14.00') ? {
        1         => 'syslog',
        default   => undef
      }
      $conf_params = {
        su_group => $default_su_group
      }
      $base_rules = {
        'wtmp' => {
          path        => '/var/log/wtmp',
          create_mode => '0664',
        },
        'btmp' => {
          path        => '/var/log/btmp',
          create_mode => '0600',
        }
      }
    }
    'Gentoo': {
      $conf_params = {
        dateext  => true,
        compress => true,
        ifempty  => false,
        mail     => false,
        olddir   => false,
      }
      $base_rules = {
        'wtmp' => {
          path        => '/var/log/wtmp',
          missingok   => false,
          create_mode => '0664',
          minsize     => '1M',
        },
        'btmp' => {
          path        => '/var/log/btmp',
          create_mode => '0600',
        }
      }
    }
    'RedHat': {
      $base_rules = {
        'wtmp' => {
          path        => '/var/log/wtmp',
          missingok   => false,
          create_mode => '0664',
          minsize     => '1M',
        },
        'btmp' => {
          path        => '/var/log/btmp',
          create_mode => '0600',
          minsize     => '1M',
        }
      }
    }
    'SuSE': {
      $base_rules = {
        'wtmp' => {
          path        => '/var/log/wtmp',
          create_mode => '0664',
          missingok   => false,
        },
        'btmp' => {
          path         => '/var/log/btmp',
          create_mode  => '0600',
          create_group => 'root',
        }
      }
      $rule_default = {
        missingok    => true,
        rotate_every => 'monthly',
        create       => true,
        create_owner => 'root',
        create_group => 'utmp',
        rotate       => 99,
        maxage       => 365,
        size         => '400k',
      }
    }
    default: { }
  }

  $config_file = '/etc/logrotate.conf'
  if !defined('$conf_params') {
    $conf_params = { }
  }
  if !defined('$base_rules') {
    $base_rules = { }
  }
  if !defined('$rule_default') {
    $rule_default = {
      missingok    => true,
      rotate_every => 'monthly',
      create       => true,
      create_owner => 'root',
      create_group => 'utmp',
      rotate       => 1,
    }
  }

}