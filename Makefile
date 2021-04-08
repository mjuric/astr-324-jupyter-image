#
# TYPE and NAME must be defined by the including makefile
#

build:
	@docker build -t mjuric/astr324:latest .

push:
	@docker push mjuric/astr324:latest
