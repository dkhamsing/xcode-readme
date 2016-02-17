# Constants
module CocoapodsReadme
  VERSION = '0.1.0'

  LOG_FILE = 'temp-log-readmes'

  BATCH = 'batch-correct'

  PRODUCT = 'xcode-readme'
  PRODUCT_DESCRIPTION = 'Correct the spelling of Xcode in a README'
  PRODUCT_URL = 'https://github.com/dkhamsing/xcode-readme'

  PULL_REQUEST_COMMIT_MESSAGE = 'Correct the spelling of Xcode in README'
  PULL_REQUEST_TITLE = PULL_REQUEST_COMMIT_MESSAGE
  PULL_REQUEST_DESCRIPTION = %q[
This pull request corrects the spelling of **Xcode** :sweat_smile:
https://developer.apple.com/xcode/

Created with [`xcode-readme`](https://github.com/dkhamsing/xcode-readme).
]
end
