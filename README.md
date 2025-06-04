# Tokenized Insurance Crop Yield Protection

A comprehensive blockchain-based crop insurance system built on Stacks using Clarity smart contracts. This system provides automated, transparent, and efficient crop insurance through tokenization and smart contract automation.

## 🌾 Overview

The Tokenized Insurance Crop Yield Protection system consists of five interconnected smart contracts that work together to provide comprehensive crop insurance coverage:

1. **Farmer Verification Contract** - Validates and manages farmer registrations
2. **Yield Monitoring Contract** - Tracks expected vs actual crop yields
3. **Weather Integration Contract** - Integrates weather data for risk assessment
4. **Claim Automation Contract** - Automates insurance claim processing
5. **Risk Pooling Contract** - Manages risk distribution among participants

## 🏗️ Architecture

### Contract Interactions

\`\`\`
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Farmer          │    │ Yield           │    │ Weather         │
│ Verification    │◄──►│ Monitoring      │◄──►│ Integration     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
│                       │                       │
│                       ▼                       │
│              ┌─────────────────┐              │
└─────────────►│ Claim           │◄─────────────┘
│ Automation      │
└─────────────────┘
│
▼
┌─────────────────┐
│ Risk            │
│ Pooling         │
└─────────────────┘
\`\`\`

## 📋 Features

### Farmer Management
- Farmer registration and verification
- Farm details and crop type tracking
- Verification status management

### Yield Monitoring
- Expected yield recording
- Actual yield tracking via oracles
- Yield loss percentage calculation
- Season-based monitoring

### Weather Integration
- Weather event recording (drought, flood, hail, frost, hurricane)
- Location-based risk scoring
- Severity and duration tracking
- Oracle-verified weather data

### Automated Claims
- Automatic claim filing based on yield loss
- Weather-based claim qualification
- Automated approval/rejection logic
- Instant payout processing

### Risk Pooling
- Decentralized risk distribution
- Stake-based participation
- Reward distribution system
- Multi-pool participation

## 🚀 Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd tokenized-crop-insurance
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Deploy contracts to testnet:
   \`\`\`bash
   clarinet deploy --testnet
   \`\`\`

## 📖 Usage

### For Farmers

1. **Register as a farmer:**
   \`\`\`clarity
   (contract-call? .farmer-verification register-farmer
   "John Doe"
   "Iowa, USA"
   u100
   "Corn")
   \`\`\`

2. **Record expected yield:**
   \`\`\`clarity
   (contract-call? .yield-monitoring record-expected-yield
   u1
   u5000)
   \`\`\`

3. **File a claim:**
   \`\`\`clarity
   (contract-call? .claim-automation file-claim
   u1
   u2024
   u1
   u30
   u7)
   \`\`\`

### For Risk Pool Participants

1. **Join a risk pool:**
   \`\`\`clarity
   (contract-call? .risk-pooling join-pool
   u1
   u1000)
   \`\`\`

2. **Check pool status:**
   \`\`\`clarity
   (contract-call? .risk-pooling get-pool u1)
   \`\`\`

## 🧪 Testing

Run the test suite:
\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract deployment
- Farmer registration and verification
- Yield recording and monitoring
- Weather event integration
- Claim processing automation
- Risk pool operations

## 📊 Contract Details

### Error Codes

| Contract | Error Code | Description |
|----------|------------|-------------|
| Farmer Verification | 100-103 | Unauthorized, exists, not found, invalid data |
| Yield Monitoring | 200-203 | Unauthorized, invalid yield, not found, not verified |
| Weather Integration | 300-302 | Unauthorized, invalid data, not found |
| Claim Automation | 400-404 | Unauthorized, exists, not found, invalid, insufficient funds |
| Risk Pooling | 500-504 | Unauthorized, insufficient stake, not found, already staked, not staked |

### Data Structures

Each contract maintains specific data maps for efficient storage and retrieval:
- Farmers: Registration and verification data
- Yields: Expected vs actual yield records
- Weather: Event data and risk scores
- Claims: Filing, processing, and payout records
- Pools: Stake distribution and participant management

## 🔒 Security

- All administrative functions require contract owner authorization
- Input validation on all public functions
- Proper error handling and assertions
- Oracle verification for external data

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

## 🗺️ Roadmap

- [ ] Mobile app integration
- [ ] Advanced weather oracle integration
- [ ] Multi-token support
- [ ] Cross-chain compatibility
- [ ] Advanced analytics dashboard
- [ ] Automated premium calculation
- [ ] Satellite imagery integration

