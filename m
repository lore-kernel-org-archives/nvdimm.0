Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5850D18787A
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 18:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696386; cv=none; b=Q4x109Go7fIg2RHd4a6ByeFyiYXgEhs/9MCo3ySbZP43YQ3NMeQgw10Nxyi9kRryptNVWT6uywjcU8JxBEtZdzhygp5S+GYcbykfjMF/g5uarIqiger25iXmXRrkXo8mcepY+IGiBtKLpE2rcrnTVp9iedgfOewa8qLrGF0nFhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696386; c=relaxed/simple;
	bh=KOdBTSSlKJayfoJokrPlQixtP5idfKnFGrRtM87MPqw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=A69UzK8oXFVEfWTrnXZmIVsXpkZeOJhc04RQ+A4604es9kgMb2JzGJuH4G6RF2ksoTzXN2T2beDkMhe/9/C5h+O5FUufa53Uoh6fCFpovt6soQ7C0AFBMz1pTZFu46/yU9ItMnUNv1vjWFI4PVixCambNzZlQuAatPgxyndvENc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RqGfwkcK; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RqGfwkcK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731696386; x=1763232386;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=KOdBTSSlKJayfoJokrPlQixtP5idfKnFGrRtM87MPqw=;
  b=RqGfwkcKctr/J5FuH/lcsj9mxOAU4yH1P1TvThEXOB7NzXlUWuATtOV2
   HuRpUHZyiETO4eWEwbwv8fKT3/Dk3QuhuhklgNrSQmyzXze94CcCUFBGE
   QWHXrsKgBtKeDRBYkbEeWQyS74uGZIHuYIyHAARE+QWE3BPQDYgOvl+YE
   bMU5v90tPbFrrtD5fEIHaWwvf0zaXNkwMCdm1Py1KbB12iwG7UogwXjTO
   ameslAaL/iauZKSic6U+8JTAoalB6L/nqwV0gr6TcTM1itKDNlTQNILWV
   U+Y5SsYBL6UjsAghUuE3rufA9bFeIfZoO5k4de/QCgo9qPTYddX7vh7rN
   A==;
X-CSE-ConnectionGUID: D+1jjhPvT/CLumKMWugMbw==
X-CSE-MsgGUID: TKoYaMy3TKa4N0dSuGjeGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="42794863"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="42794863"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:46:25 -0800
X-CSE-ConnectionGUID: 1vtajrJBR5maBsrvdiGpLQ==
X-CSE-MsgGUID: FKkwX6X4R6KHWe+M0m2l9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="92715683"
Received: from ehanks-mobl1.amr.corp.intel.com (HELO localhost) ([10.125.108.112])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:46:23 -0800
From: Ira Weiny <ira.weiny@intel.com>
Subject: [ndctl PATCH v3 0/9] ndctl: Dynamic Capacity additions for cxl-cli
Date: Fri, 15 Nov 2024 12:46:18 -0600
Message-Id: <20241115-dcd-region2-v3-0-585d480ccdab@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPqWN2cC/22MQQ6CMBBFr0Jmbc10qAKuvIdxQekAkyiYljQaw
 t0tbNTE5fv5780Q2AsHOGUzeI4SZBwS5LsMmr4eOlbiEgMhGY05Ktc45blLN1LkUJuKbcmtg2Q
 8PLfy3GqXa+JewjT61xaPel3/d6JWqNAcEW1N1pR8lmHi274Z77B2In1cjebXpeRaxkNhTVEx2
 293WZY3cjWiZeIAAAA=
X-Change-ID: 20241030-dcd-region2-2d0149eb8efd
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>, Sushant1 Kumar <sushant1.kumar@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731696382; l=3238;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=KOdBTSSlKJayfoJokrPlQixtP5idfKnFGrRtM87MPqw=;
 b=tM9eSaxqsUAG6/QAYry6/dUUzTEmfAyB9hbRlikBllhSkW0pdcuHn7A2V0iV8SkccgedxbUFu
 CQmlO074mN2Dy5lMBz5mRnm4uMZ1jthJxYTXXYFFNiUnUdp/c6xkF68
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Feedback from v2 lead to the realization that cxl-cli required changes
to address the region mode vs decoder mode difference properly.

While v2 separated these modes they were not sufficiently separated in
the user interface of create-region.  This has been corrected in this
version.  Specifically a new option has been added to cxl create-region.
The option requires a decoder mode (DC partition) when the region type
is 'dc'.  The option is ignored, and can be omitted, for ram and pmem
regions.

Other libcxl API changes were made to simplify the interface a bit.

Documentation was added both at the libcxl and cxl-cli levels.

cxl-dcd.sh was cleaned up quite a bit an enhanced.

https://github.com/weiny2/ndctl/tree/dcd-region2-2024-11-15

CXL Dynamic Capacity Device (DCD) support is close to landing in the
upstream kernel.  cxl-cli requires modifications to interact with those
devices.  This includes creating and operating on DCD regions.
cxl-testing allows for quick regression testing as well as helping to
design the cxl-cli interfaces.

Add preliminary patches with some fixes.  Update libcxl, cxl-cli and
cxl-test with DCD support.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Major changes in v3:
- [djiang: rework test script for clarity]
- [Alison: split patches between libcxl changes and cli changes]
- [Alison: fix lib symbol versioning]
- [iweiny: clarify region vs decoder mode with API to specify the
  decoder mode]
- Link to v2: https://patch.msgid.link/20241104-dcd-region2-v2-0-be057b479eeb@intel.com

---
Ira Weiny (7):
      ndctl/cxl-events: Don't fail test until event counts are reported
      ndctl/cxl/region: Report max size for region creation
      libcxl: Separate region mode from decoder mode
      cxl/region: Use new region mode in cxl-cli
      libcxl: Add extent functionality to DC regions
      cxl/region: Add extent output to region query
      cxl/test: Add Dynamic Capacity tests

Navneet Singh (2):
      libcxl: Add Dynamic Capacity region support
      cxl/region: Add cxl-cli support for DCD regions

 Documentation/cxl/cxl-create-region.txt |  11 +-
 Documentation/cxl/cxl-list.txt          |  29 ++
 Documentation/cxl/lib/libcxl.txt        |  62 ++-
 cxl/filter.h                            |   3 +
 cxl/json.c                              |  80 ++-
 cxl/json.h                              |   3 +
 cxl/lib/libcxl.c                        | 261 +++++++++-
 cxl/lib/libcxl.sym                      |  13 +
 cxl/lib/private.h                       |  17 +-
 cxl/libcxl.h                            |  96 +++-
 cxl/list.c                              |   3 +
 cxl/memdev.c                            |   4 +-
 cxl/region.c                            |  93 +++-
 test/cxl-dcd.sh                         | 879 ++++++++++++++++++++++++++++++++
 test/cxl-events.sh                      |   8 +-
 test/meson.build                        |   2 +
 util/json.h                             |   1 +
 17 files changed, 1519 insertions(+), 46 deletions(-)
---
base-commit: 04815e5f8b87e02a4fb5a61aeebaa5cad25a15c3
change-id: 20241030-dcd-region2-2d0149eb8efd

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>

