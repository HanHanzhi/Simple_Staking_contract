## Install dependency

'''
yarn add --dev @nomiclabs/hardhat-ethers@npm:hardhat-deploy-ethers ethers @nomiclabs/hardhat-etherscan @nomiclabs/hardhat-waffle chai ethereum-waffle hardhat hardhat-contract-sizer hardhat-deploy hardhat-gas-reporter prettier prettier-plugin-solidity solhint solidity-coverage dotenv
'''

## Deploy Contract

'''
yarn hardhat run deploy/00-deploy-reward-token.js
'''

## Test

'''
yarn hardhat test
'''
