# FinView Lite - Investment Insights Dashboard

A sleek and modern Flutter investment dashboard that provides a comprehensive view of your portfolio with interactive charts, real-time data visualization, and dark mode support.

## Features

### Core Features
- **Portfolio Summary**: View total portfolio value, gain/loss with percentage calculations
- **Holdings Management**: Detailed view of individual holdings with units, average cost, and current price
- **Asset Allocation Chart**: Interactive pie chart showing portfolio distribution
- **Returns Toggle**: Switch between percentage and amount views for gains/losses
- **Sorting Options**: Sort holdings by value, gain, or name
- **Responsive Design**: Optimized for both mobile and web platforms

### Bonus Features
- **Dark Mode**: Toggle between light and dark themes with preference persistence
- **Mock Login**: Secure login flow with shared preferences for session management
- **Price Refresh**: Simulate real-time price updates (±2% random variation)
- **Smooth Animations**: Polished UI transitions and interactive elements
- **Error Handling**: Graceful handling of empty data and edge cases

## Tech Stack

- **Flutter SDK**: ^3.6.0
- **Dependencies**:
  - `fl_chart: 0.68.0` - Beautiful and interactive charts
  - `shared_preferences: ^2.0.0` - Local data persistence
  - `intl: 0.20.2` - International formatting for currency and dates
  - `google_fonts: ^6.1.0` - Custom typography

## Design Approach

**Sophisticated Monochrome** - Perfect for finance applications

### Light Mode
- Pure white backgrounds (#FFFFFF)
- Soft blue-grey cards (#F8FAFC)
- Subtle borders (#E8EDF2)
- Teal accent for interactions (#06B6D4)
- Green for gains (#10B981), Red for losses (#EF4444)

### Dark Mode
- Deep blue-charcoal backgrounds (#0F1419)
- Elevated card surfaces (#1A1F26)
- Defined borders (#2A3340)
- Cyan accent for interactions (#22D3EE)
- Green for gains (#34D399), Red for losses (#F87171)

## Setup Instructions

### Prerequisites
- Flutter SDK 3.6.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- iOS Simulator (for macOS) or Android Emulator

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd project
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup**
   ```bash
   flutter doctor
   ```

4. **Run the app**
   
   For mobile:
   ```bash
   flutter run
   ```
   
   For web:
   ```bash
   flutter run -d chrome
   ```

5. **Build**
   
   Android:
   ```bash
   flutter build apk --debug
   ```

## Project Structure

```
lib/
├── main.dart                           # App entry point with auth check & theme setup
├── theme.dart                          # App-wide light & dark theme configuration

├── models/
│   ├── holding.dart                    # Represents each stock/holding
│   └── portfolio.dart                  # Portfolio model & total calculations

├── services/
│   ├── auth_service.dart               # Handles mock login & user session
│   ├── portfolio_service.dart          # Loads portfolio.json & refreshes prices
│   └── dashboard_service.dart          # Manages filters & sorting preferences

├── screens/
│   ├── login_screen.dart               # Reads name from JSON & logs in
│   └── dashboard_screen.dart           # Main dashboard view & data handling

└── widgets/
    ├── dashboard_widgets.dart          # Sort/filter chips & reusable UI
    ├── portfolio_summary_card.dart     # Shows total value & gain/loss
    ├── holding_card.dart               # Displays each stock holding
    ├── allocation_chart.dart           # Pie chart for allocations
    └── dark_mode_toggle.dart           # Light/Dark mode toggle


assets/
├── icons/
│   └── icon.png                        # Used for app icon & splash screen
└── portfolio.json                      # Mock user & portfolio data

Screenshots/                            # 📸 For documentation only (not included in app)
├── Light Mode/
├── Dark Mode/
└── Demo Video/
```

## Mock Data Format

The app uses a JSON file (`assets/portfolio.json`) for mock data:

```json
{
  "user": "Aarav Patel",
  "portfolio_value": 150000,
  "total_gain": 12000,
  "holdings": [
    {
      "symbol": "TCS",
      "name": "Tata Consultancy Services",
      "units": 5,
      "avg_cost": 3200,
      "current_price": 3400
    }
  ]
}
```

## Features Walkthrough

### 1. Login Screen
- Simple mock authentication
- Session persists across app restarts

### 2. Dashboard
- **Header**: Displays username with refresh and dark mode controls
- **Portfolio Summary**: Large card showing total value and gains
- **Allocation Chart**: Interactive pie chart with touch feedback
- **Controls Panel**: Toggle returns view and sort options
- **Holdings List**: Detailed cards for each investment

### 3. Interactive Features
- **Refresh Button**: Simulates price updates with ±2% variation
- **Sort Chips**: Sort by Value, Gain, or Name
- **Returns Toggle**: Switch between percentage (%) and amount (₹) view
- **Dark Mode**: Persistent theme preference

## Error Handling

The app gracefully handles:
- Empty portfolio scenarios
- Missing or invalid JSON data
- Network delays (simulated)
- Zero investment edge cases
- Invalid login attempts

## Testing

Run the test suite:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## Performance Considerations

- Efficient state management with StatefulWidget
- Lazy loading of portfolio data
- Optimized chart rendering with fl_chart
- Minimal rebuilds using keys and const constructors
- Responsive overflow handling

## Future Enhancements

- Real-time stock market API integration
- Transaction history tracking
- Investment recommendations
- Push notifications for price alerts
- Multi-portfolio support
- Export portfolio reports as PDF

## Screenshots

*Add screenshots here showing:*
- Login screen (light & dark)
   ![Image Alt](https://github.com/rohanshirodker/FinView-Lite-App/blob/f1c22e833e729982ec2c15795ce603fbd24bfcbd/Screenshots/Light%20mode/Light%20-%20Login%20screen.jpg) ![Image Alt](https://github.com/rohanshirodker/FinView-Lite-App/blob/f1c22e833e729982ec2c15795ce603fbd24bfcbd/Screenshots/Dark%20mode/Dark%20-%20Login%20screen.jpg)
- Dashboard with portfolio summary
  ![Image Alt](https://github.com/rohanshirodker/FinView-Lite-App/blob/f1c22e833e729982ec2c15795ce603fbd24bfcbd/Screenshots/Light%20mode/Light%20-%20Dashboard%20with%20portfolio%20summary.jpg)   ![Image Alt](https://github.com/rohanshirodker/FinView-Lite-App/blob/f1c22e833e729982ec2c15795ce603fbd24bfcbd/Screenshots/Dark%20mode/Dark%20-%20Dashboard%20with%20portfolio%20summary.jpg)
- Allocation chart interaction
 ![image_url](https://github.com/rohanshirodker/FinView-Lite-App/blob/f1c22e833e729982ec2c15795ce603fbd24bfcbd/Screenshots/Light%20mode/Light%20-%20Full%20Dashboard.jpg)
- Holdings list with sorting
  ![image_url](https://github.com/rohanshirodker/FinView-Lite-App/blob/f1c22e833e729982ec2c15795ce603fbd24bfcbd/Screenshots/Light%20mode/Light%20-%20Holdings%20list%20with%20sorting.jpg)
- Mobile and web responsive views

  

## Demo Video

*Link to screen recording demonstrating:*
https://github.com/rohanshirodker/FinView-Lite-App/blob/f1c22e833e729982ec2c15795ce603fbd24bfcbd/Screenshots/Demo%20Video/Demo%20Video.mp4
- Login flow
- Dashboard navigation
- Chart interactions
- Refresh functionality
- Dark mode toggle
- Responsive behavior




---

**Note**: This is a demonstration project using mock data. No real financial transactions or data are processed.
