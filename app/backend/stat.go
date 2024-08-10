package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/shirou/gopsutil/v3/host"
	"github.com/shirou/gopsutil/v3/net"
	"github.com/shirou/gopsutil/v4/cpu"
	"github.com/shirou/gopsutil/v4/mem"
)

// MetricsHandler interface defines the methods to handle metrics requests.
type MetricsHandler interface {
	MemoryMetrics(http.ResponseWriter, *http.Request)
	CPUMetrics(http.ResponseWriter, *http.Request)
	NetworkMetrics(http.ResponseWriter, *http.Request)
	UptimeMetrics(http.ResponseWriter, *http.Request)
}

func (s *OSMetrics) MemoryMetrics(w http.ResponseWriter, r *http.Request) {
	memory, err := mem.VirtualMemory()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	fmt.Fprintf(w, "memory total: %d bytes\n", memory.Total)
	fmt.Fprintf(w, "memory used: %d bytes\n", memory.Used)
	fmt.Fprintf(w, "memory cached: %d bytes\n", memory.Cached)
	fmt.Fprintf(w, "memory available for allocation: %d bytes\n", memory.Available)
}
