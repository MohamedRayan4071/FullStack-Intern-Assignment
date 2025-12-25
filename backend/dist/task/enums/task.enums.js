"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Status = exports.Priority = exports.Category = void 0;
var Category;
(function (Category) {
    Category["Scheduling"] = "scheduling";
    Category["Finance"] = "finance";
    Category["Technical"] = "technical";
    Category["Safety"] = "safety";
    Category["General"] = "general";
})(Category || (exports.Category = Category = {}));
var Priority;
(function (Priority) {
    Priority["High"] = "high";
    Priority["Medium"] = "medium";
    Priority["Low"] = "low";
})(Priority || (exports.Priority = Priority = {}));
var Status;
(function (Status) {
    Status["Pending"] = "pending";
    Status["InProgress"] = "in_progress";
    Status["Completed"] = "completed";
})(Status || (exports.Status = Status = {}));
