package main

import (
	"encoding/json"
	"io"
	"log"
	"net/http"
	"strings"
)

func writeJSON(w http.ResponseWriter, status int, value any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(value)
}
func routes() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodGet {
			writeJSON(w, 405, map[string]string{"error": "Use GET"})
			return
		}
		writeJSON(w, 200, map[string]string{"status": "ok", "service": "api"})
	})
	mux.HandleFunc("/echo", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			writeJSON(w, 405, map[string]string{"error": "Use POST"})
			return
		}
		var data struct {
			Message string `json:"message"`
		}
		dec := json.NewDecoder(r.Body)
		err := dec.Decode(&data)
		var extra any
		if err != nil || dec.Decode(&extra) != io.EOF || strings.TrimSpace(data.Message) == "" {
			writeJSON(w, 400, map[string]string{"error": "Informe uma mensagem não vazia em JSON."})
			return
		}
		writeJSON(w, 200, map[string]string{"message": data.Message})
	})
	return mux
}
func main() {
	log.Println("API ouvindo em 0.0.0.0:5000")
	log.Fatal(http.ListenAndServe("0.0.0.0:5000", routes()))
}
