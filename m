Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4686C35E936;
	Wed, 22 Apr 2026 23:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776899315; cv=none; b=vDJaPJBiSwn0IY/Lymzfc34rzpOlLXRxq+tWM+3Rg/XNXyrtZ07ckw5nNo/NrTccyPvLCf3GHsNzswfxrKK1qcuSMw3DtRYutgX/6okpoSoWAf8yVIk5vjIvIT4cC4ot4iH2k24N6GdfV0V1752HiI+EiipAxwudtm1f4x5OIXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776899315; c=relaxed/simple;
	bh=snJ/eGBEToWErBWeqnKNVBMuHBmvVYmdpyBQRo0IjxE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pt2fkwkr0zVpOExWu1u1vrm8omoCRtm8sfkyFEqyKOFrJaH6ESOez3DjLqu83R29y9UtA4MH5C7DhY03jsyF9Bq0Ktc7aVztGEnq0pLhjQCOs6pA1Hs3QOLAuFpZ7aWM2tvsUAYBJGoF19sRHXdbq9WpMfGTSiq3sgjZaoQNNvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E49C19425;
	Wed, 22 Apr 2026 23:08:34 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH] cxl: Add CXL type2 accelerator unit test
Date: Wed, 22 Apr 2026 16:08:33 -0700
Message-ID: <20260422230833.2622279-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CXL type2 hierachy can be setup via the cxl_test. Add a regression test
unit to CXL CLI to verify the type2 loading/unloading. Test include
removing the root port and bringing it back as well as unbinding the
type2 mock device driver and bringing it back. The expectation is that
the auto region should return.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/cxl-type2.sh | 71 +++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build  |  2 ++
 2 files changed, 73 insertions(+)
 create mode 100644 test/cxl-type2.sh

diff --git a/test/cxl-type2.sh b/test/cxl-type2.sh
new file mode 100644
index 000000000000..0ece0c4f6ddb
--- /dev/null
+++ b/test/cxl-type2.sh
@@ -0,0 +1,71 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 Intel Corporation. All rights reserved.
+
+. "$(dirname "$0")"/common
+
+rc=77
+
+set -ex
+
+trap 'err $LINENO' ERR
+
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
+	region=$("$CXL" list -b cxl_test -R | jq -r '.[0].region')
+	[ -n "$region" ] || err "$LINENO"
+	check_dmesg "$LINENO"
+	remove_kmod
+}
+
+# Test rootport disable/enable case
+cycle_root_port() {
+	load_kmod
+	port=$("$CXL" list -b cxl_test -P | jq -r '.[0].port')
+	[ -n "$port" ] || err "$LINENO"
+
+	"$CXL" disable-port "$port" -f
+	region=$(cxl list -b cxl_test -R | jq -r '.[0].region // empty')
+	[ -z "$region" ] || err "$LINENO"
+
+	"$CXL" enable-port "$port"
+	echo cxl_type2_accel.0 > /sys/bus/platform/drivers/cxl_mock_accel/bind
+	region=$(cxl list -b cxl_test -R | jq -r '.[0].region')
+	[ -n "$region" ] || err "$LINENO"
+	check_dmesg "$LINENO"
+	remove_kmod
+}
+
+# Test reload firmware case
+cycle_pdev_driver() {
+	load_kmod
+	region=$("$CXL" list -b cxl_test -R | jq -r '.[0].region')
+	[ -n "$region" ] || err "$LINENO"
+	echo cxl_type2_accel.0 > /sys/bus/platform/drivers/cxl_mock_accel/unbind
+	region=$("$CXL" list -b cxl_test -R | jq -r '.[0].region // empty')
+	[ -z "$region" ] || err "$LINENO"
+	echo cxl_type2_accel.0 > /sys/bus/platform/drivers/cxl_mock_accel/bind
+	region=$("$CXL" list -b cxl_test -R | jq -r '.[0].region')
+	[ -n "$region" ] || err "$LINENO"
+	check_dmesg "$LINENO"
+	remove_kmod
+}
+
+remove_kmod
+rc=1
+
+init_check
+cycle_root_port
+cycle_pdev_driver
diff --git a/test/meson.build b/test/meson.build
index e0e2193bfd51..567347b655d2 100644
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

base-commit: 81c7cdd6cbcb4f1f77870ff02d8dd86298036f58
-- 
2.53.0

