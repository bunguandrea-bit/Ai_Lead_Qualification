# AI Lead Qualification

> n8n workflow that receives a lead through a webhook, extracts structured data with an LLM, scores it with transparent rules and stores it in PostgreSQL.

## The problem

Small businesses receive leads from several channels and qualify them by hand: who is serious, how big is the budget, how urgent is the request. This workflow does the first pass automatically and returns a priority (`ALTO` / `MEDIUM` / `LOW`) that sales can sort by.

## How it works

```
POST /webhook/api/leads
  -> Validation (required fields, email format, budget >= 0)
       |-- invalid -> HTTP 400 with the list of errors
       '-- valid
            -> LLM extraction (gpt-4o-mini): intent, estimated budget,
               company size, urgency, business needs, summary
            -> JSON parsing / normalisation
            -> Rule-based scoring
            -> PostgreSQL insert (idempotent)
            -> HTTP 200
```

**Design choices**

- The LLM only *extracts*; it never decides the priority. The prompt forbids inventing budget or urgency (unknown values must be `null` / `"unknown"`).
- Scoring is deterministic and easy to explain to a client: budget up to 40 points (>= 5000: 40, >= 3000: 30, >= 1000: 20, below: 10) plus urgency up to 30 points (high 30, medium 20, low 10). Total >= 60 is `HIGH`, 30-59 is `MEDIUM`, below 30 is `LOW`.
- Inserts use `ON CONFLICT (transaction_hash) DO NOTHING` so repeated submissions do not create duplicates.

## Run it locally

```bash
cp .env.example .env        # set your own passwords / encryption key
docker compose up -d        # n8n on :5678, PostgreSQL with schema.sql applied
```

1. Open http://localhost:5678 and import `workflow/ai_lead_qualification.json`.
2. Create the credentials the workflow needs: an OpenAI API key and a PostgreSQL connection (host `postgres`, values from your `.env`).
3. Activate the workflow and send a test lead:

```bash
curl -X POST http://localhost:5678/webhook/api/leads \
  -H "Content-Type: application/json" \
  -d @examples/input.json
```

## Repository content

| Path | Purpose |
|------|---------|
| `workflow/ai_lead_qualification.json` | n8n workflow export (credentials removed) |
| `schema.sql` | `leads` table |
| `docker-compose.yml` | n8n + PostgreSQL |
| `examples/input.json` | sample webhook payload |

## Known limitations and roadmap

This is an MVP. What it does not do yet:

- No retry or error branch when the LLM returns invalid JSON; the flow still reaches the database step with an error object.
- The lead hash is built from name + email + company, so the same person cannot submit a second, different message.
- Query parameters are passed as a comma-separated string, which breaks if a text field contains a comma. Switching to an array is planned.
- No CRM sync or notifications yet (Slack/email alert for `HIGH` leads is the next step).
- Validation messages and some comments are in Italian.

## Tech stack

n8n, PostgreSQL 16, OpenAI API (gpt-4o-mini), JavaScript (Code nodes), Docker Compose.
