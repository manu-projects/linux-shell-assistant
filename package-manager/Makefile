yarn-dependencies:
	sudo aptitude install curl

yarn-import-gpg-key:
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg \
	| sudo apt-key add -

yarn-add-repository:
	echo "deb https://dl.yarnpkg.com/debian/ stable main" \
	| sudo tee /etc/apt/sources.list.d/yarn.list

install-package-manager-yarn: yarn-dependencies yarn-import-gpg-key yarn-add-repository
	sudo aptitude update \
	&& sudo aptitude install yarn

uninstall-yarn:
	sudo aptitude remove yarn
