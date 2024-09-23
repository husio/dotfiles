up:
	./manage.sh collect dotuser/config
	git add .
	git commit -am 'up'
	git push origin master
