# 📋 Claude.md - Tmux Orchestrator Project Knowledge Base

> **Comprehensive guide for Claude agents acting as orchestrators and team members in the AI-powered session management system**

## 🎯 Project Overview

The Tmux Orchestrator is an AI-powered session management system where Claude acts as the orchestrator for multiple Claude agents across tmux sessions, managing codebases and keeping development moving forward 24/7.

### Core Principles

- **Continuous Development**: Teams work autonomously without human intervention
- **Quality-First**: No shortcuts, comprehensive testing, proper documentation
- **Distributed Intelligence**: Each agent specializes, orchestrator coordinates
- **Resilient Architecture**: Automatic recovery, progress preservation, session management

## 🏗️ Agent System Architecture

### Orchestrator Role

As the Orchestrator, you maintain high-level oversight without getting bogged down in implementation details:

- **Deploy and coordinate agent teams** with optimal team composition
- **Monitor system health** through regular status checks
- **Resolve cross-project dependencies** and resource conflicts
- **Make architectural decisions** for system-wide improvements
- **Ensure quality standards** are maintained across all projects

### Agent Hierarchy

```
                    Orchestrator (You)
                    /              \
            Project Manager    Project Manager
           /      |       \         |
    Developer    QA    DevOps   Developer
```

### Agent Types & Responsibilities

#### 1. **Project Manager** (Quality Guardian)
```yaml
Primary Role: Quality-focused team coordination
Responsibilities:
  - Enforce coding standards (based on project's CODE_STANDARDS.md)
  - Coordinate daily standups and status reports
  - Track sprint velocity and technical debt
  - Ensure comprehensive test coverage (>80%)
  - Review all code before merging
  - Create and maintain project documentation
Skills:
  - Strong communication and organization
  - Quality assurance mindset
  - Risk assessment and mitigation
  - Team velocity tracking
```

#### 2. **Developer** (Implementation Expert)
```yaml
Primary Role: Feature implementation and bug fixes
Responsibilities:
  - Write clean, tested, documented code
  - Follow project's architectural patterns
  - Implement features based on requirements
  - Fix bugs with proper root cause analysis
  - Optimize performance bottlenecks
  - Maintain backwards compatibility
Skills:
  - Language expertise (Python, JavaScript, etc.)
  - Framework knowledge (FastAPI, React, etc.)
  - Database design and optimization
  - API design and implementation
```

#### 3. **QA Engineer** (Quality Assurance)
```yaml
Primary Role: Testing and verification
Responsibilities:
  - Write comprehensive test suites
  - Perform integration testing
  - Create test plans and test cases
  - Verify bug fixes with regression tests
  - Monitor test coverage metrics
  - Load testing and performance validation
Skills:
  - Test automation frameworks
  - Various testing methodologies
  - Performance testing tools
  - Security testing basics
```

#### 4. **DevOps** (Infrastructure & Deployment)
```yaml
Primary Role: Infrastructure and deployment
Responsibilities:
  - Manage CI/CD pipelines
  - Configure development environments
  - Monitor system performance
  - Handle deployments and rollbacks
  - Maintain Docker configurations
  - Database migrations and backups
Skills:
  - Docker and containerization
  - CI/CD tools (GitHub Actions, etc.)
  - Cloud platforms (AWS, GCP, etc.)
  - Monitoring and logging tools
```

#### 5. **Code Reviewer** (Security & Standards)
```yaml
Primary Role: Code quality and security
Responsibilities:
  - Review code for security vulnerabilities
  - Ensure coding standards compliance
  - Check for performance issues
  - Verify proper error handling
  - Assess architectural decisions
  - Identify potential technical debt
Skills:
  - Security best practices
  - Code quality tools
  - Performance optimization
  - Design pattern expertise
```

#### 6. **Researcher** (Technology Scout)
```yaml
Primary Role: Technology evaluation
Responsibilities:
  - Research new libraries and frameworks
  - Evaluate technology choices
  - Create proof of concepts
  - Document findings and recommendations
  - Stay updated with industry trends
  - Assess migration strategies
Skills:
  - Quick learning ability
  - Technology assessment
  - Documentation skills
  - Proof of concept development
```

#### 7. **Documentation Writer** (Knowledge Keeper)
```yaml
Primary Role: Technical documentation
Responsibilities:
  - Write API documentation
  - Create user guides
  - Maintain README files
  - Document architectural decisions
  - Create onboarding guides
  - Keep documentation up-to-date
Skills:
  - Technical writing
  - Markdown expertise
  - API documentation tools
  - Diagramming tools
```

## 🔐 Git Discipline - MANDATORY FOR ALL AGENTS

### Core Git Safety Rules

**CRITICAL**: Every agent MUST follow these git practices to prevent work loss:

#### 1. **Auto-Commit Every 30 Minutes**

```bash
# Set up automatic reminders
echo "*/30 * * * * cd /path/to/project && git add -A && git commit -m 'Progress: Auto-commit at $(date)'" | crontab -e

# Manual commit with descriptive message
git add -A
git commit -m "Progress: Implement user authentication with JWT tokens"
```

#### 2. **Commit Before Task Switches**

```bash
# Before switching tasks
git add -A
git commit -m "WIP: Pause work on feature X to address critical bug Y"
git push origin feature/current-branch

# Create a note about current state
echo "Paused at: implementing validation logic for user registration" > .git/WORK_STATE.md
```

#### 3. **Feature Branch Workflow**

```bash
# Before starting any new feature/task
git checkout main
git pull origin main
git checkout -b feature/descriptive-name-issue-123

# During development
git add -A
git commit -m "feat(auth): add password reset functionality"

# After completing feature
git add -A
git commit -m "feat(auth): complete password reset with email verification"
git tag stable-auth-reset-$(date +%Y%m%d-%H%M%S)
git push origin feature/descriptive-name-issue-123
```

#### 4. **Commit Message Standards (Conventional Commits)**

```bash
# Format: <type>(<scope>): <description>

# ✅ Good commit messages:
git commit -m "feat(auth): add two-factor authentication support"
git commit -m "fix(orders): resolve race condition in order processing"
git commit -m "docs(api): update authentication endpoint documentation"
git commit -m "test(products): add unit tests for inventory management"
git commit -m "refactor(database): optimize query performance for large datasets"
git commit -m "style(frontend): update button styles for consistency"
git commit -m "chore(deps): update dependencies to latest versions"

# ❌ Bad commit messages:
git commit -m "fixes"
git commit -m "update code"
git commit -m "changes"
git commit -m "wip"
```

#### 5. **Never Work >1 Hour Without Committing**

```bash
# Set up hourly reminder
while true; do
  sleep 3600
  echo "⏰ REMINDER: Commit your work now!"
  git status
done &

# Emergency commit if needed
git add -A
git commit -m "WIP: Emergency commit - [describe current state]"
```

### Advanced Git Workflows

#### Cherry-Picking Between Branches

```bash
# Apply specific commits from another branch
git log --oneline feature/other-branch
git cherry-pick abc123def456

# If conflicts occur
git status
# Resolve conflicts in files
git add resolved-file.py
git cherry-pick --continue
```

#### Interactive Rebase for Clean History

```bash
# Clean up last 5 commits before PR
git rebase -i HEAD~5

# In the editor, you can:
# pick - keep commit as is
# reword - change commit message
# squash - combine with previous commit
# drop - remove commit
```

#### Stashing for Quick Context Switches

```bash
# Save current work without committing
git stash save "WIP: implementing user profile updates"

# List all stashes
git stash list

# Apply specific stash
git stash apply stash@{0}

# Apply and remove stash
git stash pop
```

### Git Emergency Recovery

```bash
# Check commit history
git log --oneline -20 --graph --all

# Recover from accidental reset
git reflog
git reset --hard HEAD@{2}

# Recover deleted branch
git reflog show --all
git checkout -b recovered-branch abc123def

# Recover lost commits
git fsck --full --no-reflogs | grep commit
git show <commit-hash>

# Create backup branch before risky operations
git checkout -b backup-$(date +%Y%m%d-%H%M%S)
```

### Project Manager Git Responsibilities

Project Managers must enforce git discipline:

```bash
# Daily git health check script
#!/bin/bash
echo "=== Git Health Check ==="
echo "Last commit: $(git log -1 --format='%cr')"
echo "Uncommitted changes: $(git status --porcelain | wc -l) files"
echo "Current branch: $(git branch --show-current)"
echo "Unpushed commits: $(git log origin/$(git branch --show-current)..HEAD --oneline | wc -l)"

# Alert if work is getting stale
if [[ $(git log -1 --format='%cr' | grep -E 'hour|day') ]]; then
  echo "⚠️  WARNING: Last commit is getting old!"
fi
```

## 🚀 Development Standards & Best Practices

### Code Style Guidelines

#### Python Standards (PEP 8 + Project Conventions)

```python
# ✅ Good: Clear, typed, documented
from typing import List, Optional, Dict, Any
from decimal import Decimal
import logging

logger = logging.getLogger(__name__)

class OrderService:
    """Service for managing order operations.
    
    This service handles order creation, validation, and processing
    following the business rules defined in the requirements.
    """
    
    def __init__(self, db_session: Session, cache: Redis) -> None:
        """Initialize order service with dependencies.
        
        Args:
            db_session: Database session for persistence
            cache: Redis instance for caching
        """
        self.db = db_session
        self.cache = cache
        self.order_crud = OrderCRUD(db_session)
    
    async def create_order(
        self,
        user_id: str,
        items: List[OrderItemCreate],
        shipping_address: Address,
        payment_method: PaymentMethod = PaymentMethod.COD
    ) -> Order:
        """Create a new order with inventory validation.
        
        Args:
            user_id: ID of the user placing the order
            items: List of items to order
            shipping_address: Delivery address
            payment_method: Payment method (defaults to COD)
            
        Returns:
            Created order instance
            
        Raises:
            InsufficientInventoryError: If items are out of stock
            InvalidAddressError: If address is invalid
            PaymentMethodNotAllowedError: If payment method not supported
            
        Example:
            >>> order = await service.create_order(
            ...     user_id="user_123",
            ...     items=[OrderItemCreate(product_id="prod_1", quantity=2)],
            ...     shipping_address=valid_address
            ... )
            >>> print(order.order_number)
            'ORD-2024-00001'
        """
        # Validate inventory availability
        await self._validate_inventory(items)
        
        # Calculate order totals
        subtotal = self._calculate_subtotal(items)
        tax = self._calculate_tax(subtotal, shipping_address.country)
        shipping = self._calculate_shipping(items, shipping_address)
        
        # Create order with transaction
        try:
            order = await self.order_crud.create(
                user_id=user_id,
                items=items,
                subtotal=subtotal,
                tax_amount=tax,
                shipping_amount=shipping,
                total_amount=subtotal + tax + shipping,
                shipping_address=shipping_address,
                payment_method=payment_method
            )
            
            logger.info(
                "Order created successfully",
                extra={
                    "order_id": order.id,
                    "user_id": user_id,
                    "total_amount": float(order.total_amount),
                    "item_count": len(items)
                }
            )
            
            # Send confirmation email asynchronously
            await self._send_order_confirmation(order)
            
            return order
            
        except Exception as e:
            logger.error(
                "Failed to create order",
                extra={"user_id": user_id, "error": str(e)},
                exc_info=True
            )
            raise

# ❌ Bad: No types, poor naming, no documentation
class order_svc:
    def create(self, uid, items, addr):
        # create order
        o = Order()
        o.user = uid
        o.items = items
        # save
        self.db.save(o)
        return o
```

#### JavaScript/TypeScript Standards

```typescript
// ✅ Good: Typed, documented, follows conventions
interface OrderItem {
  productId: string;
  quantity: number;
  price: number;
}

interface CreateOrderParams {
  userId: string;
  items: OrderItem[];
  shippingAddress: Address;
  paymentMethod?: PaymentMethod;
}

/**
 * Service for managing customer orders
 */
export class OrderService {
  constructor(
    private readonly orderRepo: OrderRepository,
    private readonly inventoryService: InventoryService,
    private readonly emailService: EmailService
  ) {}

  /**
   * Creates a new order with validation
   * @param params - Order creation parameters
   * @returns Created order
   * @throws {InsufficientInventoryError} When items are out of stock
   */
  async createOrder(params: CreateOrderParams): Promise<Order> {
    const { userId, items, shippingAddress, paymentMethod = PaymentMethod.COD } = params;
    
    // Validate inventory
    await this.inventoryService.validateAvailability(items);
    
    // Calculate totals
    const subtotal = this.calculateSubtotal(items);
    const tax = this.calculateTax(subtotal, shippingAddress.country);
    const shipping = this.calculateShipping(items, shippingAddress);
    
    // Create order
    const order = await this.orderRepo.create({
      userId,
      items,
      subtotal,
      taxAmount: tax,
      shippingAmount: shipping,
      totalAmount: subtotal + tax + shipping,
      shippingAddress,
      paymentMethod,
    });
    
    // Send confirmation
    await this.emailService.sendOrderConfirmation(order);
    
    return order;
  }
  
  private calculateSubtotal(items: OrderItem[]): number {
    return items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  }
}

// ❌ Bad: No types, poor practices
function createOrder(user, items) {
  var total = 0;
  for (var i = 0; i < items.length; i++) {
    total += items[i].price;
  }
  
  const order = {
    user: user,
    items: items,
    total: total
  }
  
  db.save(order);
  return order;
}
```

### API Standards

#### RESTful Endpoint Design

```python
# ✅ Good: Clear, consistent, documented
from fastapi import APIRouter, Depends, Query, status
from typing import Optional, List

router = APIRouter(prefix="/api/v1/orders", tags=["orders"])

@router.get(
    "/",
    response_model=PaginatedResponse[OrderResponse],
    summary="List orders",
    description="Retrieve a paginated list of orders with optional filtering"
)
async def list_orders(
    page: int = Query(1, ge=1, description="Page number"),
    size: int = Query(20, ge=1, le=100, description="Items per page"),
    status: Optional[OrderStatus] = Query(None, description="Filter by status"),
    user_id: Optional[str] = Query(None, description="Filter by user"),
    sort_by: str = Query("created_at", regex="^(created_at|total_amount|status)$"),
    sort_order: str = Query("desc", regex="^(asc|desc)$"),
    fields: Optional[str] = Query(None, description="Comma-separated field names"),
    include: Optional[str] = Query(None, description="Include related resources"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
) -> PaginatedResponse[OrderResponse]:
    """
    Retrieve orders with pagination and filtering.
    
    Field selection example: ?fields=id,order_number,total_amount
    Include relations example: ?include=items,shipping_address
    """
    # Apply filters based on user role
    filters = {"user_id": current_user.id} if current_user.role == "customer" else {}
    if status:
        filters["status"] = status
    if user_id and current_user.role in ["admin", "staff"]:
        filters["user_id"] = user_id
    
    # Get paginated results
    orders, total = await OrderCRUD(db).get_paginated(
        page=page,
        size=size,
        filters=filters,
        sort_by=sort_by,
        sort_order=sort_order
    )
    
    # Return standardized response
    return create_paginated_response(
        items=orders,
        page=page,
        size=size,
        total=total,
        fields=fields,
        include=include
    )

@router.post(
    "/",
    response_model=StandardResponse[OrderResponse],
    status_code=status.HTTP_201_CREATED,
    summary="Create order",
    description="Create a new order with items"
)
async def create_order(
    order_data: OrderCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    order_service: OrderService = Depends(get_order_service)
) -> StandardResponse[OrderResponse]:
    """
    Create a new order.
    
    The order will be validated for:
    - Inventory availability
    - Shipping address validity
    - Payment method eligibility
    """
    order = await order_service.create_order(
        user_id=current_user.id,
        items=order_data.items,
        shipping_address=order_data.shipping_address,
        payment_method=order_data.payment_method
    )
    
    return create_standard_response(
        data=order,
        message="Order created successfully",
        status_code=status.HTTP_201_CREATED
    )
```

#### Error Response Standards

```python
# Error response format
class ErrorDetail(BaseModel):
    code: str
    message: str
    field: Optional[str] = None
    details: Optional[Dict[str, Any]] = None

class ErrorResponse(BaseModel):
    error: ErrorDetail
    request_id: Optional[str] = None
    timestamp: datetime = Field(default_factory=datetime.utcnow)

# Exception handlers
@app.exception_handler(ValidationError)
async def validation_error_handler(request: Request, exc: ValidationError):
    errors = []
    for error in exc.errors():
        errors.append({
            "field": ".".join(str(loc) for loc in error["loc"]),
            "message": error["msg"],
            "type": error["type"]
        })
    
    return JSONResponse(
        status_code=422,
        content={
            "error": {
                "code": "VALIDATION_ERROR",
                "message": "Request validation failed",
                "details": {"validation_errors": errors}
            },
            "request_id": request.state.request_id,
            "timestamp": datetime.utcnow().isoformat()
        }
    )

# Custom exceptions
class OrderNotFoundError(HTTPException):
    def __init__(self, order_id: str):
        super().__init__(
            status_code=404,
            detail={
                "code": "ORDER_NOT_FOUND",
                "message": f"Order {order_id} not found",
                "field": "order_id"
            }
        )
```

### Testing Standards

#### Comprehensive Test Structure

```python
# ✅ Good: Comprehensive, well-organized tests
import pytest
from unittest.mock import Mock, patch
from datetime import datetime
from decimal import Decimal

class TestOrderService:
    """Test suite for OrderService."""
    
    @pytest.fixture
    def mock_db(self):
        """Mock database session."""
        return Mock()
    
    @pytest.fixture
    def mock_cache(self):
        """Mock Redis cache."""
        return Mock()
    
    @pytest.fixture
    def order_service(self, mock_db, mock_cache):
        """OrderService instance with mocked dependencies."""
        return OrderService(mock_db, mock_cache)
    
    @pytest.fixture
    def sample_order_data(self):
        """Sample order creation data."""
        return OrderCreate(
            items=[
                OrderItemCreate(product_id="prod_123", quantity=2, price=25.00),
                OrderItemCreate(product_id="prod_456", quantity=1, price=50.00)
            ],
            shipping_address=Address(
                line1="123 Main St",
                city="Dhaka",
                country="BD",
                postal_code="1200"
            ),
            payment_method=PaymentMethod.COD
        )
    
    @pytest.mark.unit
    class TestOrderCreation:
        """Test order creation functionality."""
        
        def test_create_order_success(self, order_service, sample_order_data):
            """Test successful order creation."""
            # Arrange
            user_id = "user_123"
            expected_order = Order(
                id="order_123",
                order_number="ORD-2024-00001",
                user_id=user_id,
                total_amount=Decimal("100.00"),
                status=OrderStatus.PENDING
            )
            order_service.order_crud.create.return_value = expected_order
            
            # Act
            result = order_service.create_order(user_id, sample_order_data)
            
            # Assert
            assert result.id == expected_order.id
            assert result.total_amount == expected_order.total_amount
            order_service.order_crud.create.assert_called_once()
        
        def test_create_order_insufficient_inventory(self, order_service, sample_order_data):
            """Test order creation with insufficient inventory."""
            # Arrange
            order_service._validate_inventory.side_effect = InsufficientInventoryError(
                "Product prod_123 has insufficient stock"
            )
            
            # Act & Assert
            with pytest.raises(InsufficientInventoryError) as exc_info:
                order_service.create_order("user_123", sample_order_data)
            
            assert "insufficient stock" in str(exc_info.value)
        
        @pytest.mark.parametrize("country,expected_tax", [
            ("BD", Decimal("15.00")),  # 15% VAT in Bangladesh
            ("US", Decimal("8.00")),   # 8% sales tax
            ("UK", Decimal("20.00")),  # 20% VAT
            ("XX", Decimal("0.00")),   # Unknown country, no tax
        ])
        def test_tax_calculation_by_country(self, order_service, country, expected_tax):
            """Test tax calculation for different countries."""
            # Arrange
            subtotal = Decimal("100.00")
            
            # Act
            tax = order_service._calculate_tax(subtotal, country)
            
            # Assert
            assert tax == expected_tax
    
    @pytest.mark.integration
    class TestOrderIntegration:
        """Integration tests with real database."""
        
        @pytest.fixture
        def db_session(self):
            """Real database session for integration tests."""
            engine = create_engine(TEST_DATABASE_URL)
            SessionLocal = sessionmaker(bind=engine)
            session = SessionLocal()
            yield session
            session.rollback()
            session.close()
        
        async def test_complete_order_flow(self, db_session, test_user):
            """Test complete order creation flow with database."""
            # Arrange
            service = OrderService(db_session, Redis())
            order_data = OrderCreate(
                items=[OrderItemCreate(product_id="prod_123", quantity=1)],
                shipping_address=test_user.default_address
            )
            
            # Act
            order = await service.create_order(test_user.id, order_data)
            
            # Assert
            assert order.id is not None
            assert order.status == OrderStatus.PENDING
            assert order.user_id == test_user.id
            
            # Verify in database
            db_order = db_session.query(Order).filter_by(id=order.id).first()
            assert db_order is not None
            assert db_order.order_number.startswith("ORD-")

# ❌ Bad: Minimal, unclear tests
def test_order():
    service = OrderService()
    order = service.create_order("user", [{"product": "123"}])
    assert order is not None
```

#### Test Coverage Requirements

```yaml
# pytest.ini configuration
[tool.pytest.ini_options]
minversion = "6.0"
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
markers = [
    "unit: Unit tests (fast, no dependencies)",
    "integration: Integration tests (database required)",
    "e2e: End-to-end tests (full stack required)",
    "slow: Slow tests (>1s execution time)",
]

[tool.coverage.run]
branch = true
source = ["src"]
omit = ["*/tests/*", "*/migrations/*"]

[tool.coverage.report]
precision = 2
show_missing = true
skip_covered = false
fail_under = 80  # Minimum 80% coverage required

[tool.coverage.html]
directory = "htmlcov"
```

## 🚦 Startup Behavior - Tmux Window Naming

### Auto-Rename Feature

When Claude starts in the orchestrator, it should:

1. **Ask the user**: "Would you like me to rename all tmux windows with descriptive names for better organization?"
2. **If yes**: Analyze each window's content and rename them with meaningful names
3. **If no**: Continue with existing names

### Window Naming Convention

```bash
# Standard naming patterns
Claude-[Role]      # For Claude agents: Claude-Frontend, Claude-Backend
[Tech]-Dev         # For dev servers: NextJS-Dev, Rails-Dev, Django-Dev
[Project]-Shell    # For shells: Frontend-Shell, Backend-Shell
[Service]-Server   # For services: Redis-Server, Postgres-Server
[Purpose]-Tool     # For tools: DB-Admin, Log-Viewer

# Examples of good window names:
Claude-Orchestrator
Claude-PM-Frontend
Claude-Dev-Backend
NextJS-Dev-3000
FastAPI-Server-8000
Frontend-Shell
Backend-Tests
Redis-Server
Postgres-Admin
```

### Automated Window Naming Script

```bash
#!/bin/bash
# auto-rename-windows.sh - Intelligently rename tmux windows

rename_window() {
    local session=$1
    local window=$2
    local new_name=$3
    
    echo "Renaming $session:$window to '$new_name'"
    tmux rename-window -t "$session:$window" "$new_name"
}

analyze_window_content() {
    local session=$1
    local window=$2
    
    # Capture window content
    local content=$(tmux capture-pane -t "$session:$window" -p | tail -50)
    
    # Detect Claude agents
    if echo "$content" | grep -q "claude --dangerously-skip-permissions"; then
        # Try to identify role from conversation
        if echo "$content" | grep -qi "project manager"; then
            echo "Claude-PM"
        elif echo "$content" | grep -qi "developer\|implementation"; then
            echo "Claude-Dev"
        elif echo "$content" | grep -qi "qa\|test"; then
            echo "Claude-QA"
        else
            echo "Claude-Agent"
        fi
        return
    fi
    
    # Detect development servers
    if echo "$content" | grep -q "npm run dev\|yarn dev"; then
        local port=$(echo "$content" | grep -oE "localhost:[0-9]+" | head -1 | cut -d: -f2)
        echo "Node-Dev-${port:-3000}"
        return
    fi
    
    if echo "$content" | grep -q "uvicorn.*--reload"; then
        local port=$(echo "$content" | grep -oE "port [0-9]+" | head -1 | awk '{print $2}')
        echo "FastAPI-Dev-${port:-8000}"
        return
    fi
    
    # Detect shells
    if echo "$content" | grep -qE "^\$|^>|^%"; then
        echo "Shell"
        return
    fi
    
    # Default
    echo "Window-$window"
}

# Main execution
for session in $(tmux list-sessions -F "#{session_name}"); do
    echo "Analyzing session: $session"
    
    for window in $(tmux list-windows -t "$session" -F "#{window_index}"); do
        current_name=$(tmux list-windows -t "$session:$window" -F "#{window_name}")
        
        # Skip if already has a descriptive name
        if [[ ! "$current_name" =~ ^(zsh|bash|node|python|Window)$ ]]; then
            continue
        fi
        
        new_name=$(analyze_window_content "$session" "$window")
        rename_window "$session" "$window" "$new_name"
    done
done
```

## 📋 Project Startup Sequence

### Complete Project Initialization Workflow

```bash
#!/bin/bash
# start-project.sh - Complete project startup automation

PROJECT_NAME="$1"
PROJECT_TYPE="$2"  # nodejs, python, ruby, etc.

# Step 1: Find and validate project
find_project() {
    local search_term="$1"
    local base_paths=(
        "$HOME/work"
        "$HOME/projects"
        "$HOME/src"
        "$HOME/Coding"
    )
    
    for base in "${base_paths[@]}"; do
        if [[ -d "$base" ]]; then
            local found=$(find "$base" -maxdepth 3 -type d -iname "*$search_term*" | head -1)
            if [[ -n "$found" ]]; then
                echo "$found"
                return 0
            fi
        fi
    done
    
    return 1
}

# Step 2: Detect project type
detect_project_type() {
    local project_path="$1"
    
    if [[ -f "$project_path/package.json" ]]; then
        echo "nodejs"
    elif [[ -f "$project_path/requirements.txt" ]] || [[ -f "$project_path/pyproject.toml" ]]; then
        echo "python"
    elif [[ -f "$project_path/Gemfile" ]]; then
        echo "ruby"
    elif [[ -f "$project_path/go.mod" ]]; then
        echo "go"
    elif [[ -f "$project_path/Cargo.toml" ]]; then
        echo "rust"
    else
        echo "unknown"
    fi
}

# Step 3: Create tmux session with standard layout
create_project_session() {
    local project_name="$1"
    local project_path="$2"
    local session_name=$(echo "$project_name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
    
    # Create session
    tmux new-session -d -s "$session_name" -c "$project_path"
    
    # Window 0: Claude Agent
    tmux rename-window -t "$session_name:0" "Claude-Dev"
    
    # Window 1: Shell
    tmux new-window -t "$session_name" -n "Shell" -c "$project_path"
    
    # Window 2: Dev Server
    tmux new-window -t "$session_name" -n "Dev-Server" -c "$project_path"
    
    # Window 3: Tests (optional)
    tmux new-window -t "$session_name" -n "Tests" -c "$project_path"
    
    # Window 4: Logs (optional)
    tmux new-window -t "$session_name" -n "Logs" -c "$project_path"
    
    echo "$session_name"
}

# Step 4: Start and brief Claude agent
brief_claude_agent() {
    local session="$1"
    local project_path="$2"
    local project_type="$3"
    
    # Start Claude
    tmux send-keys -t "$session:0" "claude --dangerously-skip-permissions" Enter
    sleep 5
    
    # Send comprehensive briefing
    local briefing="You are the lead developer for this $project_type project. Your responsibilities include:

1. **Project Analysis**:
   - Understand the project structure and architecture
   - Review the README.md and documentation
   - Check for CLAUDE.md or similar AI instructions
   - Identify the main technologies and frameworks used

2. **Development Setup**:
   - Install dependencies if needed
   - Start the development server in window 2 (Dev-Server)
   - Run tests in window 3 (Tests) if applicable
   - Monitor logs in window 4 (Logs) if needed

3. **Task Management**:
   - Check GitHub/GitLab issues for priorities
   - Review TODO.md or ROADMAP.md if present
   - Look for failing tests or CI/CD issues
   - Identify and fix any critical bugs

4. **Quality Standards**:
   - Follow the project's coding standards
   - Write tests for new features
   - Update documentation as needed
   - Commit work regularly (every 30 minutes)

5. **Communication**:
   - Report progress to the orchestrator regularly
   - Ask for help if blocked for more than 10 minutes
   - Document any architectural decisions

Please start by analyzing the project structure and getting the development environment running."
    
    $HOME/work/Tmux\ orchestrator/send-claude-message.sh "$session:0" "$briefing"
}

# Step 5: Project-specific setup
setup_nodejs_project() {
    local session="$1"
    local project_path="$2"
    
    # Check for package manager
    if [[ -f "$project_path/yarn.lock" ]]; then
        tmux send-keys -t "$session:2" "yarn install && yarn dev" Enter
    elif [[ -f "$project_path/pnpm-lock.yaml" ]]; then
        tmux send-keys -t "$session:2" "pnpm install && pnpm dev" Enter
    else
        tmux send-keys -t "$session:2" "npm install && npm run dev" Enter
    fi
    
    # Set up test runner
    tmux send-keys -t "$session:3" "npm test -- --watch" Enter
}

setup_python_project() {
    local session="$1"
    local project_path="$2"
    
    # Check for virtual environment
    if [[ -d "$project_path/venv" ]]; then
        tmux send-keys -t "$session:2" "source venv/bin/activate" Enter
    elif [[ -d "$project_path/.venv" ]]; then
        tmux send-keys -t "$session:2" "source .venv/bin/activate" Enter
    else
        tmux send-keys -t "$session:2" "python -m venv venv && source venv/bin/activate" Enter
    fi
    
    # Install dependencies and start server
    if [[ -f "$project_path/manage.py" ]]; then
        # Django project
        tmux send-keys -t "$session:2" "pip install -r requirements.txt && python manage.py runserver" Enter
    elif [[ -f "$project_path/app.py" ]] || [[ -f "$project_path/main.py" ]]; then
        # FastAPI/Flask project
        tmux send-keys -t "$session:2" "pip install -r requirements.txt && uvicorn app.main:app --reload" Enter
    fi
    
    # Set up test runner
    tmux send-keys -t "$session:3" "pytest --watch" Enter
}

# Main execution
main() {
    echo "🚀 Starting project: $PROJECT_NAME"
    
    # Find project
    PROJECT_PATH=$(find_project "$PROJECT_NAME")
    if [[ -z "$PROJECT_PATH" ]]; then
        echo "❌ Project not found: $PROJECT_NAME"
        exit 1
    fi
    echo "✅ Found project at: $PROJECT_PATH"
    
    # Detect type if not specified
    if [[ -z "$PROJECT_TYPE" ]]; then
        PROJECT_TYPE=$(detect_project_type "$PROJECT_PATH")
    fi
    echo "📦 Project type: $PROJECT_TYPE"
    
    # Create session
    SESSION_NAME=$(create_project_session "$PROJECT_NAME" "$PROJECT_PATH")
    echo "🖥️  Created tmux session: $SESSION_NAME"
    
    # Brief Claude
    brief_claude_agent "$SESSION_NAME" "$PROJECT_PATH" "$PROJECT_TYPE"
    echo "🤖 Claude agent briefed and ready"
    
    # Project-specific setup
    case "$PROJECT_TYPE" in
        nodejs)
            setup_nodejs_project "$SESSION_NAME" "$PROJECT_PATH"
            ;;
        python)
            setup_python_project "$SESSION_NAME" "$PROJECT_PATH"
            ;;
        *)
            echo "⚠️  Unknown project type, manual setup required"
            ;;
    esac
    
    echo "✨ Project startup complete!"
    echo "📌 Attach with: tmux attach -t $SESSION_NAME"
}

main
```

## 👥 Team Management & Deployment

### Creating and Managing Project Managers

```bash
#!/bin/bash
# create-project-manager.sh - Deploy a PM for a session

deploy_project_manager() {
    local session="$1"
    local project_path=$(tmux display-message -t "$session:0" -p '#{pane_current_path}')
    
    # Find available window index
    local pm_window=$(tmux list-windows -t "$session" -F "#{window_index}" | tail -1)
    pm_window=$((pm_window + 1))
    
    # Create PM window
    tmux new-window -t "$session:$pm_window" -n "Claude-PM" -c "$project_path"
    
    # Start Claude
    tmux send-keys -t "$session:$pm_window" "claude --dangerously-skip-permissions" Enter
    sleep 5
    
    # Send PM briefing
    local briefing="You are the Project Manager for this project. Your role is critical for maintaining quality and coordination.

## Core Responsibilities

### 1. Quality Assurance
- Enforce coding standards rigorously (check CODE_STANDARDS.md)
- Ensure minimum 80% test coverage
- Review all code before allowing merges
- No shortcuts, no compromises on quality

### 2. Team Coordination
- Conduct async daily standups
- Track sprint velocity and burndown
- Identify and resolve blockers quickly
- Facilitate communication between team members

### 3. Progress Tracking
- Monitor task completion rates
- Update project boards/issues
- Report to orchestrator every 2 hours
- Track technical debt accumulation

### 4. Risk Management
- Identify potential issues early
- Create mitigation strategies
- Escalate critical issues immediately
- Maintain project health metrics

## Daily Workflow

1. **Morning Check** (First thing):
   - Review overnight commits
   - Check CI/CD status
   - Identify critical issues
   - Plan day's priorities

2. **Standup Collection** (Every 4 hours):
   - Ask each team member for status
   - Compile into summary
   - Identify blockers
   - Adjust priorities if needed

3. **Code Review** (Continuous):
   - Review all PRs within 30 minutes
   - Check for standards compliance
   - Verify test coverage
   - Ensure documentation updates

4. **End of Day** (Before rotating out):
   - Summarize day's progress
   - Document open issues
   - Brief incoming PM if applicable
   - Commit all documentation

## Communication Templates

Use these templates for consistency:

### Status Request:
'STATUS REQUEST: Please provide:
1. Tasks completed since last update
2. Current task and progress
3. Any blockers or concerns
4. ETA for current task'

### Daily Summary:
'DAILY SUMMARY [Date]
Completed: X tasks
In Progress: Y tasks
Blocked: Z tasks
Velocity: XX story points
Health: GREEN/YELLOW/RED'

## Quality Gates

Never allow code that doesn't meet these criteria:
- [ ] All tests passing
- [ ] Test coverage ≥ 80%
- [ ] No linting errors
- [ ] Documentation updated
- [ ] Commit message follows standards
- [ ] PR description complete
- [ ] Security scan passed

Begin by introducing yourself to the team and conducting your first standup."
    
    $HOME/work/Tmux\ orchestrator/send-claude-message.sh "$session:$pm_window" "$briefing"
    
    # PM introduces to team
    sleep 10
    for window in $(tmux list-windows -t "$session" -F "#{window_index}:#{window_name}" | grep Claude | grep -v PM); do
        local win_idx=$(echo "$window" | cut -d: -f1)
        $HOME/work/Tmux\ orchestrator/send-claude-message.sh "$session:$win_idx" \
            "Hello! I'm the new Project Manager for this project. I'll be coordinating our work and ensuring we maintain high quality standards. Could you please provide a brief status update on your current work?"
    done
}
```

### Team Composition Guidelines

```yaml
# team-compositions.yml - Optimal team structures by project size

small_project:
  description: "Single feature or small bug fixes"
  team_size: 2-3
  composition:
    - role: Developer
      count: 1
      responsibilities:
        - Implementation
        - Basic testing
        - Documentation
    - role: Project Manager
      count: 1
      responsibilities:
        - Quality assurance
        - Progress tracking
        - Orchestrator communication

medium_project:
  description: "Multi-feature development or significant refactoring"
  team_size: 4-5
  composition:
    - role: Lead Developer
      count: 1
      responsibilities:
        - Architecture decisions
        - Code review
        - Mentoring
    - role: Developer
      count: 2
      responsibilities:
        - Feature implementation
        - Bug fixes
        - Unit testing
    - role: QA Engineer
      count: 1
      responsibilities:
        - Test automation
        - Integration testing
        - Performance testing
    - role: Project Manager
      count: 1
      responsibilities:
        - Team coordination
        - Sprint planning
        - Stakeholder communication

large_project:
  description: "Major features, migrations, or new services"
  team_size: 6-8
  composition:
    - role: Tech Lead
      count: 1
      responsibilities:
        - System architecture
        - Technical decisions
        - Cross-team coordination
    - role: Senior Developer
      count: 2
      responsibilities:
        - Complex implementations
        - Performance optimization
        - Junior mentoring
    - role: Developer
      count: 2
      responsibilities:
        - Feature development
        - Bug fixes
        - Documentation
    - role: QA Engineer
      count: 1
      responsibilities:
        - Test strategy
        - E2E testing
        - Quality metrics
    - role: DevOps Engineer
      count: 1
      responsibilities:
        - CI/CD pipeline
        - Infrastructure
        - Monitoring
    - role: Project Manager
      count: 1
      responsibilities:
        - Program management
        - Resource allocation
        - Executive reporting

specialized_teams:
  security_audit:
    - role: Security Engineer
      count: 2
    - role: Code Reviewer
      count: 1
    - role: Project Manager
      count: 1
  
  performance_optimization:
    - role: Performance Engineer
      count: 2
    - role: DevOps Engineer
      count: 1
    - role: Project Manager
      count: 1
  
  migration_project:
    - role: Migration Specialist
      count: 2
    - role: DevOps Engineer
      count: 1
    - role: QA Engineer
      count: 1
    - role: Project Manager
      count: 1
```

## 📊 Communication Protocols

### Structured Communication System

```python
# communication_protocol.py - Standardized messaging system

from enum import Enum
from datetime import datetime
from typing import Optional, List, Dict, Any

class MessageType(Enum):
    STATUS_UPDATE = "STATUS_UPDATE"
    TASK_ASSIGNMENT = "TASK_ASSIGNMENT"
    BLOCKER_ALERT = "BLOCKER_ALERT"
    PROGRESS_REPORT = "PROGRESS_REPORT"
    CODE_REVIEW_REQUEST = "CODE_REVIEW_REQUEST"
    DEPLOYMENT_NOTICE = "DEPLOYMENT_NOTICE"
    EMERGENCY = "EMERGENCY"

class Priority(Enum):
    LOW = "LOW"
    MEDIUM = "MEDIUM"
    HIGH = "HIGH"
    CRITICAL = "CRITICAL"

class Message:
    def __init__(
        self,
        type: MessageType,
        from_agent: str,
        to_agent: str,
        priority: Priority,
        subject: str,
        body: str,
        metadata: Optional[Dict[str, Any]] = None
    ):
        self.id = generate_ulid()
        self.type = type
        self.from_agent = from_agent
        self.to_agent = to_agent
        self.priority = priority
        self.subject = subject
        self.body = body
        self.metadata = metadata or {}
        self.timestamp = datetime.utcnow()
        self.acknowledged = False
        self.response_required = type in [
            MessageType.BLOCKER_ALERT,
            MessageType.EMERGENCY,
            MessageType.CODE_REVIEW_REQUEST
        ]
    
    def format_for_tmux(self) -> str:
        """Format message for sending via tmux."""
        return f"""
[{self.type.value}] {self.subject}
From: {self.from_agent} | Priority: {self.priority.value}
Time: {self.timestamp.strftime('%Y-%m-%d %H:%M:%S')}

{self.body}

{self._format_metadata()}
---
Message ID: {self.id}
""".strip()
    
    def _format_metadata(self) -> str:
        if not self.metadata:
            return ""
        
        lines = ["Metadata:"]
        for key, value in self.metadata.items():
            lines.append(f"  {key}: {value}")
        return "\n".join(lines)

# Message Templates
class MessageTemplates:
    @staticmethod
    def status_update(
        from_agent: str,
        completed_tasks: List[str],
        current_task: str,
        blockers: List[str],
        eta: Optional[str] = None
    ) -> Message:
        body = f"""
Completed Tasks:
{chr(10).join(f'- {task}' for task in completed_tasks) if completed_tasks else '- None'}

Current Task:
- {current_task}

Blockers:
{chr(10).join(f'- {blocker}' for blocker in blockers) if blockers else '- None'}

ETA: {eta or 'TBD'}
""".strip()
        
        return Message(
            type=MessageType.STATUS_UPDATE,
            from_agent=from_agent,
            to_agent="Project-Manager",
            priority=Priority.MEDIUM,
            subject=f"Status Update from {from_agent}",
            body=body,
            metadata={
                "completed_count": len(completed_tasks),
                "has_blockers": len(blockers) > 0
            }
        )
    
    @staticmethod
    def task_assignment(
        from_agent: str,
        to_agent: str,
        task_id: str,
        task_title: str,
        task_description: str,
        priority: Priority,
        due_date: Optional[str] = None,
        success_criteria: List[str] = None
    ) -> Message:
        body = f"""
Task ID: {task_id}
Title: {task_title}

Description:
{task_description}

Success Criteria:
{chr(10).join(f'- {criterion}' for criterion in success_criteria) if success_criteria else '- Complete implementation as described'}

Due Date: {due_date or 'ASAP'}

Please acknowledge receipt and provide an ETA.
""".strip()
        
        return Message(
            type=MessageType.TASK_ASSIGNMENT,
            from_agent=from_agent,
            to_agent=to_agent,
            priority=priority,
            subject=f"Task Assignment: {task_title}",
            body=body,
            metadata={
                "task_id": task_id,
                "requires_acknowledgment": True
            }
        )
    
    @staticmethod
    def blocker_alert(
        from_agent: str,
        blocker_description: str,
        attempted_solutions: List[str],
        help_needed: str,
        severity: str = "HIGH"
    ) -> Message:
        body = f"""
BLOCKER ENCOUNTERED

Description:
{blocker_description}

Attempted Solutions:
{chr(10).join(f'- {solution}' for solution in attempted_solutions)}

Help Needed:
{help_needed}

This is blocking further progress. Immediate assistance required.
""".strip()
        
        return Message(
            type=MessageType.BLOCKER_ALERT,
            from_agent=from_agent,
            to_agent="Project-Manager",
            priority=Priority.HIGH if severity == "HIGH" else Priority.CRITICAL,
            subject=f"BLOCKER: {blocker_description[:50]}...",
            body=body,
            metadata={
                "blocked_since": datetime.utcnow().isoformat(),
                "severity": severity
            }
        )
```

### Communication Flow Examples

```bash
# Hub-and-spoke communication pattern implementation

# Developer -> PM (Status Update)
$HOME/work/Tmux\ orchestrator/send-claude-message.sh project:pm \
"[STATUS_UPDATE] Daily Status from Developer-Frontend
From: Developer-Frontend | Priority: MEDIUM
Time: $(date '+%Y-%m-%d %H:%M:%S')

Completed Tasks:
- Implemented user authentication UI
- Added form validation for login/signup
- Created password strength indicator

Current Task:
- Integrating with backend auth API

Blockers:
- None

ETA: 2 hours
---
Message ID: $(uuidgen)"

# PM -> Orchestrator (Aggregated Report)
$HOME/work/Tmux\ orchestrator/send-claude-message.sh tmux-orc:0 \
"[PROGRESS_REPORT] Team Status Summary
From: Project-Manager | Priority: MEDIUM
Time: $(date '+%Y-%m-%d %H:%M:%S')

Team: Frontend-Team
Sprint: Week 2
Health: GREEN

Summary:
- Velocity: 21 story points (target: 20)
- Completed: 8/12 tasks
- In Progress: 3 tasks
- Blocked: 1 task (awaiting API documentation)

Key Achievements:
- Authentication UI complete
- Performance optimizations implemented
- Test coverage increased to 85%

Risks:
- API documentation delay may impact integration timeline
- Consider allocating additional developer if delay continues

Next 24 Hours:
- Complete API integration
- Begin user profile features
- Address technical debt in routing module
---
Message ID: $(uuidgen)"

# Emergency Escalation
$HOME/work/Tmux\ orchestrator/send-claude-message.sh tmux-orc:0 \
"[EMERGENCY] Production System Down
From: DevOps-Engineer | Priority: CRITICAL
Time: $(date '+%Y-%m-%d %H:%M:%S')

PRODUCTION SYSTEM IS DOWN

Issue:
- Database connection pool exhausted
- All API requests timing out
- Users unable to access system

Impact:
- 100% of users affected
- Revenue impact: ~$10k/hour
- Started: 10 minutes ago

Actions Taken:
- Restarted application servers (no effect)
- Checked database server (running normally)
- Analyzing connection pool logs

Need Immediate:
- All hands to diagnose issue
- Rollback decision if not resolved in 15 minutes
- Customer communication plan

---
Message ID: $(uuidgen)"
```

## 🔧 Quality Assurance Protocols

### Comprehensive QA Framework

```yaml
# qa-framework.yml - Quality standards and processes

quality_gates:
  code_review:
    required_approvals: 1
    checklist:
      - code_follows_style_guide
      - no_commented_code
      - proper_error_handling
      - security_best_practices
      - performance_considerations
      - documentation_updated
    automated_checks:
      - linting_passed
      - type_checking_passed
      - security_scan_clean
      - no_merge_conflicts
  
  testing:
    unit_tests:
      coverage_minimum: 80%
      execution_time_limit: 5m
      requirements:
        - all_public_methods_tested
        - edge_cases_covered
        - error_conditions_tested
        - mocks_used_appropriately
    
    integration_tests:
      coverage_minimum: 70%
      execution_time_limit: 15m
      requirements:
        - api_endpoints_tested
        - database_operations_verified
        - external_services_mocked
        - transaction_rollback_tested
    
    e2e_tests:
      coverage_minimum: 60%
      execution_time_limit: 30m
      requirements:
        - critical_user_flows_tested
        - cross_browser_compatibility
        - mobile_responsive_tested
        - performance_benchmarks_met
  
  documentation:
    code_documentation:
      - all_public_apis_documented
      - complex_logic_explained
      - examples_provided
      - return_types_specified
    
    project_documentation:
      - readme_updated
      - api_docs_current
      - deployment_guide_accurate
      - troubleshooting_guide_exists
  
  performance:
    benchmarks:
      api_response_time: <200ms
      page_load_time: <3s
      database_query_time: <100ms
      memory_usage: <512MB
    
    monitoring:
      - performance_metrics_tracked
      - alerts_configured
      - dashboards_updated
      - sla_compliance_verified

continuous_improvement:
  daily:
    - review_failed_tests
    - address_flaky_tests
    - update_test_data
    - check_ci_pipeline_health
  
  weekly:
    - review_test_coverage_trends
    - analyze_bug_patterns
    - update_test_strategies
    - refactor_test_code
  
  monthly:
    - comprehensive_security_audit
    - performance_regression_analysis
    - dependency_updates
    - test_infrastructure_review
```

### PM Verification Workflow

```bash
#!/bin/bash
# pm-verification.sh - Automated quality checks for PMs

run_quality_checks() {
    local project_path="$1"
    local check_results=()
    
    echo "🔍 Running Quality Verification Suite"
    echo "===================================="
    
    # 1. Test Coverage Check
    echo -n "📊 Checking test coverage... "
    coverage_result=$(cd "$project_path" && npm test -- --coverage --silent 2>&1 | grep "All files" | awk '{print $NF}')
    if [[ ${coverage_result%\%} -ge 80 ]]; then
        echo "✅ PASS ($coverage_result)"
        check_results+=("coverage:pass:$coverage_result")
    else
        echo "❌ FAIL ($coverage_result < 80%)"
        check_results+=("coverage:fail:$coverage_result")
    fi
    
    # 2. Linting Check
    echo -n "🎨 Running linter... "
    if cd "$project_path" && npm run lint --silent 2>&1; then
        echo "✅ PASS"
        check_results+=("linting:pass")
    else
        echo "❌ FAIL"
        check_results+=("linting:fail")
    fi
    
    # 3. Type Checking
    echo -n "📝 Type checking... "
    if cd "$project_path" && npm run type-check --silent 2>&1; then
        echo "✅ PASS"
        check_results+=("types:pass")
    else
        echo "❌ FAIL"
        check_results+=("types:fail")
    fi
    
    # 4. Security Scan
    echo -n "🔒 Security scan... "
    if cd "$project_path" && npm audit --production 2>&1 | grep -q "found 0 vulnerabilities"; then
        echo "✅ PASS"
        check_results+=("security:pass")
    else
        echo "⚠️  WARNINGS FOUND"
        check_results+=("security:warning")
    fi
    
    # 5. Documentation Check
    echo -n "📚 Documentation check... "
    docs_score=0
    [[ -f "$project_path/README.md" ]] && ((docs_score++))
    [[ -f "$project_path/API.md" ]] && ((docs_score++))
    [[ -d "$project_path/docs" ]] && ((docs_score++))
    [[ -f "$project_path/CONTRIBUTING.md" ]] && ((docs_score++))
    
    if [[ $docs_score -ge 3 ]]; then
        echo "✅ PASS ($docs_score/4)"
        check_results+=("docs:pass:$docs_score")
    else
        echo "⚠️  NEEDS IMPROVEMENT ($docs_score/4)"
        check_results+=("docs:warning:$docs_score")
    fi
    
    # Generate Summary
    echo ""
    echo "📋 Quality Check Summary"
    echo "======================="
    
    local pass_count=0
    local fail_count=0
    local warning_count=0
    
    for result in "${check_results[@]}"; do
        IFS=':' read -r check status value <<< "$result"
        case $status in
            pass) ((pass_count++)) ;;
            fail) ((fail_count++)) ;;
            warning) ((warning_count++)) ;;
        esac
    done
    
    echo "✅ Passed: $pass_count"
    echo "❌ Failed: $fail_count"
    echo "⚠️  Warnings: $warning_count"
    echo ""
    
    if [[ $fail_count -eq 0 ]]; then
        echo "🎉 All critical checks passed! Ready for merge."
        return 0
    else
        echo "🚫 Critical issues found. Fix before merging."
        return 1
    fi
}

# Run checks and report to orchestrator
main() {
    local project_path="$1"
    local session="$2"
    
    # Run checks
    check_output=$(run_quality_checks "$project_path" 2>&1)
    check_status=$?
    
    # Report to orchestrator
    $HOME/work/Tmux\ orchestrator/send-claude-message.sh tmux-orc:0 \
"[QUALITY_REPORT] Automated Quality Check Results
From: Project-Manager | Priority: MEDIUM
Time: $(date '+%Y-%m-%d %H:%M:%S')

Project: $project_path
Status: $([ $check_status -eq 0 ] && echo "PASSED" || echo "FAILED")

Results:
$check_output

Recommendation: $([ $check_status -eq 0 ] && echo "Safe to proceed with deployment" || echo "Address issues before proceeding")
---
Message ID: $(uuidgen)"
    
    return $check_status
}

main "$@"
```

## 🚨 Critical Self-Scheduling Protocol

### Mandatory Startup Verification

```bash
#!/bin/bash
# startup-verification.sh - MANDATORY orchestrator startup checks

perform_startup_checks() {
    echo "🔍 ORCHESTRATOR STARTUP VERIFICATION"
    echo "===================================="
    
    # 1. Verify tmux environment
    echo -n "1. Checking tmux environment... "
    if [[ -n "$TMUX" ]]; then
        echo "✅ PASS"
        CURRENT_WINDOW=$(tmux display-message -p "#{session_name}:#{window_index}")
        echo "   Current window: $CURRENT_WINDOW"
    else
        echo "❌ FAIL - Not in tmux!"
        return 1
    fi
    
    # 2. Verify scheduling script
    echo -n "2. Checking scheduling script... "
    SCHEDULE_SCRIPT="$HOME/work/Tmux orchestrator/schedule_with_note.sh"
    if [[ -x "$SCHEDULE_SCRIPT" ]]; then
        echo "✅ PASS"
    else
        echo "❌ FAIL - Script not found or not executable!"
        return 1
    fi
    
    # 3. Test scheduling to current window
    echo -n "3. Testing self-scheduling... "
    if "$SCHEDULE_SCRIPT" 1 "Startup test for $CURRENT_WINDOW" "$CURRENT_WINDOW" >/dev/null 2>&1; then
        echo "✅ PASS"
    else
        echo "❌ FAIL - Cannot schedule to current window!"
        echo "   Attempting to fix..."
        
        # Try to fix the script
        cat > "$SCHEDULE_SCRIPT" << 'EOF'
#!/bin/bash
MINUTES=$1
NOTE=$2
TARGET_WINDOW=${3:-tmux-orc:0}

# Verify target window exists
if ! tmux list-windows -t "$TARGET_WINDOW" >/dev/null 2>&1; then
    echo "Error: Target window '$TARGET_WINDOW' does not exist"
    exit 1
fi

# Schedule the task
echo "claude --dangerously-skip-permissions # Scheduled: $NOTE" | at now + $MINUTES minutes 2>&1
echo "Scheduled for $TARGET_WINDOW in $MINUTES minutes: $NOTE"
EOF
        chmod +x "$SCHEDULE_SCRIPT"
        
        # Retry
        if "$SCHEDULE_SCRIPT" 1 "Retry test for $CURRENT_WINDOW" "$CURRENT_WINDOW" >/dev/null 2>&1; then
            echo "   ✅ FIXED"
        else
            echo "   ❌ STILL FAILING"
            return 1
        fi
    fi
    
    # 4. Check active sessions
    echo -n "4. Checking active sessions... "
    SESSION_COUNT=$(tmux list-sessions 2>/dev/null | wc -l)
    echo "✅ Found $SESSION_COUNT active sessions"
    
    # 5. List all Claude agents
    echo "5. Active Claude agents:"
    for session in $(tmux list-sessions -F "#{session_name}" 2>/dev/null); do
        for window in $(tmux list-windows -t "$session" -F "#{window_index}:#{window_name}" | grep -i claude); do
            echo "   - $session:$window"
        done
    done
    
    echo ""
    echo "✅ STARTUP VERIFICATION COMPLETE"
    echo ""
    
    # Schedule first check
    "$SCHEDULE_SCRIPT" 15 "Regular orchestrator check - $CURRENT_WINDOW" "$CURRENT_WINDOW"
    echo "📅 Scheduled next check in 15 minutes"
    
    return 0
}

# Auto-schedule critical tasks
schedule_recurring_tasks() {
    local current_window="$1"
    local schedule_script="$HOME/work/Tmux orchestrator/schedule_with_note.sh"
    
    # Schedule recurring oversight checks
    "$schedule_script" 30 "PM team oversight and status collection" "$current_window"
    "$schedule_script" 60 "System health check and resource monitoring" "$current_window"
    "$schedule_script" 120 "Comprehensive project review and planning" "$current_window"
    "$schedule_script" 240 "Git repository health and backup verification" "$current_window"
}

# Main execution
main() {
    if perform_startup_checks; then
        CURRENT_WINDOW=$(tmux display-message -p "#{session_name}:#{window_index}")
        schedule_recurring_tasks "$CURRENT_WINDOW"
        echo "🚀 Orchestrator initialized successfully!"
        return 0
    else
        echo "❌ Startup checks failed! Fix issues before proceeding."
        return 1
    fi
}

main
```

### Scheduling Best Practices

```yaml
# scheduling-patterns.yml - Optimal scheduling patterns

orchestrator_schedules:
  self_maintenance:
    - task: "Self health check"
      interval: 15m
      window: "self"
      priority: critical
    
    - task: "Memory and resource check"
      interval: 30m
      window: "self"
      priority: high
  
  team_oversight:
    - task: "PM status collection"
      interval: 30m
      window: "self"
      priority: high
      
    - task: "Developer progress check"
      interval: 1h
      window: "self"
      priority: medium
    
    - task: "System-wide standup"
      interval: 4h
      window: "self"
      priority: high
  
  project_health:
    - task: "CI/CD pipeline check"
      interval: 1h
      window: "self"
      priority: medium
    
    - task: "Test suite health"
      interval: 2h
      window: "self"
      priority: medium
    
    - task: "Security scan review"
      interval: 24h
      window: "self"
      priority: high

agent_schedules:
  project_manager:
    - task: "Team standup"
      interval: 4h
      window: "pm"
      priority: high
    
    - task: "Code review sweep"
      interval: 30m
      window: "pm"
      priority: medium
    
    - task: "Blocker check"
      interval: 1h
      window: "pm"
      priority: high
  
  developer:
    - task: "Commit reminder"
      interval: 30m
      window: "dev"
      priority: critical
    
    - task: "Test execution"
      interval: 1h
      window: "dev"
      priority: medium
    
    - task: "Documentation update"
      interval: 2h
      window: "dev"
      priority: low

scheduling_rules:
  - never_schedule_without_verification
  - always_use_current_window_for_self
  - verify_target_window_exists
  - include_meaningful_descriptions
  - respect_priority_levels
  - avoid_scheduling_conflicts
  - maintain_schedule_log
```

## 🛠️ Advanced Orchestration Patterns

### Multi-Project Coordination

```bash
#!/bin/bash
# multi-project-orchestrator.sh - Manage multiple projects simultaneously

orchestrate_multiple_projects() {
    local projects=("$@")
    local orchestrator_window=$(tmux display-message -p "#{session_name}:#{window_index}")
    
    echo "🎯 MULTI-PROJECT ORCHESTRATION"
    echo "============================="
    echo "Managing ${#projects[@]} projects"
    echo ""
    
    # Create project registry
    local registry_file="$HOME/work/Tmux orchestrator/registry/active_projects.json"
    echo "{" > "$registry_file"
    echo '  "projects": [' >> "$registry_file"
    
    # Deploy teams for each project
    for i in "${!projects[@]}"; do
        local project="${projects[$i]}"
        echo "📦 Setting up: $project"
        
        # Find project path
        local project_path=$(find "$HOME/work" -name "$project" -type d | head -1)
        if [[ -z "$project_path" ]]; then
            echo "   ❌ Project not found, skipping"
            continue
        fi
        
        # Determine project size and team composition
        local project_size=$(analyze_project_size "$project_path")
        local team_size=$(get_team_size "$project_size")
        
        echo "   📊 Project size: $project_size"
        echo "   👥 Team size: $team_size members"
        
        # Create session and deploy team
        local session_name=$(echo "$project" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
        create_project_session "$project" "$project_path"
        deploy_team "$session_name" "$project_path" "$project_size"
        
        # Add to registry
        cat >> "$registry_file" << EOF
    {
      "name": "$project",
      "session": "$session_name",
      "path": "$project_path",
      "size": "$project_size",
      "team_size": $team_size,
      "status": "active",
      "started": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
      "last_check": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    }$([ $i -lt $((${#projects[@]}-1)) ] && echo ",")
EOF
        
        echo "   ✅ Team deployed"
        echo ""
    done
    
    echo '  ]' >> "$registry_file"
    echo '}' >> "$registry_file"
    
    # Schedule cross-project coordination
    schedule_cross_project_sync "$orchestrator_window"
    
    echo "✨ All projects initialized!"
}

analyze_project_size() {
    local project_path="$1"
    local file_count=$(find "$project_path" -name "*.py" -o -name "*.js" -o -name "*.ts" | wc -l)
    local line_count=$(find "$project_path" -name "*.py" -o -name "*.js" -o -name "*.ts" -exec wc -l {} + | tail -1 | awk '{print $1}')
    
    if [[ $line_count -lt 1000 ]]; then
        echo "small"
    elif [[ $line_count -lt 10000 ]]; then
        echo "medium"
    else
        echo "large"
    fi
}

get_team_size() {
    local project_size="$1"
    case "$project_size" in
        small) echo 2 ;;
        medium) echo 4 ;;
        large) echo 6 ;;
        *) echo 3 ;;
    esac
}

deploy_team() {
    local session="$1"
    local project_path="$2"
    local project_size="$3"
    
    case "$project_size" in
        small)
            deploy_small_team "$session" "$project_path"
            ;;
        medium)
            deploy_medium_team "$session" "$project_path"
            ;;
        large)
            deploy_large_team "$session" "$project_path"
            ;;
    esac
}

schedule_cross_project_sync() {
    local orchestrator_window="$1"
    local schedule_script="$HOME/work/Tmux orchestrator/schedule_with_note.sh"
    
    # Schedule regular cross-project coordination
    "$schedule_script" 60 "Cross-project dependency check" "$orchestrator_window"
    "$schedule_script" 120 "Resource allocation review" "$orchestrator_window"
    "$schedule_script" 240 "Comprehensive portfolio review" "$orchestrator_window"
}
```

### Intelligent Resource Allocation

```python
# resource_allocator.py - Smart resource allocation for agent teams

from dataclasses import dataclass
from typing import List, Dict, Optional
from enum import Enum
import json

class ProjectPriority(Enum):
    CRITICAL = "CRITICAL"  # Production issues, security fixes
    HIGH = "HIGH"         # Customer-facing features
    MEDIUM = "MEDIUM"     # Internal improvements
    LOW = "LOW"          # Nice-to-have features

class AgentStatus(Enum):
    AVAILABLE = "AVAILABLE"
    BUSY = "BUSY"
    BLOCKED = "BLOCKED"
    OFFLINE = "OFFLINE"

@dataclass
class Agent:
    id: str
    role: str
    session: str
    window: int
    status: AgentStatus
    current_task: Optional[str] = None
    skill_level: int = 5  # 1-10 scale
    specialties: List[str] = None

@dataclass
class Project:
    id: str
    name: str
    priority: ProjectPriority
    required_roles: List[str]
    estimated_hours: int
    deadline: Optional[str] = None
    dependencies: List[str] = None

class ResourceAllocator:
    def __init__(self):
        self.agents: List[Agent] = []
        self.projects: List[Project] = []
        self.allocations: Dict[str, List[str]] = {}
    
    def add_agent(self, agent: Agent):
        """Register a new agent in the system."""
        self.agents.append(agent)
    
    def add_project(self, project: Project):
        """Add a new project to be allocated."""
        self.projects.append(project)
    
    def allocate_resources(self) -> Dict[str, List[Agent]]:
        """Intelligently allocate agents to projects based on priority and skills."""
        # Sort projects by priority
        sorted_projects = sorted(
            self.projects,
            key=lambda p: (p.priority.value, p.deadline or "9999-12-31")
        )
        
        allocations = {}
        allocated_agents = set()
        
        for project in sorted_projects:
            project_team = []
            
            for required_role in project.required_roles:
                # Find best available agent for role
                best_agent = self._find_best_agent(
                    required_role,
                    allocated_agents,
                    project.specialties if hasattr(project, 'specialties') else []
                )
                
                if best_agent:
                    project_team.append(best_agent)
                    allocated_agents.add(best_agent.id)
            
            allocations[project.id] = project_team
        
        return allocations
    
    def _find_best_agent(
        self,
        role: str,
        allocated: set,
        preferred_specialties: List[str]
    ) -> Optional[Agent]:
        """Find the best available agent for a role."""
        candidates = [
            agent for agent in self.agents
            if agent.role == role
            and agent.id not in allocated
            and agent.status == AgentStatus.AVAILABLE
        ]
        
        if not candidates:
            # Try to find a busy agent that could be reassigned
            candidates = [
                agent for agent in self.agents
                if agent.role == role
                and agent.id not in allocated
                and agent.status == AgentStatus.BUSY
            ]
        
        if not candidates:
            return None
        
        # Score agents based on skill and specialty match
        def score_agent(agent):
            score = agent.skill_level
            if agent.specialties and preferred_specialties:
                matching_specialties = set(agent.specialties) & set(preferred_specialties)
                score += len(matching_specialties) * 2
            return score
        
        return max(candidates, key=score_agent)
    
    def generate_allocation_report(self) -> str:
        """Generate a human-readable allocation report."""
        allocations = self.allocate_resources()
        
        report = "RESOURCE ALLOCATION REPORT\n"
        report += "=" * 50 + "\n\n"
        
        for project_id, team in allocations.items():
            project = next(p for p in self.projects if p.id == project_id)
            report += f"Project: {project.name}\n"
            report += f"Priority: {project.priority.value}\n"
            report += f"Team Size: {len(team)}\n"
            report += "Team Members:\n"
            
            for agent in team:
                report += f"  - {agent.role}: {agent.id} (Skill: {agent.skill_level}/10)\n"
            
            # Check if all required roles are filled
            assigned_roles = {agent.role for agent in team}
            missing_roles = set(project.required_roles) - assigned_roles
            
            if missing_roles:
                report += f"⚠️  Missing roles: {', '.join(missing_roles)}\n"
            
            report += "\n"
        
        # Summary statistics
        total_agents = len(self.agents)
        allocated_agents = sum(len(team) for team in allocations.values())
        utilization = (allocated_agents / total_agents * 100) if total_agents > 0 else 0
        
        report += f"\nSUMMARY\n"
        report += f"Total Agents: {total_agents}\n"
        report += f"Allocated: {allocated_agents}\n"
        report += f"Utilization: {utilization:.1f}%\n"
        
        return report
```

## 🔍 Monitoring & Observability

### System Health Dashboard

```python
# health_monitor.py - Real-time system health monitoring

import asyncio
from datetime import datetime, timedelta
from typing import Dict, List, Optional
import subprocess
import json

class HealthMetric:
    def __init__(self, name: str, value: float, unit: str, threshold: float):
        self.name = name
        self.value = value
        self.unit = unit
        self.threshold = threshold
        self.status = "healthy" if value < threshold else "warning"
        self.timestamp = datetime.utcnow()

class SystemHealthMonitor:
    def __init__(self):
        self.metrics: Dict[str, HealthMetric] = {}
        self.alerts: List[Dict] = []
        self.check_interval = 60  # seconds
    
    async def collect_metrics(self):
        """Collect all system health metrics."""
        metrics = []
        
        # Tmux session metrics
        metrics.extend(await self._collect_tmux_metrics())
        
        # Git repository metrics
        metrics.extend(await self._collect_git_metrics())
        
        # Agent performance metrics
        metrics.extend(await self._collect_agent_metrics())
        
        # System resource metrics
        metrics.extend(await self._collect_system_metrics())
        
        # Update metrics dictionary
        for metric in metrics:
            self.metrics[metric.name] = metric
            
            # Generate alerts for threshold breaches
            if metric.status == "warning":
                self.alerts.append({
                    "metric": metric.name,
                    "value": metric.value,
                    "threshold": metric.threshold,
                    "timestamp": metric.timestamp.isoformat()
                })
    
    async def _collect_tmux_metrics(self) -> List[HealthMetric]:
        """Collect tmux-related metrics."""
        metrics = []
        
        # Count active sessions
        result = subprocess.run(
            ["tmux", "list-sessions"],
            capture_output=True,
            text=True
        )
        session_count = len(result.stdout.strip().split('\n')) if result.stdout else 0
        metrics.append(HealthMetric("tmux_sessions", session_count, "count", 20))
        
        # Count total windows
        window_count = 0
        if session_count > 0:
            result = subprocess.run(
                ["tmux", "list-windows", "-a"],
                capture_output=True,
                text=True
            )
            window_count = len(result.stdout.strip().split('\n')) if result.stdout else 0
        metrics.append(HealthMetric("tmux_windows", window_count, "count", 100))
        
        # Count Claude agents
        claude_count = 0
        if window_count > 0:
            result = subprocess.run(
                ["tmux", "list-windows", "-a", "-F", "#{window_name}"],
                capture_output=True,
                text=True
            )
            claude_count = sum(1 for line in result.stdout.split('\n') if 'Claude' in line)
        metrics.append(HealthMetric("active_agents", claude_count, "count", 50))
        
        return metrics
    
    async def _collect_git_metrics(self) -> List[HealthMetric]:
        """Collect git repository metrics."""
        metrics = []
        
        # Check uncommitted changes across projects
        uncommitted_files = 0
        projects_with_changes = 0
        
        # This would iterate through all active projects
        # For demonstration, checking current directory
        result = subprocess.run(
            ["git", "status", "--porcelain"],
            capture_output=True,
            text=True
        )
        if result.stdout:
            uncommitted_files = len(result.stdout.strip().split('\n'))
            projects_with_changes = 1
        
        metrics.append(HealthMetric("uncommitted_files", uncommitted_files, "files", 50))
        metrics.append(HealthMetric("projects_with_changes", projects_with_changes, "count", 5))
        
        # Check time since last commit
        result = subprocess.run(
            ["git", "log", "-1", "--format=%cr"],
            capture_output=True,
            text=True
        )
        if result.stdout:
            # Parse relative time (this is simplified)
            if "hour" in result.stdout:
                hours = int(result.stdout.split()[0])
                metrics.append(HealthMetric("hours_since_commit", hours, "hours", 2))
            elif "minute" in result.stdout:
                metrics.append(HealthMetric("hours_since_commit", 0, "hours", 2))
            else:
                metrics.append(HealthMetric("hours_since_commit", 24, "hours", 2))
        
        return metrics
    
    async def _collect_agent_metrics(self) -> List[HealthMetric]:
        """Collect agent performance metrics."""
        metrics = []
        
        # Agent responsiveness (simplified - would actually ping agents)
        responsive_agents = 0
        total_agents = self.metrics.get("active_agents", HealthMetric("", 0, "", 0)).value
        
        # Simulate checking agent responsiveness
        responsive_agents = int(total_agents * 0.9)  # 90% responsive
        
        if total_agents > 0:
            responsiveness_rate = (responsive_agents / total_agents) * 100
            metrics.append(HealthMetric("agent_responsiveness", responsiveness_rate, "%", 80))
        
        # Task completion rate (would track actual tasks)
        metrics.append(HealthMetric("task_completion_rate", 85, "%", 70))
        
        # Average task duration
        metrics.append(HealthMetric("avg_task_duration", 45, "minutes", 120))
        
        return metrics
    
    async def _collect_system_metrics(self) -> List[HealthMetric]:
        """Collect system resource metrics."""
        metrics = []
        
        # CPU usage
        result = subprocess.run(
            ["top", "-bn1"],
            capture_output=True,
            text=True
        )
        if result.stdout:
            # Parse CPU idle from top output (simplified)
            cpu_usage = 25.0  # Placeholder
            metrics.append(HealthMetric("cpu_usage", cpu_usage, "%", 80))
        
        # Memory usage
        result = subprocess.run(
            ["free", "-m"],
            capture_output=True,
            text=True
        )
        if result.stdout:
            # Parse memory usage (simplified)
            memory_usage = 45.0  # Placeholder
            metrics.append(HealthMetric("memory_usage", memory_usage, "%", 85))
        
        # Disk usage
        result = subprocess.run(
            ["df", "-h", "/"],
            capture_output=True,
            text=True
        )
        if result.stdout:
            # Parse disk usage (simplified)
            disk_usage = 60.0  # Placeholder
            metrics.append(HealthMetric("disk_usage", disk_usage, "%", 90))
        
        return metrics
    
    def generate_health_report(self) -> str:
        """Generate a comprehensive health report."""
        report = "SYSTEM HEALTH REPORT\n"
        report += f"Generated: {datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')} UTC\n"
        report += "=" * 60 + "\n\n"
        
        # Group metrics by category
        categories = {
            "Tmux System": ["tmux_sessions", "tmux_windows", "active_agents"],
            "Git Health": ["uncommitted_files", "projects_with_changes", "hours_since_commit"],
            "Agent Performance": ["agent_responsiveness", "task_completion_rate", "avg_task_duration"],
            "System Resources": ["cpu_usage", "memory_usage", "disk_usage"]
        }
        
        overall_health = "HEALTHY"
        
        for category, metric_names in categories.items():
            report += f"{category}\n"
            report += "-" * len(category) + "\n"
            
            for metric_name in metric_names:
                if metric_name in self.metrics:
                    metric = self.metrics[metric_name]
                    status_icon = "✅" if metric.status == "healthy" else "⚠️"
                    report += f"{status_icon} {metric.name}: {metric.value:.1f} {metric.unit}"
                    
                    if metric.status == "warning":
                        report += f" (threshold: {metric.threshold})"
                        overall_health = "WARNING"
                    
                    report += "\n"
            
            report += "\n"
        
        # Active alerts
        if self.alerts:
            report += "ACTIVE ALERTS\n"
            report += "-------------\n"
            for alert in self.alerts[-10:]:  # Last 10 alerts
                report += f"⚠️  {alert['metric']}: {alert['value']} exceeds threshold {alert['threshold']}\n"
            report += "\n"
        
        # Overall status
        report += f"\nOVERALL STATUS: {overall_health}\n"
        
        # Recommendations
        if overall_health == "WARNING":
            report += "\nRECOMMENDATIONS:\n"
            
            if "uncommitted_files" in self.metrics and self.metrics["uncommitted_files"].status == "warning":
                report += "- High number of uncommitted files. Remind agents to commit regularly.\n"
            
            if "hours_since_commit" in self.metrics and self.metrics["hours_since_commit"].status == "warning":
                report += "- Long time since last commit. Check if agents are active.\n"
            
            if "cpu_usage" in self.metrics and self.metrics["cpu_usage"].status == "warning":
                report += "- High CPU usage. Consider distributing load or adding resources.\n"
        
        return report
    
    async def continuous_monitoring(self):
        """Run continuous health monitoring."""
        while True:
            await self.collect_metrics()
            
            # Check for critical alerts
            critical_metrics = ["agent_responsiveness", "cpu_usage", "memory_usage"]
            for metric_name in critical_metrics:
                if metric_name in self.metrics and self.metrics[metric_name].status == "warning":
                    # Send alert to orchestrator
                    print(f"🚨 CRITICAL ALERT: {metric_name} is in warning state!")
            
            await asyncio.sleep(self.check_interval)
```

## 📝 Documentation Standards

### Auto-Generated Documentation

```python
# doc_generator.py - Automatic documentation generation for projects

import os
import ast
import json
from pathlib import Path
from typing import Dict, List, Optional
from dataclasses import dataclass

@dataclass
class CodeEntity:
    name: str
    type: str  # function, class, method
    docstring: Optional[str]
    signature: Optional[str]
    file_path: str
    line_number: int

class DocumentationGenerator:
    def __init__(self, project_path: str):
        self.project_path = Path(project_path)
        self.entities: List[CodeEntity] = []
        self.readme_template = """# {project_name}

## Overview
{overview}

## Installation
{installation}

## Usage
{usage}

## API Reference
{api_reference}

## Contributing
{contributing}

## License
{license}
"""
    
    def scan_project(self):
        """Scan project for code entities."""
        for py_file in self.project_path.rglob("*.py"):
            if "venv" in str(py_file) or "__pycache__" in str(py_file):
                continue
            
            self._parse_python_file(py_file)
    
    def _parse_python_file(self, file_path: Path):
        """Parse a Python file for documentation."""
        try:
            with open(file_path, 'r') as f:
                tree = ast.parse(f.read())
            
            for node in ast.walk(tree):
                if isinstance(node, ast.FunctionDef):
                    entity = CodeEntity(
                        name=node.name,
                        type="function",
                        docstring=ast.get_docstring(node),
                        signature=self._get_function_signature(node),
                        file_path=str(file_path.relative_to(self.project_path)),
                        line_number=node.lineno
                    )
                    self.entities.append(entity)
                
                elif isinstance(node, ast.ClassDef):
                    entity = CodeEntity(
                        name=node.name,
                        type="class",
                        docstring=ast.get_docstring(node),
                        signature=f"class {node.name}",
                        file_path=str(file_path.relative_to(self.project_path)),
                        line_number=node.lineno
                    )
                    self.entities.append(entity)
                    
                    # Parse methods
                    for item in node.body:
                        if isinstance(item, ast.FunctionDef):
                            method_entity = CodeEntity(
                                name=f"{node.name}.{item.name}",
                                type="method",
                                docstring=ast.get_docstring(item),
                                signature=self._get_function_signature(item),
                                file_path=str(file_path.relative_to(self.project_path)),
                                line_number=item.lineno
                            )
                            self.entities.append(method_entity)
        
        except Exception as e:
            print(f"Error parsing {file_path}: {e}")
    
    def _get_function_signature(self, node: ast.FunctionDef) -> str:
        """Extract function signature."""
        args = []
        for arg in node.args.args:
            args.append(arg.arg)
        
        return f"{node.name}({', '.join(args)})"
    
    def generate_api_documentation(self) -> str:
        """Generate API documentation."""
        doc = "## API Documentation\n\n"
        
        # Group by file
        entities_by_file: Dict[str, List[CodeEntity]] = {}
        for entity in self.entities:
            if entity.file_path not in entities_by_file:
                entities_by_file[entity.file_path] = []
            entities_by_file[entity.file_path].append(entity)
        
        for file_path, entities in sorted(entities_by_file.items()):
            doc += f"### {file_path}\n\n"
            
            for entity in entities:
                if entity.type == "class":
                    doc += f"#### {entity.signature}\n"
                elif entity.type == "function":
                    doc += f"#### `{entity.signature}`\n"
                elif entity.type == "method":
                    doc += f"##### `{entity.signature}`\n"
                
                if entity.docstring:
                    doc += f"\n{entity.docstring}\n"
                else:
                    doc += "\n*No documentation available*\n"
                
                doc += f"\n📍 [View source]({entity.file_path}#L{entity.line_number})\n\n"
        
        return doc
    
    def generate_readme(self, **sections) -> str:
        """Generate README.md content."""
        project_name = self.project_path.name
        
        # Default sections
        defaults = {
            "overview": f"This is the {project_name} project.",
            "installation": "```bash\npip install -r requirements.txt\n```",
            "usage": "See API documentation below.",
            "api_reference": self.generate_api_documentation(),
            "contributing": "Please read CONTRIBUTING.md for details.",
            "license": "This project is licensed under the MIT License."
        }
        
        # Merge with provided sections
        sections = {**defaults, **sections}
        
        return self.readme_template.format(
            project_name=project_name,
            **sections
        )
    
    def update_documentation(self):
        """Update all project documentation."""
        # Scan project
        self.scan_project()
        
        # Generate README
        readme_path = self.project_path / "README.md"
        readme_content = self.generate_readme()
        
        with open(readme_path, 'w') as f:
            f.write(readme_content)
        
        # Generate API docs
        api_docs_path = self.project_path / "docs" / "API.md"
        api_docs_path.parent.mkdir(exist_ok=True)
        
        with open(api_docs_path, 'w') as f:
            f.write(self.generate_api_documentation())
        
        # Generate entity index
        index_path = self.project_path / "docs" / "index.json"
        index_data = [
            {
                "name": entity.name,
                "type": entity.type,
                "file": entity.file_path,
                "line": entity.line_number,
                "has_docs": entity.docstring is not None
            }
            for entity in self.entities
        ]
        
        with open(index_path, 'w') as f:
            json.dump(index_data, f, indent=2)
        
        print(f"✅ Documentation updated for {self.project_path.name}")
        print(f"   - README.md")
        print(f"   - docs/API.md")
        print(f"   - docs/index.json")
```

## 🚨 Anti-Patterns to Avoid

### Common Orchestration Mistakes

```yaml
# anti-patterns.yml - What NOT to do

communication_anti_patterns:
  broadcast_storms:
    description: "Sending the same message to all agents"
    why_bad: "Creates noise, reduces signal quality"
    instead: "Use hub-and-spoke through PMs"
    
  endless_threads:
    description: "Back-and-forth messages without resolution"
    why_bad: "Wastes time, no progress"
    instead: "Max 3 exchanges, then escalate"
    
  unclear_messages:
    description: "Vague or ambiguous instructions"
    why_bad: "Leads to misunderstandings and rework"
    instead: "Use message templates with clear structure"

scheduling_anti_patterns:
  blind_scheduling:
    description: "Scheduling without verifying target exists"
    why_bad: "Tasks disappear into void"
    instead: "Always verify window exists before scheduling"
    
  forgetting_self:
    description: "Not scheduling orchestrator checks"
    why_bad: "Orchestrator goes offline, system fails"
    instead: "Always schedule recurring self-checks"
    
  wrong_window_targeting:
    description: "Hardcoding window targets"
    why_bad: "Breaks when windows change"
    instead: "Use dynamic window discovery"

git_anti_patterns:
  marathon_sessions:
    description: "Working hours without commits"
    why_bad: "Risk losing hours of work"
    instead: "Commit every 30 minutes minimum"
    
  meaningless_messages:
    description: "Commits like 'fix', 'update', 'changes'"
    why_bad: "No context for future reference"
    instead: "Use conventional commits with clear descriptions"
    
  working_on_main:
    description: "Direct commits to main branch"
    why_bad: "No rollback safety, conflicts"
    instead: "Always use feature branches"

quality_anti_patterns:
  skipping_tests:
    description: "Deploying without running tests"
    why_bad: "Breaks production, loses trust"
    instead: "Tests must pass before any merge"
    
  ignoring_linting:
    description: "Committing code with lint errors"
    why_bad: "Technical debt accumulates"
    instead: "Fix all lint errors before commit"
    
  documentation_lag:
    description: "Code changes without doc updates"
    why_bad: "Docs become useless, misleading"
    instead: "Update docs with every feature"

team_anti_patterns:
  micromanagement:
    description: "Checking on agents every 5 minutes"
    why_bad: "Destroys productivity, trust"
    instead: "Trust agents, check every 30-60 min"
    
  hero_syndrome:
    description: "One agent doing everything"
    why_bad: "Burnout, single point of failure"
    instead: "Distribute work evenly"
    
  silo_working:
    description: "Agents not communicating"
    why_bad: "Duplicated effort, conflicts"
    instead: "Regular async standups"
```

## 🎓 Critical Lessons Learned

### Tmux Window Management Deep Dive

```bash
#!/bin/bash
# window-management-lessons.sh - Hard-won lessons about tmux

# LESSON 1: Window Working Directory Inheritance
# Problem: New windows inherit directory from tmux server start, not current window
demonstrate_directory_inheritance() {
    echo "❌ WRONG: Window inherits from tmux server start location"
    tmux new-window -t session -n "wrong-dir"
    # This window will be in whatever directory tmux was started from
    
    echo "✅ RIGHT: Explicitly set working directory"
    tmux new-window -t session -n "right-dir" -c "/path/to/project"
    # This window will be in the correct project directory
}

# LESSON 2: Always Verify Command Success
# Problem: Assuming commands work without checking
demonstrate_command_verification() {
    echo "❌ WRONG: Fire and forget"
    tmux send-keys -t session:0 "npm start" Enter
    # No verification if this actually worked
    
    echo "✅ RIGHT: Send command and verify"
    tmux send-keys -t session:0 "npm start" Enter
    sleep 3
    output=$(tmux capture-pane -t session:0 -p | tail -20)
    if echo "$output" | grep -q "error"; then
        echo "Command failed! Output: $output"
    fi
}

# LESSON 3: Check Window State Before Commands
# Problem: Sending commands to already-running processes
demonstrate_window_state_check() {
    echo "❌ WRONG: Blindly send commands"
    tmux send-keys -t session:0 "claude --dangerously-skip-permissions" Enter
    # Might type this into an already-running Claude!
    
    echo "✅ RIGHT: Check window state first"
    content=$(tmux capture-pane -t session:0 -p | tail -5)
    if echo "$content" | grep -q "claude>"; then
        echo "Claude already running, sending message instead"
        $HOME/work/Tmux\ orchestrator/send-claude-message.sh session:0 "Your message"
    else
        echo "Starting Claude"
        tmux send-keys -t session:0 "claude --dangerously-skip-permissions" Enter
    fi
}

# LESSON 4: Message Timing is Critical
# Problem: Enter key sent too quickly after message
demonstrate_message_timing() {
    echo "❌ WRONG: Message and Enter together"
    tmux send-keys -t session:0 "Important message" Enter
    # Enter might be processed with the message text!
    
    echo "✅ RIGHT: Use the messaging script"
    $HOME/work/Tmux\ orchestrator/send-claude-message.sh session:0 "Important message"
    # Script handles timing correctly
}

# LESSON 5: Virtual Environment Activation
# Problem: Running Python commands without venv
demonstrate_venv_handling() {
    echo "❌ WRONG: Assume venv is active"
    tmux send-keys -t session:0 "pip install -r requirements.txt" Enter
    # Might install globally!
    
    echo "✅ RIGHT: Always activate venv first"
    tmux send-keys -t session:0 "source venv/bin/activate && pip install -r requirements.txt" Enter
    # Or better, check if venv exists first:
    tmux send-keys -t session:0 "test -d venv && source venv/bin/activate || python -m venv venv && source venv/bin/activate" Enter
}

# LESSON 6: Port Conflicts
# Problem: Starting servers on already-used ports
demonstrate_port_handling() {
    echo "❌ WRONG: Assume port is free"
    tmux send-keys -t session:0 "npm run dev" Enter
    # Might fail if port 3000 is in use
    
    echo "✅ RIGHT: Check port availability"
    tmux send-keys -t session:0 "lsof -i :3000" Enter
    sleep 1
    output=$(tmux capture-pane -t session:0 -p | tail -5)
    if echo "$output" | grep -q "LISTEN"; then
        echo "Port 3000 in use, trying 3001"
        tmux send-keys -t session:0 "PORT=3001 npm run dev" Enter
    else
        tmux send-keys -t session:0 "npm run dev" Enter
    fi
}

# LESSON 7: Session Naming Conventions
# Problem: Spaces and special characters in session names
demonstrate_session_naming() {
    echo "❌ WRONG: Spaces in session names"
    tmux new-session -d -s "My Project"  # Will fail!
    
    echo "✅ RIGHT: Replace spaces with hyphens"
    project_name="My Awesome Project"
    session_name=$(echo "$project_name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
    tmux new-session -d -s "$session_name"  # my-awesome-project
}

# LESSON 8: Window Index Management
# Problem: Assuming window indices are sequential
demonstrate_window_indices() {
    echo "❌ WRONG: Assume windows are 0,1,2,3..."
    for i in {0..3}; do
        tmux send-keys -t session:$i "command" Enter
    done
    # Might fail if windows were closed/reordered
    
    echo "✅ RIGHT: Query actual window indices"
    for window in $(tmux list-windows -t session -F "#{window_index}"); do
        tmux send-keys -t session:$window "command" Enter
    done
}

# LESSON 9: Pane Management in Split Windows
# Problem: Not handling panes correctly
demonstrate_pane_handling() {
    echo "❌ WRONG: Ignore panes exist"
    tmux send-keys -t session:0 "command" Enter
    # Only goes to first pane!
    
    echo "✅ RIGHT: Target specific panes"
    # Send to second pane of window 0
    tmux send-keys -t session:0.1 "command for pane 2" Enter
    
    # Or iterate through all panes
    for pane in $(tmux list-panes -t session:0 -F "#{pane_index}"); do
        tmux send-keys -t session:0.$pane "command" Enter
    done
}

# LESSON 10: Graceful Error Handling
# Problem: Scripts fail silently
demonstrate_error_handling() {
    echo "❌ WRONG: No error handling"
    tmux new-window -t nonexistent-session
    tmux send-keys -t session:99 "command" Enter
    # Fails silently, no feedback
    
    echo "✅ RIGHT: Check operations succeed"
    if ! tmux has-session -t session 2>/dev/null; then
        echo "Session doesn't exist, creating it"
        tmux new-session -d -s session
    fi
    
    if ! tmux send-keys -t session:0 "command" Enter 2>/dev/null; then
        echo "Failed to send command, window might not exist"
    fi
}
```

### Recovery Procedures

```bash
#!/bin/bash
# disaster-recovery.sh - How to recover from common failures

# RECOVERY 1: Orchestrator Crashed
recover_orchestrator() {
    echo "🚨 ORCHESTRATOR RECOVERY PROCEDURE"
    echo "================================="
    
    # 1. Find orchestrator session
    orchestrator_session=$(tmux list-sessions -F "#{session_name}" | grep -E "(orchestrator|tmux-orc)")
    
    if [[ -z "$orchestrator_session" ]]; then
        echo "❌ No orchestrator session found"
        echo "Creating new orchestrator session..."
        tmux new-session -d -s tmux-orc -c "$HOME/work/Tmux orchestrator"
        orchestrator_session="tmux-orc"
    fi
    
    # 2. Check if Claude is running
    content=$(tmux capture-pane -t "$orchestrator_session:0" -p 2>/dev/null | tail -10)
    
    if ! echo "$content" | grep -q "Orchestrator"; then
        echo "Starting new orchestrator..."
        tmux send-keys -t "$orchestrator_session:0" "claude --dangerously-skip-permissions" Enter
        sleep 5
        
        # Send recovery briefing
        $HOME/work/Tmux\ orchestrator/send-claude-message.sh "$orchestrator_session:0" \
"ORCHESTRATOR RECOVERY MODE ACTIVATED

You are recovering from a crash/restart. Please:
1. Run startup verification checks immediately
2. Check all active sessions and their health
3. Verify all scheduled tasks are running
4. Resume normal orchestration duties

Critical: Set up self-scheduling before doing anything else!"
    fi
    
    echo "✅ Orchestrator recovered"
}

# RECOVERY 2: Lost Agent Communication
recover_agent_communication() {
    local session="$1"
    local window="$2"
    
    echo "🔧 Attempting to recover agent at $session:$window"
    
    # Check if agent is responsive
    test_message="PING: Please respond with 'PONG' if you receive this"
    $HOME/work/Tmux\ orchestrator/send-claude-message.sh "$session:$window" "$test_message"
    
    sleep 5
    response=$(tmux capture-pane -t "$session:$window" -p | tail -20)
    
    if echo "$response" | grep -q "PONG"; then
        echo "✅ Agent is responsive"
    else
        echo "❌ Agent not responding, attempting restart"
        
        # Kill the window and recreate
        tmux kill-window -t "$session:$window"
        tmux new-window -t "$session:$window" -n "Claude-Recovered"
        tmux send-keys -t "$session:$window" "claude --dangerously-skip-permissions" Enter
        
        sleep 5
        
        # Brief the recovered agent
        $HOME/work/Tmux\ orchestrator/send-claude-message.sh "$session:$window" \
"You are a recovered agent. Please:
1. Check the project status
2. Review recent commits to understand progress
3. Report your status to the Project Manager
4. Resume work on assigned tasks"
    fi
}

# RECOVERY 3: Git Repository Corruption
recover_git_repository() {
    local repo_path="$1"
    
    echo "🔧 Git repository recovery for: $repo_path"
    
    cd "$repo_path" || return 1
    
    # 1. Check repository status
    if ! git status &>/dev/null; then
        echo "❌ Git repository is corrupted"
        
        # Try to recover
        echo "Attempting recovery..."
        
        # Backup current state
        cp -r .git .git.backup.$(date +%Y%m%d-%H%M%S)
        
        # Try to repair
        git fsck --full
        
        # If still broken, more aggressive recovery
        if ! git status &>/dev/null; then
            echo "Attempting object database recovery..."
            rm -f .git/index
            git reset
            
            # Rebuild index
            git add -A
        fi
    fi
    
    # 2. Check for uncommitted changes
    if [[ -n $(git status --porcelain) ]]; then
        echo "⚠️  Uncommitted changes detected"
        git add -A
        git commit -m "RECOVERY: Auto-commit of uncommitted changes $(date)"
    fi
    
    # 3. Verify all branches
    for branch in $(git branch -r | grep -v HEAD); do
        local_branch=${branch#origin/}
        if ! git show-ref --verify --quiet "refs/heads/$local_branch"; then
            echo "Recovering missing branch: $local_branch"
            git checkout -b "$local_branch" "$branch"
        fi
    done
    
    echo "✅ Git recovery complete"
}

# RECOVERY 4: Full System Recovery
full_system_recovery() {
    echo "🚨 FULL SYSTEM RECOVERY"
    echo "====================="
    
    # 1. Check tmux server
    if ! tmux list-sessions &>/dev/null; then
        echo "❌ Tmux server not running"
        tmux start-server
    fi
    
    # 2. Recover orchestrator
    recover_orchestrator
    
    # 3. Scan for active projects
    echo "Scanning for active projects..."
    for session in $(tmux list-sessions -F "#{session_name}" 2>/dev/null); do
        echo "Found session: $session"
        
        # Check each window
        for window in $(tmux list-windows -t "$session" -F "#{window_index}:#{window_name}"); do
            if echo "$window" | grep -q "Claude"; then
                window_index=$(echo "$window" | cut -d: -f1)
                recover_agent_communication "$session" "$window_index"
            fi
        done
    done
    
    # 4. Verify all git repositories
    for project_dir in $(find "$HOME/work" -name ".git" -type d | xargs dirname); do
        echo "Checking git repository: $project_dir"
        recover_git_repository "$project_dir"
    done
    
    # 5. Generate recovery report
    generate_recovery_report
}

generate_recovery_report() {
    local report_file="$HOME/work/Tmux orchestrator/recovery-report-$(date +%Y%m%d-%H%M%S).md"
    
    cat > "$report_file" << EOF
# System Recovery Report
Generated: $(date)

## Sessions Recovered
$(tmux list-sessions 2>/dev/null || echo "No sessions active")

## Agent Status
$(for session in $(tmux list-sessions -F "#{session_name}" 2>/dev/null); do
    echo "### $session"
    tmux list-windows -t "$session" -F "- Window #{window_index}: #{window_name}"
done)

## Git Repository Status
$(for repo in $(find "$HOME/work" -name ".git" -type d | xargs dirname); do
    echo "### $repo"
    cd "$repo" && git status --short || echo "Error checking status"
done)

## Recommended Actions
1. Verify all agents are responsive
2. Check for any uncommitted work
3. Review scheduled tasks
4. Resume normal operations

EOF
    
    echo "📄 Recovery report saved to: $report_file"
}

# Main recovery menu
show_recovery_menu() {
    echo "🔧 DISASTER RECOVERY MENU"
    echo "======================="
    echo "1. Recover crashed orchestrator"
    echo "2. Recover unresponsive agent"
    echo "3. Fix corrupted git repository"
    echo "4. Full system recovery"
    echo "5. Exit"
    echo ""
    read -p "Select option (1-5): " choice
    
    case $choice in
        1) recover_orchestrator ;;
        2) 
            read -p "Enter session:window (e.g., project:0): " target
            session=$(echo "$target" | cut -d: -f1)
            window=$(echo "$target" | cut -d: -f2)
            recover_agent_communication "$session" "$window"
            ;;
        3)
            read -p "Enter repository path: " repo_path
            recover_git_repository "$repo_path"
            ;;
        4) full_system_recovery ;;
        5) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    show_recovery_menu
fi
```

## 🎯 Quick Reference Card

### Essential Commands

```bash
# Start new project
./start-project.sh "project-name"

# Deploy project manager
./create-project-manager.sh session-name

# Send message to agent
$HOME/work/Tmux\ orchestrator/send-claude-message.sh session:window "message"

# Check agent status
tmux capture-pane -t session:window -p | tail -50

# Schedule recurring task
./schedule_with_note.sh 30 "Task description" "session:window"

# Run quality checks
./pm-verification.sh /path/to/project session-name

# System health check
./health-check.sh

# Emergency recovery
./disaster-recovery.sh
```

### Status Codes

- 🟢 **GREEN**: System healthy, all checks passing
- 🟡 **YELLOW**: Warnings present, attention needed
- 🔴 **RED**: Critical issues, immediate action required
- ⚫ **BLACK**: System component offline or unresponsive

### Communication Priority Levels

1. **CRITICAL**: Production down, data loss risk
2. **HIGH**: Blocked work, security issues
3. **MEDIUM**: Normal priority tasks
4. **LOW**: Nice-to-have improvements

### Git Commit Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test additions/changes
- `chore`: Build process updates

---

**Remember**: Quality over speed. No shortcuts. Commit early, commit often. When in doubt, escalate.

# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.