import { formatEther, parseEther } from "viem";
import hre from "hardhat";

const tokenAddress = '0x0000000000000000000000000000000000000000';
const nullAddress = '0x0000000000000000000000000000000000000000';

async function main() {
  const accounts = await hre.viem.getWalletClients();
  const publicClient = await hre.viem.getPublicClient();
  const sender = accounts[0];
  const receivers = [accounts[1], accounts[2]];
  const amounts = [parseEther('0.01'), parseEther('0.02')];
  console.log("balance of sender", formatEther(await publicClient.getBalance({address: sender.account.address})));
  // sent transaction
  // const hash = await sender.sendTransaction({
  //   to: receivers[0].account.address,
  //   value: parseEther("1"),
  // });
  // await publicClient.waitForTransactionReceipt({ hash });
  // if (tokenAddress != nullAddress) {
  //   const token = await hre.ethers.getContractAt('Token', tokenAddress);
  //   for (let i = 0; i < receivers.length; i++) {
  //     await token.connect(sender).transfer(receivers[i].address, amounts[i]);
  //   }
  // } else {
  //   for (let i = 0; i < receivers.length; i++) {
  //     await sender.call({ value: amounts[i] });
  //   }
  // }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
