function ctop
    docker run \
        --rm \
        -it \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        quay.io/vektorlab/ctop:latest
end

