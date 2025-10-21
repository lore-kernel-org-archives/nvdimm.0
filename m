Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF912777FC
	for <nvdimm@lists.linux.dev>; Tue, 21 Oct 2025 21:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761082014; cv=none; b=dgIj6XzbtWYdCB4QyPTX+/oepTEPD9vaJL7VwiaaeWpjUr9niXUkg7h1c1zeUC/+/MF6o9CLfP3XlEx6lLwIDRXFxzufHEC1447WPdO/ilR2xQlycbAgzfhmxTSVP68RIRgdKw2XL7rUBo9ahMq38PX3Ddfgmk2U4CQ9XUjqB0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761082014; c=relaxed/simple;
	bh=0BowYaPEIEU8yOv+/qbGLkbfyD8VugtUAXKrdEbIdXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YqUb7UuCQK+wWfz7IL6jnntZ5GhGnGHmxoU2VOu5S6h5UCibqKv9qjJgO11DFF6V3hRu2I6pOpLjl03RRm/hJVJ4mf1sfvVvMD71YKLSivQAZoc09FRZmvHFSWSd8lG5+nQbkdcjFgiGJQi2nZc3FeIyeIZy3wfshd2bbYb1jmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WvH0tw5T; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WvH0tw5T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761082012; x=1792618012;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0BowYaPEIEU8yOv+/qbGLkbfyD8VugtUAXKrdEbIdXI=;
  b=WvH0tw5TaJbTxa5wTLuoNdZ1OV8rwvncKsV6tR/2jmGTs6KdM8xGGkPP
   yJGFzjJ6oBpW2DsNih3UcNHwu9TB/Vkz/qFG61YWbbf3JzwJ/NTe5smW9
   Df+fttf7XygXFsZ9LpAgnScHfs755TKaHVz9S2T1RIO98j0CvX+bAfSUN
   AOgWK7kPGV5vFHAW1ds/a40LWElIDCy0LJbKe7OJ+fStSDWUa07efeE0K
   JCybdeAjnDUZTioeTyYbGpGDXTvI4QpAYF3aE9OX2cqJD2vvkaSsVuuAY
   un8aac9twujBurxHKXANOiKLRPUj2j8afASEaQQbqIhBGFWCGEE+3DSHa
   A==;
X-CSE-ConnectionGUID: 6Er7Ma5HTQedC22gbuEV9g==
X-CSE-MsgGUID: 8FCkXc9/SZSUqtZ4hjugOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="67056461"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="67056461"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 14:26:52 -0700
X-CSE-ConnectionGUID: LvFzLvq1T8CVPF8hZlNSng==
X-CSE-MsgGUID: 6uS9j46LQHGwGaPDmH0RFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="183725742"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.17])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 14:26:50 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	Marc Herbert <marc.herbert@intel.com>
Subject: [ndctl PATCH] ndctl/test: fully reset nfit_test in pmem_ns unit test
Date: Tue, 21 Oct 2025 14:26:46 -0700
Message-ID: <20251021212648.997901-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pmem_ns unit test frequently fails when run as part of the full
suite, yet passes when executed alone.

The test first looks for an ACPI.NFIT bus with a usable region, and if
none is found, falls back to using the nfit_test bus. However, that
fallback consistently fails with errors such as:

path: /sys/devices/platform/nfit_test.0/ndbus2/region7/namespace7.0/uuid
libndctl: write_attr: failed to open /sys/devices/platform/nfit_test.0/ndbus2/region7/namespace7.0/uuid: No such file or directory
/root/ndctl/build/test/pmem-ns: failed to create PMEM namespace

This occurs because calling ndctl_test_init() with a NULL context only
unloads and reloads the nfit_test module, but does not invalidate and
reinitialize the libndctl context or sysfs view from previous runs.
The resulting stale state prevents the pmem_ns test from creating a
new namespace cleanly.

Replace the NULL context parameter when calling ndctl_test_init()
with the available ndctl_ctx to ensure pmem_ns can find usable PMEM
regions.

Reported-by: Marc Herbert <marc.herbert@intel.com>
Closes: https://github.com/pmem/ndctl/issues/290
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/pmem_namespaces.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 4bafff5164c8..7b8de9dcb61d 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -191,7 +191,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
 
 	if (!bus) {
 		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
-		rc = ndctl_test_init(&kmod_ctx, &mod, NULL, log_level, test);
+		rc = ndctl_test_init(&kmod_ctx, &mod, ctx, log_level, test);
 		ndctl_invalidate(ctx);
 		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
 		if (rc < 0 || !bus) {
-- 
2.37.3

