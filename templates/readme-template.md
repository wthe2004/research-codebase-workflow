# `<Project name>`

<One-line elevator pitch. What problem does this solve? Who is it for?>

<Optional badges: build, license, paper link, model card.>

## Quickstart

The shortest path from a fresh clone to one reproduced result. No tuning, no decisions — copy/paste should work.

```bash
git clone --recursive <repo-url>
cd <repo>
uv sync                # or pip install -r requirements.txt

# Reproduce the headline result (e.g. paper Table 1 row 1)
bash scripts/<entry>.sh
# Expected output: <metric>=<value> in <log path>; ~<wall-clock> on <hardware>.
```

If the quickstart fails on a fresh clone, that is a P0 bug — file an issue.

## Setup

<Environment requirements: Python version, CUDA version, GPU memory floor, disk floor.>

<Datasets: where to download, where to put them, any preprocessing. Link to a separate docs/data.md if non-trivial.>

<Submodules / external models / weights to fetch. Concrete commands.>

## Reproducing the paper

See [`docs/reproduce.md`](docs/reproduce.md) for the full table → command → checkpoint → seed mapping. Each row of the paper's results table corresponds to one entry there with the exact invocation, config diff, and expected log file location.

## Project structure

```
<short tree — only top-level dirs and one-line descriptions>
```

For deeper architecture see [`docs/architecture.md`](docs/architecture.md).

## Citing

```bibtex
@<entry-type>{<key>,
  title = {...},
  author = {...},
  year = {...},
}
```

## License

<Spell out the license; default for academic code is often a permissive one. State it explicitly even if it's "for academic use only" or similar.>
