.PHONY: dry

dry:
	dart pub publish -n

golden:
	cd example; flutter test --update-goldens