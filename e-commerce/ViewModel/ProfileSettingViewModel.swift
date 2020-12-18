//
//  ProfileSettingViewModel.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/17/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

// MARK: - Model
struct Book {
    let title: String
}

extension Book: IdentifiableType {
    var identity: String {
        return title
    }
}

extension Book: Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.title == rhs.title
    }
    
    static func != (lhs: Book, rhs: Book) -> Bool {
        return lhs.title != rhs.title
    }
}

// MARK: - Service
protocol Api {
    func getBooks() -> Observable<[Book]>
    func deleteBook(_ book: Book) -> Single<Book>
}

class DummyApi: Api {
    
    let books = BehaviorRelay<[Book]>(value: [
        Book(title: "Book 1"),
        Book(title: "Book 2"),
        Book(title: "Book 3")
    ])
    
    func getBooks() -> Observable<[Book]> {
        return books.asObservable()
    }
    
    func deleteBook(_ book: Book) -> Single<Book> {
        return Observable<Int>
            .timer(.milliseconds(1500), scheduler: MainScheduler.instance)
            .map { _ in book }
            .asSingle()
            .do(onSuccess: { [unowned self] (deletedBook) in
                self.books.accept(self.books.value.filter { $0 != deletedBook })
            })
    }
}

enum BookCollectionAction {
    case collectionRefreshed(withBooks: [Book])
    case bookMarkedForDeletion(_ book: Book)
}

// MARK: - View model
class BooksViewModel {
    
    
    // MARK: Inputs
    let deleteCommand = PublishRelay<IndexPath>()
    
    
    // MARK: outputs
    let items: Observable<[Book]>
    
    
    private let disposeBag = DisposeBag()
    private let collectionActions = ReplaySubject<BookCollectionAction>.create(bufferSize: 1)
    
    init(api: Api = DummyApi()) {
        items = collectionActions.scan([], accumulator: { (currentBooks, action) -> [Book] in
            switch action {
            case .bookMarkedForDeletion(let book):
                return currentBooks.filter { $0 != book }
            case .collectionRefreshed(withBooks: let books):
                return books
            }
        })
        
        api.getBooks()
            .map { books -> BookCollectionAction in return .collectionRefreshed(withBooks: books) }
            .bind(to: collectionActions)
            .disposed(by: disposeBag)
        
        let bookMarkedForDeletion =  deleteCommand
            .withLatestFrom(items) { index, items in return items[index.row] }
            .share()
        
        bookMarkedForDeletion
            .map { book -> BookCollectionAction in return .bookMarkedForDeletion(book) }
            .bind(to: collectionActions)
            .disposed(by: disposeBag)

        bookMarkedForDeletion
            .flatMap(api.deleteBook)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
