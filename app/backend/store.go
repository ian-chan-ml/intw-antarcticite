package main

import (
	"log"
	"net"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

func logServiceRequest(r *http.Request) {
	logsDir := "/tmp/access/logs"
	err := os.MkdirAll(logsDir, 0755)
	if err != nil {
		log.Fatalf("failed to create log directory: %v", err)
	}

	// Generate the log file name with the current date and hour
	now := time.Now()
	logFileName := filepath.Join(logsDir, now.Format("2006-01-02_15.log"))

	// Open the log file in append mode, creating it if necessary
	file, err := os.OpenFile(logFileName, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Fatalf("failed to open log file: %v", err)
	}
	defer file.Close()

	// Get the client's IP address
	ip, _, err := net.SplitHostPort(r.RemoteAddr)
	if err != nil {
		ip = r.RemoteAddr
	}

	// Log additional headers if needed
	userAgent := r.Header.Get("User-Agent")

	// Create a logger and log the request details
	logger := log.New(file, "", log.LstdFlags)
	logger.Printf("Request: %s %s %s | IP: %s | User-Agent: %s", r.Method, r.URL.Path, now.Format(time.RFC3339), ip, userAgent)
}

func getAccessLogs(w http.ResponseWriter, r *http.Request) {
	logServiceRequest(r)
	logsDir := "/tmp/access/logs"

	// Read all files in the logs directory
	files, err := os.ReadDir(logsDir)
	if err != nil {
		http.Error(w, "Unable to read log directory", http.StatusInternalServerError)
		return
	}

	var logFiles []string
	for _, file := range files {
		// Append full path of the file
		logFiles = append(logFiles, filepath.Join(logsDir, file.Name()))
	}

	if len(logFiles) == 0 {
		http.Error(w, "No log files found", http.StatusNotFound)
		return
	}

	// Use the cat command to concatenate the log files
	cmd := exec.Command("cat", logFiles...)
	output, err := cmd.Output()
	if err != nil {
		http.Error(w, "Failed to read log files", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "text/plain")
	w.Write(output)
}
