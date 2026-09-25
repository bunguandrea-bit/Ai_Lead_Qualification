# AI Lead Qualification System

> Automated lead analysis and qualification using n8n,
> PostgreSQL and LLMs.

## Overview

This workflow automatically processes incoming leads,
analyzes their intent and assigns a priority score.

## Problem

Small businesses often receive leads through multiple
channels and manually evaluate them before contacting them.

This workflow automates the initial qualification process.

## Architecture

Webhook
→ Validation
→ AI Analysis
→ Lead Scoring
→ PostgreSQL
→ CRM
→ Notification

## Features

- Webhook-based lead ingestion
- Input validation
- LLM-powered lead analysis
- Structured JSON output
- Rule-based lead scoring
- PostgreSQL persistence
- CRM integration
- Error handling
- Notifications

## Example

Input:

workflow/Input/input.json

Output:

workflow/Input/input.json

## Tech Stack

- n8n
- PostgreSQL
- OpenAI API
- REST APIs
- JavaScript
- Webhooks

## Workflow

[architecture image]

## Future Improvements

- Email ingestion
- CRM synchronization
- Analytics dashboard
- Automatic follow-up generation
