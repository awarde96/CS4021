//
//Black and White Bakery Lock
//


int threads = 3;
int ncs = 0;
int done = 0;
byte color = 0;

int number[3];
int mycolor[3];
int choosing[3];
int critical[3];

active[3] proctype bakeryLock(){
	int CNT = 0;
again:
	choosing[_pid] = 1;
	mycolor[_pid] = color;

	int max = 0;
	int i = 0;
	do
		:: (i != threads) ->
			if
				:: (number[i] > max) && (mycolor[_pid] == mycolor[i]) -> max = number[i];
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
	int w;

	do
	:: (j < threads) && (choosing[j] == 0) ->
		v = number[j];
		w = mycolor[j];
		if
			:: w == mycolor[_pid] -> 
			if
				::v = number[j]; w = mycolor[j]; (v == 0) || (v >= number[_pid] && j >= _pid) || (w != mycolor[_pid]) -> j++;
			fi
			:: w != mycolor[_pid] -> 
			if
				::v = number[j]; (v == 0) || ( mycolor[_pid] != color) || (mycolor[j] == mycolor[_pid]) -> j++;
			fi
		fi
	:: (j == threads) -> break;
	od
	assert(j == 3);
	//critcial section
	ncs++;
	critical[_pid] = 1;
	assert(ncs == 1);
	ncs--;
	critical[_pid] = 0;

	if
		:: mycolor[_pid] == 0 -> color = 1;
		:: mycolor[_pid] == 1 -> color = 0;
	fi

	number[_pid] = 0;

	if
	:: CNT <= 3 -> CNT++;
		goto again
	:: CNT == 4 -> done++;
	fi
}

ltl claim{
	//deadlock free
	(eventually(done == threads)) &&

	//Liveness
	(eventually(ncs)) &&

	//starvation free
	(eventually(critical[0])) &&
	(eventually(critical[1])) &&
	(eventually(critical[2])) &&

	//safety
	(always(ncs <= 1));
}
