"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TaskUtilities = void 0;
const common_1 = require("@nestjs/common");
const uuid_1 = require("uuid");
const category_keyword_1 = require("./predefined/category.keyword");
const priority_keyword_1 = require("./predefined/priority.keyword");
const action_keyword_1 = require("./predefined/action.keyword");
let TaskUtilities = class TaskUtilities {
    generateUUID() {
        return (0, uuid_1.v4)();
    }
    extractCategory(text) {
        if (!text)
            return 'general';
        text = text.toLowerCase();
        for (const [key, val] of category_keyword_1.categoryMap.entries()) {
            for (const keyword of val) {
                if (new RegExp(`\\b${keyword}\\b`, 'i').test(text))
                    return key;
            }
        }
        return 'general';
    }
    extractPriority(text) {
        if (!text)
            return 'low';
        text = text.toLowerCase();
        for (const [key, val] of priority_keyword_1.priorityMap.entries()) {
            for (const keyword of val) {
                if (new RegExp(`\\b${keyword}\\b`, 'i').test(text))
                    return key;
            }
        }
        return 'low';
    }
    extractDueDate(description) {
        if (!description)
            return null;
        const text = description.toLowerCase();
        const dateRegex = /\b(today|tomorrow|tonight|this week|next week|next month|monday|tuesday|wednesday|thursday|friday|saturday|sunday)\b/i;
        const numericDateRegex = /\b(\d{1,2}[\/\-]\d{1,2}(?:[\/\-]\d{2,4})?|\b\d{1,2}(?:st|nd|rd|th)?\s(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:t)?(?:ember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)(?:\s\d{4})?)\b/i;
        const match = description.match(dateRegex) || description.match(numericDateRegex);
        if (!match)
            return null;
        const phrase = match[1] || match[0];
        const now = new Date();
        const dayMs = 24 * 60 * 60 * 1000;
        switch (phrase.toLowerCase()) {
            case 'today':
                return now;
            case 'tomorrow':
                return new Date(now.getTime() + dayMs);
            case 'tonight':
                const tonight = new Date(now);
                tonight.setHours(20, 0, 0, 0);
                return tonight;
            case 'this week':
                return now;
            case 'next week':
                return new Date(now.getTime() + 7 * dayMs);
            case 'next month':
                const nextMonth = new Date(now);
                nextMonth.setMonth(now.getMonth() + 1);
                return nextMonth;
            default:
                const parsed = Date.parse(phrase);
                return isNaN(parsed) ? null : new Date(parsed);
        }
    }
    extractAssignedPerson(description) {
        if (!description)
            return null;
        const regex = /\b(?:assign(?:ed)?\s*to|with|by|for|to)\s+([A-Z][A-Za-z]+(?:\s[A-Z][A-Za-z]+){0,2})/;
        const match = description.match(regex);
        return match ? match[1].trim() : null;
    }
    extractDates(description) {
        if (!description)
            return [];
        const regex = /\b(today|tomorrow|tonight|this week|next week|next month|monday|tuesday|wednesday|thursday|friday|saturday|sunday|\d{1,2}[\/\-]\d{1,2}(?:[\/\-]\d{2,4})?|\d{1,2}(?:st|nd|rd|th)?\s(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:t)?(?:ember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)(?:\s\d{4})?)\b/gi;
        const matches = Array.from(description.matchAll(regex), (m) => m[1] || m[0]);
        return [...new Set(matches.map((d) => d.trim()))];
    }
    extractLocations(description) {
        if (!description)
            return [];
        const regex = /\b(?:at|in|near|from)\s+([A-Z][A-Za-z]+(?:\s[A-Z][A-Za-z]+)?)/g;
        const matches = Array.from(description.matchAll(regex), (m) => m[1].trim());
        return [...new Set(matches)];
    }
    extractActions(description) {
        if (!description)
            return [];
        const actions = action_keyword_1.actionVerbs.filter((verb) => new RegExp(`\\b${verb}\\b`, 'i').test(description));
        return [...new Set(actions)];
    }
    getSuggestedActions(category) {
        return (suggested_actions[category] ||
            suggested_actions['general'] ||
            []);
    }
    extractEntities(description) {
        return {
            assigned_to: this.extractAssignedPerson(description),
            dates: this.extractDates(description),
            locations: this.extractLocations(description),
            actions: this.extractActions(description),
        };
    }
};
exports.TaskUtilities = TaskUtilities;
exports.TaskUtilities = TaskUtilities = __decorate([
    (0, common_1.Injectable)()
], TaskUtilities);
const suggested_actions = {
    scheduling: ['Block calendar', 'Send invite', 'Prepare agenda', 'Set reminder'],
    finance: ['Check budget', 'Get approval', 'Generate invoice', 'Update records'],
    technical: ['Diagnose issue', 'Check resources', 'Assign technician', 'Document fix'],
    safety: ['Conduct inspection', 'File report', 'Notify supervisor', 'Update checklist'],
    general: ['Review task', 'Add notes', 'Set reminder'],
};
