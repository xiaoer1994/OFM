# @TEST-EXEC: bro %INPUT >output
# @TEST-EXEC: btest-diff output

const one_to_32: vector of count = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32};

for ( i in one_to_32 )
	{
	print mask_addr(255.255.255.255, one_to_32[i]);
	}
