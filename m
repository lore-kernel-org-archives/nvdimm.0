Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198B12638BC;
	Fri, 31 Oct 2025 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761932412; cv=none; b=TAo6sOQ9eKAU21tXgXZJlpcwgkFW4zwHFTfggLMHkksU+ePYQvAaJ00AW5+uomd+mPw6IVICPmmzAsL/wmSTHsynqXGB2uoj4g7iEZlcvCnZYEDGrp3Bnpdlj5XW5MIrGnMb/fbzTm+S6wBJjRMwBmvULD5J0W5Z8GHJePwtR7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761932412; c=relaxed/simple;
	bh=bvwdyEujS2eQUX2VF1ZxMri1qijj5f0BCfHMVZLFmjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fn2qwoGebR6XWuk8jsARVDojZ60KKJDEq28a+6krYLphLacEx4J33992PO7AdaMHchXYFhQwi8z0caCh6gFJF3xwZuI+LMmAfwld/GWV6BGpSjm5oHTycEFlCBtZHA2QtXTM7UFijLgco8ZvmrVfUh5zYrGkhGFN/FXhUDwrmLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4976C4CEFD;
	Fri, 31 Oct 2025 17:40:11 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com
Subject: [NDCTL PATCH 5/5] cxl/test: Add support for poison test for ELC
Date: Fri, 31 Oct 2025 10:40:03 -0700
Message-ID: <20251031174003.3547740-6-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251031174003.3547740-1-dave.jiang@intel.com>
References: <20251031174003.3547740-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a unit test for extended linear cache (ELC) poison handling testing.
The common code needs to be adjusted in order to handle the offset created
by ELC. The caculations are not impacted for normal region testing since
ELC size would be 0.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/common-poison     | 22 +++++++++++++++++-----
 test/cxl-poison-elc.sh | 41 +++++++++++++++++++++++++++++++++++++++++
 test/meson.build       |  2 ++
 3 files changed, 60 insertions(+), 5 deletions(-)
 create mode 100755 test/cxl-poison-elc.sh

diff --git a/test/common-poison b/test/common-poison
index 15a091e41dc3..3926e2fef4c4 100644
--- a/test/common-poison
+++ b/test/common-poison
@@ -130,9 +130,21 @@ test_poison_by_region_by_dpa()
 
 test_poison_by_region_offset()
 {
-	local base gran hpa1 hpa2
+	local base gran hpa1 hpa2 cache_size cache_offset
 	base=$(cat /sys/bus/cxl/devices/"$region"/resource)
 	gran=$(cat /sys/bus/cxl/devices/"$region"/interleave_granularity)
+	cache_size=0
+
+	# This case is a no-op until cxl-test ELC mocking arrives
+	# Try to get cache_size if the attribute exists
+	if [ -f "/sys/bus/cxl/devices/$region/extended_linear_cache_size" ]; then
+		cache_size=$(cat /sys/bus/cxl/devices/"$region"/extended_linear_cache_size)
+	fi
+
+	# Offset within extended linear cache (if cache_size > 0)
+	if [[ $cache_size -gt 0 ]]; then
+		base=$((base + cache_size))
+	fi
 
 	# Test two HPA addresses: base and base + granularity
 	# This hits the two memdevs in the region interleave.
@@ -142,15 +154,15 @@ test_poison_by_region_offset()
 	# Inject at the offset and check result using the hpa
 	# ABI takes an offset, but recall the hpa to check trace event
 
-	inject_poison_sysfs "$region" 0
+	inject_poison_sysfs "$region" $cache_size
 	check_trace_entry "$region" "$hpa1"
-	inject_poison_sysfs "$region" "$gran"
+	inject_poison_sysfs "$region" "$((gran + cache_size))"
 	check_trace_entry "$region" "$hpa2"
 	validate_poison_found "-r $region" 2
 
-	clear_poison_sysfs "$region" 0
+	clear_poison_sysfs "$region" $cache_size
 	check_trace_entry "$region" "$hpa1"
-	clear_poison_sysfs "$region" "$gran"
+	clear_poison_sysfs "$region" "$((gran + cache_size))"
 	check_trace_entry "$region" "$hpa2"
 	validate_poison_found "-r $region" 0
 }
diff --git a/test/cxl-poison-elc.sh b/test/cxl-poison-elc.sh
new file mode 100755
index 000000000000..25f54fb99171
--- /dev/null
+++ b/test/cxl-poison-elc.sh
@@ -0,0 +1,41 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2025 Intel Corporation. All rights reserved.
+
+. "$(dirname "$0")"/common
+
+rc=77
+
+set -ex
+[ -d "/sys/kernel/tracing" ] || do_skip "test requires CONFIG_TRACING"
+
+trap 'err $LINENO' ERR
+
+check_prereq "jq"
+
+modprobe -r cxl_test
+modprobe cxl_test extended_linear_cache=1
+
+rc=1
+
+# THEORY OF OPERATION: Exercise cxl-cli and cxl driver ability to
+# inject, clear, and get the poison list. Do it by memdev and by region.
+
+. "$(dirname "$0")"/common-poison
+
+# Clear old trace events, enable cxl_poison, enable global tracing
+echo "" > /sys/kernel/tracing/trace
+echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
+echo 1 > /sys/kernel/tracing/tracing_on
+
+test_poison_by_memdev_by_dpa
+find_auto_region
+test_poison_by_region_by_dpa
+[ -f "/sys/kernel/debug/cxl/$region/inject_poison" ] ||
+       do_skip "test cases requires inject by region kernel support"
+test_poison_by_region_offset
+test_poison_by_region_offset_negative
+
+check_dmesg "$LINENO"
+
+modprobe -r cxl-test
diff --git a/test/meson.build b/test/meson.build
index 710a15850e2b..248917fd1edd 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -255,8 +255,10 @@ endif
 
 if get_option('libtracefs').enabled()
   cxl_poison = find_program('cxl-poison.sh')
+  cxl_poison_elc = find_program('cxl-poison-elc.sh')
   tests += [
     [ 'cxl-poison.sh', cxl_poison, 'cxl' ],
+    [ 'cxl-poison-elc.sh', cxl_poison_elc, 'cxl' ],
   ]
 endif
 
-- 
2.51.0

