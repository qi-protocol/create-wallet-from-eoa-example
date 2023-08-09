# Create a simple wallet via SimpleWalletFactory.sol

clone this repo via

```
git clone --recurse-submodules https://github.com/qi-protocol/create-wallet-sample
```

build the repo
```
yarn install
forge build
```

change private key
```
mv .secret.example .secret
```

run test
```
forge test -vv
```