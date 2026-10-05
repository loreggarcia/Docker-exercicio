package main

import (
	"encoding/json"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestContract(t *testing.T) {
	tests := []struct {
		method, path, body string
		status             int
		expected           map[string]string
	}{
		{"GET", "/health", "", 200, map[string]string{"status": "ok", "service": "api"}},
		{"POST", "/echo", `{"message":"Hello Docker"}`, 200, map[string]string{"message": "Hello Docker"}},
		{"POST", "/echo", `{"message":"  Olá 🐳  "}`, 200, map[string]string{"message": "  Olá 🐳  "}},
	}
	for _, body := range []string{"", "{", "null", "[]", "{}", `{"message":""}`, `{"message":"  "}`, `{"message":42}`, `{"message":null}`, `{"message":"ok"} {}`} {
		tests = append(tests, struct {
			method, path, body string
			status             int
			expected           map[string]string
		}{"POST", "/echo", body, 400, nil})
	}
	for _, tt := range tests {
		t.Run(tt.method+tt.path+tt.body, func(t *testing.T) {
			r := httptest.NewRequest(tt.method, tt.path, strings.NewReader(tt.body))
			r.Header.Set("Content-Type", "application/json")
			w := httptest.NewRecorder()
			routes().ServeHTTP(w, r)
			if w.Code != tt.status {
				t.Fatalf("status %d; esperado %d", w.Code, tt.status)
			}
			var data map[string]string
			if err := json.Unmarshal(w.Body.Bytes(), &data); err != nil {
				t.Fatal(err)
			}
			if tt.status == 400 {
				if data["error"] == "" {
					t.Fatal("erro ausente")
				}
				return
			}
			if len(data) != len(tt.expected) {
				t.Fatal(data)
			}
			for key, value := range tt.expected {
				if data[key] != value {
					t.Fatal(data)
				}
			}
		})
	}
}
