Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7972C190
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 02:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730772665; cv=none; b=K/A/wLWxnNXmJibKEwPufR4cLGhuPlV+Nhe0Pd0DQzzW69SBDiCXu4OY/sz2cZ7zWOiIA2sV+O6alOiy5Ug30j1JufP/PDojGp+quIKyqKVlH4g0tIEQMGixvauxxFHqnip90BBoG2qUuykB24+8ZawlBSxbAqWc1myav+0aJno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730772665; c=relaxed/simple;
	bh=hnLd9uKNGg/dfC1e0X7dAhxFr6tFoWMyfF0hmMRbnCs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=gWSxTchufr8ongpaKmVKNXxtC9RKKEkTDDFOskdvRgSErtODXuKta58whbStkF6GRhZjpmpvd6B98dmAUdmtSqeCDiaCWZHvTtCCbQJ5ekI75Fi/JJDV8+sU5zUkQz7I6ydlHpFIncMU4cjm5jVKHbvJWbuG1XPYT2jjIvRqtOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F9qTzFiK; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F9qTzFiK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730772664; x=1762308664;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=hnLd9uKNGg/dfC1e0X7dAhxFr6tFoWMyfF0hmMRbnCs=;
  b=F9qTzFiK9hpRwEsnLEaDwSWdD0kkHm2g/HA0xiD8qWTEwq/DEiBybWM8
   hTdZsZ6BwboaZF68QQpONWOj1kcfUswF8REt1CjN7qpxxl66vHC+SaKIs
   FUwfmtXKCELxPraFSyK6UdnxGf7ig2aLEFnBoJQlOKXAv0LFuRLiKpWwa
   0fkVv+HsQi93TiMK9SxU27K/x4S6IvDbc7kcpNyqsylZChEkuR0XXU4LO
   4n2WrCU2nUVkPQuGtPyvEUiXaJ3VsbKgUGVVYOYHla0OfzVjbyeV3JT9C
   9JNabGWNyKlInVtXYBE6AThe8e0C2xZ0W/1o74fDu0pQUuvYZRPSQCR9q
   Q==;
X-CSE-ConnectionGUID: rx1SogjjSqakzAdIrczmJw==
X-CSE-MsgGUID: 5etpdOzfQX2dCFLIw4ARAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="33337317"
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="33337317"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:11:03 -0800
X-CSE-ConnectionGUID: m9z6R+ncSUqAgEgrUS55dA==
X-CSE-MsgGUID: 7wpk+J2+Sou+rteHNtuW7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="88596921"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.226])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:11:03 -0800
From: Ira Weiny <ira.weiny@intel.com>
Subject: [ndctl PATCH v2 0/6] ndctl: DCD additions
Date: Mon, 04 Nov 2024 20:10:44 -0600
Message-Id: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKR+KWcC/22MQQ7CIBBFr9LMWswwElNdeQ/TRYFpO4mCgYZoG
 u4udu3y/fz3NsichDNcuw0SF8kSQwM6dOCWMcysxDcGQjIaT6i88yrx3G6kyKM2F7Y9Tx6a8Uo
 8yXuv3YfGi+Q1ps8eL/q3/u8UrVChOSPakazp+SZh5cfRxScMtdYvP1EIL6YAAAA=
X-Change-ID: 20241030-dcd-region2-2d0149eb8efd
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>, Sushant1 Kumar <sushant1.kumar@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730772649; l=1950;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=hnLd9uKNGg/dfC1e0X7dAhxFr6tFoWMyfF0hmMRbnCs=;
 b=Hsi5gNn663y+Kw41vITrQ2qbUbSoDuidVzp/VzAQ3DH2L0ymYLU4QPEcRq9wL66OGjDDXhL5q
 bz1swtvRWY1Anvta+Pi/Lddy2EleRkOB2oXALEHJhEQvA7C7HGcVIJw
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

https://github.com/weiny2/ndctl/tree/dcd-region2-2024-11-03

CXL Dynamic Capacity Device (DCD) support is close to landing in the
upstream kernel.  cxl cli requires some modifications to best interact
with those devices.  This includes creating and viewing details of DCD
regions.  cxl-testing is also valuable in regression testing the kernel
interfaces.

Add preliminary patches with some fixes.  Update cxl cli with DCD
support and add cxl-testing.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Changes in v2:
- Fan: properly init index.
- Link to v1: https://patch.msgid.link/20241030-dcd-region2-v1-0-04600ba2b48e@intel.com

---
Ira Weiny (5):
      ndctl/cxl-events: Don't fail test until event counts are reported
      ndctl/cxl/region: Report max size for region creation
      ndctl: Separate region mode from decoder mode
      ndctl/cxl: Add extent output to region query
      ndctl/cxl/test: Add Dynamic Capacity tests

Navneet Singh (1):
      cxl/region: Add creation of Dynamic capacity regions

 Documentation/cxl/cxl-list.txt |   4 +
 cxl/filter.h                   |   3 +
 cxl/json.c                     |  79 ++++-
 cxl/json.h                     |   3 +
 cxl/lib/libcxl.c               | 248 +++++++++++++++-
 cxl/lib/libcxl.sym             |   9 +
 cxl/lib/private.h              |  19 +-
 cxl/libcxl.h                   |  99 ++++++-
 cxl/list.c                     |   3 +
 cxl/memdev.c                   |   7 +-
 cxl/region.c                   |  53 +++-
 test/cxl-dcd.sh                | 656 +++++++++++++++++++++++++++++++++++++++++
 test/cxl-events.sh             |   8 +-
 test/meson.build               |   2 +
 util/json.h                    |   1 +
 15 files changed, 1173 insertions(+), 21 deletions(-)
---
base-commit: 04815e5f8b87e02a4fb5a61aeebaa5cad25a15c3
change-id: 20241030-dcd-region2-2d0149eb8efd

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>

