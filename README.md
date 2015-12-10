# shadow-service
Update approved fields on the shadow device

[![Build Status](https://travis-ci.org/octoblu/shadow-service.svg?branch=master)](https://travis-ci.org/octoblu/shadow-service)
[![Code Climate](https://codeclimate.com/github/octoblu/shadow-service/badges/gpa.svg)](https://codeclimate.com/github/octoblu/shadow-service)
[![Test Coverage](https://codeclimate.com/github/octoblu/shadow-service/badges/coverage.svg)](https://codeclimate.com/github/octoblu/shadow-service)
[![npm version](https://badge.fury.io/js/shadow-service.svg)](http://badge.fury.io/js/shadow-service)
[![Gitter](https://badges.gitter.im/octoblu/help.svg)](https://gitter.im/octoblu/help)

## Update device config
`id` is the "real" device's uuid. Removes [OMITTED_FIELDS](/src/controllers/config-controller.coffee) from `POST` body.

```
  POST /config/:id
```
