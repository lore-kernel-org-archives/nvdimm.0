Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DAA341AB6
	for <nvdimm@lists.linux.dev>; Wed,  1 Apr 2026 22:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775081624; cv=none; b=qhqZq4rcJUYuMuzHczH4dMH9cWnUa6JYcmc93yzxR2Rjmh2XKvgkAcWQq1YvTpCLXCJ5kcB+jthhyxQw7YU36/dUp46z7/r5g3mDXkqKhFjntFY3+tpiig8IMTpopkOReYMNyg0KFpPZNh/P4i2EomZveKoD9Jxk2rC48FGH7wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775081624; c=relaxed/simple;
	bh=z/yHfebh9vBu21Iks61O4YdSv9daEnESQYuQihcyY74=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KCBJ6m2N8vkq1m3Pcix3aFAEDekvx7HaNTkzeNyMyZGC4gDgFw0gb+W9IkoHAMF62JYsZiKBPPdMgj7tILraUm7cOvdPwZ3Pqf1Rw+ljgW6Fk4/AeylGvZ0hVOHkMkQ29SASKOS5t4CkQ9FpfMmf+zvUrSCDTRwQD2uJZ+ssQj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=an90O94h; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="an90O94h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775081621; x=1806617621;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=z/yHfebh9vBu21Iks61O4YdSv9daEnESQYuQihcyY74=;
  b=an90O94hosHz7Rvdo1Yz8K8jBJss+q/DogCx44l8LUlafkK80Cn2dzCm
   BIt0AMWEaRrEF+aPCTuZVvdEoSLue/+xEOiYIQ8eeZtrwc17jpSPLboz4
   LZk44bzCK+Ns77dcE4IziM4XEgC+69Arpk+/bzhbwetZailMegSgW5phs
   yiBn6rmd+e+JYyZk+LQykYIW69BNuyM1c6oM0EO8AYtjKREk8hpoIKiv2
   uw1/lixIWT8iRKYBdAju4axxXxp0TVn8yKE2AOI4QkGYe2/wf6a1mWQFS
   M0zWMHPvog7E2BBz4ivGldfTZInVFrhUXqAme94vhZuulztUvwfsq0EfO
   Q==;
X-CSE-ConnectionGUID: 6z/vErrkSUWEwVXxCdCPzw==
X-CSE-MsgGUID: HJE2lMhhTW2NZ2gwkRbZKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11746"; a="87208060"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="87208060"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 15:13:39 -0700
X-CSE-ConnectionGUID: xCL3G5wyRg+knNABOdG87A==
X-CSE-MsgGUID: TyfXMC9ZQMmeS1czPd2sZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="250009004"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.95])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 15:13:39 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] test/cxl-dax-hmem.sh: validate dax_hmem vs CXL collisions
Date: Wed,  1 Apr 2026 15:13:35 -0700
Message-ID: <20260401221336.2894052-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dan Williams <dan.j.williams@intel.com>

Use the new "cxl_test.hmem_test" and "cxl_test.fail_autoassemble"
module options to implement a new cxl-dax-hmem.sh test. The test
checks dax_hmem takeover of Soft Reserve ranges that collide with
autoassembled CXL regions. It depends on the cxl_mock_mem driver
to launch multiple async probes before the dax_hmem driver attaches.

[as: do_skip on missing params, explicit param usage, robust unload,
check_dmesg, misc style]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-dax-hmem.sh | 66 ++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build     |  2 ++
 2 files changed, 68 insertions(+)
 create mode 100755 test/cxl-dax-hmem.sh

diff --git a/test/cxl-dax-hmem.sh b/test/cxl-dax-hmem.sh
new file mode 100755
index 000000000000..1c00ab021e03
--- /dev/null
+++ b/test/cxl-dax-hmem.sh
@@ -0,0 +1,66 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 Intel Corporation
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
+modinfo cxl_test | grep -q '^parm:.*hmem_test' || \
+	do_skip "cxl_test hmem_test module param not available"
+
+modinfo cxl_test | grep -q '^parm:.*fail_autoassemble' || \
+	do_skip "cxl_test fail_autoassemble module param not available"
+
+rc=1
+
+unload()
+{
+	modprobe -r dax_cxl 2>/dev/null || true
+	modprobe -r dax_hmem 2>/dev/null || true
+	modprobe -r cxl_mock_mem 2>/dev/null || true
+	modprobe -r cxl_test 2>/dev/null || true
+}
+
+find_dax_cxl()
+{
+	$DAXCTL list -R | jq -r \
+		'.[] | select(.path | contains("cxl_acpi.0")) | .path'
+}
+
+find_dax_hmem()
+{
+	$DAXCTL list -R | jq -r \
+		'.[] | select(.path | contains("hmem_platform.1")) | .path'
+}
+
+unload
+
+# Verify CXL autoassembly claims the Soft Reserve range before dax_hmem.
+modprobe cxl_mock_mem
+modprobe cxl_test hmem_test=1
+
+dax=$(find_dax_cxl)
+[[ -z "$dax" ]] && err $LINENO
+dax=$(find_dax_hmem)
+[[ -n "$dax" ]] && err $LINENO
+
+unload
+
+# Verify dax_hmem claims the Soft Reserve range when CXL autoassembly fails.
+modprobe cxl_mock_mem
+modprobe cxl_test hmem_test=1 fail_autoassemble=1
+
+dax=$(find_dax_cxl)
+[[ -n "$dax" ]] && err $LINENO
+dax=$(find_dax_hmem)
+[[ -z "$dax" ]] && err $LINENO
+
+unload
+check_dmesg "$LINENO"
diff --git a/test/meson.build b/test/meson.build
index 593edf552b36..4260a3fa4448 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -169,6 +169,7 @@ cxl_destroy_region = find_program('cxl-destroy-region.sh')
 cxl_qos_class = find_program('cxl-qos-class.sh')
 cxl_translate = find_program('cxl-translate.sh')
 cxl_elc = find_program('cxl-elc.sh')
+cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -203,6 +204,7 @@ tests = [
   [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
   [ 'cxl-translate.sh',       cxl_translate,      'cxl'   ],
   [ 'cxl-elc.sh',             cxl_elc,            'cxl'   ],
+  [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.3

