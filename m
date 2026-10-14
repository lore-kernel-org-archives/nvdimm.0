Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497802D9796
	for <nvdimm@lists.linux.dev>; Wed, 14 Oct 2026 04:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791952710; cv=none; b=hKSrCO46B0+OBtDtnCHiDy+2YaNZmajn8jx8P18YNVUHZdggVi8cSKwK3Uqcn5cccVdMjLy6gQpYcW8MYAjLQj78uhoJerLANaJBcHLa6BogBHndgNQ/Psib8p3xrINelQfv7PbrBg03Zg0dhFWLSp3lnIgASJKBGaRY7KeWIcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791952710; c=relaxed/simple;
	bh=WgO2z21qiQifReUdyWhyJhpNkxL3VqsKvzN87nSwryU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SjonPttVIXyVpm69Mngr3cBYKa5caDSAA+lwvDLBQg+VeFom/8mqECwim9hkeAw5aDJHDds/2nutJ8eKdN53D2stOOj1VatLndQweWIBB8cPm1hBQ9gSaP/oz8/WM0uKmD+yKCAO5ZO4Ha2WPeIVjMsZ2m0rKJAntF+jM4KvZSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IQQTvHWf; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IQQTvHWf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791952706; x=1823488706;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WgO2z21qiQifReUdyWhyJhpNkxL3VqsKvzN87nSwryU=;
  b=IQQTvHWf5nd6JLh34sNQSDIrSDmWEkfMIlicKsTKpqdaR+V4A2KAmnYP
   77qxgW/JHeQtg0v7jsamKQXAcfGuDex7M+0OBdD/3I68bR5jNT8u0AyNm
   RRozlm50xVSMm8/+mHf3w4DnQS38xxSyUtqp1Heg9BcHCZbYtV1HAl5C7
   zUApIDX/5+zf9nTFR8pcxrs/moCcwlwxUyrG07Wnm7eDaktkc1pmwA9Ib
   1EzM+0DM4kb4YfW9b4ibMuuVbkqRAALHFh8ESUafC9XtdrP70nIwCKtEk
   7NEZc+QSPFoiKP/pEYu44vfER7spX7QNXvEMcJenXh4BecAUFOy3xSuOx
   A==;
X-CSE-ConnectionGUID: vwYwtuLYRzKRHpeidrRLpA==
X-CSE-MsgGUID: 4ERIAghwRdmjc52VtkE/2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="574096"
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="574096"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 21:38:25 -0700
X-CSE-ConnectionGUID: PouncQQ3TRK59G2lciQCZw==
X-CSE-MsgGUID: 8iRqJD9ZQK+FWCyVisrvPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="1411164"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.192])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 21:38:25 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] test/cxl-kunit.sh: enable running the CXL KUnit tests
Date: Tue, 13 Oct 2026 21:38:22 -0700
Message-ID: <20261014043823.295243-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CXL KUnit suites run when their modules are loaded, but the ndctl CXL
test suite does not load them. As a result, they are not exercised by
the existing ndctl tests.

Add cxl-kunit.sh to discover and load installed CXL KUnit modules, check
their KTAP results in debugfs, and unload the modules on exit. Test
failures are reported individually without preventing the remaining suites
from running.

Discover modules by the cxl_*_kunit naming convention so newly added suites
are included automatically.

Add CONFIG_KUNIT, CONFIG_KUNIT_DEBUGFS, and CONFIG_CXL_KUNIT_TEST=m to the
README kernel configuration.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 README.md         |  3 ++
 test/cxl-kunit.sh | 86 +++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build  |  2 ++
 3 files changed, 91 insertions(+)
 create mode 100755 test/cxl-kunit.sh

diff --git a/README.md b/README.md
index a71db28f62fb..83e809a2b325 100644
--- a/README.md
+++ b/README.md
@@ -130,6 +130,9 @@ loaded.  To build and install nfit_test.ko:
    CONFIG_NVDIMM_SECURITY_TEST=y
    CONFIG_ENCRYPTED_KEYS=y
    CONFIG_NVDIMM_KEYS=y
+   CONFIG_KUNIT=y
+   CONFIG_KUNIT_DEBUGFS=y
+   CONFIG_CXL_KUNIT_TEST=m
    ```
 1. Install cxl_test and related mock modules.
    ```
diff --git a/test/cxl-kunit.sh b/test/cxl-kunit.sh
new file mode 100755
index 000000000000..12e94e417cac
--- /dev/null
+++ b/test/cxl-kunit.sh
@@ -0,0 +1,86 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 Intel Corporation. All rights reserved.
+
+# Run CXL KUnit suites through the ndctl test harness.
+# Discover test modules by name and check their KTAP results in debugfs.
+# See Documentation/driver-api/cxl/testing.rst in the kernel.
+
+# shellcheck disable=SC1091 # common is sourced from the test directory
+. "$(dirname "$0")"/common
+
+kunit_debugfs=/sys/kernel/debug/kunit
+
+mapfile -t modules < <(find /lib/modules/"$(uname -r)" \
+	-name 'cxl_*_kunit.ko*' -printf '%f\n' | sed 's/\.ko.*$//' | sort)
+
+[ ${#modules[@]} -gt 0 ] ||
+	do_skip "test requires CONFIG_CXL_KUNIT_TEST=m"
+
+unload_modules() {
+	local mod
+
+	for mod in "${modules[@]}"; do
+		modprobe -r "$mod" 2>/dev/null || true
+	done
+}
+
+trap unload_modules EXIT
+trap 'err $LINENO' ERR
+set -ex
+# shellcheck disable=SC2034 # rc is the exit status used by err()
+rc=1
+
+# Force test suites to rerun on module load
+unload_modules
+
+loaded=()
+summary=()
+nr_failed=0
+
+for mod in "${modules[@]}"; do
+	if modprobe "$mod"; then
+		loaded+=("$mod")
+	else
+		summary+=("$mod: FAIL, module did not load")
+		nr_failed=$((nr_failed + 1))
+	fi
+done
+
+[ -d "$kunit_debugfs" ] ||
+	do_skip "test requires CONFIG_KUNIT_DEBUGFS=y"
+
+for mod in "${loaded[@]}"; do
+	nr_suites=0
+
+	for results in "$kunit_debugfs"/cxl_*/results; do
+		[ -f "$results" ] || continue
+		grep -qE "^[[:space:]]*# module: $mod\$" "$results" || continue
+
+		suite=$(basename "$(dirname "$results")")
+		nr_suites=$((nr_suites + 1))
+		cat "$results"
+
+		# Match the suite result, not individual test cases
+		if grep -qE "^ok [0-9]+ $suite\$" "$results"; then
+			summary+=("$mod: suite $suite PASS")
+		else
+			summary+=("$mod: suite $suite FAIL")
+			nr_failed=$((nr_failed + 1))
+		fi
+	done
+
+	if [ "$nr_suites" -eq 0 ]; then
+		summary+=("$mod: FAIL, no suite results in $kunit_debugfs")
+		nr_failed=$((nr_failed + 1))
+	fi
+done
+
+set +x
+echo "CXL KUnit summary:"
+printf '  %s\n' "${summary[@]}"
+set -x
+
+[ "$nr_failed" -eq 0 ] || err "$LINENO"
+
+echo "CXL KUnit: all suites from ${#modules[@]} modules passed"
diff --git a/test/meson.build b/test/meson.build
index 07c8618cbc6e..3b3a634ef25d 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -173,6 +173,7 @@ cxl_elc = find_program('cxl-elc.sh')
 cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
 cxl_region_replay = find_program('cxl-region-replay.sh')
 cxl_type2 = find_program('cxl-type2.sh')
+cxl_kunit = find_program('cxl-kunit.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -211,6 +212,7 @@ tests = [
   [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
   [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
   [ 'cxl-type2.sh',           cxl_type2,          'cxl'   ],
+  [ 'cxl-kunit.sh',           cxl_kunit,          'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.3

