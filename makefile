.PHONY: dry publish golden

dry:
	flutter pub publish --dry-run

golden:
	cd example; flutter test --update-goldens

publish:
	flutter pub publish