# Kind example 

While playing around with kind  I run into the problem that container on with port 80 exposed can not be accessed via ingress executed on a mac.
For demonstration purposes I adapted the example on [kinds.sigs.k8s.io](https://kind.sigs.k8s.io/docs/user/ingress/).

The changes introduced are:

bar-app change the listen port to 80
```yaml
kind: Pod
apiVersion: v1
metadata:
  name: bar-app
  labels:
    app: bar
spec:
  containers:
  - name: bar-app
    image: hashicorp/http-echo:0.2.3
    args:
    - "-text=bar"
    - "-listen=:80"
```

bar-service change the listen and target port to 80
```yaml
kind: Service
apiVersion: v1
metadata:
  name: bar-service
spec:
  selector:
    app: bar
  ports:
  # Default port used by the image
  - port: 80
    targetPort: 80
```

cahnge the ingress configuration to connect to the bar-service on port 80
```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: example-ingress
spec:
  rules:
  - http:
      paths:
      - path: /foo
        backend:
          serviceName: foo-service
          servicePort: 5678
      - path: /bar
        backend:
          serviceName: bar-service
          servicePort: 80
```