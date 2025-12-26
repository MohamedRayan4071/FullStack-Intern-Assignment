import 'package:task_manager_frontend/bloc/dto/task_dto.dart';

List<int> countStatus(List<TaskDTO> taskDTOs) {
  List<int> result = [0, 0 , 0];

  for (var task in taskDTOs) {
    if (task.status == "pending") {
      result[0] =(result.elementAt(0)) + 1;
    }
    else if(task.status == "in_progress") {
      result[1] =(result.elementAt(1)) + 1;
    }
    else if (task.status == "completed") {
      result[2] =(result.elementAt(2)) + 1;
    }
  }

  return result;
  
}