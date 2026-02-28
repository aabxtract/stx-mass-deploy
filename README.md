# STX Mass Deploy

> A hands-on experiment in mass-deploying Clarity smart contracts on the Stacks blockchain — built to learn the ropes of contract deployment, tooling, and security fundamentals.

---

## Overview

This project is a **learning-focused initiative** to explore the end-to-end process of deploying smart contracts at scale on the [Stacks](https://www.stacks.co/) blockchain. By mass-deploying 100 simple Clarity contracts, the goal is to deeply understand:

- **Clarinet tooling** — project setup, deployment plans, and configuration
- **Transaction mechanics** — batching, fees, nonce management, and anchor blocks
- **Mainnet deployment workflows** — from local development to live chain execution
- **Stacks security protocols** — how the network validates, processes, and secures smart contract deployments

## Project Structure

```
stx-mass-deploy/
├── Clarinet.toml                          # Project manifest — defines which contracts are active
├── contracts/                             # 100 Clarity smart contracts (create1.clar – create100.clar)
│   ├── create1.clar
│   ├── create2.clar
│   └── ...
├── deployments/
│   └── default.mainnet-plan.yaml          # Mainnet deployment plan with batched transactions
├── settings/
│   ├── Mainnet.toml                       # Mainnet configuration (node URLs, deployer wallet)
│   ├── Testnet.toml                       # Testnet configuration
│   ├── Devnet.toml                        # Local devnet configuration
│   └── Simnet.toml                        # Simulation network configuration
├── generate-contracts.ps1                 # PowerShell script to generate all 100 contracts
├── generate-testnet-plan.ps1              # PowerShell script to generate testnet deployment plan
└── README.md
```

## Contracts

Each contract is a minimal Clarity smart contract that stores and retrieves a unique number. This simplicity is intentional — the focus here is on **deployment mechanics**, not contract complexity.

```clarity
;; Example: create42.clar
(define-data-var storedNumber uint u42)

(define-read-only (get-number)
  (var-get storedNumber)
)

(define-public (set-number (newNumber uint))
  (begin
    (var-set storedNumber newNumber)
    (ok newNumber)
  )
)
```

##  Quick Start

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) installed
- A funded STX wallet (mnemonic configured in `settings/Mainnet.toml`)
- PowerShell (for contract generation scripts)

### 1. Generate Contracts

```powershell
.\generate-contracts.ps1
```

This creates 100 Clarity contracts in the `contracts/` directory, each with a unique stored number.

### 2. Configure Deployment

Edit `Clarinet.toml` to include only the contracts you want to deploy. Each contract entry looks like:

```toml
[contracts.create42]
path = "contracts/create42.clar"
clarity_version = 2
epoch = 2.4
```

### 3. Set Up Your Wallet

Configure your deployer wallet in `settings/Mainnet.toml`:

```toml
[accounts.deployer]
mnemonic = "your twelve word seed phrase goes here"
balance = 2038000
```

> **Never commit real mnemonics to a public repository.** This project is for learning only.

### 4. Deploy to Mainnet

```powershell
clarinet deployments apply --mainnet
```

Clarinet will display the deployment plan, total cost, and estimated duration before asking for confirmation.

## Stacks Security Protocols — Key Learnings

### Proof of Transfer (PoX)

Stacks uses a unique consensus mechanism called **Proof of Transfer**, where STX miners commit Bitcoin to mine Stacks blocks. This anchors Stacks' security directly to Bitcoin's proof-of-work, making it one of the most secure smart contract platforms.

### Post-Conditions

Clarity's **post-conditions** are a powerful security feature that protect users by asserting what a transaction *should* do. If the conditions aren't met, the entire transaction reverts. This prevents unexpected token transfers and rug-pull scenarios at the protocol level.

### Clarity Language Security

Clarity is **decidable** — you can always know what a contract will do before executing it. Key security properties include:

| Feature | Description |
|---|---|
| **No re-entrancy** | Clarity prevents re-entrancy attacks by design |
| **No unbounded loops** | All loops must have known bounds, preventing infinite execution |
| **Published source code** | All deployed contracts have their source visible on-chain |
| **Decidability** | Contract behavior can be fully analyzed before execution |
| **No EVM-style overflow** | Arithmetic operations are checked and safe by default |

### Transaction Security

During mass deployment, several security mechanisms are observed:

- **Nonce sequencing** — Each transaction from an account must have a sequential nonce, preventing replay attacks
- **Anchor block confirmation** — Contracts are deployed with `anchor-block-only: true` to ensure they are confirmed in Bitcoin-anchored blocks for maximum security
- **Fee estimation** — The network requires minimum fees to prevent spam; too-low fees result in transaction rejection
- **Batch processing** — Clarinet batches transactions across multiple blocks to avoid mempool congestion

### Network Validation

Every contract deployment goes through:

1. **Syntax validation** — The Clarity code is parsed and validated
2. **Type checking** — All types are verified at deployment time (not runtime)
3. **Cost analysis** — Execution costs are calculated and bounded
4. **Consensus inclusion** — The transaction is included in a block through PoX consensus

## Deployment Notes

### Cost Breakdown

- **Per contract cost:** ~1,000 microSTX (0.001 STX)
- **50 contracts total cost:** ~0.050 STX
- **Deployment duration:** ~2 Stacks blocks (batched across 2 block windows)

### Lessons Learned

1. **Batch size matters** — Clarinet splits transactions into batches to fit within block limits. Too many contracts in one batch can lead to failures.
2. **Fee sensitivity** — Setting fees too low (e.g., default estimates) can cause `unable to post transaction` errors. A cost of `1000` microSTX per contract works reliably.
3. **Incremental deployment** — When deployments partially fail, remove already-deployed contracts from `Clarinet.toml` and the deployment plan before retrying.
4. **Nonce management** — Failed transactions can consume nonces, requiring careful tracking when redeploying.

##  Resources

- [Stacks Documentation](https://docs.stacks.co/)
- [Clarity Language Reference](https://docs.stacks.co/clarity/language-overview)
- [Clarinet Documentation](https://docs.hiro.so/clarinet)
- [Stacks Explorer](https://explorer.stacks.co/)
- [Proof of Transfer Whitepaper](https://www.stacks.co/pox)

##  License

This project is for educational purposes. Use at your own risk on mainnet.

---

*Built with curiosity, deployed with Clarinet.* 
