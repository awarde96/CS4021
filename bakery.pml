//
// Bakery lock
//

int threads = 3;
int ncs = 0;
int done = 0;

int number[3];
int choosing[3];

active[3] proctype bakeryLock(){
	int CNT = 0;
again:
	CNT = CNT;
	choosing[_pid] = 1;
	int max = 0;
	int i = 0;
	//do
	//	::(number[i] > max) -> max = number[i];
	//	::(i < threads-1) -> i++;
	//	::(i == threads-1)-> break;
	//od;
	do
		:: (i != threads) ->
			if
				:: (number[i] > max) -> max = number[i];
				:: else;
			fi
			i++;
		:: (i == threads) -> break;
	od

	assert(i != 4)

	number[_pid] = max + 1;
	choosing[_pid] = 0;

	int j = 0;
	int v;

	do
	:: (j < threads) && (choosing[j] == 0) ->
		v = number[j];
		if
			::(((v != 0) && ((v < number[_pid]) || ((v == number[_pid]) && (j < _pid)))) == false) -> j++;
			:: else;
			//:: (number[j] == 0) -> j++;
			//:: (number[j] > number[_pid]) -> j++;
			//:: ((number[j] == number[_pid]) && (j >= _pid)) -> j++;
		fi
	:: (j == threads) -> break;
	od;
	
	assert(j != 4);
	//critcial section
	ncs++;
	assert(ncs == 1);
	ncs--;

	number[_pid] = 0;

	if
	:: CNT <= 3 -> CNT++;
		goto again
	:: CNT == 4 -> done++;
	fi
	
}


