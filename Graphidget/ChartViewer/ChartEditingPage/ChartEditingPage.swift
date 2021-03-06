//
//  ChartEditingPage.swift
//  Graphidget
//
//  Created by 村松龍之介 on 2020/10/29.
//

import SwiftUI
import SharedObjects

struct ChartEditingPage: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = ChartEditingViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                typeSelection
                Form {
                    chartNameSection
                    itemSections
                    if viewModel.chartItems.count < 6 {
                        appendItemSection
                    }
                }
                registerSection
                    .background(Color(UIColor.systemGroupedBackground))
            }
            .navigationBarTitle("ChartEditingPage.title", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .frame(width: 44, height: 44, alignment: .center)
                }),
                trailing: EditButton()
            )
        }
    }

    private var typeSelection: some View {
        Picker("", selection: $viewModel.chartType) {
            Text("ChartEditingPage.percentage")
                .tag(ChartModel.ValueType.percentage)
            Text("ChartEditingPage.currency")
                .tag(ChartModel.ValueType.currency)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }

    private var chartNameSection: some View {
        Section(header: Text("ChartEditingPage.chartName.header")) {
            TextField("ChartEditingPage.chartName.placeholder", text: $viewModel.chartName)
                .multilineTextAlignment(.trailing)
        }
    }

    private var itemSections: some View {
        ForEach(viewModel.chartItems.indices, id: \.self) { index in
            // なぜか数値だとLocalizeできないのでStringに変換している
            Section(header: Text("ChartEditingPage.item.header \(String(index.advanced(by: 1)))")) {
                HStack {
                    Text("ChartEditingPage.item.name.title").bold()
                    TextField("ChartEditingPage.item.name.placeholder", text: $viewModel.chartItems[index].name)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("ChartEditingPage.item.value.title").bold()
                    TextField("ChartEditingPage.item.value.placeholder", text: $viewModel.chartItems[index].value)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                    Text(viewModel.chartType.suffix)
                        .foregroundColor(Color(.placeholderText))
                        .bold()
                }
            }
        }
        .onDelete(perform: viewModel.delete)
    }

    private var appendItemSection: some View {
        Section {
            Button(action: {
                viewModel.appendEntryField()
            }, label: {
                HStack {
                    Spacer()
                    Image(systemName: "plus.circle")
                    Text("ChartEditingPage.appendItem.button").multilineTextAlignment(.center)
                    Spacer()
                }
            })
        }
    }

    private var registerSection: some View {
        Button(action: {
            viewModel.saveChart { result in
                switch result {
                case .success:
                    presentationMode.wrappedValue.dismiss()
                case .failure:
                    break
                }
            }
        }, label: {
            HStack {
                Spacer()
                Text("ChartEditingPage.create.button")
                    .bold()
                    .foregroundColor(Color(UIColor.systemBackground))
                Spacer()
            }
        })
        .padding()
        .background(Color.accentColor)
        //        .clipShape(Capsule())
        .cornerRadius(.infinity, corners: [.topLeft, .topRight])
        .disabled(viewModel.chartName.isEmpty)
    }
}

struct ChartEditingPage_Previews: PreviewProvider {
    static var viewModel: ChartEditingViewModel {
        let viewModel = ChartEditingViewModel()

        viewModel.chartName = ""
        viewModel.chartItems = [ChartEntry()]

        return viewModel
    }
    static var previews: some View {
        Group {
            ChartEditingPage(viewModel: viewModel)
            ChartEditingPage(viewModel: viewModel)
                .environment(\.colorScheme, .dark)
        }
    }
}
