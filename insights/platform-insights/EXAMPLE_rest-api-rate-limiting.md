# Insight: REST API Rate Limiting Detection

**Date**: 2024-05-28  
**Category**: Platform  
**Subcategory**: REST-API-Rate-Limiting  
**Applies To**: REST APIs with rate limiting (HTTP 429 responses)  
**Applied To Agents**: module-worker, jira-ingestion-specialist  
**Severity**: Medium  

## The Problem

Module tests failed 5% of the time during parallel execution against REST APIs. 
HTTP 429 (Too Many Requests) responses were not handled, causing intermittent test failures 
that required manual retries.

## What We Learned

Modern REST APIs implement rate limiting to protect their infrastructure. When limits are 
exceeded, they return HTTP 429 status code along with a `Retry-After` header indicating 
how long to wait before retrying.

Previous approach:
- No 429 detection
- Fixed timeout values
- Manual retry required

## The Solution

Implement intelligent rate limit detection and exponential backoff:

1. Check for HTTP 429 status code in all API responses
2. Read `Retry-After` header (value in seconds)
3. If header is missing, default to 60 seconds
4. Use exponential backoff on subsequent retries: 60s → 120s → 240s
5. Maximum 3 retry attempts before failing

**Example Code Pattern**:

```python
import time
import requests

def call_api_with_retry(url, max_retries=3):
    backoff = 60
    
    for attempt in range(max_retries):
        response = requests.get(url)
        
        if response.status_code == 429:
            # Read retry-after header, default to backoff value
            retry_after = int(response.headers.get('Retry-After', backoff))
            
            print(f"Rate limited. Waiting {retry_after}s before retry...")
            time.sleep(retry_after)
            
            # Exponential backoff for next attempt
            backoff *= 2
            continue
            
        return response
    
    raise Exception("Max retries exceeded due to rate limiting")
```

**Agent Update Locations**:
- `module-worker.md`: Added rate limit handling to module testing phase
- `jira-ingestion-specialist.md`: Added retry logic for Jira API calls

## Impact

**Before**:
- Success rate: 95% (5% failures due to rate limiting)
- Manual intervention required: ~10 runs per month
- Wasted developer time: ~30 minutes per month

**After**:
- Success rate: 100%
- Manual intervention: 0
- Time saved: ~5 minutes per run (automatic retry vs manual restart)

## Applies To

This pattern applies to any platform using REST APIs with rate limiting:

**Cloud Platforms**:
- Azure Resource Manager API
- AWS API Gateway
- Google Cloud APIs

**Third-Party Services**:
- Jira REST API
- ServiceNow API
- GitHub API
- Slack API

**Custom Applications**:
- Any REST endpoint implementing rate limiting
- APIs behind API gateways (Kong, Apigee)
- Microservices with throttling

**Detection**: Look for HTTP 429 responses or rate limit errors in API documentation.

---

*This is an EXAMPLE insight file showing the format. Real insights will be written here by learning-evolution-specialist during actual runs.*
