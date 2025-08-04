Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E830C243964
	for <nvdimm@lists.linux.dev>; Mon,  4 Aug 2025 09:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754298103; cv=none; b=WzW5TN/Cw69VjkzDp5Bi1ydtwhH57hbqqAug9vqmhK6o2zy7e/NctmG+bWxPDqmr/mNfNURth3qgodTJNZM3QlDD07G/YBG1ktd9GbtCAwTwi/cHERG9lIXm5PKXNF3lc/tHUE19hH1WQielIBxrzgB9ROMwKYg+yigGhNh1HEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754298103; c=relaxed/simple;
	bh=4yFU3wAC2aa+FSEwpbKHuT+pG7q6tGWOkvFuBdfSqSY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n933uR6bROuiuVrd0Xx33ynqBhYwfBCJ3Z8VBfW8N2sb0MxEYlN5DMZA+eAr8AOtBX9d8/p/x0VEXsjb5Cl/OWi3TzJihSyS/2wTgB0WgGg9rbuQHBRDYhW6W4HXwTgw+rZVSCwQAABy9tyxIVT9GZK3x96GuqJl31AlpJ6myFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W9bwgoz7; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W9bwgoz7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754298102; x=1785834102;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4yFU3wAC2aa+FSEwpbKHuT+pG7q6tGWOkvFuBdfSqSY=;
  b=W9bwgoz74t+bDhKCinqtMshD7UEsbUHm0OruxQQ0aU3KiMzYUgQHFv6A
   GQlBl9s5HIaEqArXc/vP8iBh705+XSfsOFRKzutQuo9+BJi4JW09J3gtF
   VEDxBZT8xh+HIQQDLlkLtNGi28hG6uqvv5T5t+8BTHD+7WITb4fSSXO1w
   Flyb1goZ6NeSCC9XimxaX2isMGVPR4LMVaMitR+IUirF24/RTQILO6kJj
   cWsoYnQGIMmqUdqNmMal6P5WO3SHQ1fz56kr8X7Nps3KpC4b77CkSHVTR
   SOJwFHAxP2qI3z0J330cKeKzfS9NMuKZcCNao957c8fN0DlWUf0LXoBR9
   Q==;
X-CSE-ConnectionGUID: PPi3VgmfQ9iz/4khmFmpZA==
X-CSE-MsgGUID: f/XhtejvTh2hNG2jwuW/ew==
X-IronPort-AV: E=McAfee;i="6800,10657,11511"; a="56443378"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="56443378"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 02:01:41 -0700
X-CSE-ConnectionGUID: 5YbDb/y4QLCJxOTNnlI0qQ==
X-CSE-MsgGUID: VFnxtZsWSTapQVCWfARLFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="164106420"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.77])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 02:01:41 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] cxl: Add cxl-translate.sh unit test
Date: Mon,  4 Aug 2025 02:01:35 -0700
Message-ID: <20250804090137.2593137-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The cxl-translate.sh unit test feeds trusted data sets to a kernel
test module: cxl_translate. The module accesses the CXL Drivers's
address translation functions.

The trusted samples are either from the CXL Driver Writers Guide[1]
or from another source that has been verified. ie a spreadsheet
reviewed by CXL developers.

[1] https://www.intel.com/content/www/us/en/content-details/643805/cxl-memory-device-sw-guide.html

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-translate.sh | 297 ++++++++++++++++++++++++++++++++++++++++++
 test/meson.build      |   2 +
 2 files changed, 299 insertions(+)
 create mode 100755 test/cxl-translate.sh

diff --git a/test/cxl-translate.sh b/test/cxl-translate.sh
new file mode 100755
index 000000000000..5a300f24af8f
--- /dev/null
+++ b/test/cxl-translate.sh
@@ -0,0 +1,297 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2025 Intel Corporation. All rights reserved.
+
+# Allow what shellcheck suspects are unused - the arrays
+# shellcheck disable=SC2034
+
+# source common to get the err()
+. "$(dirname "$0")"/common
+
+trap 'err $LINENO' ERR
+set -ex
+rc=1
+
+MODULO=0
+XOR=1
+
+
+# Test against 'Sample Sets' and 'XOR Tables'
+#
+# Sample Set's have a pattern and the expected HPAs have been verified
+# although maybe not published. They verify Modulo and XOR translations.
+#
+# XOR Table's are extracted from the CXL Driver Writers Guide [1].
+# Although the XOR Tables do not include an explicit check of the Modulo
+# translation result, a Modulo calculation is always the first step in
+# any XOR calculation. ie. if Modulo fails so does XOR.
+#
+# [1] https://www.intel.com/content/www/us/en/content-details/643805/cxl-memory-device-sw-guide.html
+
+# Start time for kernel log checking at millisecond granularity
+set_log_start_time() {
+        log_start_time=$(date '+%Y-%m-%d %H:%M:%S.%3N')
+}
+
+check_dmesg_results() {
+        local nr_entries=$1
+        local expect_failures=${2:-false}  # Optional param
+        local log nr_pass nr_fail
+
+        log=$(journalctl -r -k --since "$log_start_time")
+
+	nr_pass=$(echo "$log" | grep -c "CXL Translate Test.*PASS") || nr_pass=0
+        nr_fail=$(echo "$log" | grep -c "CXL Translate Test.*FAIL") || nr_fail=0
+
+        if [ "$expect_failures" = "false" ]; then
+                # Expect all PASS and no FAIL
+                [ "$nr_pass" -eq "$nr_entries" ] || err "$LINENO"
+                [ "$nr_fail" -eq 0 ] || err "$LINENO"
+        else
+                # Expect no PASS and all FAIL
+		[ "$nr_pass" -eq 0 ] || err "$LINENO"
+                [ "$nr_fail" -eq "$nr_entries" ] || err "$LINENO"
+        fi
+}
+
+# Sample Sets
+#
+# params_#: dpa, region eiw, region eig, host bridge ways
+# expect_[modulo|xor]_#: expected spa for each position in the region
+# 	interleave set for the modulo|xor math.
+#
+# Feeds the parameters with an expected SPA for each position in the region
+# interleave to the test module. Returns success if the calculation matches
+# the expected SPA and the reverse calculation returns the original DPA and
+# position.
+
+# 4 way region interleave using 4 host bridges
+# Notation: 1+1+1+1
+declare -A Sample_4R_4H=(
+	["params_0"]="0 2 0 4"
+	["expect_modulo_0"]="0 256 512 768"
+	["expect_xor_0"]="0 256 512 768"
+	["params_1"]="256 2 0 4"
+	["expect_modulo_1"]="1024 1280 1536 1792"
+	["expect_xor_1"]="1024 1280 1536 1792"
+	["params_2"]="2048 2 0 4"
+	["expect_modulo_2"]="8192 8448 8704 8960"
+	["expect_xor_2"]="8192 8448 8704 8960"
+)
+
+# 12 way region interleave using 12 host bridges
+# Notation: 1+1+1+1+1+1+1+1+1+1+1+1
+declare -A Sample_12R_12H=(
+	["params_0"]="0 10 0 12"
+	["expect_modulo_0"]="0 256 512 768 1024 1280 1536 1792 2048 2304 2560 2816"
+	["expect_xor_0"]="0 256 512 768 1024 1280 1536 1792 2304 2048 2816 2560"
+	["params_1"]="512 10 0 12"
+	["expect_modulo_1"]="6144 6400 6656 6912 7168 7424 7680 7936 8192 8448 8704 8960"
+	["expect_xor_1"]="6912 6656 6400 6144 7936 7680 7424 7168 8192 8448 8704 8960"
+)
+
+decode_r_eiw()
+{
+	case $1 in
+		0) echo 1 ;;
+		1) echo 2 ;;
+		2) echo 4 ;;
+		3) echo 8 ;;
+		4) echo 16 ;;
+		8) echo 3 ;;
+		9) echo 6 ;;
+		10) echo 12 ;;
+		*) echo "Invalid r_eiw value: $1" ; err "$LINENO" ;;
+	esac
+}
+
+generate_sample_tests() {
+        local -n input_sample_set=$1
+        local -n output_array=$2
+
+        # Find all params_* keys and extract the index
+        local indices=()
+        for key in "${!input_sample_set[@]}"; do
+                if [[ $key =~ ^params_([0-9]+)$ ]]; then
+                        indices+=("${BASH_REMATCH[1]}")
+                fi
+        done
+
+        # Sort indices to process in order
+	mapfile -t indices < <(printf '%s\n' "${indices[@]}" | sort -n)
+
+        for i in "${indices[@]}"; do
+                # Split the parameters and expected spa values
+                IFS=' ' read -r dpa r_eiw r_eig hb_ways <<< "${input_sample_set["params_$i"]}"
+                IFS=' ' read -r -a expect_modulo_values <<< "${input_sample_set["expect_modulo_$i"]}"
+                IFS=' ' read -r -a expect_xor_values <<< "${input_sample_set["expect_xor_$i"]}"
+
+                ways=$(decode_r_eiw "$r_eiw")
+                for ((pos = 0; pos < ways; pos++)); do
+                        expect_spa_modulo=${expect_modulo_values[$pos]}
+                        expect_spa_xor=${expect_xor_values[$pos]}
+
+                        # Add the MODULO test case, then the XOR test case
+                        output_array+=("$dpa $pos $r_eiw $r_eig $hb_ways $MODULO $expect_spa_modulo")
+                        output_array+=("$dpa $pos $r_eiw $r_eig $hb_ways $XOR $expect_spa_xor")
+                done
+        done
+}
+
+test_sample_sets() {
+        local sample_name=$1
+        local -n sample_set=$1
+        local generated_tests=()
+
+        generate_sample_tests sample_set generated_tests
+
+        IFS=','
+        table_string="${generated_tests[*]}"
+        IFS=' '
+
+        modprobe -r cxl-translate
+        set_log_start_time
+        echo "Testing $sample_name with ${#generated_tests[@]} test entries"
+        modprobe cxl-translate "table=$table_string"
+        check_dmesg_results "${#generated_tests[@]}"
+}
+
+# XOR Tables
+#
+# The tables that follow are the XOR translation examples in the
+# CXL Driver Writers Guide Sections 2.13.24.1 and 25.1
+# Note that the Guide uses the device number in its table notation.
+# Here the 'position' of that device number is used, not the
+# device number itself, which is meaningless in this context.
+#
+# Format: "dpa pos r_eiw r_eig hb_ways xor_math(0|1) xor_spa:
+
+# 4 way region interleave using 4 host bridges
+# Notation: 1+1+1+1
+XOR_Table_4R_4H=(
+	"248   0 2 0 4 1 248"
+	"16    1 2 0 4 1 272"
+	"16    2 2 0 4 1 528"
+	"32    3 2 0 4 1 800"
+	"288   0 2 0 4 1 1056"
+	"288   1 2 0 4 1 1312"
+	"288   2 2 0 4 1 1568"
+	"288   3 2 0 4 1 1824"
+	"544   1 2 0 4 1 2080"
+	"544   0 2 0 4 1 2336"
+	"544   3 2 0 4 1 2592"
+	"1040  2 2 0 4 1 4112"
+	"1568  3 2 0 4 1 6176"
+	"32784 1 2 0 4 1 131088"
+	"65552 2 2 0 4 1 262160"
+	"98336 3 2 0 4 1 393248"
+	"98328 2 2 0 4 1 393496"
+	"98352 2 2 0 4 1 393520"
+	"443953523 0 2 0 4 1 1775813747"
+)
+
+XOR_Table_8R_4H=(
+	"248       0 3 0 4 1 248"
+	"16        1 3 0 4 1 272"
+	"16        2 3 0 4 1 528"
+	"32        3 3 0 4 1 800"
+	"272       1 3 0 4 1 2064"
+	"528       2 3 0 4 1 4112"
+	"800       3 3 0 4 1 6176"
+	"16400     1 3 0 4 1 131088"
+	"32784     2 3 0 4 1 262160"
+	"49184     3 3 0 4 1 393248"
+	"49176     2 3 0 4 1 393496"
+	"49200     2 3 0 4 1 393520"
+	"116520373 3 3 0 4 1 932162229"
+	"244690459 5 3 0 4 1 1957525275"
+	"292862215 5 3 0 4 1 2342899463"
+	"30721158  4 3 0 4 1 245769350"
+	"246386959 4 3 0 4 1 1971096847"
+	"72701249  5 3 0 4 1 581610561"
+	"529382429 5 3 0 4 1 4235060509"
+	"191132300 2 3 0 4 1 1529057420"
+	"18589081  1 3 0 4 1 148712089"
+	"344295715 7 3 0 4 1 2754367011"
+)
+
+XOR_Table_12R_12H=(
+	"224 0 10 0 12 1 224"
+	"16  1 10 0 12 1 272"
+	"16  2 10 0 12 1 528"
+	"32  3 10 0 12 1 800"
+	"32  4 10 0 12 1 1056"
+	"32  5 10 0 12 1 1312"
+	"32  6 10 0 12 1 1568"
+	"32  7 10 0 12 1 1824"
+	"32  9 10 0 12 1 2080"
+	"32  8 10 0 12 1 2336"
+	"32 11 10 0 12 1 2592"
+	"32 10 10 0 12 1 2848"
+	"288 0 10 0 12 1 3360"
+	"299017087 7 10 0 12 1 3588205439"
+	"329210435 0 10 0 12 1 3950524995"
+	"151050637 11 10 0 12 1 1812608653"
+	"145169214  2 10 0 12 1 1742030654"
+	"328998732 10 10 0 12 1 3947985996"
+	"159252439  3 10 0 12 1 1911027415"
+	"342098916  5 10 0 12 1 4105186020"
+	"97970344   8 10 0 12 1 1175645096"
+	"214995572  8 10 0 12 1 2579948404"
+	"101289661  7 10 0 12 1 1215475645"
+	"40424079   7 10 0 12 1 485088911"
+	"231458716  7 10 0 12 1 2777503900"
+)
+
+# A fail table entry is expected to fail the DPA->SPA calculation.
+# Intent is to show that the test module can tell good from bad.
+# If one of these cases passes, don't trust other pass results.
+# This is not a test of module parsing, so don't send garbage.
+Expect_Fail_Table=(
+	"544   3 2 0 4 1 2080" # Change position
+        "544   2 2 0 4 1 2336"
+        "544   1 2 0 4 1 2592"
+	"272   1 2 0 4 1 2064" # Change r_eiw
+	"528   2 1 0 4 1 4112"
+	"800   3 10 0 4 1 6176"
+	"32  4 10 0 12 1 1156" # Change expected spa
+	"32  5 10 0 12 1 1112"
+	"32  6 10 0 12 1 1168"
+	"32  7 10 0 12 1 1124"
+)
+
+test_tables() {
+        local table_name=$1
+        local -n table_ref=$1
+        local expect_failures=${2:-false}  # Optional parameter, defaults to false
+        local IFS
+
+        IFS=','
+        table_string="${table_ref[*]}"
+        IFS=' '
+
+        if [ "$expect_failures" = "true" ]; then
+                echo "Testing $table_name with ${#table_ref[@]} entries (expecting FAIL results)"
+        else
+                echo "Testing $table_name with ${#table_ref[@]} test entries"
+        fi
+
+        modprobe -r cxl-translate
+        set_log_start_time
+        modprobe cxl-translate "table=$table_string"
+
+        check_dmesg_results "${#table_ref[@]}" "$expect_failures"
+}
+
+test_tables Expect_Fail_Table true
+test_sample_sets Sample_4R_4H
+test_sample_sets Sample_12R_12H
+test_tables XOR_Table_4R_4H
+test_tables XOR_Table_8R_4H
+test_tables XOR_Table_12R_12H
+
+echo "Translate test complete with no failures"
+
+modprobe -r cxl-translate
+
+
diff --git a/test/meson.build b/test/meson.build
index 91eb6c2b1363..bf4d73eea918 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -168,6 +168,7 @@ cxl_sanitize = find_program('cxl-sanitize.sh')
 cxl_destroy_region = find_program('cxl-destroy-region.sh')
 cxl_qos_class = find_program('cxl-qos-class.sh')
 cxl_poison = find_program('cxl-poison.sh')
+cxl_translate = find_program('cxl-translate.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -201,6 +202,7 @@ tests = [
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
   [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
   [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
+  [ 'cxl-translate.sh',       cxl_translate,      'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.3

