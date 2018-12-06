#!/bin/sh -x

create_agent () {
  rm -rf $1
  ./myelin new $1
  cd $1
  cat > agents/$1.agent <<- EOM
    construct _ do
    end

    run log do
      log <> "\\n Running $1 agent at #{Node.self}"
    end
EOM

  ../myelin build
  PORT=$2 ../myelin deploy
  cd ..
}

create_bid () {
  (cd $1 && PORT=$2 ../myelin bid $1)
}

agent_address () {
  cat $1/storage/$1
}

create_agent "stage_1" 11122
create_agent "stage_2" 11123
create_bid "stage_1" 11124
create_bid "stage_2" 11125

PID=`PORT=11122 ./myelin start_pipeline $(agent_address "stage_1"),$(agent_address "stage_2")`
sleep 20
PORT=11125 ./myelin run_pipeline $PID hello
