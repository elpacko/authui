build-docker:
	docker build -t svelte/authui .
run-docker:
	docker run -p 5173:5173  svelte/authui