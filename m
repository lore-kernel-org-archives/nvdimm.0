Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02DD4A14
	for <nvdimm@lists.linux.dev>; Wed, 10 Aug 2022 23:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660172976; x=1691708976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4ayfycPi5Ay3dElNFo2IpBfNV2KeWP7L//kKReci7Cg=;
  b=mSkKxYgOUXbdjXPlAfOId14cXXlixLqoTVMD2y9JHRKboug7SUgCR9uB
   goUjFzcKObmbnJdAR0Ug61rGvbcjVIaikTK8HNGCIiPiSBnFiwCV8j1Ff
   Yks4iUr8Bq96++r7jw9Nl4LrEI05+Qkr7aHMUKFpxDMAIMsVRKhbSZbxU
   XLvHkb/sp2j0AVeErrkF3yHkxrD13L6JVSQXqM8+Dq/0D7RDviXwWkuLu
   qz6k2M9ZRXEDbgwJi8Ff1OLEC98se0AUfKvkbBUeFFBaN+dw8CoGafsDe
   Cf5ct1qXVwP0D6hBRurCDxn/ngRdKbNfQ7wW/3+sNeOaEqGih5lGT5e3x
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="377506181"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="377506181"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 16:09:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="581429460"
Received: from maughenb-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.94.5])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 16:09:34 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 09/10] test: add a cxl-create-region test
Date: Wed, 10 Aug 2022 17:09:13 -0600
Message-Id: <20220810230914.549611-10-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810230914.549611-1-vishal.l.verma@intel.com>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4358; h=from:subject; bh=4ayfycPi5Ay3dElNFo2IpBfNV2KeWP7L//kKReci7Cg=; b=owGbwMvMwCXGf25diOft7jLG02pJDElfrGZ2fDiRrP19w00hs7gs4d+cYcZz27/unlDttXjKTX27 mqfpHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZjI09WMDCcfXlkv82X+Rr7zP/9mrV o970NwVIjGxnO6X1xnXI5YuvAuw282xkMGCrMlZN2FePPWrN+uxd2t++toh02PNqfD7duJmswA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a unit test to exercise the cxl-create-region command with different
combinations of memdevs and decoders, using cxl_test based mocked
devices.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/cxl-create-region.sh | 126 ++++++++++++++++++++++++++++++++++++++
 test/meson.build          |   2 +
 2 files changed, 128 insertions(+)
 create mode 100644 test/cxl-create-region.sh

diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
new file mode 100644
index 0000000..8e297ca
--- /dev/null
+++ b/test/cxl-create-region.sh
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
+modprobe cxl_test
+udevadm settle
+
+destroy_regions()
+{
+	if [[ "$*" ]]; then
+		$CXL destroy-region -f -b cxl_test "$@"
+	else
+		$CXL destroy-region -f -b cxl_test all
+	fi
+}
+
+create_x1_region()
+{
+	mem="$1"
+
+	# find a pmem capable root decoder for this mem
+	decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
+		  jq -r ".[] |
+		  select(.pmem_capable == true) |
+		  select(.nr_targets == 1) |
+		  .decoder")
+
+	if [[ ! $decoder ]]; then
+		echo "no suitable decoder found for $mem, skipping"
+		return
+	fi
+	op_attempted=1
+
+	# create region
+	region=$($CXL create-region -d "$decoder" -m "$mem" | jq -r ".region")
+
+	if [[ ! $region ]]; then
+		echo "create-region failed for $decoder / $mem"
+		err "$LINENO"
+	fi
+
+	# cycle disable/enable
+	$CXL disable-region --bus=cxl_test "$region"
+	$CXL enable-region --bus=cxl_test "$region"
+
+	# cycle destroying and creating the same region
+	destroy_regions "$region"
+	region=$($CXL create-region -d "$decoder" -m "$mem" | jq -r ".region")
+
+	if [[ ! $region ]]; then
+		echo "create-region failed for $decoder / $mem"
+		err "$LINENO"
+	fi
+}
+
+create_subregions()
+{
+	slice=$((256 << 20))
+	mem="$1"
+
+	# find a pmem capable root decoder for this mem
+	decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
+		  jq -r ".[] |
+		  select(.pmem_capable == true) |
+		  select(.nr_targets == 1) |
+		  .decoder")
+
+	if [[ ! $decoder ]]; then
+		echo "no suitable decoder found for $mem, skipping"
+		return
+	fi
+	op_attempted=1
+
+	size="$($CXL list -m "$mem" | jq -r '.[].pmem_size')"
+	if [[ ! $size ]]; then
+		echo "$mem: unable to determine size"
+		err "$LINENO"
+	fi
+
+	num_regions=$((size / slice))
+
+	declare -a regions
+	for (( i = 0; i < num_regions; i++ )); do
+		regions[$i]=$($CXL create-region -d "$decoder" -m "$mem" -s "$slice" | jq -r ".region")
+		if [[ ! $region ]]; then
+			echo "create sub-region failed for $decoder / $mem"
+			err "$LINENO"
+		fi
+		udevadm settle
+	done
+
+	for (( i = (num_regions - 1); i >= 0; i-- )); do
+		destroy_regions "${regions[$i]}"
+	done
+}
+
+# test reading labels directly through cxl-cli
+readarray -t mems < <("$CXL" list -b cxl_test -M | jq -r '.[].memdev')
+
+for mem in ${mems[@]}; do
+	op_attempted=0
+	create_x1_region "$mem"
+	if (( op_attempted == 1 )); then
+		destroy_regions
+	fi
+done
+
+# test multiple subregions under the same decoder, using slices of the same memdev
+# to test out back-to-back pmem DPA allocations on memdevs
+for mem in ${mems[@]}; do
+	op_attempted=0
+	create_subregions "$mem"
+done
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index b382f46..5953c28 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -153,6 +153,7 @@ track_uuid = find_program('track-uuid.sh')
 cxl_topo = find_program('cxl-topology.sh')
 cxl_sysfs = find_program('cxl-region-sysfs.sh')
 cxl_labels = find_program('cxl-labels.sh')
+cxl_create_region = find_program('cxl-create-region.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -180,6 +181,7 @@ tests = [
   [ 'cxl-topology.sh',	      cxl_topo,		  'cxl'   ],
   [ 'cxl-region-sysfs.sh',    cxl_sysfs,	  'cxl'   ],
   [ 'cxl-labels.sh',          cxl_labels,	  'cxl'   ],
+  [ 'cxl-create-region.sh',   cxl_create_region,  'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.1

