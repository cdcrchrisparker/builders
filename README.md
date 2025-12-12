# This Project's Purpose

This started as me wanting to experiment with Golang's claim that it statically compiles code and does not require any runtime libraries on compatible systems. Where *compatible* in this context presumably means "POSIX" compatible.

At some point I *might* add runners and builders for other languages than Golang.

Each builder will have its own README file which describes what it does.

---

### To save a local image:

```bash
docker save -o image_name.tar image_name:tag
gzip image_name.tar
```

### To restore a local image

```bash
gunzip image_name.tar.gz
docker load -i image_name.tar
```


---

### I need to write this somewhere

Cool video about Git

[Git Will Finally Make Sense After This](https://www.youtube.com/watch?v=Ala6PHlYjmw)