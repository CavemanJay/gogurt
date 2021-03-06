
appName=multi
rootOut = build
linuxOut = $(rootOut)/$(appName)
winOut = $(rootOut)/$(appName).exe
releaseFlags = -s -w
buildCmd = go build
version = 0.1.0
buildFlags = -X main.version=$(version)
releasePath = "release/$(version)"

compile:
	$(buildCmd) -ldflags="$(buildFlags)" -o $(linuxOut)

listen: compile
	./$(linuxOut) listen

listen-music: compile
	./$(linuxOut) -a "Music" listen 

wsl: compile
	./$(linuxOut) -f "/mnt/c/Users/cueva/Sync/" listen 

music: compile
	./$(linuxOut) m

help: compile
	./$(linuxOut) -h

dial: compile
	./$(linuxOut) dial

archive: compile
	./$(linuxOut) archive 

all: 
	GOOS=windows $(buildCmd) -o $(winOut)
	GOOS=linux $(buildCmd) -o $(linuxOut)

clean:
	rm -rvf $(rootOut) build data $(releasePath)/* __debug_bin

install:
	$(buildCmd) -ldflags="$(buildFlags) $(releaseFlags)" -o $(GOPATH)/bin

uninstall:
	rm -rvf "${GOPATH}/bin/$(appName)"

release: clean 
	mkdir -p $(releasePath)
	xgo -v -out='$(appName)-$(version)' -tags='release' -ldflags='$(releaseFlags) $(buildFlags)' -dest ./$(releasePath) --targets=windows/*,linux/amd64,linux/386 github.com/CavemanJay/$(appName)
	# find ./ -name "*.go" -o -name "go.*" -o -name "*.yml" | tar -cvf $(releasePath)/$(appName)-$(version).tar.gz -T -

docker: clean
	docker build --build-arg VERSION=$(version) .