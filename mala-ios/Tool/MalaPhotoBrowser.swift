//
//  MalaPhotoBrowser.swift
//  mala-ios
//
//  Created by 王新宇 on 3/24/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

private let MalaPhotoBrowserCellReuseID = "MalaPhotoBrowserCellReuseID"

open class MalaPhotoBrowser: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, SKPhotoBrowserDelegate {

    // MARK: - Property
    var imageURLs: [String] = [] {
        didSet {
            // 加载图片对象, 刷新视图
            images.removeAll()
            for imageURL in imageURLs {
                let image = SKPhoto.photoWithImageURL(imageURL)
                image.shouldCachePhotoURLImage = true
                images.append(image)
            }
            collectionView.reloadData()
        }
    }
    /// 图片对象
    var images: [SKPhoto] = [SKPhoto]()
    /// 相册
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: MalaPhotoBrowserFlowLayout())
        return collectionView
    }()
    
    
    // MARK: - Life Cycle
    override open func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupUserInterface()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private Method
    private func configure() {
        title = "老师相册"
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MalaPhotoBrowserCell.self, forCellWithReuseIdentifier: MalaPhotoBrowserCellReuseID)
    }
    
    private func setupUserInterface() {
        // Style
        collectionView.backgroundColor = MalaColor_EDEDED_0
        
        // SubViews
        view.addSubview(collectionView)
        
        // Autolayout
        collectionView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(view.snp_size)
            make.center.equalTo(view.snp_center)
        }
    }
    
    
    // MARK: - DataSource
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MalaPhotoBrowserCellReuseID, for: indexPath) as! MalaPhotoBrowserCell
        cell.imageURL = imageURLs[(indexPath as NSIndexPath).row]
        return cell
    }
    
    
    // MARK: - Delegate
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? MalaPhotoBrowserCell else {
            return
        }
        
        guard let originImage = cell.contentImageView.image else {
            return
        }
        
        /// 图片浏览器
        let browser = SKPhotoBrowser(originImage: originImage, photos: images, animatedFromView: cell)
        browser.initializePageIndex((indexPath as NSIndexPath).row)
        browser.delegate = self
        browser.statusBarStyle = nil
        browser.displayAction = false
        browser.bounceAnimation = false
        browser.displayDeleteButton = false
        browser.displayBackAndForwardButton = false
        
        present(browser, animated: true, completion: {})
    }

}


open class MalaPhotoBrowserFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Instance Method
    override init() {
        super.init()
        
        scrollDirection = .vertical
        let itemCountInRow: CGFloat = 3
        let itemMargin: CGFloat = 10
        let itemWidth: CGFloat = (MalaScreenWidth - itemMargin*(itemCountInRow+1))/itemCountInRow
        let itemHeight: CGFloat = (MalaScreenWidth - itemMargin*(itemCountInRow+1))/itemCountInRow
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        minimumInteritemSpacing = itemMargin
        minimumLineSpacing = itemMargin
        sectionInset = UIEdgeInsetsMake(itemMargin, itemMargin, itemMargin, itemMargin)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


open class MalaPhotoBrowserCell: UICollectionViewCell {
    
    // MARK: - Property
    /// 当前Cell图片URL
    var imageURL: String = "" {
        didSet {
            contentImageView.ma_setImage(URL(string: imageURL) ?? URL())
        }
    }
    
    
    // MARK: - Components
    /// 图片视图
    private lazy var contentImageView: UIImageView = {
        let contentImageView = UIImageView.placeHolder()
        contentImageView.image = UIImage(named: "detailPicture_placeholder")
        return contentImageView
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // SubViews
        contentView.addSubview(contentImageView)
        
        // Autolayout
        contentImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(contentView.snp_center)
            make.size.equalTo(contentView.snp_size)
        }
    }
}
