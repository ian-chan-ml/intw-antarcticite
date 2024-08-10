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

func (s *OSMetrics) CPUMetrics(w http.ResponseWriter, r *http.Request) {
	before, err := cpu.Times(false)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	time.Sleep(time.Duration(1) * time.Second)
	after, err := cpu.Times(false)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	beforeStats := before[0]
	afterStats := after[0]

	userDelta := afterStats.User - beforeStats.User
	systemDelta := afterStats.System - beforeStats.System
	idleDelta := afterStats.Idle - beforeStats.Idle

	totalDelta := userDelta + systemDelta + idleDelta

	fmt.Fprintf(w, "cpu user: %f %%\n", float64(userDelta/totalDelta*100))
	fmt.Fprintf(w, "cpu system: %f %%\n", float64(systemDelta/totalDelta*100))
	fmt.Fprintf(w, "cpu idle: %f %%\n", float64(idleDelta/totalDelta*100))
}
