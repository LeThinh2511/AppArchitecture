import UIKit
import KooberUIKit
import KooberKit
import RxSwift

enum CellIdentifier: String {
    
    case cell
}

class DropoffLocationPickerContentRootView: NiblessView {
    
    // MARK: - Properties
    let viewModel: DropoffLocationPickerViewModel
    let disposeBag = DisposeBag()
    
    var searchResults = BehaviorSubject<[NamedLocation]>(value: [])
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.cell.rawValue)
        tableView.insetsContentViewsToSafeArea = true
        tableView.contentInsetAdjustmentBehavior = .automatic
        return tableView
    }()
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: DropoffLocationPickerViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: frame)
        
        addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.searchResults
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected view model search results observable error.") })
            .drive(searchResults)
            .disposed(by: disposeBag)
        
        searchResults
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected search results observable error.") })
            .drive(onNext: { [weak self] _ in self?.tableView.reloadData() })
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
}

extension DropoffLocationPickerContentRootView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            return try searchResults.value().count
        } catch {
            fatalError("Error reading value from search results subject.")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        do {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.cell.rawValue)
            cell?.textLabel?.text = try searchResults.value()[indexPath.row].name
            return cell!
        } catch {
            fatalError("Error reading value from search results subject.")
        }
    }
}

extension DropoffLocationPickerContentRootView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let selectedLocation = try searchResults.value()[indexPath.row]
            viewModel.select(dropoffLocation: selectedLocation)
        } catch {
            fatalError("Error reading value from search results subject.")
        }
    }
}
