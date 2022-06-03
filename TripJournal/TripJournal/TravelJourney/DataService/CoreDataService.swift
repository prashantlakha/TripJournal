import Foundation
import CoreData

class CoreDataService {
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "TravelJourney")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }
    
    func updateLocation() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    func deleteLocation(location: TJLocation) {
        persistentContainer.viewContext.delete(location)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context \(error)")
        }
    }
    
    func getAllLocations() -> [TJLocationComponentViewModel] {
        let fetchRequest: NSFetchRequest<TJLocation> = TJLocation.fetchRequest()
        do {
            let locations = try persistentContainer.viewContext.fetch(fetchRequest)
            let viewModels = locations.map { location -> TJLocationComponentViewModel in
                let mediaString = location.media
                var allMedia = [TJMedia]()
                if let mediaArray = mediaString?.components(separatedBy: ",") {
                    for med in mediaArray {
                        allMedia.append(TJMedia(med))
                    }
                }
                return TJLocationComponentViewModel(location.placeTitle ?? "", location.desc ?? "", location.address ?? "", location.latitude, location.longitude, allMedia)
            }
            return viewModels
        } catch {
            return [] 
        }
    }
    
    func saveLocation(title: String, desc: String, address: String, lat: Double, lng: Double, media: String) {
        let travel = TJLocation(context: persistentContainer.viewContext)
        travel.placeTitle = title
        travel.address = address
        travel.desc = desc
        travel.latitude = lat
        travel.longitude = lng
        travel.media = media
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save movie \(error)")
        }
    }
}
