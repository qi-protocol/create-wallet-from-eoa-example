# Create a simple wallet via SimpleWalletFactory.sol

## Steps

1. clone this repo via
```
git clone --recurse-submodules https://github.com/qi-protocol/create-wallet-sample
```

2. rename file and change private key
```
mv .secret.example .secret
```

3. build the repo
```
yarn install
forge build
```

4. run test
```
forge test -vv
```