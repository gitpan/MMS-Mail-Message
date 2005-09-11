#!perl -T

use Test::More tests => 10;
use MMS::Mail::Message;

my $message = new MMS::Mail::Message;

is($message->header_datetime("Somedate"),'Somedate');
is($message->header_subject("Subject"),'Subject');
is($message->header_from("From"),'From');
is($message->header_to("To"),'To');
is($message->body_text("Text"),'Text');

is($message->header_datetime,"Somedate");
is($message->header_subject,"Subject");
is($message->header_from,"From");
is($message->header_to,"To");
is($message->body_text,"Text");

