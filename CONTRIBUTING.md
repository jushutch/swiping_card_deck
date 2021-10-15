# Introduction :wave:

Thank you for your interest in contributing to the swiping_card_deck package! It's people like you that make 
open-source development so great!

This document outlines requirements and best practices for contributing. Following these guidelines helps to communicate that you respect the time of the developers managing and developing this open source project. In return, they will reciprocate that respect in addressing your issue, assessing changes, and helping you finalize your pull requests.

There are many ways to contribute to this package, from writing tutorials or blog posts, improving the documentation, submitting bug reports and feature requests, triaging open issues, or writing code which can be incorporated into the package itself.

However, please don't open pull requests that don't address an existing issue. Any pull request that doesn't
reference an open issue is subject to be closed immediately. This helps to keep the project organized and provide a fair chance for all contributors to work on issues.

# Ground Rules :page_with_curl:

Responsibilities
* Be respectful and open-minded when discussing issues or receiving feedback. There are issues with many correct answers, but deciding on the preferred answer requires collaboration.
* Any pull request that modifies code should have corresponding tests to validate changes. For example, a new feature should have unit tests that verify correct behavior and a bug fix should have a regression test to prevent the bug from reoccuring. In general, keep test line coverage as close to 100% as possible; no pull requests will be approved with line coverage less than 80%.
* Keep issues and pull requests active. If you open it, it is your job to make sure it gets attention and is eventually resolved. All issues and pull requests are subject to removal after being inactive for one month. In order to prevent your issue or pull request from being closed, create comments with status updates, questions, or concerns.

# Your First Contribution :computer:
Unsure where to begin contributing to the swiping_card_deck package? You can start by looking through the `good first issue` and `help wanted` issues:
* `good first issue` - issues which should only require small changes to existing code, documentation, or QA, or have well documented solutions that are easy to understand.
* `help wanted` - issues which are actively seeking contributors. Your chances of being assigned to work on an issue are better if they include this label.

First time contributing to an open-source project? Working on your first pull request? Here are a couple of friendly tutorials that might help:
* [How to Contribute to an Open Source Project on GitHub](https://kcd.im/pull-request)
* [First Timers Only](http://www.firsttimersonly.com/)

In general, feel free to ask questions! If you have trouble opening a pull request, need git help, or just don't know what changes to make, ask a mainatiner and they would be happy to help! Everybody has to start somewhere and this project aims to make first contributions easy.

# Getting Started :hammer:
The process to contribute from start to finish is as follows:

1. Create an issue or find an existing issue. Issues with the `help wanted` label are actively seeking contributors and have the best chances of being assigned.
2. Claim an issue by leaving a comment on the open issue asking to be assigned and a maintainer will respond shortly. Once you have been assigned you can start working on making your changes.
3. The first step to make changes is to fork the repository on GitHub. For help, see the GitHub documentation: [Fork A Repo](https://docs.github.com/en/get-started/quickstart/fork-a-repo).
4. Next, create a development branch on your fork. Branch names should be a short description of the issue in lowercase, prefixed with the issue number, all separated by hyphens. 

    :heavy_check_mark: **Examples of valid branches**:

    * 1-add-dartdoc-comments
    * 2-write-unit-tests
    * 3-create-github-actions-workflow
    
    :x: **Examples of invalid branches**:

    * add-dartdoc-comments-1
    * 1AddDartdocComments
    * write-unit-tests

5. Make frequent commits on your branch. Follow this template for commit messages:
    > Short description with capitalized first word
    >
    > Make sure to leave a blank line in-between the title and description. The
    > description should be a brief summary of changes and should wrap at 80
    > characters. Next is a blank line, following by the GitHub issue number that
    > this commit is related to. Follow the exact format given below.
    >
    > Issue #5

6. During development, make sure to check in on the issue and see if there are any new
comments. If the issue is taking longer than expected, leave a short comment with an
update on your progress in order to keep the issue active. Failing to keep the issue
active could result in being unassigned and having it assigned to someone else.

7. Once you feel that the changes on your branch resolve the issue, open a pull request.
Refer to the GitHub documentation if you need help:

8. In the description of the pull request, give a brief description of your changes. Then
include the line "Resolves issue #1", where the issue number is the number of the issue that
your pull request should resolve.

9. A maintainer will review your pull request as soon as possible and suggest changes. Once the 
pull request meets all of the requirements, the maintainer will handle merging. Once it has been merged 
you can delete your local branch. Congratulations; you just contributed to a flutter package! :tada: