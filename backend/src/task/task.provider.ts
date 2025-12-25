import { Injectable } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid'
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
      if (val.some((keyword) => text.includes(keyword))) return key;
    }
    return 'general';
  }

  extractPriority(text: string): string {
    if (!text) return 'low';
    text = text.toLowerCase();

    for (const [key, val] of priorityMap.entries()) {
      if (val.some((keyword) => text.includes(keyword))) return key;
    }
    return 'low';
  }

  extractDueDate(description: string): Date | null {
    if (!description) return null;

    const dateRegex =
      /\b(today|tomorrow|tonight|this week|next week|monday|tuesday|wednesday|thursday|friday|saturday|sunday|\d{1,2}\s?(?:am|pm)|\b\d{1,2}(?:st|nd|rd|th)?\s(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)\b)/i;

    const match = description.match(dateRegex);
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
      case 'next week':
        return new Date(now.getTime() + 7 * dayMs);
      case 'this week':
        return now;
      default:
        const parsed = Date.parse(phrase);
        return isNaN(parsed) ? null : new Date(parsed);
    }
  }

  extractAssignedPerson(description: string): string | null {
    if (!description) return null;

    const regex =
      /\b(?:assign(?:ed)?\s*to|with|by|for|to)\s+([A-Z][A-Za-z]+(?:\s[A-Z][A-Za-z]+)*)/i;
    const match = description.match(regex);
    return match ? match[1] : null;
  }

  extractDates(description: string): string[] {
    if (!description) return [];
    const regex =
      /\b(today|tomorrow|tonight|this week|next week|monday|tuesday|wednesday|thursday|friday|saturday|sunday|\d{1,2}\s?(?:am|pm)|\b\d{1,2}(?:st|nd|rd|th)?\s(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)\b)/gi;
    return Array.from(description.matchAll(regex), (m) => m[1] || m[0]);
  }

  extractLocations(description: string): string[] {
    if (!description) return [];
    const regex = /\b(?:at|in)\s+([A-Za-z]+(?:\s[A-Za-z]+)?)/g;
    return Array.from(description.matchAll(regex), (m) => m[1]);
  }

  extractActions(description: string): string[] {
    if (!description) return [];
    return actionVerbs.filter((verb) =>
      new RegExp(`\\b${verb}\\b`, 'i').test(description),
    );
  }

  getSuggestedActions(category: CategoryKey): string[] {
    return (
      suggested_actions[category] ||
      suggested_actions['general'] ||
      []
    );
  }
}

const suggested_actions: Record<CategoryKey, string[]> = {
  scheduling: ['Block calendar', 'Send invite', 'Prepare agenda', 'Set reminder'],
  finance: ['Check budget', 'Get approval', 'Generate invoice', 'Update records'],
  technical: [
    'Diagnose issue',
    'Check resources',
    'Assign technician',
    'Document fix',
  ],
  safety: [
    'Conduct inspection',
    'File report',
    'Notify supervisor',
    'Update checklist',
  ],
  general: ['Review task', 'Add notes', 'Set reminder'],
};
