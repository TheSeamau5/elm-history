# elm-history

This library contains a set of the bindings to the HTML5 History API methods. This allows you to programmatically travel backwards and forwards in the browser history as well as detect changes to the url path or hash.


## Changing the url path
You can change the url path by performing either the `setPath` or `replacePath` tasks

- `setPath`

```elm
setPath : String -> Task error ()
```

`setPath` allows you to change the current url path. If you are familiar with the HTML5 History API, this is equivalent to calling, in Javascript, `history.pushState(null, "", path)`. `setPath` moves the browser history forwards, which means that if you press the browser's back button after performing the `setPath` task, you will go back to the previous page (the one before you have called `setPath`).

- `replacePath`


```elm
replacePath : String -> Task error ()
```

`replacePath` allows you to replace the current url path. If you are familiar with the HTML5 History API, this is equivalent to calling, in Javascript, `history.replaceState(null, "", path)`. `replacePath` does not move the browser history forwards, which means that if you press the browser's back button after performing the `replacePath` task, you will not go back to the previous page (the one before you have called `replacePath`). You will probably end up in some completely different page.


##### Choosing between `setPath` and `replacePath`

In most cases, you will want to use `setPath`. If you use `setPath`, the previous pages will be accessible to the user by pressing the browser's back button. If this is the behavior you seek, use `setPath`.

`replacePath` is meant for transient states, i.e. states you do not want to go back to by pressing the browser back button. These states may include, but not limited to, login forms or slideshows. These have in common the fact that you want them to have specific urls you can just copy-paste and have them work but you may not want them to be accessible to the user by pressing the back button.

## Moving through the browser history

You can move through the browser history by performing either the `back`, `forward`, or `go` tasks.

- `go`

```elm
go : Int -> Task error ()
```

The `go` task allows you to move either forwards or backwards in the browser history. If given a positive number, the browser will go forwards in the browser history by the given amount, if available. If given a negative number, the browser will go backwards in the browser history by the absolute value of the given amount, if available.

- `back`

```elm
back : Task error ()
```

Performing the `back` task is equivalent to pressing the browser back button or calling `go -1`. This will point the browser to the previous page, if available.


- `forward`

```elm
forward : Task error ()
```

Performing the `forward` task is equivalent to pressing the browser forward button on calling `go 1`. This will point the browser to the next page, if available.


## Reacting to url path changes

You can react to url path changes with the `path` signal, to url hash changes with the `hash` signal, and to general history changes with the `length` signal.

- `path`

```elm
path : Signal String
```

This is a `Signal` of the url path that changes whenever the url path is modified, either by interaction or through code. This `Signal` is key to being able to route pages in single page applications as they save you a potentially expensive trip back to the server.

Paths are usually of the form:
```
/index.html

/blog/entry1.html

/users/4973/profile.html
```

- `hash`

```elm
hash : Signal String
```

This is a `Signal` of the url hash that changes whenever the url hash is modified, usually by interaction. Sometimes, when you click on an `a` tag, the browser will not refresh the page. Instead, it will focus on the area surrounding the `a` tag. This is usually done to separate a given page into multiple sections which can directly be access through the url. Sometimes, you may want to react in a particular way given the selected hash (such as performing a specific animation, or loading a particular asset).


Hashes are usually of the form:
```
#myTag

#section3

#Biography
```

- `length`

```elm
length : Signal Int
```

This is a `Signal` representing the current length of the browser history. This is occasionally useful, mostly as a heuristic to decide on whether to use `setPath` or `replacePath`. This `Signal` can also be used as a general *browser-history-has-changed* `Signal` as it is updated whenever the browser history has changed.
