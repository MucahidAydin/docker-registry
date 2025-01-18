# Example: Using Docker Registry - Fetch Public IP with Docker

This Docker image fetches the **public IP address** of the container using `curl` and displays it in the terminal. It queries the `ifconfig.me` service to retrieve the public IP.

## Push to Registry

### Login to the registry:
```bash
docker login [registry_domain]
```
This command authenticates you with the Docker registry.

</br>

### Build and tag the image:
```bash
docker build --tag [registry_domain]/example -f Dockerfile .
```
This command builds the Docker image from the provided Dockerfile and tags it for your registry.

</br>

### Push the image to the registry:
```bash
docker push [registry_domain]/example
```
This command pushes the image to your Docker registry, making it available for others to pull.

</br>

### Check the registry for your image:
```bash
curl https://[registry_domain]/v2/_catalog
```
This command checks your registry’s catalog to verify if the image has been pushed successfully.

</br>

## Pull from Registry
To pull the image from the registry:
```bash
docker pull [registry_domain]/example
```
This command pulls the image from your Docker registry and allows you to run it locally.
