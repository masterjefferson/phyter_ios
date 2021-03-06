//
// Created by Jefferson Jones on 5/29/17.
// Copyright (c) 2017 Jefferson Jones. All rights reserved.
//

import Foundation
import RxSwift

class ObserveInstrumentMeasurementsArgs: UseCaseArgs {
  let instrumentId: UUID
  
  init(instrumentId: UUID) {
    self.instrumentId = instrumentId
  }
}

class ObserveInstrumentMeasurementsUpdate: UseCaseUpdate {
  let liveQuery: MeasurementLiveQuery
  
  init(_ liveQuery: MeasurementLiveQuery) {
    self.liveQuery = liveQuery
  }
}

class ObserveInstrumentMeasurements:
    MeasurementRepositoryOngoingUseCase<ObserveInstrumentMeasurementsArgs, ObserveInstrumentMeasurementsUpdate, UseCaseResult> {
  
  var querySubs: Disposable?
  
  open override func execute(
      _ args: ObserveInstrumentMeasurementsArgs?,
      onUpdate: @escaping (ObserveInstrumentMeasurementsUpdate) -> Void,
      onSuccess: @escaping (UseCaseResult) -> Void,
      onError: @escaping (Error) -> Void) {
    guard let id = args?.instrumentId else {
      onError(UseCaseError.argsRequired)
      return
    }
    terminate()
    querySubs = repo.measurements(forInstrumentId: id).subscribe(onNext: {
      query in
      onUpdate(ObserveInstrumentMeasurementsUpdate(query))
    })
  }
  
  open override func terminate() {
    querySubs?.dispose()
  }
}
