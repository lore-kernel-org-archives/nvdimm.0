Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1169A37DAAA;
	Fri, 26 Jun 2026 17:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782493802; cv=none; b=coecbsh9m24uDr6qonys9eeunwJGboTRn/mWBKv4aNAe1bAWOII9wKd4Rv9g5PNmf22qCksyOx7OEOQqj+LVIN0eM9OKaT15sjfDFCLrSYmIzN5WJFj5uVwv2i0pS99qM/AShLkbNPFTouAhUbETFqm59xLcwAETxuSJdFAEiiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782493802; c=relaxed/simple;
	bh=SoAJgLlEOnUchXjHYkJ+yVUN1P37jkym3o4Ur8qAwY8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FX6jMkQ2NqwIlztlRf/12qfICMjaBYaAhbCKbNZR0UgWf2ECbLdKhv7TubfdmvpRsNE1Azp5SgVWBUwZFoCiGRfj7TVyxyCC2rZdLzOzevfX/IN2J0IGiCWmjOI792r/2+YcvKTQ+j1Ow/+p1OS/5QR5JXmD7umfQMx9DgjN0CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A591F000E9;
	Fri, 26 Jun 2026 17:10:00 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH v3] cxl: Add CXL type2 accelerator unit test
Date: Fri, 26 Jun 2026 10:09:59 -0700
Message-ID: <20260626170959.1416017-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CXL type2 hierachy can be setup via the cxl_test. Add a regression test
unit to CXL CLI to verify the type2 loading/unloading. Test include
removing the root port and bringing it back, unbinding the type2 mock
device driver and bringing it back, and checking to see if a region
can be destroyed and a memdev can be disabled.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v3:
- Add //empty to all jq quiries (Alison)
---
 test/cxl-type2.sh | 103 ++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build  |   2 +
 2 files changed, 105 insertions(+)
 create mode 100644 test/cxl-type2.sh

diff --git a/test/cxl-type2.sh b/test/cxl-type2.sh
new file mode 100644
index 000000000000..8c5321e6bf8c
--- /dev/null
+++ b/test/cxl-type2.sh
@@ -0,0 +1,103 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 Intel Corporation. All rights reserved.
+
+. "$(dirname "$0")"/common
+
+rc=77
+set -ex
+trap 'err $LINENO' ERR
+check_prereq "jq"
+
+remove_kmod() {
+	modprobe -r cxl_test
+}
+
+load_kmod() {
+	modprobe cxl_test type2_test=1
+}
+
+init_check() {
+	load_kmod
+	[ -f /sys/module/cxl_test/parameters/type2_test ] || \
+		do_skip "cxl_test type2_test module param not available"
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region // empty')
+	[ -n "$region" ] || err "$LINENO"
+}
+
+# Test rootport disable/enable case
+cycle_root_port() {
+	echo "Testing root port disable/enable"
+	memdev=$("$CXL" list -b "$CXL_TEST_BUS" -M | jq -r '.[0].memdev // empty')
+	[ -n "$memdev" ] || err "$LINENO"
+	port=$("$CXL" list -b "$CXL_TEST_BUS" -m "$memdev" -P | jq -r '.[0].port // empty')
+	[ -n "$port" ] || err "$LINENO"
+
+	"$CXL" disable-port "$port" -f
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region // empty')
+	[ -z "$region" ] || err "$LINENO"
+
+	"$CXL" enable-port "$port"
+	echo cxl_type2_accel.0 > /sys/bus/platform/drivers/cxl_mock_accel/bind
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region // empty')
+	[ -n "$region" ] || err "$LINENO"
+}
+
+# Test rebind device driver
+cycle_pdev_driver() {
+	echo "Testing device driver unbind/bind"
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region // empty')
+	[ -n "$region" ] || err "$LINENO"
+	echo cxl_type2_accel.0 > /sys/bus/platform/drivers/cxl_mock_accel/unbind
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region // empty')
+	[ -z "$region" ] || err "$LINENO"
+	echo cxl_type2_accel.0 > /sys/bus/platform/drivers/cxl_mock_accel/bind
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region // empty')
+	[ -n "$region" ] || err "$LINENO"
+}
+
+# Test memdev removal with CXL CLI
+test_dev_removal() {
+	echo "Testing device removal with CXL CLI"
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region // empty')
+	[ -n "$region" ] || err "$LINENO"
+	"$CXL" disable-region "$region"
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region // empty')
+	[ -z "$region" ] || err "$LINENO"
+
+	# type2 region is auto region and cannot be destroyed
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -Ri | jq -r '.[0].region // empty')
+	[ -n "$region" ] || err "$LINENO"
+	"$CXL" destroy-region "$region" || true
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -Ri | jq -r '.[0].region // empty')
+	[ -n "$region" ] || err "$LINENO"
+
+	# Do it directly via sysfs since CXL CLI has checks that will skip sysfs
+	echo "0" | tee /sys/bus/cxl/devices/"$region"/commit || true
+	region=$("$CXL" list -b "$CXL_TEST_BUS" -Ri | jq -r '.[0].region // empty')
+	[ -n "$region" ] || err "$LINENO"
+
+	# Make sure there's no delete_region for a type2 root decoder
+	rd=$("$CXL" list -b "$CXL_TEST_BUS" -r"$region" -D | jq -r '.[0]."root decoders"[0].decoder')
+	[ -n "$rd" ] || err "$LINENO"
+	[ ! -f /sys/bus/cxl/devices/"$rd"/delete_region ] || err "$LINENO"
+
+	memdev=$("$CXL" list -b "$CXL_TEST_BUS" -M | jq -r '.[0].memdev // empty')
+	[ -n "$memdev" ] || err "$LINENO"
+
+	# memdev is not expected to be removed because region can't be destroyed
+	"$CXL" disable-memdev "$memdev" || true
+	memdev=$("$CXL" list -b "$CXL_TEST_BUS" -M | jq -r '.[0].memdev // empty')
+	[ -n "$memdev" ] || err "$LINENO"
+}
+
+remove_kmod
+init_check
+rc=1
+
+cycle_root_port
+cycle_pdev_driver
+test_dev_removal
+
+check_dmesg "$LINENO"
+remove_kmod
diff --git a/test/meson.build b/test/meson.build
index 56aed9cc3c9d..7bc972d4943e 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -171,6 +171,7 @@ cxl_translate = find_program('cxl-translate.sh')
 cxl_elc = find_program('cxl-elc.sh')
 cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
 cxl_region_replay = find_program('cxl-region-replay.sh')
+cxl_type2 = find_program('cxl-type2.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -207,6 +208,7 @@ tests = [
   [ 'cxl-elc.sh',             cxl_elc,            'cxl'   ],
   [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
   [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
+  [ 'cxl-type2.sh',           cxl_type2,          'cxl'   ],
 ]
 
 if get_option('destructive').enabled()

base-commit: 5fcbbee57319e718bf522436ea6595bd0f71296c
-- 
2.54.0

