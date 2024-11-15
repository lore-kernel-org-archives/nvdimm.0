Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA6A126C10
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 18:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696047; cv=none; b=J0WgQfMHzNKXfMHQ05b3nCY3KdQwjkbDY0rMxEP23z+OnoSP0V7YEOotK30FS1zdsFLsTRa1VLh4jk+quUXhfLNZjZHwmkmC4i0l4PBW8/rFv4du8VyN9c/CjriIfT4uMhzwET9pM8+QykjRv7820pINFJo/hD8oMHOXN7go8wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696047; c=relaxed/simple;
	bh=KOdBTSSlKJayfoJokrPlQixtP5idfKnFGrRtM87MPqw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=qiqY19ihzBl9AxIYfXYUtHTEl/cbM/2vUaYwNOuCmbByzWgoQ8W+acSSjHAgzWZsH0IdnB3TQrHWYmPij4QluuELnMUDyUSvugDtrQ7OCKMoCXO5iBH1gQsBx0vfs70c+7NygQxwk9IHWcGSXDtqFHNItann4SKMweKp9Vp63YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XqZR4oiJ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XqZR4oiJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731696044; x=1763232044;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=KOdBTSSlKJayfoJokrPlQixtP5idfKnFGrRtM87MPqw=;
  b=XqZR4oiJxvvbXbRAFyMWDlJrGvPIR4bhOXncVjyOp6+vEzk4qPrBvlhE
   k2tHitP5JuOUFN/W0dkYQ08ZrI/FapPR2i5DyUrNZL9D3K+LvmUOza3uy
   GUnb/5hOjvkqcfO4sEYgo8Y5z7/7d/ISf/n1sGmpihkuTJK9wJIy/QhiA
   +NuhFohlrhao1/AplicblFC9SvvTlx7BiUhV0UqF8Aw+AyuP2NsTa7N+u
   6BFvTMSXiEwxcxvfHk1CYzRRNYxM6bvn1uB7qhlOxb8DhHriiDTFipj1L
   0iAzuWJ0HRnF9QngtsRaSZxcOmIlfMVPYzOYTYWhFxt+PL5eiSSxy1MYf
   w==;
X-CSE-ConnectionGUID: AzD583eKQzSm9rGZnsmemw==
X-CSE-MsgGUID: SzHZ9vFiSDezhLJEqcqZug==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="31127878"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="31127878"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:40:36 -0800
X-CSE-ConnectionGUID: uCU5tQJnTWWZKOpkcmdOtA==
X-CSE-MsgGUID: 3kyO7Io3TGm3etrgc8kQmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="88522602"
Received: from ehanks-mobl1.amr.corp.intel.com (HELO localhost) ([10.125.108.112])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:40:36 -0800
From: Ira Weiny <ira.weiny@intel.com>
Subject: [ndctl PATCH v3 0/9] ndctl: Dynamic Capacity additions for cxl-cli
Date: Fri, 15 Nov 2024 12:40:33 -0600
Message-Id: <20241115-dcd-region2-v3-0-326cd4e34dcd@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKGVN2cC/22MQQ6CMBBFr0Jmbc10qAKuvIdxQekAkyiYljQaw
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731696034; l=3238;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=KOdBTSSlKJayfoJokrPlQixtP5idfKnFGrRtM87MPqw=;
 b=X3E/L9AZgjJAVoUSGxGg+SPimq14rMVQwVT0RaR7pbNinFOt+x46e/jW/P8xPatufa3rR/pRz
 6B41ghTU6qOCJ7WdQy4urFa3PD8nVhmEQBMwZbUgk5hXj+B1lufM1z3
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

