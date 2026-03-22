# Clarity Store Deployment

A standalone project to deploy the `clarity-store` contract and interact with it.

## Deployment with Clarinet

1. Make sure you have [Clarinet](https://github.com/hirosystems/clarinet) installed.
2. Initialize or verify the setup:

```bash
clarinet check
```

3. Deploy using Clarinet on a local, devnet, testnet, or mainnet using standard clarinet commands.

For devnet testing:
```bash
clarinet console
# Once inside, you can interact with clarity-store functions:
>> (contract-call? .clarity-store set-value "test" u"testing123")
>> (contract-call? .clarity-store get-value "test")
```

For deploying to an actual network (for example, Devnet/Testnet):
```bash
clarinet deployment generate-plan --devnet
clarinet deployment apply --devnet
```
*(adjust `--devnet` to `--testnet` or `--mainnet` as necessary)*

## Direct Deployment (Alternative to Clarinet)

If `clarinet deployment apply --mainnet` fails with a `RecvError` or panic, you can use the Stacks.js deployment script provided.

### Configuration
1. Open `deploy.ts`.
2. Replace `REPLACE_ME_WITH_YOUR_PRIVATE_KEY` with your actual STX Mainnet private key (not the mnemonic).

### Run Deployment
```bash
npm run deploy
```

## Interaction using Node.js

We provide a TypeScript script `interact.ts` for you to interact with your deployed contract directly using the `@stacks.js` libraries.

### Setup

1. Install dependencies:
```bash
npm install
```

### Configure Script

Open `interact.ts` and update the following placeholders:
- `senderKey`: the private key of the account owning the contract.
- `contractAddress`: the address of the contract that was deployed.
- `network`: by default it's configured for testnet, toggle it to mainnet if on mainnet.

### Run Script

```bash
npm start
```

