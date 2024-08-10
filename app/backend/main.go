package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

// OSMetrics struct implements the MetricsHandler interface.
type OSMetrics struct{}

func main() {
	osstats := &OSMetrics{}

	// Helloworld endpoint
	http.HandleFunc("/", getHelloString)

	// OS Stats endpoints
	http.HandleFunc("/memory", osstats.MemoryMetrics)
	http.HandleFunc("/cpu", osstats.CPUMetrics)
	http.HandleFunc("/network", osstats.NetworkMetrics)
	http.HandleFunc("/uptime", osstats.UptimeMetrics)

	// Prometheus endpoint
	http.Handle("/metrics", promhttp.Handler())

	fmt.Println("Serving requests on port 8080")
	err := http.ListenAndServe(":8080", nil)
	log.Fatal(err)
}
