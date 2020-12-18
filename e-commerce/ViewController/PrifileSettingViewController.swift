//
//  PrifileSettingViewController.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/17/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfBooks {
    var header: String?
    var items: [Book]
}

extension SectionOfBooks: AnimatableSectionModelType {
    typealias Item = Book
    
    var identity: String { return self.header ?? "SectionOfBooks" }
    
    init(original: SectionOfBooks, items: [Book]) {
        self = original
        self.items = items
    }
}

fileprivate func createDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionOfBooks> {
    return RxTableViewSectionedAnimatedDataSource(
        animationConfiguration: AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .left),
        configureCell:{ (ds, tableView, indexPath, book) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = book.title
            return cell
        },
        canEditRowAtIndexPath: { _, _ in true }
    )
}

class TestView: UIView {
    let tableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        add(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class PrifileSettingViewController: UIViewController {
    
    let cView = TestView()
    var tableView: UITableView!
    
    let dataSource = createDataSource()
    let disposeBag = DisposeBag()
    var viewModel: BooksViewModel!
    
    override func loadView() {
        view = cView
        tableView = cView.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = BooksViewModel()
        
        viewModel.items
            .map { books in [SectionOfBooks(header: "My books", items: books)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .bind(to: viewModel.deleteCommand)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: viewModel.deleteCommand)
            .disposed(by: disposeBag)
    }
    
}
