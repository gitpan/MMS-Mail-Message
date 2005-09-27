package MMS::Mail::Message;

use warnings;
use strict;

=head1 NAME

MMS::Mail::Message - A class representing an MMS (or picture) message.

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';

=head1 SYNOPSIS

This class is used by MMS::Mail::Parser to provide an itermediate data storage class after the MMS has been parsed by the parse method but before it has been through the second stage of parsing (the MMS::Mail::Parser C<provider_parse> method).

=head1 METHODS

The following are the top-level methods of the MMS::Mail::Message class.

=head2 Constructor

=over

=item C<new()>

Return a new MMS::Mail::Message object.  Valid attributes are:

=over

=item C<strip_characters> STRING

Passed as an array reference, C<strip_characters> defines the characters used by the C<header_from>, C<header_to>, C<header_datetime>, C<body_text> and C<header_subject> methods to remove from their respective properties (in both the MMS::Mail::Message and MMS::Mail::Message::Parsed classes).

=back

=back

=head2 Regular Methods

=over

=item C<header_datetime> STRING

Returns the time and date the MMS was received when invoked with no supplied parameter.  When supplied with a parameter it sets the object property to the supplied parameter.

=item C<header_from> STRING

Returns the sending email address the MMS was sent from when invoked with no supplied parameter.  When supplied with a parameter it sets the object property to the supplied parameter.

=item C<header_to> STRING

Returns the recieving email address the MMS was sent to when invoked with no supplied parameter.  When supplied with a parameter it sets the object property to the supplied parameter.

=item C<header_subject> STRING

Returns the MMS subject when invoked with no supplied parameter.  When supplied with a parameter it sets the object property to the supplied parameter.

=item C<body_text> STRING

Returns the MMS bodytext when invoked with no supplied parameter.  When supplied with a paramater it sets the object property to the supplied parameter.

=item C<strip_characters> STRING

The supplied string should be a set of characters valid for use in the regular expression character class C<s/[]//g>.  When set with a value the property is used by the C<header_from>, C<header_to>, C<header_datetime>, C<body_text> and C<header_subject> methods to remove these characters from their respective properties (in both the MMS::Mail::Message and MMS::Mail::Message::Parsed classes).

=item C<attachments> ARRAYREF

Returns an array reference to the array of MMS message attachments.  When supplied with a parameter it sets the object property to the supplied parameter.

=item C<add_attachment> MIME::Entity

Adds the supplied MIME::Entity attachment to the attachment stack for the message.  This method is mainly used by the MMS::MailParser class to add attatchments while parsing.

=item C<is_valid>

Returns true or false depending if the C<header_datetime>, C<header_from> and C<header_to> fields are all populated or not.

=back

=head1 AUTHOR

Rob Lee, C<< <robl@robl.co.uk> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-mms-mail-message@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MMS-Mail-Message>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 NOTES

Please read the Perl artistic license ('perldoc perlartistic') :

10. THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
    WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES
    OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

=head1 ACKNOWLEDGEMENTS

As per usual this module is sprinkled with a little Deb magic.

=head1 COPYRIGHT & LICENSE

Copyright 2005 Rob Lee, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

L<MMS::Mail::Message>, L<MMS::Mail::Message::Parsed>, L<MMS::Mail::Provider>

=cut

sub new {
  my $type = shift;
  my $args = {@_};

  my $self = {};
  bless $self, $type;
 

  $self->{clone_fields} = [	"header_from",
				"header_to",
				"header_datetime",
				"attachments",
				"strip_characters"];

  $self->{fields} = [	"header_from",
			"header_to",
			"body_text",
			"header_datetime",
			"header_subject",
			"attachments",
			"strip_characters"];

  foreach my $field (@{$self->{fields}}) {
    $self->{$field} = undef;
  }
  $self->{attachments} = [];

  if (exists $args->{strip_characters}) {
    $self->strip_characters($args->{strip_characters});
  }

  return $self;
}

sub header_datetime {

  my $self = shift;
  my $element = shift;

  if (defined $element) { 
    $element =~ s/[$self->{strip_characters}]//g if (defined $self->{strip_characters} );
    $self->{header_datetime} = $element 
  }

  return $self->{header_datetime};

}

sub header_from {

  my $self = shift;
  my $element = shift;

  if (defined $element) {
    $element =~ s/[$self->{strip_characters}]//g if (defined $self->{strip_characters} );
    $self->{header_from} = $element
  }

  return $self->{header_from};

}

sub header_to {

  my $self = shift;
  my $element = shift;

  if (defined $element) {
    $element =~ s/[$self->{strip_characters}]//g if (defined $self->{strip_characters} );
    $self->{header_to} = $element
  }

  return $self->{header_to};

}

sub body_text {

  my $self = shift;
  my $element = shift;

  if (defined $element) {
    $element =~ s/[$self->{strip_characters}]//g if (defined $self->{strip_characters} );
    $self->{body_text} = $element
  }

  return $self->{body_text};

}

sub header_subject {

  my $self = shift;
  my $element = shift;

  if (defined $element) {
    $element =~ s/[$self->{strip_characters}]//g if (defined $self->{strip_characters} );
    $self->{header_subject} = $element
  }

  return $self->{header_subject};

}

sub attachments {

  my $self = shift;

  if (@_) { $self->{attachments} = shift }
  return $self->{attachments};

}

sub add_attachment {

  my $self = shift;
  my $attachment = shift;

  unless (defined $attachment) {
    return 0;
  }

  push @{$self->{attachments}}, $attachment;

  return 1;

}

sub is_valid {

  my $self = shift;

  unless ($self->header_from) {
    return 0;
  }
  unless ($self->header_to) {
    return 0;
  }
  unless ($self->header_datetime) {
    return 0;
  }

  return 1;

}

sub strip_characters {

  my $self = shift;

  if (@_) { $self->{strip_characters} = shift }
  return $self->{strip_characters};

}


sub _clone_data {

  my $self = shift;
  my $message = shift;

  foreach my $field (@{$self->{clone_fields}}) {
    $self->{$field} = $message->{$field};
  }
 
}

sub DESTROY {

  my $self = shift;

  foreach my $attach (@{$self->{attachments}}) {
    $attach->bodyhandle->purge;
  }

}

1; # End of MMS::Mail::Message
