project:
	xcodegen generate --spec project.yml --use-cache
	bundle exec pod install || bundle exec pod install --repo-update

swift_version:
	@echo `swift --version | sed -nE 's/.*version ([0-9]+\.[0-9]+(\.[0-9]+)?).*/\1/p'`

lint:
	Pods/SwiftLint/swiftlint --config "$(PWD)/.swiftlint.yml" --path Projects

framework:
	pipenv run cookiecutter Templates/Framework
	@echo "\033[92m✋ Don't forget to add target in Podfile!\033[0m"

sort:
	bundle exec xcodeproj sort