#!/bin/bash
# Usage: compare-benchmarks.sh <base-metrics.json> <head-metrics.json> <flag-percent>
#
# Prints a Markdown table comparing the median of each benchmark, as exported by
# `xcrun xcresulttool get test-results metrics`, and flags changes above the given
# percentage. It compares instructions retired when both runs report them, and CPU
# time otherwise, since virtualized runners don't expose hardware counters.
set -euo pipefail

base=$1
head=$2
flag=$3

instructions="com.apple.dt.XCTMetric_CPU.instructions_retired"
cpu_time="com.apple.dt.XCTMetric_CPU.time"

medians() { # file metric
	jq --arg metric "$2" '
		map({
			key: (.testIdentifier | sub("\\(\\)$"; "")),
			value: (.testRuns[0].metrics[] | select(.identifier == $metric) | .measurements | sort | .[length / 2 | floor]),
		})
		| from_entries
	' "$1"
}

has_counts() { # file
	jq -e --arg metric "$instructions" 'any(.[].testRuns[0].metrics[]; .identifier == $metric and (.measurements | max) > 0)' "$1" > /dev/null
}

if has_counts "$head" && { [ "$(jq length "$base")" = 0 ] || has_counts "$base"; }; then
	metric=$instructions
else
	metric=$cpu_time
fi

jq -n -r \
	--argjson base "$(medians "$base" "$metric")" \
	--argjson head "$(medians "$head" "$metric")" \
	--argjson flag "$flag" \
	--arg metric "$metric" \
	--arg instructions "$instructions" '
	def value:
		if $metric == $instructions then . / 1000 | . * 10 | round / 10 | tostring + "M"
		else . * 1000 | round | tostring + " ms"
		end;
	def change: (if . > 0 then "+" else "" end) + (. * 10 | round / 10 | tostring) + "%";
	"| Benchmark | Base | Pull request | Change |",
	"| --- | ---: | ---: | ---: |",
	(
		$head | keys[] as $name
		| $head[$name] as $new
		| $base[$name] as $old
		| if $old == null then
			"| \($name) | | \($new | value) | New |"
		else
			(($new - $old) / $old * 100) as $delta
			| "| \($name) | \($old | value) | \($new | value) | \($delta | change)\(if $delta > $flag then " ⚠️" else "" end) |"
		end
	),
	"",
	"Median \(if $metric == $instructions then "instructions retired" else "CPU time" end) over 10 iterations. ⚠️ marks increases above \($flag)%."
'
