import {
  makeContractCall,
  broadcastTransaction,
  AnchorMode,
  stringAsciiCV,
  uintCV,
} from '@stacks/transactions';
import { StacksMainnet, StacksTestnet } from '@stacks/network';

// Using MAINNET configuration since it's going to be on mainnet
const network = new StacksMainnet();
// Optional: If you ever want to revert to testnet:
// const network = new StacksTestnet();

// REPLACE THESE VALUES
const senderKey = 'YOUR_PRIVATE_KEY_HERE'; // The private key of the sender/owner
const contractAddress = 'YOUR_CONTRACT_ADDRESS'; // e.g. SP... (Your STX Mainnet Address)
const contractName = 'clarity-store';

/**
 * Call the `set-student` function to add a student's name and age to the store.
 */
async function setStudent(name: string, age: number) {
  const txOptions = {
    contractAddress,
    contractName,
    functionName: 'set-student',
    functionArgs: [stringAsciiCV(name), uintCV(age)],
    senderKey,
    validateWithAbi: true,
    network,
    anchorMode: AnchorMode.Any,
  };

  console.log(`Setting student record: Name: "${name}", Age: ${age}...`);
  const transaction = await makeContractCall(txOptions);
  
  const broadcastResponse = await broadcastTransaction(transaction, network);
  console.log('Broadcast Response:', broadcastResponse);
}

/**
 * Main execution.
 */
async function main() {
  console.log('Interacting with Student Clarity Store (MAINNET)...');
  
  // Example usage:
  // Note: the name must be an ascii string max 64 chars
  await setStudent('Alice', 20);
}

main().catch(console.error);
