FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo '#!/bin/bash\n' \
    'echo "========================="\n' \
    'echo "🌐 Fetching Public IP 🌐"\n' \
    'echo "========================="\n' \
    'echo "Your Public IP Address:"\n' \
    'curl -s ifconfig.me\n' \
    'echo "\n========================="\n' \
    > /fetch_public_ip.sh

RUN chmod +x /fetch_public_ip.sh

CMD ["/bin/bash", "/fetch_public_ip.sh"]
