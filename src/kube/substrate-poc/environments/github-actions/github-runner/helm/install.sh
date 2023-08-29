helm upgrade --install --namespace actions-runner-system --create-namespace\
  --set=authSecret.create=true\
  --set=authSecret.github_token=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\
  --wait actions-runner-controller actions-runner-controller/actions-runner-controller