import {
  makeContractDeploy,
  broadcastTransaction,
  AnchorMode,
  ClarityVersion,
} from '@stacks/transactions';
import { StacksMainnet } from '@stacks/network';
import * as fs from 'fs';
import * as path from 'path';

// Using MAINNET configuration
const network = new StacksMainnet();

// =======================================================
// REPLACE WITH YOUR ACTUAL MAINNET SENDER PRIVATE KEY
const senderKey = 'REPLACE_ME_WITH_YOUR_PRIVATE_KEY';
// =======================================================

const contractName = 'clarity-store';

async function deployContract() {
  console.log(`Starting deployment script for ${contractName}...`);
  
  // Read the Clarity file from the /contracts folder
  const codeBody = fs.readFileSync(path.join(__dirname, 'contracts', 'clarity-store.clar'), 'utf8');

  // Prepare deployment transaction
  const txOptions = {
    contractName,
    codeBody,
    senderKey,
    network,
    anchorMode: AnchorMode.Any,
    clarityVersion: ClarityVersion.Clarity2, // Stacks 2.4/Nakamoto compliance
    // fee: 150000, // Optional: uncomment and adjust fee manually if network is congested
  };

  try {
    const transaction = await makeContractDeploy(txOptions);
    console.log('Transaction signed! Broadcasting...');

    const broadcastResponse = await broadcastTransaction(transaction, network);
    console.log('\n✅ Deployment Broadcast Response:');
    console.log(broadcastResponse);
    
    console.log('\nTrack it in the explorer:');
    console.log(`https://explorer.hiro.so/txid/${broadcastResponse.txid}?chain=mainnet`);
  } catch (err) {
    console.error('Deployment error:', err);
  }
}

deployContract();
