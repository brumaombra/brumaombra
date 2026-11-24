# Deployments

Deployments run in one dedicated thread that does nothing else. It's started the first time I ask to deploy, and every deploy request goes to it, with the environment to deploy to.