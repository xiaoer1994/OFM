# (uses listen.bro just to ensure input sources are more reliably fully-read).
# @TEST-SERIALIZE: comm
#
# @TEST-EXEC: btest-bg-run bro bro -b %INPUT
# @TEST-EXEC: btest-bg-wait -k 5
# @TEST-EXEC: btest-diff out

redef InputAscii::separator = "|";
redef InputAscii::set_separator = ",";
redef InputAscii::empty_field = "(empty)";
redef InputAscii::unset_field = "-";

@TEST-START-FILE input.log
#separator |
#set_separator|,
#empty_field|(empty)
#unset_field|-
#path|ssh
#open|2012-07-20-01-49-19
#fields|data|data2
#types|string|string
abc\x0a\xffdef|DATA2
abc\x7c\xffdef|DATA2
abc\xff\x7cdef|DATA2
#end|2012-07-20-01-49-19
@TEST-END-FILE

@load frameworks/communication/listen

global outfile: file;
global try: count;

type Val: record {
		data: string;
		data2: string;
};

event line(description: Input::EventDescription, tpe: Input::Event, a: string, b: string)
	{
	print outfile, a;
	print outfile, b;
	try = try + 1;
	if ( try == 3 )
		{
		close(outfile);
		terminate();
		}
	}

event bro_init()
	{
	try = 0;
	outfile = open("../out");
	Input::add_event([$source="../input.log", $name="input", $fields=Val, $ev=line, $want_record=F]);
	Input::remove("input");
	}
