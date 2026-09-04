Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFC23A9DB2
	for <nvdimm@lists.linux.dev>; Fri,  4 Sep 2026 02:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788490386; cv=none; b=XBQIGLDh/D5ybeQXXwZg1hxKEGNTW811mflEM4WM3VPbHkCpCqVoOfSHaMhvLoKsdU/KBmw/FUhq0yokkV7tiFC53CGlQNH0T6Xq5az7+ZKdOFw4X27bGwomOUSahxJYiW+6kd+6U3J4GjMqPKXXqRCTcpmGSHo5CjSnsHDU0D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788490386; c=relaxed/simple;
	bh=q6wqXRhwBeUix4bXDR+Hl5b7taCAE9jRD0iTF92b93Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWF6Bu3/qIG3bbHHZI87jULQ74yIPthhz1vDRyvTatwLz04S8sANuTg59vLk1Zo5LUZp7NXQZYrG/aZH6P4xOega9Usx8fYpQ3PKWHr7BbZ0S1ieBbsMvj0uYZEPnhht+TdoNXlHj5ba0dFFS/GJeGklxiu8jazMIOKJgZE/U08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jKKgpOfD; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jKKgpOfD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788490383; x=1820026383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q6wqXRhwBeUix4bXDR+Hl5b7taCAE9jRD0iTF92b93Q=;
  b=jKKgpOfDDCuNcN6b4Fkb8fsw/zcpKLNHKVAq6uPRvLlHWhJA2kw0celw
   fbcCBZ5QMo3TGhxbFso8zdTCdAuPP+J0UUd5MsKdS6aKWGoU27OskCdpz
   UO9ak+LOavU7LqpeFo1ran3yGBQENGtyXtk2DlTljptiUhnB7Tz2W/epf
   HARolUWQ/OtJLU8og2lOT8dC/8Bylf4VXjLm6AQXPGhTwVX+gA8iRXk3Y
   dVGXrFmMLZuFhVYl6trCAswkj+DlbYa3X5+5nXTU8225gTirgpY33GO6M
   jSabGJ2eVFYcIo3X5hwCQfjYDzHyqufjUdM3YRq7p8UQnYLh+MUk4xXHl
   Q==;
X-CSE-ConnectionGUID: qaVBdMFyRnmgvAojFVJU0Q==
X-CSE-MsgGUID: B0+5pLuoTvyfhZXpHN57AA==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88915026"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88915026"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 19:53:01 -0700
X-CSE-ConnectionGUID: QCC0iMN2TMGRCny00HhGMA==
X-CSE-MsgGUID: x0syX3OLRsivwumPJHPKvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="271865667"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.10])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 19:53:01 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2 1/3] test/cxl-create-region.sh: fold in XOR region coverage
Date: Thu,  3 Sep 2026 19:52:55 -0700
Message-ID: <b56fbcd6af980ed2f7e9e7cbd3effe2369d099b6.1788489571.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1788489571.git.alison.schofield@intel.com>
References: <cover.1788489571.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the CXL Unit Test Suite, region creation coverage is split between
cxl-create-region.sh and cxl-xor-region.sh.

Consolidate the XOR coverage into cxl-create-region.sh so region
creation testing lives in one place. This avoids maintaining parallel
test infrastructure and makes it easier to add new region creation
cases.

Remove the now redundant cxl-xor-region.sh.

Continue to maintain cxl-region-sysfs.sh because it exercises the CXL
driver ABI directly.

Assisted-by: Claude:Opus-4-8
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-create-region.sh | 111 ++++++++++++++++++++++++++++++++
 test/cxl-xor-region.sh    | 129 --------------------------------------
 test/meson.build          |   2 -
 3 files changed, 111 insertions(+), 131 deletions(-)
 delete mode 100644 test/cxl-xor-region.sh

diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index 658b9b8ff58a..d7a6840fed1a 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -133,6 +133,98 @@ create_single()
 	destroy_regions "$region"
 }
 
+create_and_destroy_region()
+{
+	region=$($CXL create-region -d "$decoder" -m "$memdevs" |
+		jq -r ".region")
+
+	if [[ ! $region ]]; then
+		echo "create-region failed for $decoder"
+		err "$LINENO"
+	fi
+
+	destroy_regions "$region"
+}
+
+setup_x1()
+{
+	# Find an x1 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 1) |
+		.decoder")
+
+	# Find a memdev for this host-bridge
+	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	memdevs="$mem0"
+}
+
+setup_x2()
+{
+	# Find an x2 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 2) |
+		.decoder")
+
+	# Find a memdev for each host-bridge interleave position
+	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")
+	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 1) | .target")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
+	memdevs="$mem0 $mem1"
+}
+
+setup_x4()
+{
+	# find an x2 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 2) |
+		.decoder")
+
+	# Find a memdev for each host-bridge interleave position
+	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")
+	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 1) | .target")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
+	mem2=$($CXL list -M -p "$port_dev0" | jq -r ".[1].memdev")
+	mem3=$($CXL list -M -p "$port_dev1" | jq -r ".[1].memdev")
+	memdevs="$mem0 $mem1 $mem2 $mem3"
+}
+
+setup_x3()
+{
+	# find an x3 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 3) |
+		.decoder")
+
+	if [[ ! $decoder ]]; then
+		echo "no x3 decoder found, skipping xor-x3 test"
+		return
+	fi
+
+	# Find a memdev for each host-bridge interleave position
+	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")
+	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 1) | .target")
+	port_dev2=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 2) | .target")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
+	mem2=$($CXL list -M -p "$port_dev2" | jq -r ".[0].memdev")
+	memdevs="$mem0 $mem1 $mem2"
+}
+
 # test region creation on devices behind a single-port host-bridge
 create_single
 
@@ -149,6 +241,25 @@ for mem in ${mems[@]}; do
 	create_subregions "$mem"
 done
 
+# Reload cxl_test with XOR interleave arithmetic to exercise the XOR math
+# option of the CXL driver. Create x1,2,3,4 regions across the XOR roots.
+# As with the modulo tests above, changes to the CXL topology in
+# tools/testing/cxl/test/cxl.c may require an update here.
+modprobe -r cxl_test
+modprobe cxl_test interleave_arithmetic=1
+
+setup_x1
+create_and_destroy_region
+setup_x2
+create_and_destroy_region
+setup_x4
+create_and_destroy_region
+# x3 decoder may not be available in cxl/test topo yet
+setup_x3
+if [[ $decoder ]]; then
+	create_and_destroy_region
+fi
+
 check_dmesg "$LINENO"
 
 modprobe -r cxl_test
diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
deleted file mode 100644
index fb4f9a0a1515..000000000000
--- a/test/cxl-xor-region.sh
+++ /dev/null
@@ -1,129 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (C) 2022 Intel Corporation. All rights reserved.
-
-. $(dirname $0)/common
-
-rc=77
-
-set -ex
-
-trap 'err $LINENO' ERR
-
-check_prereq "jq"
-
-modprobe -r cxl_test
-modprobe cxl_test interleave_arithmetic=1
-rc=1
-
-# THEORY OF OPERATION: Create x1,2,3,4 regions to exercise the XOR math
-# option of the CXL driver. As with other cxl_test tests, changes to the
-# CXL topology in tools/testing/cxl/test/cxl.c may require an update here.
-
-create_and_destroy_region()
-{
-	region=$($CXL create-region -d "$decoder" -m "$memdevs" |
-		jq -r ".region")
-
-	if [[ ! $region ]]; then
-		echo "create-region failed for $decoder"
-		err "$LINENO"
-	fi
-
-	$CXL destroy-region -f -b cxl_test "$region"
-}
-
-setup_x1()
-{
-	# Find an x1 decoder
-	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
-		select(.pmem_capable == true) |
-		select(.nr_targets == 1) |
-		.decoder")
-
-	# Find a memdev for this host-bridge
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
-	memdevs="$mem0"
-}
-
-setup_x2()
-{
-	# Find an x2 decoder
-	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
-		select(.pmem_capable == true) |
-		select(.nr_targets == 2) |
-		.decoder")
-
-	# Find a memdev for each host-bridge interleave position
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 1) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
-	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
-	memdevs="$mem0 $mem1"
-}
-
-setup_x4()
-{
-	# find an x2 decoder
-	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
-		select(.pmem_capable == true) |
-		select(.nr_targets == 2) |
-		.decoder")
-
-	# Find a memdev for each host-bridge interleave position
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 1) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
-	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
-	mem2=$($CXL list -M -p "$port_dev0" | jq -r ".[1].memdev")
-	mem3=$($CXL list -M -p "$port_dev1" | jq -r ".[1].memdev")
-	memdevs="$mem0 $mem1 $mem2 $mem3"
-}
-
-setup_x3()
-{
-	# find an x3 decoder
-	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
-		select(.pmem_capable == true) |
-		select(.nr_targets == 3) |
-		.decoder")
-
-	if [[ ! $decoder ]]; then
-		echo "no x3 decoder found, skipping xor-x3 test"
-		return
-	fi
-
-	# Find a memdev for each host-bridge interleave position
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 1) | .target")
-	port_dev2=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 2) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
-	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
-	mem2=$($CXL list -M -p "$port_dev2" | jq -r ".[0].memdev")
-	memdevs="$mem0 $mem1 $mem2"
-}
-
-setup_x1
-create_and_destroy_region
-setup_x2
-create_and_destroy_region
-setup_x4
-create_and_destroy_region
-# x3 decoder may not be available in cxl/test topo yet
-setup_x3
-if [[ $decoder ]]; then
-	create_and_destroy_region
-fi
-
-check_dmesg "$LINENO"
-
-modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index 07c8618cbc6e..d6cd2a3d4b10 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -162,7 +162,6 @@ cxl_topo = find_program('cxl-topology.sh')
 cxl_sysfs = find_program('cxl-region-sysfs.sh')
 cxl_labels = find_program('cxl-labels.sh')
 cxl_create_region = find_program('cxl-create-region.sh')
-cxl_xor_region = find_program('cxl-xor-region.sh')
 cxl_update_firmware = find_program('cxl-update-firmware.sh')
 cxl_events = find_program('cxl-events.sh')
 cxl_sanitize = find_program('cxl-sanitize.sh')
@@ -201,7 +200,6 @@ tests = [
   [ 'cxl-region-sysfs.sh',    cxl_sysfs,	  'cxl'   ],
   [ 'cxl-labels.sh',          cxl_labels,	  'cxl'   ],
   [ 'cxl-create-region.sh',   cxl_create_region,  'cxl'   ],
-  [ 'cxl-xor-region.sh',      cxl_xor_region,     'cxl'   ],
   [ 'cxl-events.sh',          cxl_events,         'cxl'   ],
   [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
-- 
2.37.3

