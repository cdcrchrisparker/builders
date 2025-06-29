# The Golang Builder

Encapsulates everything you need to manage a Golang project without having Golang installed on your local machine. The basic steps for getting started are:

- Have the Docker container software installed on your local machine - details of which are beyond the scope of this document
- Build the local image
- Add an alias for ease of use
- Run Golang commands as if "go" is installed locally
- Shell into the image to snoop around

---

## Build the local image

### Before starting, you'll want to know your own UID and GID

You'll want to match the internal Golang's user UID (user id) and GID  (primary group id) to your own in order for the builder to seamlessly open files, run commands, and save artifacts. The included Dockerfile defaults to UID=1000 and GID=1000 - which will likely suffice for the vast majority of users. Basically if you are using GNU/Linux of any flavor on a desktop - **and** you are the only user - then you likely have a UID and GID of 1000.

You can check your UID and GID with the following command:

`echo "UID=$(id -u) : GID=$(id -g)"`

You'll want to build the image with your own numbers if either number is something other than "1000". Another consideration is if you have multiple users, and you want every user to have access. In this case there are two distinct possibilities (there may be other options):

1. Supply the id of a group which all users have in common and then make sure all build directories have granted rwx permissions to that group.
2. Build the image multiple times with each build using a different UID and GID and tag each build appropriately such that each user can use their own version.

Note that the majority of the size of the Docker image comes from the Golang Docker base image.  Having multiple copies with the local addition of local tools will not bloat your computer by any significant amount.

### How to build

From here out, my instructions assume you will always use the tag "go:latest".  Adjust accordingly if you choose another tag.

**The simple build if you are the only user of your machine, and your UID/GID match 1000/1000:**

`docker build -t go:latest .`

**The build if your UID or GID do not match 1000:**

`docker build --build-arg DUID=$(id -u) --build-arg DGID=$(id -g) -t go:latest .`

**The build if you to want specify a specific UID/GID (here I use '2000')**

`docker build --build-arg DUID=2000 --build-arg DGID=2000 -t go:latest .`

**Building for multiple users - each has their own tag:**

`docker build --build-arg DUID=$(id -u yakko) --build-arg DGID=$(id -g yakko) -t go:yakko .`

`docker build --build-arg DUID=$(id -u wakko) --build-arg DGID=$(id -g wakko) -t go:wakko .`

`docker build --build-arg DUID=$(id -u dot) --build-arg DGID=$(id -g dot) -t go:dot .`

---

### Adding an alias for ease of use

You *could* always run your Docker image like this:

`docker run -v ${PWD}:/home/gocompiler/app go (your commands)`

That will work, but yikes what a pain in the rear! Here are some alias suggestions to make this more seamless. I suggest first testing these interactively from a terminal, then once you are satisfied it works how you intend, add it/them to your ~/.bash_aliases file.

**If your tag is "latest":**

`alias go='docker run -v ${PWD}:/home/gocompiler/app go:latest '`

**If you have separate tags for each user:**

**Yakko's alias:** `alias go='docker run -v ${PWD}:/home/gocompiler/app go:yakko '`

**Wakko's alias:** `alias go='docker run -v ${PWD}:/home/gocompiler/app go:wakko '`

**Dot's alias:** `alias go='docker run -v ${PWD}:/home/gocompiler/app go:dot '`

---

### Run Golang commands

Now that you have a convenient alias, you can run "go" commands as if Golang is installed locally.  For example, to initialize a new project and compile *hello world*:

```bash
mkdir go-hello
cd go-hello
go mod init hello
# Add a go hello world source file named "hello.go"
go build .
# Notice that you now have a local executable called "hello"
./hello
# Notice that you can run the executable without any Golang dependencies installed locally
```

Source for Hello World in go:

```go
package main
import "fmt"
func main() {
    fmt.Println("Hello, World!")
}
```

---

### Shelling into the image

The script *run-go.sh* includes a clause that calls *snooze.sh*. That script is designed to sit in a slow loop while a file called *watchdog* is present. The idea is that you can start the Docker image in one terminal and then shell into it in another to snoop around.

The following steps all assume you have added the alias described above such that the command `go` is sufficient to start the image. The basic steps for shelling into a Docker image are:

- Start the image in "snooze mode" `go snooze`. That terminal will sit idle.
- Start another terminal instance.
- List, and then copy the "CONTAINER ID" of the  of the Docker image `docker ps`

|CONTAINER ID | IMAGE | COMMAND | CREATED | STATUS | PORTS | NAMES
| ----------- | ----- | ------- | ------- | ------ | ----- | ----- | 
| 1bfea3b4aea1 | go | "/home/gocompiler/ru…" | 7 seconds ago | Up 6 seconds | | interesting_hertz |
 
- Shell into the image `docker exec -it 1bfea3b4aea1 /bin/bash`
- When you are done, simply delete "watchdog" `rm ~/watchdog`

Those steps are not terribly difficult. However, laziness being one of the desired characteristics of a programmer - let's do it an easier way...

**Step 1:** Add the following function to your ~/.bash_aliases

```bash
# A simple function to help one perform a 'docker exec'
function de () {
    if [ $# -eq 0 ]; then
        echo "You must at minimum supply a name or term that uniquely identifies a running Docker image"
    elif [ $# -eq 1 ]; then
        docker exec -it $(docker ps | grep "$1" | cut -d ' ' -f 1) /bin/bash
    else
        name="$1"
        what="$2"
        shift ; shift
        docker exec -it $(docker ps | grep "$name" | cut -d ' ' -f 1) "$what" $@
    fi
}
```

**Step 2:** Make sure you have your aliases loaded - either by logging out and back in again - or else for your current terminal with the command `source ~/.bash_aliases`

**Step 3:** Start the Docker image in "snooze" mode `docker run go snooze`

**Step 4:** Use your handy alias to shell into the Docker image `de go`

**Step 5:** Do whatever investigation suits your fancy

**Step 6:** Close the session by deleting "watchdog" `rm ~/watchdog`
