---
agent: agent
---
{
  "project_context": {
    "app_name": "CityPulse",
    "description": "A smart city dashboard app for Turkcell Codenight. It visualizes mock city data (signal, traffic, environmental) and handles anomaly alerts.",
    "platform": "Flutter",
    "target_devices": ["iOS", "Android"],
    "backend_tech": "Python (Mock API)"
  },
  "design_system": {
    "branding": "Turkcell Corporate Identity",
    "color_palette": {
      "primary_blue": "#26377B",
      "primary_yellow": "#FFC900",
      "accent_blue": "#00A4E4",
      "background_color": "#F4F6F8",
      "surface_color": "#FFFFFF",
      "success_green": "#2ECC71",
      "alert_red": "#E74C3C",
      "text_primary": "#1A1A1A",
      "text_on_primary_blue": "#FFFFFF",
      "text_on_primary_yellow": "#26377B"
    },
    "typography": {
      "font_family": "Google Fonts (Roboto or Poppins)",
      "headers": "Bold, Primary Blue",
      "body": "Regular, Text Primary"
    },
    "ui_style": "Modern, Clean, Card-based Dashboard, High Contrast"
  },
  "architecture": {
    "pattern": "Feature-based Architecture",
    "state_management": "Riverpod",
    "navigation": "GoRouter or Flutter standard navigation",
    "folder_structure": [
      "lib/core/constants",
      "lib/core/theme",
      "lib/core/network",
      "lib/data/models",
      "lib/data/services",
      "lib/features/dashboard",
      "lib/features/map",
      "lib/features/alerts",
      "lib/features/feedback",
      "lib/widgets"
    ]
  },
  "dependencies": {
    "http_client": "dio",
    "state_management": "flutter_riverpod",
    "charts": "fl_chart",
    "maps": "flutter_map",
    "icons": "font_awesome_flutter",
    "layout": "percent_indicator, gap"
  },
  "api_contract": {
    "base_url": "http://127.0.0.1:5000 (localhost)",
    "endpoints": [
      {
        "method": "GET",
        "path": "/cities/{id}/summary",
        "response_fields": ["traffic_gb", "signal_strength", "air_quality", "paycell_transactions", "eco_score"]
      },
      {
        "method": "GET",
        "path": "/alerts",
        "response_fields": ["title", "message", "severity", "timestamp"]
      },
      {
        "method": "POST",
        "path": "/feedback",
        "body_fields": ["city_id", "user", "message", "category"]
      }
    ]
  },
  "tasks_for_ai": [
    "1. Initialize the Flutter project with the specified folder structure.",
    "2. Create a Theme file using the 'design_system' colors (Turkcell Blue #26377B and Yellow #FFC900).",
    "3. Create Data Models based on the 'api_contract' section.",
    "4. Set up a Dio client in 'core/network' to handle API requests.",
    "5. Create a Dashboard screen with dummy charts using fl_chart matching the design style."
  ]
}