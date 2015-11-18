# team-device-service
Update approved fields on the team device

[![Build Status](https://travis-ci.org/octoblu/team-device-service.svg?branch=master)](https://travis-ci.org/octoblu/team-device-service)
[![Code Climate](https://codeclimate.com/github/octoblu/team-device-service/badges/gpa.svg)](https://codeclimate.com/github/octoblu/team-device-service)
[![Test Coverage](https://codeclimate.com/github/octoblu/team-device-service/badges/coverage.svg)](https://codeclimate.com/github/octoblu/team-device-service)
[![npm version](https://badge.fury.io/js/team-device-service.svg)](http://badge.fury.io/js/team-device-service)
[![Gitter](https://badges.gitter.im/octoblu/help.svg)](https://gitter.im/octoblu/help)

## Update device config
`id` is the "real" device's uuid. Removes [OMITTED_FIELDS](/octoblu/team-device-service/tree/master/src/controllers/config-controller.coffee) from `POST` body.

```
  POST /config/:id
```
