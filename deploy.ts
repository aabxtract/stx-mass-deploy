import {
  makeContractDeploy,
  broadcastTransaction,
  AnchorMode,
  ClarityVersion,
} from '@stacks/transactions';
import { StacksMainnet } from '@stacks/network';
import { generateWallet, deriveAccount } from '@stacks/wallet-sdk';
import * as fs from 'fs';
import * as path from 'path';

// Using MAINNET configuration
const network = new StacksMainnet();

const contractName = 'clarity-store';

/**
 * Extract mnemonic from Mainnet.toml
 */
function getMnemonicFromConfig(): string | null {
  const configPath = path.join(__dirname, 'settings', 'Mainnet.toml');
  if (!fs.existsSync(configPath)) return null;
  const content = fs.readFileSync(configPath, 'utf8');
  const match = content.match(/mnemonic\s*=\s*"([^"]+)"/);
  return match ? match[1] : null;
}

async function deployContract() {
  console.log(`Starting automated deployment for ${contractName}...`);
  
  const mnemonic = getMnemonicFromConfig();
  if (!mnemonic) {
    console.error('Error: Mnemonic not found in settings/Mainnet.toml');
    process.exit(1);
  }

  // Derive the private key from the mnemonic
  const wallet = await generateWallet({ mnemonic, password: '' });
  const account = deriveAccount({
    hierarchicalDeterministicWallet: wallet,
    index: 0,
  });
  const senderKey = account.stxPrivateKey;

  console.log('Private key derived successfully!');

  // Read the Clarity file from the /contracts folder
  const codeBody = fs.readFileSync(path.join(__dirname, 'contracts', 'clarity-store.clar'), 'utf8');

  // Prepare deployment transaction
  const txOptions = {
    contractName,
    codeBody,
    senderKey,
    network,
    anchorMode: AnchorMode.Any,
    clarityVersion: ClarityVersion.Clarity2,
  };

  try {
    const transaction = await makeContractDeploy(txOptions);
    console.log('Transaction signed! Broadcasting...');

    const broadcastResponse = await broadcastTransaction(transaction, network);
    console.log('\n✅ Deployment Broadcast Response:');
    console.dir(broadcastResponse, { depth: null });
    
    if (broadcastResponse.txid) {
      console.log('\nTrack it in the explorer:');
      console.log(`https://explorer.hiro.so/txid/${broadcastResponse.txid}?chain=mainnet`);
    } else {
      console.error('Broadcast failed or no TXID returned.');
    }
  } catch (err) {
    console.error('Deployment error:', err);
  }
}

deployContract();
