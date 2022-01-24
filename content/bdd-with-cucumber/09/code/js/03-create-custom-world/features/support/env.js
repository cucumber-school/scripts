const { setWorldConstructor } = require('@cucumber/cucumber')

class ShoutyWorld {
}

setWorldConstructor(ShoutyWorld)