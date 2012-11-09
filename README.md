# Concurrent Hello World in CL with lparallel

There's a blog post about it at the following address:

  http://tapoueh.org/blog/2012/11/04-Concurrent-Hello.html

This lisp package is a toy exemple showing how to use
[lparallel](http://lparallel.org/) and its queuing API in order to implement
some concurrent program with "rendez-vous" or at with a way to pass
information in between concurrent workers.

Please note that the *lparallel* library is not meant to be used with a
disposable *kernel*, quite the contrary. That design choice has been made
explicitely so as not to *pollute* your local Lisp Image where you're doing
your REPL testing and development. After all, it's meant to be a one-off toy
test.

So don't take `with-temp-kernel` seriously, it's usually exactly how *not*
to do things in a real application!
