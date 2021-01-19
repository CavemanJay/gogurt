
rootOut = build
linuxOut = $(rootOut)/gogurt
winOut = $(rootOut)/gogurt.exe

compile:
	go build -o $(linuxOut)

listen: compile
	./$(linuxOut) listen

wsl: compile
	./$(linuxOut) listen -f "/mnt/c/Users/cueva/Sync/"

help: compile
	./$(linuxOut) -h

dial: compile
	./$(linuxOut) dial

all: 
	GOOS=windows go build -o $(winOut)
	GOOS=linux go build -o $(linuxOut)

xgo:
	mkdir -p $(rootOut)
	xgo -v -x -tags='release' -ldflags='-s -w' -dest ./$(rootOut) --targets=windows/*,linux/amd64,linux/386 github.com/JayCuevas/gogurt

clean:
	rm -rvf $(rootOut)