import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicles_response_entity.dart';

abstract class SupervisorRemoteDatasource {
  Future<VehiclesResponseEntity> getVehicles({required int page, required int limit});
}
