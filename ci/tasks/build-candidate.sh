#!/usr/bin/env bash

set -e

source /etc/profile.d/chruby.sh
chruby 2.1.2

semver=`cat version-semver/number`

pushd bosh-cpi-release
  echo "running unit tests"
  pushd src/bosh_vcloud_cpi
    bundle install
    bundle exec rspec spec/unit
  popd

  echo "installing the latest bosh_cli"
  gem install bosh_cli --no-ri --no-rdoc

  echo "using bosh CLI version..."
  bosh version

  cpi_release_name="bosh-vcloud-cpi"

  echo "building CPI release..."
  bosh create release --name $cpi_release_name --version $semver --with-tarball
popd

mv bosh-cpi-release/dev_releases/$cpi_release_name/$cpi_release_name-$semver.tgz candidate/
