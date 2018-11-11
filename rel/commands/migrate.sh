#!/bin/sh

release_ctl eval --mfa "Grain.ReleaseTasks.migrate/1" --argv -- "$@"
