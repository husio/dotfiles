up:
	./manage.sh collect dotuser/config
	sudo ./manage.sh collect dotsystem/config
	git add .
	git commit -am 'up'
	git push origin master
