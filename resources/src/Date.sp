class Date {
    method year+   ${ date -d $self '+%Y'  }
    method month+  on {
        GNU     ${date -d $self '+%-m' }
        BusyBox ${date -d $self '+%mp'|dc}
    }
    method day+  on {
        GNU     ${date -d $self '+%-d' }
        BusyBox ${date -d $self '+%dp'|dc}
    }
}

augment DateTime {
    constant @date  = on {
        GNU { \${date -u -d} }
        BusyBox { \${date -u -D '%Y-%m-%dT%T' -d} }
    }

    method year+ ${@date $self '+%Y'}

    method month+ on {
        GNU     ${@date $self '+%-m'}
        BusyBox ${@date $self '+%mp'|dc}
    }
    method day+ on {
        GNU     ${@date $self '+%-d'}
        BusyBox ${@date $self '+%dp'|dc}
    }
    method hour+ on {
        GNU     ${@date $self '+%-H'}
        BusyBox ${@date $self '+%Hp'|dc}
    }
    method minute+ on {
        GNU     ${@date $self '+%-M'}
        BusyBox ${@date $self '+%Mp'|dc}
    }
    method second+ on {
        GNU     ${@date $self '+%-S'}
        BusyBox ${@date $self '+%Sp'|dc}
    }
    method milli+ on {
        GNU ${@date $self '+%-3N'}
        BusyBox { $self.${sed -r 's/.*\.|Z$//g;ap'|dc} }
    }

    method dow+ ${@date $self '+%w'}

    method posix+  ${@date $self '+%s'}

    method valid? {
                      # XXX: \n? at the end is undesirable but necessary atm
        $self.matches(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}\n?$/);
    }

    method Bool { $self.valid }

    method Date { $self.${cut -dT -f1} }

    static method epoch-start^ { '1970-01-01T00:00:00.000' }

    static method now^ on {
        BusyBox ${date -u ("+\%FT${nmeter -d0 '%3t' | head -n1}") }
        GNU     ${date -u '+%FT%T.%3N' }
    }
}

sub now-->DateTime { DateTime.now }

augment Date {
    method DateTime { "{$self}T00:00:00.000Z" }
}
