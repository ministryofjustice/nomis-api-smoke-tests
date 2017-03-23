# nomis-api-smoke-tests
A non-exhaustive set of smoke tests to allow validation that a particular version of https://github.com/ministryofjustice/nomis-api has been deployed and is working on a given URL.


NOTE: These are *smoke tests*, designed to be performed _after_ a release - _not_ functional tests for running before a release. They require a genuine running instance of the API to hit.

# Setup

## You will need
* Ruby (developed and tested on 2.3.0 - may work on versions back to 1.9.x, but have not tested these)
* rubygems (developed and tested on 2.5.1)
* bundler (developed and tested on 1.14.5)

### To install the bundle of Ruby gems
From the root directory, type:
```bash
> bundle install
```

# Running tests

## Environment variables

```bash
NOMIS_API_CLIENT_KEY_FILE=(path to your client private key file)
NOMIS_API_CLIENT_TOKEN_FILE=(path to your client token file)
```
If you don't have these, see ["Getting a client token"](https://github.com/ministryofjustice/noms-api-gateway#getting-a-client-token) in the [noms-api-gateway](https://github.com/ministryofjustice/noms-api-gateway) repo.

You'll also need the base URL of the environment you want to test against:
```bash
NOMIS_API_BASE_URL=https://(domain)/nomisapi/
```

...and some parameters for particular API methods
```bash
NOMIS_API_OFFENDER_ID=(valid offender ID - note this is not a NOMIS ID, but an offender_id)
NOMIS_API_PRISON_ID=(3 letter id of a valid prison - this can be any prison, does NOT need to be the prison that the offender_id above is in)
```

### Running the tests
From the root directory, type:
```ruby
> rspec
```

### Running tests for a specific release
Each released version of the API has its own directory of tests, under spec/
This allows you to run tests for particular versions against particular environments.

To run the tests for, say, version 1.6:
```ruby
> rspec spec/1.6
```

You can vary the deployed environment you are running against by providing different values for
NOMIS_API_BASE_URL (and NOMIS_API_CLIENT_TOKEN_FILE)


# Troubleshooting

### 'iat skew too large'
We do not yet have an NNTP server in the Quantum environment, hence time can drift on any of the VMs.
This can cause issues if the drift is more than 10s, as the API Gateway will check the 'iat' timestamp
in each request payload, and reject any that are outside the +/- 10s range.

To work around this, you can provide an environment variable NOMIS_API_IAT_FUDGE_FACTOR, set to a number of seconds (default is 0). This value will be added to your timestamp before generating the Bearer token.

For example, if you receive an error message that says:
```
iat skew too large (11)
```
- then the server time has drifted more than 10s into the past, and you should be able to workaround it
by providing a negative value for NOMIS_API_IAT_FUDGE_FACTOR like so:
```bash
> NOMIS_API_IAT_FUDGE_FACTOR=-5 rspec
```

# Running through Docker

A dockerfile is supplied to help you run the tests through docker, to build, from root directory, run:
```
docker build -t nomis-api-smoke-tests .
```

To run through the tests create an env variable file in the standard docker format (no need for `""`) with the non sensitive variables:
```
VARNAME=VALUE
VAR2=VALUE
```

The sensitive vars like TOKENS can be passed through the docker flag `-e 'TOKEN=FOO'`. Run the tests as described in [Running tests for a specific release](#running-tests-for-a-specific-release) through an interactive shell: `docker run -ti --env-file=.env -e TOKEN=abcdef nomis-api-smoke-tests bash`


