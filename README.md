# MakeuPedia

Makeupedia is an app for fun.
-----------------------------
It allows any user to find text that exists on a Wikipedia page and replace that text on their own. For example, a user can rewrite history by specifying that Steven Hawking was president of the United States in 1789. And why not? Home boy is amazing.

### Developer Setup:
* Bundle gems

```bash
$ bundle
```

* Initialize the database

```bash
$ rake db:create
$ rake db:migrate
```

* Start Rails

```bash
$ rails server
```

### Tests:
* Setup the test environment:

```bash
$ rake db:test:prepare
```

* Run the tests:

```bash
$ rspec
```

* Run JavaScript Tests:

```bash
$ rake jasmine
```

Then visit your localhost:8888 to view the tests.
