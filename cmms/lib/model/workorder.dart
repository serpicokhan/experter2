class WorkOrder {
  final int id;
  final String problem;
  final String asset;
  final DateTime dueDate;
  final String maintenanceType;
  final String status;
  final String priority;

  WorkOrder({
    required this.id,
    required this.problem,
    required this.asset,
    required this.dueDate,
    required this.maintenanceType,
    required this.status,
    required this.priority,
  });
}