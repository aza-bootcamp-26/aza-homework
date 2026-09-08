//
//  SwiftUI Views
//
//  Module 06 Building iOS User Interfaces
//  Lab Exercise Build Two Views
//
//  SCENARIO
//  Our mobile app needs to help customers become familiar with
//  our products. Your task is to create two views using SwiftUI.
//  The first will display a list of products and the second will
//  display details for one product.
//
//  You can add these two views to an existing SwiftUI app or
//  start a new SwiftUI app to contain them.
//
//
//  REQUIREMENTS
//  1.  The Product class must contain the following properties:
//          - id is an Int
//          - name is a String
//          - productNumber is a String
//          - color is a String
//          - listPrice is a Double
//  2.  The ProductList view must use a NavigationStack to display
//      the list of Products. The name and color should be displayed
//  3.  The Products should be loaded via a Task. You should hard
//      code several products into the Product loading function.
//  4.  The application should display the ProductList view when
//      it first loads
//  5.  The ProductDetails view should display all of the properties
//      of one Product.
//  6.  Tapping on one of the Products in the list should navigate
//      to the details screen and also pass the selected Product
//      to be displayed.
//
//
//  DELIVERABLES
//
//  The Product class and both views should be committed to your
//  homework repo and pushed. You can define them all in one file
//  or define each in their own file, as you see fit.
//

import SwiftUI

// Product class
class Product: Identifiable, Hashable {
    
    var id: Int
    var name: String
    var productNumber: String
    var color: String
    var listPrice: Double
    
    init(id: Int, name: String, productNumber: String, color: String, listPrice: Double) {
        self.id = id
        self.name = name
        self.productNumber = productNumber
        self.color = color
        self.listPrice = listPrice
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

// ProductList view
struct ProductList: View {
    @State private var products: [Product] = []
    
    var body: some View {
        NavigationStack {
            List(products) { product in
                NavigationLink(product.name, value: product)
            }
            .navigationTitle("Our Products")
            .navigationDestination(for: Product.self) {
                selectedProduct in ProductDetails(product: selectedProduct)
            }
        }
        .task {
            loadData()
        }
    }
    
    func loadData() {
        products = [
            // example products
            Product(id: 0, name: "iPhone", productNumber: "39109876", color: "White", listPrice: 1_500.00),
            Product(id: 1, name: "MacBook Pro", productNumber: "29581209", color: "Jet Black", listPrice: 3_000.00),
            Product(id: 2, name: "iPad", productNumber: "291680290", color: "Cherry Red", listPrice: 1_999.99)
        ]
    }
}

// ProductDetails view
struct ProductDetails: View {
    var product: Product;
    
    var body: some View {
        VStack {
            Text(product.name)
                .font(.largeTitle)
            Text("Color: \(product.color)")
                .font(Font.title)
            Text(String(format: "$%.2f", product.listPrice))
                .font(Font.title)
            Text("Product ID: \(String(product.id))")
            Text("Product no. \(product.productNumber)")
        }
    }
}

#Preview {
    ProductList()
}
