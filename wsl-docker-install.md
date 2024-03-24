# Add SSH-identity

https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04-de

- `ssh-keygen`

# WSL2-Config
- Create file in `C:/USERS/[USER]/.wslconfig`

> <pre>
>[wsl2]
>swap=1G
>memory=8G
>
>localhostForwarding=true
>dnsTunneling=true
>networkingMode=NAT
>
>[experimental]
>hostAddressLoopback=true
>autoMemoryReclaim=gradual
> </pre>

