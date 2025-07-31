# Simple Specs Example

## How It Works

The orchestrator finds your existing specs and tells the AI agents to follow them. That's it.

## Example 1: Simple Requirements

**File**: `requirements.md` (in your project root)
```markdown
# Project Requirements

- Use React with TypeScript
- 90% test coverage minimum
- All PRs need approval before merge
- Deploy to staging first, then production
```

## Example 2: User Stories  

**File**: `stories/checkout.md`
```markdown
# Checkout Flow

As a customer, I want to:
- Add items to cart
- Review my order
- Pay securely 
- Get confirmation email

Must handle:
- Invalid payment methods
- Out of stock items
- Promo codes
```

## Example 3: Technical Specs

**File**: `specs/api.md`
```markdown
# API Requirements

## Authentication
- JWT tokens for all requests
- 30 minute timeout
- Role-based permissions

## Performance
- < 200ms response time
- Rate limit: 100 req/min per user
- Cache frequently accessed data
```

## Result

Agents automatically:
- ✅ Follow your requirements
- ✅ Implement your user stories  
- ✅ Meet your technical specs
- ✅ Use your existing structure

**No configuration needed. Just works.**