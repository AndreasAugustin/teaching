# teaching

## abstract

repository for public blogs.

- [dev.to/andreasaugustin][dev-to]

## Dependencies

This tool is using some open source projects

- record terminal and render to gif

```bash
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -r deps/terminal_recorder/requirements.txt
```

Now you are able to record the terminal (see below)

```bash
git submodule init
cd deps/terminal_recorder/asciinema/
cargo build -r
cd ../../..
```

Now you are able to transform your terminal records to gifs.

```bash
cd deps/terminal_recorder
make record
make play
make render
```

## Contributions

[Contributions of any kind welcome](.github/CONTRIBUTING.md).

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

![Lint](https://github.com/AndreasAugustin/template/workflows/Lint/badge.svg)

## DEV

The development environment targets are located in the [Makefile](Makefile)

```bash
make help
```

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/AndreasAugustin"><img src="https://avatars0.githubusercontent.com/u/8027933?v=4" width="100px;" alt=""/><br /><sub><b>andy Augustin</b></sub></a><br /><a href="https://github.com/AndreasAugustin/template/commits?author=AndreasAugustin" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

[dev-to]: https://dev.to/andreasaugustin
