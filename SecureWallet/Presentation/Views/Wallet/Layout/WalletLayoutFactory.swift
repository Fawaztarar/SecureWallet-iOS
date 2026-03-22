//
//  WalletLayout.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 20/03/2026.
//

import Foundation
import UIKit

final class WalletLayoutFactory{
    
//    static func makeLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { sectionIndex, _ in
//            
//            guard let section = WalletSection(rawValue: sectionIndex) else {
//                return nil
//            }
//            
//            switch section {
//            case .balance:
//                return balanceSection()
//            case .transactions:
//                return  transactionSection()
//            }
//            
//        }
//        
//    }
    
    static func makeLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            // Section 0 = balance
            if sectionIndex == 0 {
                return balanceSection()
            }
            
            // All others = transaction sections
            return transactionSection()
        }
    }
    
    
    
    private static func balanceSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(180))
    )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: item.layoutSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16)
        
        return section
    }
    
    private static func transactionSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(200) // dynamic card height
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: item.layoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 12 // ✅ spacing between cards
        
        section.contentInsets = .init(
            top: 8,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        
        
        // 🔥 Header
         let headerSize = NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1),
             heightDimension: .estimated(40)
         )
         
         let header = NSCollectionLayoutBoundarySupplementaryItem(
             layoutSize: headerSize,
             elementKind: UICollectionView.elementKindSectionHeader,
             alignment: .top
         )
         
         section.boundarySupplementaryItems = [header]
        
        return section
    }
}
