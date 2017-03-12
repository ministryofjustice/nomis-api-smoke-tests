# nomis-api-smoke-tests
A non-exhaustive set of smoke tests to allow validation that a particular version of https://github.com/ministryofjustice/nomis-api has been deployed and is working on a given URL

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

These are smoke tests, designed to be performed against a genuine running instance of the API, for the purpose of verify
```bash
NOMIS_API_CLIENT_KEY_FILE=(path to your client private key file)
NOMIS_API_CLIENT_TOKEN_FILE=(path to your client token file - see )
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
