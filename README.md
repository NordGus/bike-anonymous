# Bikes Anonymous

## Setup Environment
* Start development environment
    ```shell
    docker compose up dev
    ```
* Setup application's environment
    ```shell
    docker compose exec dev bin/setup
    ```
* Set `jwt_secret` credential
    ```shell
    rails credentials:edit
    ```
* Start development server
    1. Start bash session inside the container
        ```shell
        docker compose exec dev /bin/bash
        ```
    2. In the bash session run
       ```shell
       rails s -b 0.0.0.0
       ```
* Start sidekiq server
    ```shell
    docker compose exec dev bundle exec sidekiq
    ```

## Pending Upgrades

* Integrate an error service like Honeybadger, Airbrake, Rollbar, Bugsnag, Sentry, Exceptiontrap, Raygun, etc.
* Write better email notifications.
* Implement localizations for notifications and PDFs.