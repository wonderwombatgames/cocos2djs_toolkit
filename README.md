# Cocos2D-X Javascript Game Toolkit

This is a collection of auxiliary classes and objects I abstracted from 2 simple games I developed.

They contain most of the boilerplate code I was using on my simple games, but they are far from complete. As I develop different kinds of games I will add and improve this collection and perhaps have something more usefull and complete with time.

The documentation is minimal.

The code was written in coffeescript because I like the conciseness of it over the verbosity of JS. Regardless the implementation does not have any coffescript specific feature and it has a high correlation to what would have been the code if written in JS.

To compile to javascript use the command: 
coffee -m -b -c -o ./DESTINATION ./SOURCE

You have to use "-b" to avoid coffescript encapsulation
I added -m  to create maps between cs and js and make life easier when debugging on the js console of the brower.

