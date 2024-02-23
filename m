Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3D0C8CE
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 02:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708654556; cv=none; b=GeHCGAJtyLnnTs3YFTGJtZ6HU7lbvCioVNITRBxavVGSTh9qdLhgGLi7JL5fUNMylytursPn7/Vra3CSldGunNSrrKaRcFDzpPoBMYKfLZxUkNjvbs207MbnpYgJLV4T8uFrKvuygENL512M3R7O737YV2ZiMnzLtiswS6idkkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708654556; c=relaxed/simple;
	bh=oQvBOVgfsNLCjuievYMWAxaXWIEpXlHud/XlzXk6KRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eVhnUuQYEdMsEd7FjgaBRhI16h8dfz/9vtMdX5Bd6RPetD7tYkzazGymDkl+6AUQuSGp6TW/2e1/yXjBvsd6Snr3MRGtbHc70BeS7LlYR20sIstfyhlAtjr6pZDeyk3Fn9zT0nq9wGd6fgLPUg8QHyKj8Mh26HCJG1DqhWqxCG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PpKWJw5L; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PpKWJw5L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708654554; x=1740190554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oQvBOVgfsNLCjuievYMWAxaXWIEpXlHud/XlzXk6KRQ=;
  b=PpKWJw5LcBe0E2qb/YaZswOEoiIddSXPT0rsbekih8lAAzI3c5JylCzt
   HHdBiEY8fdGX0IPbFJCnsppw8mOflHhtZA7sqHtcms2S9xmP/2DWz/rBS
   3ys7LWyjnKRMb9fXx6g4VW9dc0zwixiKb5ax6rlywumTEPewc0l9jIgv6
   FYXiZ6NQQq2+8rJDBiFNO00XCcZ7mE5sKkUtgetNkfyrEANzT4fl5iFIH
   TiHopyxUayMX2w107jyjHkfwX32sqrPgUpCvmfzPd5EaecFiHOhLV/5IX
   rwidw+oX50hZRdsgm2ECAz4ZBBs7MVaCrVGlPzKlnsMX6tZzOdb3559d3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="14364258"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="14364258"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="10410161"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.29.102])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:53 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v8 7/7] cxl/test: add cxl-poison.sh unit test
Date: Thu, 22 Feb 2024 18:15:44 -0800
Message-Id: <464abbfa50b0fd62ea2979e097dfc1a64314da0c.1708653303.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1708653303.git.alison.schofield@intel.com>
References: <cover.1708653303.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Exercise cxl list, libcxl, and driver pieces of the get poison list
pathway. Inject and clear poison using debugfs and use cxl-cli to
read the poison list by memdev and by region.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 test/cxl-poison.sh | 137 +++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build   |   2 +
 2 files changed, 139 insertions(+)
 create mode 100644 test/cxl-poison.sh

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
new file mode 100644
index 000000000000..af2e9dcd1a11
--- /dev/null
+++ b/test/cxl-poison.sh
@@ -0,0 +1,137 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 Intel Corporation. All rights reserved.
+
+. "$(dirname "$0")"/common
+
+rc=77
+
+set -ex
+
+trap 'err $LINENO' ERR
+
+check_prereq "jq"
+
+modprobe -r cxl_test
+modprobe cxl_test
+
+rc=1
+
+# THEORY OF OPERATION: Exercise cxl-cli and cxl driver ability to
+# inject, clear, and get the poison list. Do it by memdev and by region.
+
+find_memdev()
+{
+	readarray -t capable_mems < <("$CXL" list -b "$CXL_TEST_BUS" -M |
+		jq -r ".[] | select(.pmem_size != null) |
+		select(.ram_size != null) | .memdev")
+
+	if [ ${#capable_mems[@]} == 0 ]; then
+		echo "no memdevs found for test"
+		err "$LINENO"
+	fi
+
+	memdev=${capable_mems[0]}
+}
+
+create_x2_region()
+{
+	# Find an x2 decoder
+	decoder="$($CXL list -b "$CXL_TEST_BUS" -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 2) |
+		.decoder")"
+
+	# Find a memdev for each host-bridge interleave position
+	port_dev0="$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")"
+	port_dev1="$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 1) | .target")"
+	mem0="$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")"
+	mem1="$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")"
+
+	region="$($CXL create-region -d "$decoder" -m "$mem0" "$mem1" |
+		jq -r ".region")"
+	if [[ ! $region ]]; then
+		echo "create-region failed for $decoder"
+		err "$LINENO"
+	fi
+	echo "$region"
+}
+
+# When cxl-cli support for inject and clear arrives, replace
+# the writes to /sys/kernel/debug with the new cxl commands.
+
+inject_poison_sysfs()
+{
+	memdev="$1"
+	addr="$2"
+
+	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
+}
+
+clear_poison_sysfs()
+{
+	memdev="$1"
+	addr="$2"
+
+	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
+}
+
+validate_poison_found()
+{
+	list_by="$1"
+	nr_expect="$2"
+
+	poison_list="$($CXL list "$list_by" --media-errors |
+		jq -r '.[].media_errors')"
+	if [[ ! $poison_list ]]; then
+		nr_found=0
+	else
+		nr_found=$(jq "length" <<< "$poison_list")
+	fi
+	if [ "$nr_found" -ne "$nr_expect" ]; then
+		echo "$nr_expect poison records expected, $nr_found found"
+		err "$LINENO"
+	fi
+}
+
+test_poison_by_memdev()
+{
+	find_memdev
+	inject_poison_sysfs "$memdev" "0x40000000"
+	inject_poison_sysfs "$memdev" "0x40001000"
+	inject_poison_sysfs "$memdev" "0x600"
+	inject_poison_sysfs "$memdev" "0x0"
+	validate_poison_found "-m $memdev" 4
+
+	clear_poison_sysfs "$memdev" "0x40000000"
+	clear_poison_sysfs "$memdev" "0x40001000"
+	clear_poison_sysfs "$memdev" "0x600"
+	clear_poison_sysfs "$memdev" "0x0"
+	validate_poison_found "-m $memdev" 0
+}
+
+test_poison_by_region()
+{
+	create_x2_region
+	inject_poison_sysfs "$mem0" "0x40000000"
+	inject_poison_sysfs "$mem1" "0x40000000"
+	validate_poison_found "-r $region" 2
+
+	clear_poison_sysfs "$mem0" "0x40000000"
+	clear_poison_sysfs "$mem1" "0x40000000"
+	validate_poison_found "-r $region" 0
+}
+
+# Turn tracing on. Note that 'cxl list --poison' does toggle the tracing.
+# Turning it on here allows the test user to also view inject and clear
+# trace events.
+echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
+
+test_poison_by_memdev
+test_poison_by_region
+
+check_dmesg "$LINENO"
+
+modprobe -r cxl-test
diff --git a/test/meson.build b/test/meson.build
index 65db049821ee..cf99df665978 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -159,6 +159,7 @@ cxl_update_firmware = find_program('cxl-update-firmware.sh')
 cxl_events = find_program('cxl-events.sh')
 cxl_sanitize = find_program('cxl-sanitize.sh')
 cxl_destroy_region = find_program('cxl-destroy-region.sh')
+cxl_poison = find_program('cxl-poison.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -190,6 +191,7 @@ tests = [
   [ 'cxl-events.sh',          cxl_events,         'cxl'   ],
   [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
+  [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.3

