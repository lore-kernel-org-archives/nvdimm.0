Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6F312C7FB
	for <nvdimm@lists.linux.dev>; Tue,  9 Jul 2024 04:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720500248; cv=none; b=HEFm4r3WhELSJUw161s6uw1aDJstuXM1NQ+d4VIAe2+sRBC/7ISnxj/CEzfGSrShHEodxXk10Yzmj/tYA1Yl/AXMX7Pdc+nuvNFnV+N1wXjGdoyc9JNnFkRsJx/cUHXYrgantSpinPVjTcuHTb3vIIQ5msm31Sg5s4gmzA5AAho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720500248; c=relaxed/simple;
	bh=Gdj+Y3Xt8tco/mfw2qvmPDnhoHJZbMfH7meffJ0e/Co=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cGkHcI8IyyjGc4OHHrDqb3V+nLoFTB8o2HiofSvg2GO8uOxk9j+kgXXzehkwenJOPJ/ON0LQS7V3sgW8CkIOUkM4rxhFH6iGLUGECdAbTRuJAIVY0W2X4wzf2GYVcVKWesXdXIKjhTbtXEcCTgi6y4VZnAH8NuYBiLS9ZmPKV+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lYW7Ix0M; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lYW7Ix0M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720500246; x=1752036246;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Gdj+Y3Xt8tco/mfw2qvmPDnhoHJZbMfH7meffJ0e/Co=;
  b=lYW7Ix0Mlcl3opn6W0BZhqHV7ykcxrr8YvjXWNHqWFpfhLms99LKrgsl
   YFonMDJZ5U87H8a3GnkPB+Fot55mIY9bu7SK8IddEdnxfbZ0NnMoA5ybo
   7VTy7sT43tDs37xj/zXnzFjwom3d4D0+jYXHfnWFn5dKdYtCGNms8B2E4
   yUAwpfWC5w4qXsa1TZBZRgafDHC7VkIVGAxuPsWQOcOFZJK9HRioXg0fZ
   qWGd55olD2zczbQI9lTOEi9ko9tUyqS915v+HFf1z8d5UTmD0gWOSYP5+
   T6WAiMPZjnS4ecnYWZYPunnTJAZbbZez0+Sn13pbSXGRXG5iyuskAYsMV
   g==;
X-CSE-ConnectionGUID: cRaAoY15R7WpnzVkR5sMww==
X-CSE-MsgGUID: YTeCp2TYQ+eix+Gn1qqOhg==
X-IronPort-AV: E=McAfee;i="6700,10204,11127"; a="17547661"
X-IronPort-AV: E=Sophos;i="6.09,194,1716274800"; 
   d="scan'208";a="17547661"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 21:44:06 -0700
X-CSE-ConnectionGUID: I8MHVM7+RYCOt6+yYQWquw==
X-CSE-MsgGUID: 1bkpzV2WRgijiYDJmTZG/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,194,1716274800"; 
   d="scan'208";a="47684213"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.105.241])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 21:44:05 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] ndctl,cxl/test: Add a common unit test for creating pmem namespaces
Date: Mon,  8 Jul 2024 21:44:00 -0700
Message-Id: <20240709044400.679650-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Replace the nfit-only create.sh unit test with a set of scripts that
test pmem namespace creation in either the nfit or cxl environments.

The intent is to do the same reconfiguring of pmem namespaces as was
done by create.sh and then expand that with devdax namespaces and
create/destroy (no reconfigure) cases.

Script namespace.sh provides the shared functionality.
Scripts cxl-namespace and nfit-namespace set up the environments.
Scripts cxl-namespace.sh and nfit-namespace.sh kick off the tests.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/create.sh         | 45 --------------------
 test/cxl-namespace     | 25 +++++++++++
 test/cxl-namespace.sh  |  5 +++
 test/meson.build       |  6 ++-
 test/namespace.sh      | 95 ++++++++++++++++++++++++++++++++++++++++++
 test/nfit-namespace    |  6 +++
 test/nfit-namespace.sh |  5 +++
 7 files changed, 140 insertions(+), 47 deletions(-)
 delete mode 100755 test/create.sh
 create mode 100644 test/cxl-namespace
 create mode 100644 test/cxl-namespace.sh
 create mode 100644 test/namespace.sh
 create mode 100644 test/nfit-namespace
 create mode 100644 test/nfit-namespace.sh

diff --git a/test/create.sh b/test/create.sh
deleted file mode 100755
index 9a6f3733939e..000000000000
--- a/test/create.sh
+++ /dev/null
@@ -1,45 +0,0 @@
-#!/bin/bash -x
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
-
-set -e
-
-SECTOR_SIZE="4096"
-rc=77
-
-. $(dirname $0)/common
-
-check_min_kver "4.5" || do_skip "may lack namespace mode attribute"
-
-trap 'err $LINENO' ERR
-
-# setup (reset nfit_test dimms)
-modprobe nfit_test
-reset
-
-rc=1
-
-# create pmem
-dev="x"
-json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m raw)
-eval $(echo $json | json2var )
-[ $dev = "x" ] && echo "fail: $LINENO" && exit 1
-[ $mode != "raw" ] && echo "fail: $LINENO" &&  exit 1
-
-# convert pmem to fsdax mode
-json=$($NDCTL create-namespace -m fsdax -f -e $dev)
-eval $(echo $json | json2var)
-[ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
-
-# convert pmem to sector mode
-json=$($NDCTL create-namespace -m sector -l $SECTOR_SIZE -f -e $dev)
-eval $(echo $json | json2var)
-[ $sector_size != $SECTOR_SIZE ] && echo "fail: $LINENO" &&  exit 1
-[ $mode != "sector" ] && echo "fail: $LINENO" &&  exit 1
-
-# free capacity for blk creation
-$NDCTL destroy-namespace -f $dev
-
-_cleanup
-
-exit 0
diff --git a/test/cxl-namespace b/test/cxl-namespace
new file mode 100644
index 000000000000..8a7c23b8ce95
--- /dev/null
+++ b/test/cxl-namespace
@@ -0,0 +1,25 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Intel Corporation. All rights reserved.
+
+cxl_create_region()
+{
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 1) |
+		.decoder")
+
+	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+
+	region=$($CXL create-region -d "$decoder" -m "$mem0" |
+		jq -r ".region")
+	if [[ ! $region ]]; then
+		err "$LINENO"
+	fi
+}
+
+modprobe -r cxl_test
+modprobe cxl_test
+rc=1
+cxl_create_region
diff --git a/test/cxl-namespace.sh b/test/cxl-namespace.sh
new file mode 100644
index 000000000000..15259ea09603
--- /dev/null
+++ b/test/cxl-namespace.sh
@@ -0,0 +1,5 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Intel Corporation. All rights reserved.
+
+. $(dirname $0)/namespace.sh cxl
diff --git a/test/meson.build b/test/meson.build
index a965a79fd6cb..02bd368743b7 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -132,7 +132,7 @@ revoke_devmem = executable('revoke_devmem', testcore + [
 
 mmap = executable('mmap', 'mmap.c',)
 
-create = find_program('create.sh')
+nfit_namespace = find_program('nfit-namespace.sh')
 clear = find_program('clear.sh')
 pmem_errors = find_program('pmem-errors.sh')
 daxdev_errors_sh = find_program('daxdev-errors.sh')
@@ -160,11 +160,12 @@ cxl_events = find_program('cxl-events.sh')
 cxl_sanitize = find_program('cxl-sanitize.sh')
 cxl_destroy_region = find_program('cxl-destroy-region.sh')
 cxl_qos_class = find_program('cxl-qos-class.sh')
+cxl_namespace = find_program('cxl-namespace.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
   [ 'dsm-fail',               dsm_fail,	      	  'ndctl' ],
-  [ 'create.sh',              create,	      	  'ndctl' ],
+  [ 'nfit-namespace.sh',      nfit_namespace,     'ndctl' ],
   [ 'clear.sh',               clear,	      	  'ndctl' ],
   [ 'pmem-errors.sh',         pmem_errors,    	  'ndctl' ],
   [ 'daxdev-errors.sh',       daxdev_errors_sh,	  'dax'	  ],
@@ -192,6 +193,7 @@ tests = [
   [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
   [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
+  [ 'cxl-namespace.sh',       cxl_namespace,      'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
diff --git a/test/namespace.sh b/test/namespace.sh
new file mode 100644
index 000000000000..9e7e27af6c35
--- /dev/null
+++ b/test/namespace.sh
@@ -0,0 +1,95 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Intel Corporation. All rights reserved.
+
+. "$(dirname "$0")/common"
+
+rc=77
+trap 'err $LINENO' ERR
+check_prereq "jq"
+
+
+do_set_up()
+{
+	# Set up based on calling environment
+	if [[ "$1" == "nfit" ]]; then
+		. "$(dirname "$0")/nfit-namespace"
+		target=(-b "$NFIT_TEST_BUS0")
+	elif [[ "$1" == "cxl" ]]; then
+		. "$(dirname "$0")/cxl-namespace"
+		target=(--region="$region")
+	else
+		do_skip "Missing nfit or cxl input parameter"
+	fi
+
+	rc=1
+}
+
+test_namespace_create()
+{
+	local mode_list=("raw" "fsdax" "devdax" "sector")
+
+	for ns_mode in "${mode_list[@]}"; do
+		local params json
+		local dev="x"
+
+		if [[ "$ns_mode" == "devdax" || "$ns_mode" == "fsdax" ]]; then
+			params=("${target[@]}" -m "$ns_mode" --map=mem)
+		else
+			params=("${target[@]}" -m "$ns_mode")
+		fi
+
+		json=$($NDCTL create-namespace "${params[@]}")
+		eval "$(echo "$json" | json2var)"
+
+		if [[ "$dev" == "x" || "$mode" != "$ns_mode" ]]; then
+			err "$LINENO"
+		fi
+
+		$NDCTL destroy-namespace -f $dev || err "$LINENO"
+	done
+}
+
+test_namespace_reconfigure()
+{
+	# Create a raw pmem namespace then reconfigure it.
+	# Based on the original nfit create.sh plus devdax.
+
+	local json mode sector_size
+	local dev="x"
+
+	json=$($NDCTL create-namespace "${target[@]}" -t pmem -m raw)
+	eval "$(echo "$json" | json2var )"
+	[ "$dev" = "x" ] && err "$LINENO"
+	[ "$mode" != "raw" ] && err "$LINENO"
+
+	# convert pmem to fsdax mode
+	json=$($NDCTL create-namespace -m fsdax -f -e "$dev" --map=mem)
+	eval "$(echo "$json" | json2var )"
+	[ "$mode" != "fsdax" ] && err "$LINENO"
+
+	# convert pmem to sector mode
+	json=$($NDCTL create-namespace -m sector -l 4096 -f -e "$dev")
+	eval "$(echo "$json" | json2var )"
+	[ "$sector_size" != 4096 ] && err "$LINENO"
+	[ "$mode" != "sector" ] && err "$LINENO"
+
+	# convert pmem to devdax mode
+	json=$($NDCTL create-namespace -m devdax -f -e "$dev" --map=mem)
+	eval "$(echo "$json" | json2var )"
+	[ "$mode" != "devdax" ] && err "$LINENO"
+
+	$NDCTL destroy-namespace -f "$dev" || err "$LINENO"
+}
+
+do_set_up "$1"
+test_namespace_create
+test_namespace_reconfigure
+
+check_dmesg "$LINENO"
+
+if [ "$1" = "nfit" ]; then
+	_cleanup
+elif [ "$1" = "cxl" ]; then
+	_cxl_cleanup
+fi
diff --git a/test/nfit-namespace b/test/nfit-namespace
new file mode 100644
index 000000000000..1f7db4051537
--- /dev/null
+++ b/test/nfit-namespace
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Intel Corporation. All rights reserved.
+
+modprobe -r nfit_test
+modprobe nfit_test
+reset
diff --git a/test/nfit-namespace.sh b/test/nfit-namespace.sh
new file mode 100644
index 000000000000..28f4deac69d6
--- /dev/null
+++ b/test/nfit-namespace.sh
@@ -0,0 +1,5 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Intel Corporation. All rights reserved.
+
+. $(dirname $0)/namespace.sh nfit

base-commit: 16f45755f991f4fb6d76fec70a42992426c84234
-- 
2.37.3

