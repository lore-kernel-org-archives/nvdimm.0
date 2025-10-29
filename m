Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96AE2D0C80
	for <nvdimm@lists.linux.dev>; Wed, 29 Oct 2025 03:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761708583; cv=none; b=pgdIpSkcKEGuT0BcyxH2Bj7m/TZYAVqcAIOZuTiMzc3XYKuYshDvuhGBTZsQKOgm/VKFTCAnkCQx6HwBGkCtGXh5p3lygClU+MCwGGu6ZDL8ov16HBq2tH5IwUf3PpmWbSCH+/IguA7inbhqND2RtmLha8il1bHPD1ScrawMmvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761708583; c=relaxed/simple;
	bh=potTdtxKzftzt7ZPSgoPqBo+SlHs4LxXORhCBc5NirQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NBeUM7WiE4sCyhqcQYwbLwlVwlvpL3SZChWzyzAg24lT+7lvOM/4cyh+ynABegLV5FR7PwPgvtOmxkSleDTAWT28NVjOKBcBdKatEHjzM1zOQoRzsZAdWrSCsyNl0Lt4dC+6roQP6dha/UHgOJs/k8pql322sYrVQ2ImezoMfto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XpYKVMOU; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XpYKVMOU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761708582; x=1793244582;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=potTdtxKzftzt7ZPSgoPqBo+SlHs4LxXORhCBc5NirQ=;
  b=XpYKVMOUe0vNmCkNakfY2237jNKvLXWe93ktmrpukMYagMvLoSWe5/rf
   QMxmCrijwqUmfw4mK1hWZR2Zz7YtXuIJeFx0dGPZiPwJw+5XVq4uqLe1Z
   nSgbg+OYmu49JB3W1aSXtPSXC3BuiL9UYHf9GjNUtNpm3KlvU2H58E1zY
   VgCeKuEcFrJ1AJYGLztKED9FZ6bIQoc65DvvWOK+QZDMapqHai/ImpxU3
   mrSEgxIV/aAAJAq6dxMBzPEXmQ07T+s1a6pzhj1EwZL+/3cfmoeSGH1BG
   9Og3tI2rCDouXnzVqsh0lQ77FuNnEKa3cwqhiCpL+w3J/9FzI5fjcmdYm
   A==;
X-CSE-ConnectionGUID: H4BRnFTfQUCfQMnopILhIw==
X-CSE-MsgGUID: +Q8on96VT4SulRjySuo4qg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63521965"
X-IronPort-AV: E=Sophos;i="6.19,262,1754982000"; 
   d="scan'208";a="63521965"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 20:29:41 -0700
X-CSE-ConnectionGUID: 7EvhiZGwQxGSmHNizuZH6g==
X-CSE-MsgGUID: gSTd0xLRQYCUNxVDrP7E0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,262,1754982000"; 
   d="scan'208";a="189591837"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.56])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 20:29:41 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	Marc Herbert <marc.herbert@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v2] ndctl/test: fully reset nfit_test in pmem-ns unit test
Date: Tue, 28 Oct 2025 20:29:35 -0700
Message-ID: <20251029032937.1211857-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pmem_ns unit test is designed to fallback to using the nfit_test
bus resource when an ACPI resource is not available. That fallback is
not as solid as it could be, causing intermittent failures of the unit
test.

That nfit_test fallback fails with errors such as:
path: /sys/devices/platform/nfit_test.0/ndbus2/region7/namespace7.0/uuid
libndctl: write_attr: failed to open /sys/devices/platform/nfit_test.0/ndbus2/region7/namespace7.0/uuid: No such file or directory
/root/ndctl/build/test/pmem-ns: failed to create PMEM namespace

This occurs because calling ndctl_test_init() with a NULL context
only unloads and reloads the nfit_test module, but does not invalidate
and reinitialize the libndctl context or its sysfs view from previous
runs. The resulting stale state prevents the test from creating a new
namespace cleanly.

Replace the NULL context parameter when calling ndctl_test_init()
with the available ndctl_ctx to ensure pmem_ns can find usable PMEM
regions.

Add more debug messaging to describe why the nfit_test fallback path
is taken, ie NULL bus or NULL region.


Reported-by: Marc Herbert <marc.herbert@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Marc Herbert <marc.herbert@intel.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v2:
- Clarify which ACPI resource was not found, bus or region (MarcH)
- Update commit message and log
- Remove Closes tag (MarcH)


 test/pmem_namespaces.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 4bafff5164c8..6411e58ed5fd 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -178,20 +178,24 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
 
 	ndctl_set_log_priority(ctx, log_level);
 
+	/* Try to use ACPI resource first, then nfit_test */
 	bus = ndctl_bus_get_by_provider(ctx, "ACPI.NFIT");
-	if (bus) {
-		/* skip this bus if no label-enabled PMEM regions */
+	if (bus)
 		ndctl_region_foreach(bus, region)
 			if (ndctl_region_get_nstype(region)
 					== ND_DEVICE_NAMESPACE_PMEM)
 				break;
-		if (!region)
-			bus = NULL;
+
+	if (!bus)
+		fprintf(stderr, "ACPI.NFIT: bus not found\n");
+	else if (!region) {
+		fprintf(stderr, "ACPI.NFIT: no PMEM region found\n");
+		bus = NULL;
 	}
 
 	if (!bus) {
 		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
-		rc = ndctl_test_init(&kmod_ctx, &mod, NULL, log_level, test);
+		rc = ndctl_test_init(&kmod_ctx, &mod, ctx, log_level, test);
 		ndctl_invalidate(ctx);
 		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
 		if (rc < 0 || !bus) {
-- 
2.37.3

