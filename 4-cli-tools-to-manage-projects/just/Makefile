makefile-multiline:
# this code shows bash history files for all users on the system that have a login shell
# (in the real project it was actually truncating those files)
	for res in `awk -F':' '{if($$(NF) ~ /sh$$/ && $$6 != "")printf $$1":"$$6"\n"}' /etc/passwd`; do \
	  user=`echo $$res | awk -F: '{print $$1}'` ; \
	  homedir=`echo $$res | awk -F: '{print $$2}'` ; \
	  if [ -s $${homedir}/.bash_history ]; then echo "Has to be cleaned: $${homedir}/.bash_history" ; fi ; \
	done

.PHONY: makefile-multiline test clean all
