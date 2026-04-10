import 'dart:convert';

class AppointmentModel {
  final String hospitalId;
  final String hospitalName;
  final String hospitalAddress;
  final String appointmentDate;
  final String appointmentTime;
  final String estimatedTime;
  final String tokenNumber;
  final String department;
  final String departmentName;
  final String patientName;
  final String? status;
  final String? patientId;
  // Live Queue Metrics
  final int? currentlyServing;
  final int? patientsAhead;
  final String? estimatedServiceTime;

  const AppointmentModel({
    required this.hospitalId,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.estimatedTime,
    required this.tokenNumber,
    required this.department,
    required this.departmentName,
    required this.patientName,
    this.status,
    this.patientId,
    this.currentlyServing,
    this.patientsAhead,
    this.estimatedServiceTime,
  });

  @override
  String toString() {
    return 'AppointmentModel( hospitalId: $hospitalId, hospitalName: $hospitalName, appointmentDate: $appointmentDate, department: $department, patientName: $patientName)';
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> data) {
    final hospitalDetails = data['hospitalDetails'] as Map<String, dynamic>?;
    
    return AppointmentModel(
      hospitalId: data['hospital_id'] ?? hospitalDetails?['_id'] ?? '',
      hospitalName: data['hospital_name'] ?? hospitalDetails?['name'] ?? '',
      hospitalAddress: data['hospital_address'] ??
          hospitalDetails?['address'] ??
          (hospitalDetails?['city'] != null
              ? '${hospitalDetails?['city']}, ${hospitalDetails?['district']}'
              : ''),
      appointmentDate: data['appointment_date'] ?? '',
      appointmentTime: data['appointment_time'] ?? '',
      estimatedTime: data['estimated_time']?.toString() ??
          data['estimated_service_time']?.toString() ??
          'Pending',
      tokenNumber: data['token_number']?.toString() ?? 'TBD',
      department: data['department'] ?? '',
      departmentName: data['department_name'] ?? data['department'] ?? '',
      patientName: data['patient_name'] ?? '',
      status: data['status'] as String?,
      patientId: data['patient_id'] as String?,
      currentlyServing: data['currently_serving'] is int
          ? data['currently_serving'] as int
          : int.tryParse(data['currently_serving']?.toString() ?? ''),
      patientsAhead: data['patients_ahead'] is int
          ? data['patients_ahead'] as int
          : int.tryParse(data['patients_ahead']?.toString() ?? ''),
      estimatedServiceTime: data['estimated_service_time']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hospital_id': hospitalId,
      'hospital_name': hospitalName,
      'hospital_address': hospitalAddress,
      'appointment_date': appointmentDate,
      'appointment_time': appointmentTime,
      'estimated_time': estimatedTime,
      'token_number': tokenNumber,
      'department': department,
      'department_name': departmentName,
      'patient_name': patientName,
      if (status != null) 'status': status,
      if (patientId != null) 'patient_id': patientId,
      if (currentlyServing != null) 'currently_serving': currentlyServing,
      if (patientsAhead != null) 'patients_ahead': patientsAhead,
      if (estimatedServiceTime != null) 'estimated_service_time': estimatedServiceTime,
    };
  }

  /// `dart:convert`
  factory AppointmentModel.fromJson(String data) {
    return AppointmentModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  String toJson() => json.encode(toMap());

  AppointmentModel copyWith({
    String? hospitalId,
    String? hospitalName,
    String? hospitalAddress,
    String? appointmentDate,
    String? appointmentTime,
    String? estimatedTime,
    String? tokenNumber,
    String? department,
    String? departmentName,
    String? patientName,
    String? status,
    String? patientId,
    int? currentlyServing,
    int? patientsAhead,
    String? estimatedServiceTime,
  }) {
    return AppointmentModel(
      hospitalId: hospitalId ?? this.hospitalId,
      hospitalName: hospitalName ?? this.hospitalName,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      department: department ?? this.department,
      departmentName: departmentName ?? this.departmentName,
      patientName: patientName ?? this.patientName,
      status: status ?? this.status,
      patientId: patientId ?? this.patientId,
      currentlyServing: currentlyServing ?? this.currentlyServing,
      patientsAhead: patientsAhead ?? this.patientsAhead,
      estimatedServiceTime: estimatedServiceTime ?? this.estimatedServiceTime,
    );
  }
}
