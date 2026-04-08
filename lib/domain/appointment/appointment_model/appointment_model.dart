import 'dart:convert';

class AppointmentModel {
  final String? id;
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

  const AppointmentModel({
    this.id,
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
  });

  @override
  String toString() {
    return 'AppointmentModel(id: $id, hospitalId: $hospitalId, hospitalName: $hospitalName, appointmentDate: $appointmentDate, department: $department, patientName: $patientName)';
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> data) {
    return AppointmentModel(
      id: data['id'] as String?,
      hospitalId: data['hospital_id'] ?? data['hospitalId'] ?? '',
      hospitalName: data['hospital_name'] ?? data['hospitalName'] ?? 'Qflow Hospital',
      hospitalAddress: data['hospital_address'] ?? data['hospitalAddress'] ?? 'Hospital Address',
      appointmentDate: data['appointment_date'] ?? data['appointmentDate'] ?? '',
      appointmentTime: data['appointment_time'] ?? data['appointmentTime'] ?? '',
      estimatedTime: data['estimated_time'] ?? data['estimatedTime'] ?? 'Pending',
      tokenNumber: data['token_number']?.toString() ?? data['tokenNumber']?.toString() ?? 'TBD',
      department: data['department'] ?? '',
      departmentName: data['department_name'] ?? data['departmentName'] ?? data['department'] ?? 'General',
      patientName: data['patient_name'] ?? data['patientName'] ?? 'Patient',
      status: data['status'] as String?,
      patientId: data['patient_id'] ?? data['patientId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
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
    };
  }

  /// `dart:convert`
  factory AppointmentModel.fromJson(String data) {
    return AppointmentModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  String toJson() => json.encode(toMap());

  AppointmentModel copyWith({
    String? id,
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
  }) {
    return AppointmentModel(
      id: id ?? this.id,
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
    );
  }
}
