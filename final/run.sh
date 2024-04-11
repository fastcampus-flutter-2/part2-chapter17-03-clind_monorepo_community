# usage: ./run.sh

# fvm 을 사용하지 않는다면, fvm 을 제거해주세요
FLUTTER="fvm flutter"

DIR=$(pwd)

for dir in $(find . -type f -name 'pubspec.yaml' -exec dirname "{}" \;); do
  echo "Working in directory: $dir"
  cd "$dir" || continue

  echo "Removing pubspec.lock..."
  rm -f pubspec.lock || true

  echo "Running 'flutter clean'..."
  $FLUTTER clean || true

  echo "Updating packages with force-upgrade..."
  $FLUTTER update-packages --force-upgrade || true

  echo "Getting packages..."
  $FLUTTER pub get || true

  if grep -q "build_runner:" pubspec.lock; then
    echo "Running build_runner to generate and build project files..."
    $FLUTTER packages pub run build_runner build --delete-conflicting-outputs
  fi

  cd "$DIR" || exit
done