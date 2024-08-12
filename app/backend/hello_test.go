package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestGetHelloString(t *testing.T) {
	// Create a request to pass to the handler.
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(getHelloString)

	handler.ServeHTTP(rr, req)

	// Check the response body is what we expect.
	expected := "Hello, World!"
	if rr.Body.String() != expected {
		t.Errorf("handler returned unexpected body: got %v want %v",
			rr.Body.String(), expected)
	}
}
