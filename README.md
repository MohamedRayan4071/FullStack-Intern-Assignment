Smart Task Manager:
-------------------

Smart Task Manager is a full-stack application that helps users create, organize, and manage tasks intelligently. The system automatically analyzes the task content to determine its category, priority, and due date — making it more than just a to-do list.

Example: “Fix server issue by tomorrow” is automatically classified as:

Category: Technical
Priority: High
Due Date: Tomorrow
Overview
This project was built to demonstrate a complete workflow — from backend data processing to a mobile frontend — for a smart, automated task system.

The app allows users to:

    i) Create, edit, and delete tasks
    ii) Automatically detect category, priority, and due date from text
    iii) View progress by task status (Pending, In Progress, Completed)
    iv) Filter tasks by category or priority
    v) Get suggestions for next actions based on the type of task
    vi) The backend is powered by NestJS, while the frontend uses Flutter for a clean, modern mobile experience.

Features:

    Pull-to-refresh
    Offline indicator
    Form validation
    Responsive layout
    Backend: (NestJS)
    Framework: NestJS (Node.js + TypeScript) 
    Database: PostgreSQL with TypeORM Environment Variables: Managed via dotenv Validation: Class-Validator and Class-Transformer

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

API Endpoints:

    POST /api/tasks – Create new task 
    GET /api/tasks – Retrieve all tasks 
    GET /api/tasks/:id – Get specific task by id
    PATCH /api/tasks/:id – Update existing task
    DELETE /api/tasks/:id – Remove a task
    POST /api/tasks/auto-gen-data - Get the auto generated classification data for comfirmation

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Utility Services:

    i) Keyword-based category and priority detection
    ii) Extraction of dates, assigned persons, and locations
    iii) Generating suggested actions

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Technologies Used:

    Backend: Node.js (Nest.js framework)
    Database: Supabase (PostgreSQL)
    Frontend: Flutter
    Hosting: Vercel

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Folder Structure:

    project/
    │
    ├── backend/
    │   ├── src/
    │   ├── dist/
    │   ├── package.json
    │   └── vercel.json
    │
    └── frontend/
        ├── lib/
        ├── assets/
        ├── pubspec.yaml
        └── build/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Setup Instructions:

    Backend:
    
        cd backend
        npm install
        npm run start:dev

    Frontend:
    
        cd frontend
        flutter pub get
        flutter run

    Build for Production:
    
        npm run build         
        flutter build apk

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Highlights:

    1) Smart text-based task classification and prioritization
    2) Organized backend structure with NestJS modules and services
    3) Clean and responsive Flutter UI using Material Design 3
    4) Centralized state management with BLoC
    4) End-to-end workflow from API to mobile app
    5) Scalable codebase for future features
    6) CI/CD automation for deployment

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Hosted on: (Vercel)

    https://full-stack-intern-assignment.vercel.app/

Android build application:(download apk from the below given drive link)

    https://drive.google.com/drive/folders/1TBujrTzAXVOFbZJnyutLYhKw4YK3Fvdj?usp=drive_link

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Author: Mohamed Rayan

GitHub: @mohamedrayan4071
