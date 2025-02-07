# vert
Package `vert` provides WebAssembly interop between Go and JS values.

## Differences from norunners/vert
- removed vert.Value type so that the package is compatible with go1.18 (js.Wrapper was removed)
- changed signature of func(vert.Value) AssignTo(any) to func AssignTo(js.Value, any)

## Install
```bash
GOOS=js GOARCH=wasm go get github.com/jrs526/vert
```

## Examples
### Hello World!
Below is a trivial string value interop.
```go
package main

import "github.com/jrs526/vert/v2"

func main() {
	v := vert.ValueOf("Hello World!")
	// Use v as a JS value.

	s := ""
	vert.AssignTo(v, &s)
	// Use s as a Go value.
}
```

### Structs & Objects
Go structs and JS objects interop seamlessly.
```go
package main

import "github.com/jrs526/vert/v2"

type Data struct {
	Message string
}

func main() {
	v := vert.ValueOf(Data{
		Message: "Hello World!",
	})
	// e.g. {"Message": "Hello World!"}

	d := &Data{}
	vert.AssignTo(v, d)
}
```

### Tagged Struct Fields
Tagged struct fields allow defined JS field names.
```go
package main

import "github.com/jrs526/vert/v2"

type Data struct {
	Message string `js:"msg"`
}

func main() {
	v := vert.ValueOf(Data{
		Message: "Hello World!",
	})
	// The defined JS tag names the field.
	// e.g. {"msg": "Hello World!"}

	d := &Data{}
	vert.AssignTo(v, d)
}
```

## Error Handling
`AssignTo` returns an `error` value.  
```go
package main

import "github.com/jrs526/vert/v2"

type Data struct {
	Message string
}

func main() {
	v := vert.ValueOf("Hello World!")

	d := &Data{}
	if err := vert.AssignTo(v, d); err != nil {
		// Handle error.
	}
}
```

## Why?
Package `syscall/js`, of the Go standard library, has limited interop support between Go and JS values.
1. The function `js.ValueOf` will not accept struct types. The result panics with `ValueOf: invalid value`.
2. The type `js.Value.` does not support an `Interface` or *assignment* method for non-basic Go values.
However, the methods `Bool`, `Int`, `Float` and `String` support basic Go values.

Package `vert` leverages and extends `syscall/js` to accommodate these shortcomings.

## License
* [MIT License](LICENSE)
