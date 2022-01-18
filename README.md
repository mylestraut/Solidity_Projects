# Solidity_Projects

Introduction:

These are my first solidity contracts written as part of the Patrick Collins FreeCodeCamp tutorial.
There is also a deploy.py file using web3.py to deploy the SimpleStorage.sol file to a local Ganache network.

Issues:
I had an issue where the chainlink imports did not want to work in my FundMe.sol file.
I changed the compiler version from >0.6.0 <= 0.9.0 to ^0.8.0 and it resolved the problem but now gives me a pragma error. My thinking is that if this file is compiled using a version 8 compiler in its own project it should work...

Thanks:
Thank you for taking the time to read through these contracts. Any and all feedback is much apreciated.
