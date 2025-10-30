Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FBE1F63FF
	for <nvdimm@lists.linux.dev>; Thu, 30 Oct 2025 00:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761784947; cv=none; b=ZpC9h5+wXrZWJVdPmGu0bQrhQhbiZVHOs6kRpaBfysoN5DEZaxnHr+TpE3U258cFzWegqvXZcDWvJdR8kiJHM4evRilQ+FpiA2DGpXHckPXNTdGMPYrEH5VAN56QYdiLP25a2yGKq/IroIi4RwfiEq48xuO81ChEBT3ve68fQt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761784947; c=relaxed/simple;
	bh=WqLbkS2L2A72MkRIWAP9Cf0KEfzLcYVlvhMlsvEh82A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dKUNI5zch5qAN0fI/H+W9m+dN6Uf9XMFNoPLJuE5H3w/rezjJI8f4qP1OD48XyC9n7MIhiLn6DlBMNR4XQB/SCBEaF450xwwcJTqdKiVqFDfia5MdcUpptrAX0rjETp3W4IpFLXtYnKVhz4sxwq24bGL3MDaUT+J4HLFZ75/v24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KsCcZ2yy; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KsCcZ2yy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761784946; x=1793320946;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WqLbkS2L2A72MkRIWAP9Cf0KEfzLcYVlvhMlsvEh82A=;
  b=KsCcZ2yyHjUuZ52Mlo125ApbIarIkE3XrgppwsOBlF+L3lR7GOg91Mb2
   YSOtaD3/ree7TSOHntITHd2dA69Or3P6uosPeCXRH4Nx0dn6isvK7Qw4Q
   h5YDyYMpyNHe6xB7Rv0JZ2DXpUvLaPZ5KS0fkrb07ZvJy4OGHsG8ZtF7A
   M9OCtFSxEU+YkqhfEMhp7Epnu0U2gijDFTgSMoM3xEAt2/4RHVeZ/vm9Z
   DSLsvNgupEhABCDTUi0hi7nbO13MTRz9jZE7ffGGnvmeiQQKVkq8p7x6Q
   OWafgUgJk6yTd7vBUNaZxWZJb5ng4JGdQxGgAnWuvtjvCdA3uI+rK5VU8
   g==;
X-CSE-ConnectionGUID: juz3OPm2TJOB1zeY4gYsbw==
X-CSE-MsgGUID: L2aFVfr4SF6OfimMEVsSVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="89387773"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="89387773"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 17:42:26 -0700
X-CSE-ConnectionGUID: fAfK9XMqQ/yUvTK3gSB+Dg==
X-CSE-MsgGUID: wf049fDOT7mMo1taJu+yew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="185007590"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.174])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 17:42:25 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH] tools/testing/nvdimm: Stop read past end of global handle array
Date: Wed, 29 Oct 2025 17:42:20 -0700
Message-ID: <20251030004222.1245986-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KASAN reports a global-out-of-bounds access when running these nfit
tests: clear.sh, pmem-errors, pfn-meta-errors.sh, btt-errors.sh,
daxdev-errors.sh, and inject-error.sh.

[] BUG: KASAN: global-out-of-bounds in nfit_test_ctl+0x769f/0x7840 [nfit_test]
[] Read of size 4 at addr ffffffffc03ea01c by task ndctl/1215
[] The buggy address belongs to the variable:
[] handle+0x1c/0x1df4 [nfit_test]

The nfit_test mock platform defines a static table of 7 NFIT DIMM
handles, but nfit_test.0 builds 8 mock DIMMs total (5 DCR + 3 PM).
When the final DIMM (id == 7) is selected, this code:
    spa->devices[0].nfit_device_handle = handle[nvdimm->id];
indexes past the end of the 7-entry table, triggering KASAN.

Fix this by adding an eighth entry to the handle[] table and a
defensive bounds check so the test fails cleanly instead of
dereferencing out-of-bounds memory.

To generate a unique handle, the new entry sets the 'imc' field rather
than the 'chan' field. This matches the pattern of earlier entries
and avoids introducing a non-zero 'chan' which is never used in the
table. Computing the new handle shows no collision.

Notes from spelunkering for a Fixes Tag:

Commit 209851649dc4 ("acpi: nfit: Add support for hot-add") increased
the mock DIMMs to eight yet kept the handle[] array at seven.

Commit 10246dc84dfc ("acpi nfit: nfit_test supports translate SPA")
began using the last mock DIMM, triggering the KASAN.

Commit af31b04b67f4 ("tools/testing/nvdimm: Fix the array size for
dimm devices.") addressed a related KASAN warning but not the actual
handle array length.

Fixes: 209851649dc4 ("acpi: nfit: Add support for hot-add")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 tools/testing/nvdimm/test/nfit.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index cfd4378e2129..cdbf9e8ee80a 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -129,6 +129,7 @@ static u32 handle[] = {
 	[4] = NFIT_DIMM_HANDLE(0, 1, 0, 0, 0),
 	[5] = NFIT_DIMM_HANDLE(1, 0, 0, 0, 0),
 	[6] = NFIT_DIMM_HANDLE(1, 0, 0, 0, 1),
+	[7] = NFIT_DIMM_HANDLE(1, 0, 1, 0, 1),
 };
 
 static unsigned long dimm_fail_cmd_flags[ARRAY_SIZE(handle)];
@@ -688,6 +689,13 @@ static int nfit_test_search_spa(struct nvdimm_bus *bus,
 	nd_mapping = &nd_region->mapping[nd_region->ndr_mappings - 1];
 	nvdimm = nd_mapping->nvdimm;
 
+	if (WARN_ON_ONCE(nvdimm->id >= ARRAY_SIZE(handle))) {
+		dev_err(&bus->dev,
+			"invalid nvdimm->id %u >= handle array size %zu\n",
+			nvdimm->id, ARRAY_SIZE(handle));
+		return -EINVAL;
+	}
+
 	spa->devices[0].nfit_device_handle = handle[nvdimm->id];
 	spa->num_nvdimms = 1;
 	spa->devices[0].dpa = dpa;

base-commit: 211ddde0823f1442e4ad052a2f30f050145ccada
-- 
2.37.3

