PROJECT_NAME=Airosef

all: help

apk:
	@godot --quit ./project.godot --export-debug Android ./$(PROJECT_NAME).apk

help:
	@echo "Existing commands:"
	@echo "  - apk:	Build APK"

.PHONY: apk