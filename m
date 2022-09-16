Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129D517EA
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 01:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663292107; x=1694828107;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4GEEjrPYFP5stP0vBfb7KIBEFoySVBMr4pByZLMmuAA=;
  b=e7zE6gP/IUVckS18XuZ3IaGzSpA507gwoL6/nzZSkuqygtKgw1evIWJ6
   80geWyt2rHl0ElnrPqqPgtkr2fxooWkHzgh85MlJbpW7Xe30FixIsVAoJ
   nAjA8+0LciusYcejMhwuvQPghB9PLJAeipmVmaGQnGriQjgBl8ju29liM
   g4883QwEREK8HvtW5Ho3fTBpgpKer3C/Fkb8gItZuPWELTDttSi6u/y0o
   3+VqwD5fgaclCLcaVNl98G6VVDiRCjmEZybjLLkUtHD6lgbznyBXru4W2
   f+8e1Smr2MOXt7p74lz0R/S3s0NfWk8ndVHbCpd3gXK80NBe7caDelC9Q
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="300247779"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="300247779"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 18:35:06 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="743164755"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.120.139])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 18:35:05 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 1/2] cxl/test: add cxl_xor_region test
Date: Thu, 15 Sep 2022 18:35:01 -0700
Message-Id: <98823273af4318ac8e903cd5289b94d5621b0dde.1663290390.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663290390.git.alison.schofield@intel.com>
References: <cover.1663290390.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Exercise the kernel driver support of XOR math by creating
x1, x2, x3, x4 regions using CFMWS's that use XOR Math.

x1 - no interleave, target index is always 0
x2 - 2 way interleave uses one xormap
x3 - 3 way interleave uses no xormaps and relies on a modulo calc.
x4 - 4 way interleave uses two xormaps

Use module parameter "xor_math=1" to select the cxl_test topology
that supports XOR math. XOR math is not used in the default cxl_test
module, to avoid memory bloat.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-xor-region.sh | 126 +++++++++++++++++++++++++++++++++++++++++
 test/meson.build       |   2 +
 2 files changed, 128 insertions(+)
 create mode 100644 test/cxl-xor-region.sh

diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
new file mode 100644
index 000000000000..6bbea9c9257e
--- /dev/null
+++ b/test/cxl-xor-region.sh
@@ -0,0 +1,126 @@
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
+# Load cxl_test with the support for XOR math.
+modprobe cxl_test interleave_arithmetic=1
+udevadm settle
+
+# THEORY OF OPERATION: Create x1,2,3,4 regions to exercise the XOR math 
+# option of the CXL driver. As with other cxl_test tests, changes to the
+# CXL topology in tools/testing/cxl/test/cxl.c may require an update here.
+
+create_region()
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
+	# Below order matters
+        memdevs="$mem0 $mem1"
+}
+
+setup_x3()
+{
+        # Find an x3 decoder
+        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+          select(.pmem_capable == true) |
+          select(.nr_targets == 3) |
+          .decoder")
+	
+        # Find a memdev for each host-bridge interleave position
+        port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+            .targets | .[] | select(.position == 0) | .target")
+        port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
+            .targets | .[] | select(.position == 1) | .target")
+        port_dev2=$($CXL list -T -d $decoder | jq -r ".[] |
+            .targets | .[] | select(.position == 2) | .target")
+        mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
+        mem1=$($CXL list -M -p $port_dev1 | jq -r ".[0].memdev")
+        mem2=$($CXL list -M -p $port_dev2 | jq -r ".[0].memdev")
+	# Below order matters
+        memdevs="$mem1 $mem2 $mem0"
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
+        mem1=$($CXL list -M -p $port_dev1 | jq -r ".[0].memdev")
+        mem2=$($CXL list -M -p $port_dev2 | jq -r ".[0].memdev")
+        mem3=$($CXL list -M -p $port_dev3 | jq -r ".[0].memdev")
+	# Below order matters
+        memdevs="$mem0 $mem1 $mem2 $mem3"
+}
+
+setup_x1
+create_region
+setup_x2
+create_region
+setup_x3
+create_region
+setup_x4
+create_region
+modprobe -r cxl_test
+
diff --git a/test/meson.build b/test/meson.build
index 5953c286d13f..89cae9e99dff 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -154,6 +154,7 @@ cxl_topo = find_program('cxl-topology.sh')
 cxl_sysfs = find_program('cxl-region-sysfs.sh')
 cxl_labels = find_program('cxl-labels.sh')
 cxl_create_region = find_program('cxl-create-region.sh')
+cxl_xor_region = find_program('cxl-xor-region.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -182,6 +183,7 @@ tests = [
   [ 'cxl-region-sysfs.sh',    cxl_sysfs,	  'cxl'   ],
   [ 'cxl-labels.sh',          cxl_labels,	  'cxl'   ],
   [ 'cxl-create-region.sh',   cxl_create_region,  'cxl'   ],
+  [ 'cxl-xor-region.sh',      cxl_xor_region,     'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.31.1

