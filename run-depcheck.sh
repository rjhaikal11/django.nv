services:
  - docker:dind       # To run all jobs in this pipeline, use a docker image that contains a docker daemon running inside (dind - docker in docker). Reference: https://forum.gitlab.com/t/why-services-docker-dind-is-needed-while-already-having-image-docker/43534

stages:
  - build
  - test
  - release
  - preprod
  - integration
  - prod

build:
  stage: build
  script:
    - echo "This is a build step"

test:
  stage: test
  script:
    - echo "This is a test step"

odc-backend:
  stage: test
  image: gitlab/dind:latest
  script:
    - chmod +x ./run-depcheck.sh
    - mkdir -p reports
    # Note: The Docker volume mount in run-depcheck.sh persists the report file from container to host.
    # The output redirection here captures script logs to stdout for artifact collection.
    - ./run-depcheck.sh > reports/dependency-check-report.json
  artifacts:
    paths:
      - reports/dependency-check-report.json
    when: always
    expire_in: one week

integration:
  stage: integration
  script:
    - echo "This is an integration step"
    - exit 1
  allow_failure: true # Even if the job fails, continue to the next stages

prod:
  stage: prod
  script:
    - echo "This is a deploy step."
  when: manual # Continuous Delivery