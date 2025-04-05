const { Given, When, Then } = require('@wdio/cucumber-framework');
const { expect, $ } = require('@wdio/globals')

const LoginPage = require('../pageobjects/login.page');
const SecurePage = require('../pageobjects/secure.page');
const { default: AllureReporter } = require('@wdio/allure-reporter');

const pages = {
    login: LoginPage
}

Given(/^I am on the (\w+) page$/, async (page) => {
    AllureReporter.addStep(`I am on the ${page} page`);
    console.log(`I am on the ${page} page`);
    await pages[page].open()
});

When(/^I login with (\w+) and (.+)$/, async (username, password) => {
    AllureReporter.addStep(`I login with ${username} and ${password}`);
    await LoginPage.login(username, password)
});

Then(/^I should see a flash message saying (.*)$/, async (message) => {
    AllureReporter.addStep(`I should see a flash message saying ${message}`);
    await expect(SecurePage.flashAlert).toBeExisting();
    await expect(SecurePage.flashAlert).toHaveText(expect.stringContaining(message));
});

