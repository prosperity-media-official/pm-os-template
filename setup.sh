#!/bin/bash
set -e

echo "Setting up Prosperity Brain workspace..."
echo ""

# Check prosperity-skills submodule
if [ ! -f "prosperity-skills/README.md" ]; then
    echo "WARNING: prosperity-skills is missing!"
    echo "  Run: git submodule update --init --recursive"
    echo "  Without skills, /pm-new-project, /pm-codify, /pm-generate-content-brief, /pm-reporting won't work."
    echo ""
    echo "Attempting to initialise submodule now..."
    git submodule update --init --recursive

    # Check again after attempting init
    if [ ! -f "prosperity-skills/README.md" ]; then
        echo ""
        echo "ERROR: Could not initialise prosperity-skills."
        echo "  Make sure you cloned with: git clone --recurse-submodules <repo-url>"
        echo "  Or run: git submodule update --init --recursive"
        exit 1
    fi
fi

echo "prosperity-skills found."
echo ""

# Symlink skills into Claude Code skills directory
mkdir -p ~/.claude/skills
for skill in prosperity-skills/pm-*/; do
    if [ -d "$skill" ]; then
        skill_name=$(basename "$skill")
        ln -sf "$(pwd)/$skill" "$HOME/.claude/skills/$skill_name"
        echo "  Linked: $skill_name"
    fi
done

echo ""
echo "Setup complete! Skills installed:"
ls -d ~/.claude/skills/pm-* 2>/dev/null | xargs -I{} basename {} || echo "  (none found)"
echo ""
echo "Next steps:"
echo "  1. Open Claude Code in this directory"
echo "  2. Run /pm-new-project to onboard your first client"
echo "  3. Or manually create a client folder following _example-client/"
