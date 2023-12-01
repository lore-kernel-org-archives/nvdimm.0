Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920615393
	for <nvdimm@lists.linux.dev>; Fri,  1 Dec 2023 04:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Px9to9FW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701403577; x=1732939577;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=OMGUXm0uyCiXwluHW7yP9z55uWYXvBA6zk5awABv6gM=;
  b=Px9to9FWley8ELXlA1J7ncDQgk6Q/++QEH0iajcvMxHXokKoNVD7qXZJ
   95nDz103LAfUriOhtQnV2vUh61AiGcyR6xpoaHsfTfFjtEJSkBNlfhbBM
   vb8kwDzKRTRg4yob5KQ+JS0Ds93x4IRMA3hfVWNnBovq9bbFKZZWnXtus
   KV6SRBtVFb3REpzIRFRv0k3DQNkyPaEMPLsMZ3N6HYseWAIyrsIJ77UB/
   FzW3WMpO+gG9hmd0iUUxDSbdQQFgSOgGZ0skmBrODmfStHxamHCqJz3Yd
   tABse/Uf1bQpRDL9leMdZu//stanH9Sd+aDh09FPgNJb1wuKYzRmV2m/r
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="433266"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="433266"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 20:06:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="769540359"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="769540359"
Received: from iweiny-desk3.amr.corp.intel.com (HELO localhost) ([10.212.102.178])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 20:06:14 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Thu, 30 Nov 2023 20:06:13 -0800
Subject: [PATCH ndctl RESEND 1/2] ndctl/test: Add destroy region test
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-fix-region-destroy-v1-1-7f916d2bd379@intel.com>
References: <20231130-fix-region-destroy-v1-0-7f916d2bd379@intel.com>
In-Reply-To: <20231130-fix-region-destroy-v1-0-7f916d2bd379@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-0f7f0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1701403573; l=3293;
 i=ira.weiny@intel.com; s=20221222; h=from:subject:message-id;
 bh=OMGUXm0uyCiXwluHW7yP9z55uWYXvBA6zk5awABv6gM=;
 b=t3jWKdbBr1UeuqYw6qKIaj/crGvTneMM1az+H+Ax0QNH3n1cO+/87csRisYnK//3GzoeLFctV
 Bz+RBSMhQmBDItHzzWySiHzEbshC30FHIjczdwn3i4wWCV1W38CPvbz
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=brwqReAJklzu/xZ9FpSsMPSQ/qkSalbg6scP3w809Ec=

Commit 9399aa667ab0 ("cxl/region: Add -f option for disable-region")
introduced a regression when destroying a region.

Add a tests for destroying a region.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 test/cxl-destroy-region.sh | 76 ++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build           |  2 ++
 2 files changed, 78 insertions(+)

diff --git a/test/cxl-destroy-region.sh b/test/cxl-destroy-region.sh
new file mode 100644
index 000000000000..251720a98688
--- /dev/null
+++ b/test/cxl-destroy-region.sh
@@ -0,0 +1,76 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 Intel Corporation. All rights reserved.
+
+. $(dirname $0)/common
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
+rc=1
+
+check_destroy_ram()
+{
+	mem=$1
+	decoder=$2
+
+	region=$($CXL create-region -d "$decoder" -m "$mem" | jq -r ".region")
+	if [ "$region" == "null" ]; then
+		err "$LINENO"
+	fi
+	$CXL enable-region "$region"
+
+	# default is memory is system-ram offline
+	$CXL disable-region $region
+	$CXL destroy-region $region
+}
+
+check_destroy_devdax()
+{
+	mem=$1
+	decoder=$2
+
+	region=$($CXL create-region -d "$decoder" -m "$mem" | jq -r ".region")
+	if [ "$region" == "null" ]; then
+		err "$LINENO"
+	fi
+	$CXL enable-region "$region"
+
+	dax=$($CXL list -X -r "$region" | jq -r ".[].daxregion.devices" | jq -r '.[].chardev')
+
+	$DAXCTL reconfigure-device -m devdax "$dax"
+
+	$CXL disable-region $region
+	$CXL destroy-region $region
+}
+
+# Find a memory device to create regions on to test the destroy
+readarray -t mems < <("$CXL" list -b cxl_test -M | jq -r '.[].memdev')
+for mem in ${mems[@]}; do
+        ramsize=$($CXL list -m $mem | jq -r '.[].ram_size')
+        if [ "$ramsize" == "null" ]; then
+                continue
+        fi
+        decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
+                  jq -r ".[] |
+                  select(.volatile_capable == true) |
+                  select(.nr_targets == 1) |
+                  select(.size >= ${ramsize}) |
+                  .decoder")
+        if [[ $decoder ]]; then
+		check_destroy_ram $mem $decoder
+		check_destroy_devdax $mem $decoder
+                break
+        fi
+done
+
+check_dmesg "$LINENO"
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index 2706fa5d633c..126d663dfce2 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -158,6 +158,7 @@ cxl_xor_region = find_program('cxl-xor-region.sh')
 cxl_update_firmware = find_program('cxl-update-firmware.sh')
 cxl_events = find_program('cxl-events.sh')
 cxl_poison = find_program('cxl-poison.sh')
+cxl_destroy_region = find_program('cxl-destroy-region.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -188,6 +189,7 @@ tests = [
   [ 'cxl-xor-region.sh',      cxl_xor_region,     'cxl'   ],
   [ 'cxl-events.sh',          cxl_events,         'cxl'   ],
   [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
+  [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
 ]
 
 if get_option('destructive').enabled()

-- 
2.42.0

