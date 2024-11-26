# RecipeGenerator

## How to use

1. Clone this repo
1. Install PostgreSQL in case you don't have it
1. Install node and yarn. Expected node version ">=16 || 14 >=14.17".
1. Run `yarn install` and `yarn build --watch`. This bundles the JS assets in the administration site using [esbuild](https://github.com/evanw/esbuild).
1. `bundle exec rspec` and make sure all tests pass (non-headless mode) or `HEADLESS=true bundle exec rspec` (headless mode)
1. `rails assets:precompile` to precompile assets
1. Run `bin/dev`.

