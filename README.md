# Product CRUD App

A cross-platform (Flutter) application for managing products with a SQL Server backend.

## Related Projects

- [Product API (Node.js Backend)](https://github.com/Ithnoobs/product-api)

## Features

- Product list with infinite scrolling, search, and sort (name, price, stock)
- Add, edit, and delete products, with full data validation and error handling
- Confirmation dialogs for deletion
- Export single product to **CSV** or **PDF** (Syncfusion)
- State management using Provider
- Supports desktop (Windows/Linux) and mobile

## Setup

1. Clone this repo.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Make sure your backend API (see [product-api](https://github.com/Ithnoobs/product-api)) is running and accessible.
4. Configure API endpoint if needed (edit `lib/services/api_service.dart`).
5. Run the app:
   ```bash
   flutter run
   ```

## Export Feature

- You can export any product as a CSV or a professional PDF file from the product details screen.

## Build for Desktop

- Windows and Linux supported via CMake. See platform-specific directories for more info.

## License

MIT