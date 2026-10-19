//
//  LiveBrewMutatingCommandFactory.swift
//  BrewCLI
//

import BrewCore
import Foundation

/// Production factory: a thin adapter over ``BrewCommands`` value builders.
public struct LiveBrewMutatingCommandFactory: BrewMutatingCommandFactory {
    public init() {}

    public func installCommand(kind: HomebrewPackageKind, name: String) -> BrewCommand {
        BrewCommands.install(name, kind: kind, forceBottle: forceBottleEnabled)
    }

    public func upgradeCommand(kind: HomebrewPackageKind, name: String) -> BrewCommand {
        BrewCommands.upgrade(name, kind: kind, forceBottle: forceBottleEnabled)
    }

    public func uninstallCommand(kind: HomebrewPackageKind, name: String) -> BrewCommand {
        BrewCommands.uninstall(name, kind: kind)
    }

    public func bulkUpgradeCommand(selection: BrewUpgradeSelection) -> BrewCommand {
        BrewCommands.bulkUpgrade(selection, forceBottle: forceBottleEnabled)
    }

    public func doctorFixCommand(arguments: [String]) -> BrewCommand {
        var arguments = arguments
        if forceBottleEnabled,
           let verb = arguments.first,
           ["install", "upgrade", "reinstall"].contains(verb),
           !arguments.contains("--cask"), !arguments.contains("--casks") {
            if !arguments.contains("--formula") {
                arguments.insert("--formula", at: 1)
            }
            if !arguments.contains("--bottle-only") {
                arguments.append("--bottle-only")
            }
        }
        return BrewCommands.doctorFix(arguments: arguments)
    }

    public func bundleDumpCommand(fileURL: URL) -> BrewCommand {
        BrewCommands.bundleDump(fileURL: fileURL)
    }

    private var forceBottleEnabled: Bool {
        UserDefaults.standard.bool(forKey: BrewCommands.forceBottlePreferenceKey)
    }
}
