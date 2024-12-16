if [ "$CF_PAGES_BRANCH" = "main" ]; then
  hugo -b "https://benpoppy.dev/"
else
  hugo -b "$CF_PAGES_URL/"
fi
