i18n:
	bundle exec rake i18n

data:
	bundle exec rake data

missing:
	grep -ohR 'translation missing: [a-z\.]\+' _site | sed 's/translation missing: [a-z][a-z]\.\([a-z\.]\+\)$$/\1/g' | sort | uniq
