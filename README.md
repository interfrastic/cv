# cv

My curriculum vitæ, résumé, or equivalent term that can’t be rendered properly
in ASCII.

Prerequisites:

* Docker (all platforms)
* Git Bash (for Windows support)

To include full contact information in Markdown format, place it in a file
named `contact.md` in the `include` directory, like this:

```
$ cat include/contact.md
742 Evergreen Ter., Springfield, West Dakota 12345-6789, <tel:+1-939-555-0113>\
<https://www.linkedin.com/in/homer-j-simpson/>
```

To build the output files, execute the build script:

```
./build
```
