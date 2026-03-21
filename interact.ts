import {
  makeContractCall,
  broadcastTransaction,
  AnchorMode,
  stringAsciiCV,
  stringUtf8CV,
} from '@stacks/transactions';
import { StacksMainnet, StacksTestnet } from '@stacks/network';

// Toggle this based on your deployment network
// const network = new StacksMainnet();
const network = new StacksTestnet();

// REPLACE THESE VALUES
const senderKey = 'YOUR_PRIVATE_KEY_HERE'; // The private key of the sender/owner
const contractAddress = 'YOUR_CONTRACT_ADDRESS'; // e.g. ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM
const contractName = 'clarity-store';

/**
 * Call the `set-value` function to add a key-value pair to the store.
 */
async function setValue(key: string, value: string) {
  const txOptions = {
    contractAddress,
    contractName,
    functionName: 'set-value',
    functionArgs: [stringAsciiCV(key), stringUtf8CV(value)],
    senderKey,
    validateWithAbi: true,
    network,
    anchorMode: AnchorMode.Any,
  };

  console.log(`Setting value for key "${key}"...`);
  const transaction = await makeContractCall(txOptions);
  
  const broadcastResponse = await broadcastTransaction(transaction, network);
  console.log('Broadcast Response:', broadcastResponse);
}

/**
 * Main execution. Update this to test other functions.
 */
async function main() {
  console.log('Interacting with Clarity Store...');
  
  // Example usage:
  // Note: the key must be an ascii string max 64 chars
  // Note: the value must be a utf8 string max 256 chars
  await setValue('greeting', 'Hello World from Stacks.js!');
}

main().catch(console.error);
