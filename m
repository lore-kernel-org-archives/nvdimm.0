Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E83442C
	for <nvdimm@lists.linux.dev>; Sun, 15 Dec 2024 02:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734231515; cv=none; b=eym/RdgbU4ZVYIrTJVPidQkmIpuaF7btnOzTXQyr6sSBPRJkgvpQ2yBTquhCTt7OBgpJsrCa/aLdVjH3ZY7D/hBjdaxbx0gSM8EfU++DbkuY0RPfrf7C2PYsdvDPXpMidfPugvM8b4hAKh9wT4a7IyAM5T9qrT04lpr2EC5Jb+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734231515; c=relaxed/simple;
	bh=cIHzad8pydsLvYg7kJWXruofQ0n0BNs+StpTV4rXUgE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=qK3DcOCdiChTzPsO+m5BX10Pawi5dXact8LoKw/3SuUIn5jYvigTIBTLzeQDm7CMJIFsJTMojnBnxyJw7O/M9pIh6LNhsxee8A4m3DDI4h0tXyM0yu3qMfap7imbIZaKRy4cATQ4T0iT869uMvZfpJNUjvKcJLHJqb5lh6ar/XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CSry3kCi; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CSry3kCi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734231513; x=1765767513;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=cIHzad8pydsLvYg7kJWXruofQ0n0BNs+StpTV4rXUgE=;
  b=CSry3kCieryZsUTOLqLo+vAp7NHW9kpz5MCi/5saiTKtocXNA9wtwdaC
   7UGkR4tbBQZzjqNx3A7sDIbPp0q171oMLxzhnnVClw7eRA7N/2XfvR3HW
   jFkEdeyLWblQYkKUW9F5ylYVHwAyoxqZqw6eiIdeGu31PBWgIWtEMK9jr
   fLqq+ei4MyYJzNyA59vM34k3WnaMasBlRNpLAGF1dJPNN5iMxV4BM+h+Q
   Cwc2tY9Yildvrcn/daMu/1+TIOS+f83nUHhEMiWdhSN5YxYppeoqVnFlv
   uxm1mRDAaXK2Cc+cqWjJ8CvmNDum3XIj0I8s0hoRC8mP9zIbtOVMkn2Uc
   g==;
X-CSE-ConnectionGUID: /X/M+/bbTHyEEYwCG7Ud+A==
X-CSE-MsgGUID: Jd6gts9ZSL2tkDkD3NUErQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11286"; a="52166933"
X-IronPort-AV: E=Sophos;i="6.12,235,1728975600"; 
   d="scan'208";a="52166933"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:32 -0800
X-CSE-ConnectionGUID: PYOJXIKlTQm7k2iXuSl/mg==
X-CSE-MsgGUID: Rd1GPDglTQGXtMYqsnECcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="97309304"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.111.42])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:31 -0800
From: Ira Weiny <ira.weiny@intel.com>
Subject: [ndctl PATCH v4 0/9] ndctl: Dynamic Capacity additions for cxl-cli
Date: Sat, 14 Dec 2024 20:58:27 -0600
Message-Id: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANNFXmcC/23MQQ6CMBCF4auQrq2ZlqlUV97DuKDtAE0UTEsaD
 eHuFjaKcfkm8/0TixQ8RXYqJhYo+eiHPg/cFcx2dd8S9y5vJkGigBK4s44HavOb5NKBwCMZTY1
 jWTwCNf651i7XvDsfxyG81ngSy/V/JwkOHPAAYGppUNPZ9yPd9na4s6WT5McKwK2V2RoCVRmsj
 kTm15ZfVqitLbNVWjnUYK2rN3ae5zdGn/QiHgEAAA==
X-Change-ID: 20241030-dcd-region2-2d0149eb8efd
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Sushant1 Kumar <sushant1.kumar@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734231510; l=2544;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=cIHzad8pydsLvYg7kJWXruofQ0n0BNs+StpTV4rXUgE=;
 b=xFqjDdebhT2u7x/Vuu8t1xiK+k4AT21f/hdTBRJ4CyKRya2d9YaBAtC7vqzik9TQV67oi1bIx
 Dha5zL5Q4XKCmG2FiwmXGPXs8vLbnFfQx9i3v2wM/lnjTP1HJeKIEHk
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Further testing showed some bugs in the 'jq' command use in cxl-test.
Fix those bugs and adjust test to work around false positive lockdep
splats.

This series can be found here:

	https://github.com/weiny2/ndctl/tree/dcd-region2-2024-12-10

CXL Dynamic Capacity Device (DCD) support is close to landing in the
upstream kernel.  cxl-cli requires modifications to interact with those
devices.  This includes creating and operating on DCD regions.
cxl-testing allows for quick regression testing as well as helping to
design the cxl-cli interfaces.

Add preliminary patches with some fixes.  Update libcxl, cxl-cli and
cxl-test with DCD support.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Changes in v4:
- iweiny: Fix dax device checks in cxl-test
- iweiny: Update some documentation
- Link to v3: https://patch.msgid.link/20241115-dcd-region2-v3-0-585d480ccdab@intel.com

---
Ira Weiny (9):
      ndctl/cxl-events: Don't fail test until event counts are reported
      ndctl/cxl/region: Report max size for region creation
      libcxl: Separate region mode from decoder mode
      cxl/region: Use new region mode in cxl-cli
      libcxl: Add Dynamic Capacity region support
      cxl/region: Add cxl-cli support for DCD regions
      libcxl: Add extent functionality to DC regions
      cxl/region: Add extent output to region query
      cxl/test: Add Dynamic Capacity tests

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

