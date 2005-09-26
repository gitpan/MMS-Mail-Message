#!perl -T

use Test::More tests => 21;
use MMS::Mail::Message;

my $message = new MMS::Mail::Message;

is($message->header_datetime("Somedate\n"),"Somedate\n");
is($message->header_subject("Subject\n"),"Subject\n");
is($message->header_from("From\n"),"From\n");
is($message->header_to("To\n"),"To\n");
is($message->body_text("Text\n"),"Text\n");

is($message->header_datetime,"Somedate\n");
is($message->header_subject,"Subject\n");
is($message->header_from,"From\n");
is($message->header_to,"To\n");
is($message->body_text,"Text\n");

is($message->strip_characters("\n"),"\n");

is($message->header_datetime("Somedate\n"),"Somedate");
is($message->header_subject("Subject\n"),"Subject");
is($message->header_from("From\n"),"From");
is($message->header_to("To\n"),"To");
is($message->body_text("Text\n"),"Text");

is($message->header_datetime,"Somedate");
is($message->header_subject,"Subject");
is($message->header_from,"From");
is($message->header_to,"To");
is($message->body_text,"Text");

