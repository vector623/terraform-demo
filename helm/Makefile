#!make

GITREF=master
export

clean:
	-rm demo-site/charts/demo-site-0.1.0.tgz

package:
	-helm package \
		 --version 0.1.0 ./demo-site \
		 --destination ./demo-site/charts/ \
		 --app-version 0.1.0

install:
	helm install -n dev demo-site-${GITREF} demo-site/charts/demo-site-0.1.0.tgz \
		--set git.ref=${GITREF}

uninstall:
	-helm uninstall -n dev demo-site-${GITREF}

all: uninstall clean package install

