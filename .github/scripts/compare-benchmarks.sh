#!/bin/bash
# Usage: compare-benchmarks.sh <base-metrics.json> <head-metrics.json> <max-regression-percent>
#
# Compares the median instructions retired of each benchmark, as exported by
# `xcrun xcresulttool get test-results metrics`, prints a Markdown table, and
# exits with 1 when any benchmark regresses by more than the given percentage.
set -euo pipefail

base=$1
head=$2
threshold=$3

medians() {
	jq '
		map({
			key: (.testIdentifier | sub("\\(\\)$"; "")),
			value: (
				.testRuns[0].metrics[]
				| select(.identifier == "com.apple.dt.XCTMetric_CPU.instructions_retired")
				| .measurements | sort | .[length / 2 | floor]
			),
		})
		| from_entries
	' "$1"
}

jq -n -r \
	--argjson base "$(medians "$base")" \
	--argjson head "$(medians "$head")" \
	--argjson threshold "$threshold" '
	def millions: . / 1000 | . * 10 | round / 10 | tostring + "M";
	def change: if . > 0 then "+" else "" end + (. * 10 | round / 10 | tostring) + "%";
	"| Benchmark | Base | Pull request | Change |",
	"| --- | ---: | ---: | ---: |",
	(
		$head | keys[] as $name
		| $head[$name] as $new
		| $base[$name] as $old
		| if $old == null then
			"| \($name) | | \($new | millions) | New |"
		else
			(($new - $old) / $old * 100) as $delta
			| "| \($name) | \($old | millions) | \($new | millions) | \($delta | change)\(if $delta > $threshold then " ⚠️" else "" end) |"
		end
	),
	"",
	"Median instructions retired over 10 iterations. Changes above \($threshold)% fail this check."
'

jq -n -e \
	--argjson base "$(medians "$base")" \
	--argjson head "$(medians "$head")" \
	--argjson threshold "$threshold" '
	[$head | to_entries[] | select($base[.key] != null) | (.value - $base[.key]) / $base[.key] * 100]
	| all(. <= $threshold)
' > /dev/null
