import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DEFAULT_UNLOCK_TIME = Math.floor(Date.now() / 1000) + 300; // Default to 5 minutes from deployment
const DEFAULT_LOCKED_AMOUNT: bigint = 1_000_000_000_000_000_000n; // 1 ETH in wei

const TimeLockedWallet = buildModule("TimeLockedWallet", (m) => {
  // Define parameters with default values
  const unlockTime = m.getParameter("unlockTime", DEFAULT_UNLOCK_TIME);
  const lockedAmount = m.getParameter("lockedAmount", DEFAULT_LOCKED_AMOUNT);

  // Deploy the TimeLockedWallet contract with unlockTime and lockedAmount as constructor arguments
  const timeLockedWallet = m.contract("TimeLockedWallet", [unlockTime], {
    value: lockedAmount,
  });

  return { timeLockedWallet };
});

export default TimeLockedWallet;
