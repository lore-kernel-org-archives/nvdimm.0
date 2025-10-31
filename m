Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36C824886A;
	Fri, 31 Oct 2025 17:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761932406; cv=none; b=lqki8LbQxUnMszeVE1TUCYRi13x+wr9Ted3LP9vZFBqRZnHv/y01pArnjt+SRbixp5vbDzycMDsm7pqxssaqMZyn+GySgiIX4WqabNon0FbKSzso5ySM26m/LR4SU3we3pn2PW1mDlEq4vClubk/zYCYV+cSD48jtJS42K005tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761932406; c=relaxed/simple;
	bh=dAKovBVRDwnjiivGEdr7UI0DX2gfkl18cKpE5uONB/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biPHhm/32US50QpGYz7oZhf7lU9r5UXJCcu2ljAy/mUnx7b31HjtMrz83OzMAre+x/4KdUEHnjRAovLifVfTNCUK7L13HOICoBRhpqgGoiOljHtRlMoMnW0tFlLI2O6/cYzuI+sj61DLEjHqovdmsiHOIz+sF0SeqBrmBrn4LxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D202C4CEF1;
	Fri, 31 Oct 2025 17:40:06 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com
Subject: [NDCTL PATCH 1/5] cxl/test: Add test for extended linear cache support
Date: Fri, 31 Oct 2025 10:39:59 -0700
Message-ID: <20251031174003.3547740-2-dave.jiang@intel.com>
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

Add a unit test that verifies the extended linear cache setup paths
in the kernel driver. cxl_test provides a mock'd version. The test
verifies the sysfs attribute that indicates extended linear cache support
is correctly reported. It also verifies the sizing and offset of the
regions and decoders.

The expecation is that CFMWS covers the entire extended linear cache
region. The first part is DRAM and second part is CXL memory in a 1:1
setup. The start base for hardware decoders should be offsetted by the
DRAM size.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/cxl-elc.sh  | 89 ++++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build |  2 ++
 2 files changed, 91 insertions(+)
 create mode 100755 test/cxl-elc.sh

diff --git a/test/cxl-elc.sh b/test/cxl-elc.sh
new file mode 100755
index 000000000000..632e859c21f3
--- /dev/null
+++ b/test/cxl-elc.sh
@@ -0,0 +1,89 @@
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
+find_region()
+{
+	json="$($CXL list -b cxl_test -R)"
+	region=$(echo "$json" | jq -r '.[] | select(has("extended_linear_cache_size") and .extended_linear_cache_size != null) | .region')
+	[[ -n "$region" && "$region" != "null" ]] || do_skip "no test extended linear cache region found"
+}
+
+retrieve_info()
+{
+	# Root decoder name
+	cxlrd="$($CXL list -r$region -D | jq -r '.[] | select(has("root decoders")) | ."root decoders"[0].decoder')"
+	# Root decoder (CFMWS) window size
+	cxlrd_size="$($CXL list -b cxl_test -d $cxlrd | jq '.[0]."decoders:root0"[0].size')"
+	# Root decoder (CFMWS) window address base
+	cxlrd_hpa="$($CXL list -b cxl_test -r $region | jq '.[0]."regions:root0"[0].resource')"
+
+	# Region size
+	region_size="$($CXL list -b cxl_test -r $region | jq '.[0]."regions:root0"[0].size')"
+
+	# switch port 0 size
+	swp0_size="$($CXL list -r $region -D | jq '.[] | select(has("port decoders")) | ."port decoders"[0] | .size')"
+	# switch port 0 base address
+	swp0_hpa="$($CXL list -r $region -D | jq '.[] | select(has("port decoders")) | ."port decoders"[0] | .resource')"
+
+	# switch port 1 size
+	swp1_size="$($CXL list -r $region -D | jq '.[] | select(has("port decoders")) | ."port decoders"[1] | .size')"
+	# switch port 1 base address
+	swp1_hpa="$($CXL list -r $region -D | jq '.[] | select(has("port decoders")) | ."port decoders"[1] | .resource')"
+
+	# endpoint port 0 size
+	ep0_size="$($CXL list -r $region -D | jq '.[] | select(has("endpoint decoders")) | ."endpoint decoders"[0] | .size')"
+	# endpoint port 0 base address
+	ep0_hpa="$($CXL list -r $region -D | jq '.[] | select(has("endpoint decoders")) | ."endpoint decoders"[0] | .resource')"
+
+	# endpoint port 1 size
+	ep1_size="$($CXL list -r $region -D | jq '.[] | select(has("endpoint decoders")) | ."endpoint decoders"[1] | .size')"
+	# endpoint port 1 base address
+	ep1_hpa="$($CXL list -r $region -D | jq '.[] | select(has("endpoint decoders")) | ."endpoint decoders"[1] | .resource')"
+}
+
+compare_sizes()
+{
+	# The CXL region size should equal to the CFMWS size.
+	# It should be DRAM+CXL size combined
+	((cxlrd_size == region_size)) || err "$LINENO"
+
+	# The switch decoder size should be half of CFMWS size.
+	((cxlrd_size == swp0_size * 2)) || err "$LINENO"
+	((cxlrd_size == swp1_size * 2)) || err "$LINENO"
+
+	# The endpoint decoder size should be half of CFMWS size
+	((cxlrd_size == ep0_size * 2)) || err "$LINENO"
+	((cxlrd_size == ep1_size * 2)) || err "$LINENO"
+}
+
+# The extended linear cache is expected to be DRAM:CXL of 1:1 size
+# The CXL region occupies the second half of the CFMWS
+compare_bases()
+{
+	((cxlrd_hpa == swp0_hpa - swp0_size)) || err "$LINENO"
+	((cxlrd_hpa == swp1_hpa - swp1_size)) || err "$LINENO"
+
+	((cxlrd_hpa == ep0_hpa - ep0_size)) || err "$LINENO"
+	((cxlrd_hpa == ep1_hpa - ep1_size)) || err "$LINENO"
+}
+
+retrieve_info
+compare_sizes
+compare_bases
diff --git a/test/meson.build b/test/meson.build
index 615376ea635a..710a15850e2b 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -167,6 +167,7 @@ cxl_events = find_program('cxl-events.sh')
 cxl_sanitize = find_program('cxl-sanitize.sh')
 cxl_destroy_region = find_program('cxl-destroy-region.sh')
 cxl_qos_class = find_program('cxl-qos-class.sh')
+cxl_elc = find_program('cxl-elc.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -199,6 +200,7 @@ tests = [
   [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
   [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
+  [ 'cxl-elc.sh',             cxl_elc,            'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.51.0

