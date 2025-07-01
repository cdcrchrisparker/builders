# Getting started with Golang

### Prerequisites:

Be sure to start in the local [README](./README.md) file. Follow the instructions such that you can run go commands from your terminal.

---

### Moving past "Hello World"

"Hello world" in golang is trivial. But once one starts writing real code, one will need to separate functions into modules and etcetera. How to do that is extremely simple once one understands the mechanism - the problem is that it's *so* easy that nobody bothers to give a simple working recipe.

**NOTE:** For the purposes of this example, the full path that we will be using is ${HOME}/go-projects. Note that I use "${HOME}" instead of "\~" only because the "\~" is a little hard to see in code samples.

---

### Create your directory structure and touch all files:

```bash
cd ${HOME}

# Prepping our project
mkdir recipe
cd recipe
go mod init greeter # <-- Remember "greeter" here, it's important

# Main code
touch main.go

# Prepping the "hello" module
mkdir hello
touch hello/sayhello.go

# Prepping the "goodbye" module
mkdir goodbye
touch goodbye/saygoodbye.go
```


The finished project tree should look like this:

    /recipe
    ├─ go.mod
    ├─ main.go
    ├─ goodbye
    |  └─ saygoodbye.go
    └─ hello
       └─ sayhello.go

Note that the names "saygoodbye.go" and "sayhello.go" are arbitrary, the files could be named anything. I choose the names specifically so that the relationship (and lack thereof) between the module name, directory names, and file names would (or at least should) become obvious.

---

### Edit "saygoodbye.go" in the directory "goodbye"

Below is the full source for "saygoodbye.go":

```golang
package goodbye

func MyGoodbye () string {
  return "Goodbye cruel world!"
}
```

Note that "saygoodbye.go" is inside the directory **goodbye** - consequently the package name is also **goodbye**. This is important - the package name in any code files **MUST** match the directory name in which the module sits.

---

### Edit "sayhello.go" in the directory "hello"

Below is the full source for "sayhello.go":

```golang
package hello

func MyHello () string {
  return "Hello world!"
}
```

This reinforces the idea that the directory name and package name must match. "hello" is both the directory name and package name.

---

### Edit "main.go" in the base directory

Below is the full source for "main.go":

```golang
package main

import (
    "fmt"
    "greeter/hello"
    "greeter/goodbye"
)

func main() {
    fmt.Println(hello.MyHello())
    fmt.Println(goodbye.MyGoodbye())
}
```

Notice the following points:

- Our local imports start with the name of the project. Remember "go mod init **greeter**"? The name supplied is used here.
- Note that directory name is used as the specification for where to find the modules.

---

Assuming you have met the requirements for running go commands, then you should be able to run the following:

```
$ go run main.go 
Hello world!
Goodbye cruel world!
```
