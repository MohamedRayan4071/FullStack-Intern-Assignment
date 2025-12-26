import { Injectable } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { categoryMap } from './predefined/category.keyword';
import { priorityMap } from './predefined/priority.keyword';
import { actionVerbs } from './predefined/action.keyword';
import { CategoryKey } from './predefined/category.type';

@Injectable()
export class TaskUtilities {
  generateUUID(): string {
    return uuidv4();
  }

  extractCategory(text: string): string {
    if (!text) return 'general';
    text = text.toLowerCase();

    for (const [key, val] of categoryMap.entries()) {
      for (const keyword of val) {
        if (new RegExp(`\\b${keyword}\\b`, 'i').test(text)) return key;
      }
    }
    return 'general';
  }

  extractPriority(text: string): string {
    if (!text) return 'low';
    text = text.toLowerCase();

    for (const [key, val] of priorityMap.entries()) {
      for (const keyword of val) {
        if (new RegExp(`\\b${keyword}\\b`, 'i').test(text)) return key;
      }
    }
    return 'low';
  }

  extractDueDate(description: string): Date | null {
    if (!description) return null;
    const text = description.toLowerCase();


    const dateRegex =
      /\b(today|tomorrow|tonight|this week|next week|next month|monday|tuesday|wednesday|thursday|friday|saturday|sunday)\b/i;

    const numericDateRegex =
      /\b(\d{1,2}[\/\-]\d{1,2}(?:[\/\-]\d{2,4})?|\b\d{1,2}(?:st|nd|rd|th)?\s(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:t)?(?:ember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)(?:\s\d{4})?)\b/i;

    const match = description.match(dateRegex) || description.match(numericDateRegex);
    if (!match) return null;

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

  extractAssignedPerson(description: string): string | null {
    if (!description) return null;
    const regex =
      /\b(?:assign(?:ed)?\s*to|with|by|for|to)\s+([A-Z][A-Za-z]+(?:\s[A-Z][A-Za-z]+){0,2})/;
    const match = description.match(regex);
    return match ? match[1].trim() : null;
  }

  extractDates(description: string): string[] {
    if (!description) return [];
    const regex =
      /\b(today|tomorrow|tonight|this week|next week|next month|monday|tuesday|wednesday|thursday|friday|saturday|sunday|\d{1,2}[\/\-]\d{1,2}(?:[\/\-]\d{2,4})?|\d{1,2}(?:st|nd|rd|th)?\s(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:t)?(?:ember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)(?:\s\d{4})?)\b/gi;

    const matches = Array.from(description.matchAll(regex), (m) => m[1] || m[0]);
    return [...new Set(matches.map((d) => d.trim()))];
  }

  extractLocations(description: string): string[] {
    if (!description) return [];
    const regex = /\b(?:at|in|near|from)\s+([A-Z][A-Za-z]+(?:\s[A-Z][A-Za-z]+)?)/g;
    const matches = Array.from(description.matchAll(regex), (m) => m[1].trim());
    return [...new Set(matches)];
  }

  extractActions(description: string): string[] {
    if (!description) return [];
    const actions = actionVerbs.filter((verb) =>
      new RegExp(`\\b${verb}\\b`, 'i').test(description),
    );
    return [...new Set(actions)];
  }

  getSuggestedActions(category: CategoryKey): string[] {
    return (
      suggested_actions[category] ||
      suggested_actions['general'] ||
      []
    );
  }

  extractEntities(description: string) {
    return {
      assigned_to: this.extractAssignedPerson(description),
      dates: this.extractDates(description),
      locations: this.extractLocations(description),
      actions: this.extractActions(description),
    };
  }
}


const suggested_actions: Record<CategoryKey, string[]> = {
  scheduling: ['Block calendar', 'Send invite', 'Prepare agenda', 'Set reminder'],
  finance: ['Check budget', 'Get approval', 'Generate invoice', 'Update records'],
  technical: ['Diagnose issue', 'Check resources', 'Assign technician', 'Document fix'],
  safety: ['Conduct inspection', 'File report', 'Notify supervisor', 'Update checklist'],
  general: ['Review task', 'Add notes', 'Set reminder'],
};
