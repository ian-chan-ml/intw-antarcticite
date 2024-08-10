package main

import (
	"fmt"
	"net/http"
)

func getHelloString(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, World!")
}
