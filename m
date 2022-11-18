Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A68FEB29
	for <nvdimm@lists.linux.dev>; Fri, 18 Nov 2022 04:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668747225; x=1700283225;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TTq049knGqsgKEZMsehbGAZj3jxH2M7B/X4fPk5L/Oo=;
  b=lpjZ8PwCwsY377D+opUVUGq37Bg7HkqfpESTeg7RNqpWpGrfWrZvsGBU
   /k7AQBv3655Pnjsk5y8gE9tAIlshlohFG1R7Q85NwajY6mVP58QSLZulR
   hdvvfyGTiv7Ugy6hB5BB//RmvFqJFx8h+dBPsC6SXNv1LIGEXwHDKcaha
   YlYZof2ZOdTY1YSTsHGQd3VZ4TcNI8Tr5oyXXO8s20F5xoz9ayS0yxRha
   tvzul3WiEIwAnC9x6C7hSo9ZIfxMbUMhp+4tAXFS6EgXHVn1wEqLY5xbT
   yL9GwHlacQzFrpAyDH1xN4LGp4bPq1fkcBzfIgrBpFyqBc7AtE0OXIRTy
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="399341617"
X-IronPort-AV: E=Sophos;i="5.96,173,1665471600"; 
   d="scan'208";a="399341617"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 20:53:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="969148088"
X-IronPort-AV: E=Sophos;i="5.96,173,1665471600"; 
   d="scan'208";a="969148088"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.84.12])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 20:53:34 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v3] cxl/test: add cxl_xor_region test
Date: Thu, 17 Nov 2022 20:53:32 -0800
Message-Id: <20221118045332.1330804-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Exercise the kernel driver support of XOR math by creating regions
with 1,2, and 4-way interleaves using XOR interleave arithmetic.

Use module parameter "interleave_arithmetic=1" to select the cxl_test
topology that supports XOR math. XOR math is not used in the default
cxl_test module.

Add this test to the 'cxl' suite so that it gets exercised routinely.
If the topology defined in cxl_test changes, this test may require
an update.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
Depends on kernel patches here [1]

Changes in v3
- s/create_region/create_and_destroy_region (DaveJ)
- Built on ndctl: release v74 plus Dan's cxl-cli test and usability updates [2]

Changes in v2
- Update to match cxl_test topology changes
- Remove 3-way interleave
- Small naming updates

[1] https://lore.kernel.org/linux-cxl/cover.1668745515.git.alison.schofield@intel.com/
[2] https://lore.kernel.org/nvdimm/166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com/


 test/cxl-xor-region.sh | 99 ++++++++++++++++++++++++++++++++++++++++++
 test/meson.build       |  2 +
 2 files changed, 101 insertions(+)
 create mode 100644 test/cxl-xor-region.sh

diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
new file mode 100644
index 000000000000..5c2108c821e2
--- /dev/null
+++ b/test/cxl-xor-region.sh
@@ -0,0 +1,99 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2022 Intel Corporation. All rights reserved.
+
+. $(dirname $0)/common
+
+rc=1
+
+set -ex
+
+trap 'err $LINENO' ERR
+
+check_prereq "jq"
+
+modprobe -r cxl_test
+modprobe cxl_test interleave_arithmetic=1
+udevadm settle
+
+# THEORY OF OPERATION: Create x1,2,3,4 regions to exercise the XOR math
+# option of the CXL driver. As with other cxl_test tests, changes to the
+# CXL topology in tools/testing/cxl/test/cxl.c may require an update here.
+
+create_and_destroy_region()
+{
+	region=$($CXL create-region -d $decoder -m $memdevs | jq -r ".region")
+
+	if [[ ! $region ]]; then
+		echo "create-region failed for $decoder"
+		err "$LINENO"
+	fi
+
+	$CXL destroy-region -f -b cxl_test "$region"
+}
+
+setup_x1()
+{
+        # Find an x1 decoder
+        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+          select(.pmem_capable == true) |
+          select(.nr_targets == 1) |
+          .decoder")
+
+        # Find a memdev for this host-bridge
+        port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+            .targets | .[] | select(.position == 0) | .target")
+        mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
+        memdevs="$mem0"
+}
+
+setup_x2()
+{
+        # Find an x2 decoder
+        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+          select(.pmem_capable == true) |
+          select(.nr_targets == 2) |
+          .decoder")
+
+        # Find a memdev for each host-bridge interleave position
+        port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+            .targets | .[] | select(.position == 0) | .target")
+        port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
+            .targets | .[] | select(.position == 1) | .target")
+        mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
+        mem1=$($CXL list -M -p $port_dev1 | jq -r ".[0].memdev")
+        memdevs="$mem0 $mem1"
+}
+
+setup_x4()
+{
+        # find x4 decoder
+        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+          select(.pmem_capable == true) |
+          select(.nr_targets == 4) |
+          .decoder")
+
+        # Find a memdev for each host-bridge interleave position
+        port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+            .targets | .[] | select(.position == 0) | .target")
+        port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
+            .targets | .[] | select(.position == 1) | .target")
+        port_dev2=$($CXL list -T -d $decoder | jq -r ".[] |
+            .targets | .[] | select(.position == 2) | .target")
+        port_dev3=$($CXL list -T -d $decoder | jq -r ".[] |
+            .targets | .[] | select(.position == 3) | .target")
+        mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
+        mem1=$($CXL list -M -p $port_dev1 | jq -r ".[1].memdev")
+        mem2=$($CXL list -M -p $port_dev2 | jq -r ".[2].memdev")
+        mem3=$($CXL list -M -p $port_dev3 | jq -r ".[3].memdev")
+        memdevs="$mem0 $mem1 $mem2 $mem3"
+}
+
+setup_x1
+create_and_destroy_region
+setup_x2
+create_and_destroy_region
+setup_x4
+create_and_destroy_region
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index c31d8eac66c5..e0aaf5c6eaa9 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -154,6 +154,7 @@ cxl_topo = find_program('cxl-topology.sh')
 cxl_sysfs = find_program('cxl-region-sysfs.sh')
 cxl_labels = find_program('cxl-labels.sh')
 cxl_create_region = find_program('cxl-create-region.sh')
+cxl_xor_region = find_program('cxl-xor-region.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -181,6 +182,7 @@ tests = [
   [ 'cxl-region-sysfs.sh',    cxl_sysfs,	  'cxl'   ],
   [ 'cxl-labels.sh',          cxl_labels,	  'cxl'   ],
   [ 'cxl-create-region.sh',   cxl_create_region,  'cxl'   ],
+  [ 'cxl-xor-region.sh',      cxl_xor_region,     'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.3

