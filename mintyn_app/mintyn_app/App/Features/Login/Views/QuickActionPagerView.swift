import UIKit

protocol QuickActionPagerViewDelegate: AnyObject {
    func quickActionPagerView(_ pagerView: QuickActionPagerView, didChangePage page: Int)
}

final class QuickActionPagerView: UIView {
    struct Card {
        let title: String
        let subtitle: String?
        let iconSystemName: String
        let style: QuickActionButton.Style

        init(
            title: String,
            subtitle: String? = nil,
            iconSystemName: String,
            style: QuickActionButton.Style = .default
        ) {
            self.title = title
            self.subtitle = subtitle
            self.iconSystemName = iconSystemName
            self.style = style
        }
    }

    struct Page {
        let rows: [[Card?]]
    }

    weak var delegate: QuickActionPagerViewDelegate?

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private var pageViews = [UIView]()
    private var currentPage = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with pages: [Page]) {
        currentPage = min(currentPage, max(0, pages.count - 1))

        pageViews.forEach { $0.removeFromSuperview() }
        pageViews.removeAll()

        for page in pages {
            let pageView = makePageView(for: page)
            contentStackView.addArrangedSubview(pageView)
            pageViews.append(pageView)

            NSLayoutConstraint.activate([
                pageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
            ])
        }

        setPage(currentPage, animated: false)
    }

    func setPage(_ page: Int, animated: Bool) {
        guard !pageViews.isEmpty else { return }

        currentPage = max(0, min(page, pageViews.count - 1))
        let xOffset = CGFloat(currentPage) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: animated)
        delegate?.quickActionPagerView(self, didChangePage: currentPage)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard !pageViews.isEmpty else { return }
        let xOffset = CGFloat(currentPage) * scrollView.bounds.width
        if abs(scrollView.contentOffset.x - xOffset) > 0.5 {
            scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
        }
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = true

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .horizontal
        contentStackView.spacing = 0
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill

        addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 150),

            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }

    private func makePageView(for page: Page) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let rowsStackView = UIStackView()
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false
        rowsStackView.axis = .vertical
        rowsStackView.spacing = 14
        rowsStackView.alignment = .fill
        rowsStackView.distribution = .fillEqually

        for row in page.rows {
            rowsStackView.addArrangedSubview(makeRowView(for: row))
        }

        containerView.addSubview(rowsStackView)

        NSLayoutConstraint.activate([
            rowsStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            rowsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            rowsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            rowsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        return containerView
    }

    private func makeRowView(for cards: [Card?]) -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.spacing = 14
        rowStackView.alignment = .fill
        rowStackView.distribution = .fillEqually

        for card in cards {
            if let card {
                let button = QuickActionButton(
                    title: card.title,
                    subtitle: card.subtitle,
                    iconSystemName: card.iconSystemName,
                    style: card.style
                )
                rowStackView.addArrangedSubview(button)
            } else {
                let spacerView = UIView()
                spacerView.isUserInteractionEnabled = false
                rowStackView.addArrangedSubview(spacerView)
            }
        }

        return rowStackView
    }
}

extension QuickActionPagerView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentPage(using: scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateCurrentPage(using: scrollView)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentPage(using: scrollView)
    }

    private func updateCurrentPage(using scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }

        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        let normalizedPage = max(0, min(page, max(0, pageViews.count - 1)))
        guard normalizedPage != currentPage else { return }

        currentPage = normalizedPage
        delegate?.quickActionPagerView(self, didChangePage: currentPage)
    }
}
