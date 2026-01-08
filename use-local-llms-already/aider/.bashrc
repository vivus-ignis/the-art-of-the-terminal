# add this to your .bashrc file
aw() {
	AIDER_DARK_MODE=true \
		AIDER_ANALYTICS_DISABLE=true \
		AIDER_AUTO_COMMITS=false \
		AIDER_CACHE_PROMPTS=true \
		AIDER_GITIGNORE=false \
		AIDER_NOTIFICATIONS=true \
		AIDER_AUTO_LINT=false \
		AIDER_ARCHITECT=false \
		AIDER_MODEL=ollama_chat/gpt-oss:20b \
		AIDER_SUBTREE_ONLY=true \
		AIDER_WATCH_FILES=true \
		AIDER_DETECT_URLS=false \
		OLLAMA_API_BASE=http://localhost:11434 \
		aider --read CONVENTIONS.md
}

# aider with architect mode
awa() {
	AIDER_DARK_MODE=true \
		AIDER_ANALYTICS_DISABLE=true \
		AIDER_AUTO_COMMITS=false \
		AIDER_CACHE_PROMPTS=true \
		AIDER_GITIGNORE=false \
		AIDER_NOTIFICATIONS=true \
		AIDER_ARCHITECT=true \
		AIDER_AUTO_LINT=false \
		AIDER_MODEL=ollama_chat/gpt-oss:20b \
		AIDER_EDITOR_MODEL=ollama_chat/ministral-3:14b \
		AIDER_SUBTREE_ONLY=true \
		AIDER_WATCH_FILES=true \
		AIDER_DETECT_URLS=false \
		OLLAMA_API_BASE=http://localhost:11434 \
		aider --read CONVENTIONS.md
}
