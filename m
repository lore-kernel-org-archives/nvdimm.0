Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883D55398
	for <nvdimm@lists.linux.dev>; Mon, 15 Aug 2022 19:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660591346; x=1692127346;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PBfYQPgZSq7q+c20aALR0P51XJsCwD7YzY7SKX4OEDM=;
  b=ciSrUvUuvLtpEcijOQiHnNLmgpfEp2RRGgbV0h5/qUZE6N+oHqbtIFOo
   qvZPNk07skjGu8ZhQVFUESafzcXHVG6tWfkmo3FctLiamp6dDej2ijcZk
   ridq0TQioeeXZQBL1Nru8eKYmP6MrlNCCvt9z11lfGIh4W8VQWSLFyJ5x
   WmlmM2Al17fKqLSTVlWAC5YYENO0TbLjmkZ4JKy3ODkCziInDTMEQvLvp
   5REYLMDvEV1LWVrNZoqOUlKOQUHtcDyC0IcJ6INFW5FExkYGOVdlGAs+3
   4LTdaB/2rNXx9GKBCRsNTaZoX8W7bo0spdfW5S1Tp54I/7vhCxmQnj8S6
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="292038728"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="292038728"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:22 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="606758268"
Received: from smadiset-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.5.99])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:21 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 10/11] test: add a cxl-create-region test
Date: Mon, 15 Aug 2022 13:22:13 -0600
Message-Id: <20220815192214.545800-11-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220815192214.545800-1-vishal.l.verma@intel.com>
References: <20220815192214.545800-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4439; h=from:subject; bh=PBfYQPgZSq7q+c20aALR0P51XJsCwD7YzY7SKX4OEDM=; b=owGbwMvMwCXGf25diOft7jLG02pJDEm/5jy7IvjewHTetdgFKT8Y571nd7hy9GPL9bw0kQoxucDN khZrO0pZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjAR/xxGhq6ltRI3c2PYTh4r7Nk7vU aOp3s+85cVBiviH27SdFtbv5bhn3K021sf8+bGPYfuyIXsYy7sVjilq1ew6nPKXPkTTPl3mAE=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a unit test to exercise the cxl-create-region command with different
combinations of memdevs and decoders, using cxl_test based mocked
devices.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/cxl-create-region.sh | 125 ++++++++++++++++++++++++++++++++++++++
 test/meson.build          |   2 +
 2 files changed, 127 insertions(+)
 create mode 100644 test/cxl-create-region.sh

diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
new file mode 100644
index 0000000..66df38f
--- /dev/null
+++ b/test/cxl-create-region.sh
@@ -0,0 +1,125 @@
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
+	destroy_regions "$region"
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
+		if [[ ! ${regions[$i]} ]]; then
+			echo "create sub-region failed for $decoder / $mem"
+			err "$LINENO"
+		fi
+		udevadm settle
+	done
+
+	echo "created $num_regions subregions:"
+	for (( i = 0; i < num_regions; i++ )); do
+		echo "${regions[$i]}"
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
+	create_x1_region "$mem"
+done
+
+# test multiple subregions under the same decoder, using slices of the same memdev
+# to test out back-to-back pmem DPA allocations on memdevs
+for mem in ${mems[@]}; do
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

