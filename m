Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586EF633
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 03:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668136817; x=1699672817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sQeRo3g4sdBJ0pWvvRj+9tOdBa8K1tS5T7mi8mKysLQ=;
  b=OgppwqP0/MLMmTNLi/zNDqzy/wIwoUkDcm8bvNxBZVwkjWE60y5OxiPz
   +o6r/1y16CFldge4PwZnhreMyaPa/8No8WcoV9uzz/Zho0OLdHDtG/E+d
   gWMNICxSvmfDNC5fPwRJlqUy9Ti1Gl1M8Olqukp8pMjPmM/NI4+rkW8qO
   fESXqx9euIQee30fp0Swdw92T32yhXmf7N2EHV0ZKxBqIwFi5uTqgQUwe
   1Oebwv0aZ+0FDjXsPPnOYbuNrMygMrQ4rKIsqDkpIsLMj14alp2VuTAfH
   tvg1Sk1XKJI3eOkATS5QZ4KaPKg/RGyOYUf0KEXEPo5srhcjMw5LY+W8G
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="373638357"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="373638357"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:20:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="743129974"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="743129974"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.161.45])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:20:16 -0800
From: alison.schofield@intel.com
To: Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 5/5] test: add a cxl-get-poison test
Date: Thu, 10 Nov 2022 19:20:08 -0800
Message-Id: <fe384a7dc7bc9b84db640dbbf6b7af73fe7ebd5c.1668133294.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1668133294.git.alison.schofield@intel.com>
References: <cover.1668133294.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Exercise cxl list, libcxl, and driver pieces of the get poison
pathway. The poison records themselves are mocked by cxl_test,
but the work of triggering the poison read, logging as trace events,
and then collecting and parsing is all for real.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-get-poison.sh | 78 ++++++++++++++++++++++++++++++++++++++++++
 test/meson.build       |  2 ++
 2 files changed, 80 insertions(+)
 create mode 100644 test/cxl-get-poison.sh

diff --git a/test/cxl-get-poison.sh b/test/cxl-get-poison.sh
new file mode 100644
index 000000000000..fe93a67a5240
--- /dev/null
+++ b/test/cxl-get-poison.sh
@@ -0,0 +1,78 @@
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
+modprobe cxl_test
+udevadm settle
+
+# The number or errors that cxl_test mocks is subject to change.
+NR_ERRS=2
+
+# THEORY OF OPERATION: Exercise cxl-cli and cxl driver capabilites wrt
+# retrieving poison lists. The poison list is maintained by the device.
+# It may be requested per memdev or per region.
+
+create_region()
+{
+	region=$($CXL create-region -d $decoder -m $memdevs | jq -r ".region")
+
+	if [[ ! $region ]]; then
+		echo "create-region failed for $decoder"
+		err "$LINENO"
+	fi
+}
+
+setup_x2_region()
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
+find_media_errors()
+{
+	nr=$(echo $json | jq -r ".nr_media_errors")
+	if [[ $nr -ne $NR_ERRS ]]; then
+		echo "$mem: $NR_ERRS media errors expected, $nr found"
+		err "$LINENO"
+	fi
+}
+
+# Read poison from each available memdev
+readarray -t mems < <("$CXL" list -b cxl_test -Mi | jq -r '.[].memdev')
+for mem in ${mems[@]}; do
+	json=$("$CXL" list -m "$mem" --media-errors | jq -r '.[].media_errors')
+	find_media_errors
+done
+
+# Read poison from one region
+setup_x2_region
+create_region
+json=$("$CXL" list -r "$region" --media-errors | jq -r '.[].media_errors')
+find_media_errors
+cxl disable-region $region
+cxl destroy-region $region
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index 5953c286d13f..721c69e79f5e 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -154,6 +154,7 @@ cxl_topo = find_program('cxl-topology.sh')
 cxl_sysfs = find_program('cxl-region-sysfs.sh')
 cxl_labels = find_program('cxl-labels.sh')
 cxl_create_region = find_program('cxl-create-region.sh')
+cxl_get_poison = find_program('cxl-get-poison.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -182,6 +183,7 @@ tests = [
   [ 'cxl-region-sysfs.sh',    cxl_sysfs,	  'cxl'   ],
   [ 'cxl-labels.sh',          cxl_labels,	  'cxl'   ],
   [ 'cxl-create-region.sh',   cxl_create_region,  'cxl'   ],
+  [ 'cxl-get-poison.sh',      cxl_get_poison,     'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.3

