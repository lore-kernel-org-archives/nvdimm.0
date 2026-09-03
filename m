Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6627F393DF3
	for <nvdimm@lists.linux.dev>; Thu,  3 Sep 2026 21:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788471278; cv=none; b=K58JtQgyVKMAbRrlFfCEPZ8DvqCMuKzfGpzntbdaB7YTAAavIbO79ILZCReWcbe83KlO2kQ2pQP5Ui08S2wtO/hrZ4uYLmY30J1besRpELB0uN5osTbZjHGg+fkOYW6pkfsFU/gMxoChzP05xTKXBDM1rcqI0G5u8IaqVy0jwxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788471278; c=relaxed/simple;
	bh=pXg6tDzs/yIYtlmSo7jSZci613flJoW63eNAIK4mf4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JnEaAxjXOBzlFn2BEdPKKR01M7+jKQ85eJYf5mEzwUTPHczpD0m+7ciRjOeaDVu42gAh6P2gzxqhqsaFSg7jbc3yEJztjSuhcX1oZFbAi8m4s13vOaNvxBgViHpfoFAabc6vOpk2Ba8v9kBl9/q8wv6GWkhRKYN2gz7BB569lcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CqeodVrO; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CqeodVrO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788471274; x=1820007274;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pXg6tDzs/yIYtlmSo7jSZci613flJoW63eNAIK4mf4k=;
  b=CqeodVrOZdC7+/p5TlLiB0uFPMSK63FUITHHLnj8Oo98qGyUIIGmiyeH
   nlMB9v4TkvONaENwoMDX5fkLjHGd9jhXnWG0lsvgnfKTG+1KKwUuz1yMu
   3sMAVpfrm3IB9M7mIVx4yMdrMFmrPeqqs/fkiU9YKR7GwsQWThL4PiVTB
   iz8ekneybTWGoBWFjwBeESCPuLnelbb2ecIg52UgyK/y0hw6PWiWjhmGv
   SvOtgCZaCZ/GH5L1pDnBX3MqfvRozRKQrTNO+ZkhNS7HM4tfmj7Zk/5sd
   DdFeYWlTWr6r+0LAlzFQI73S9O9i7wNWEiurgMIM+lLORNLdIEEpX82nP
   A==;
X-CSE-ConnectionGUID: 5oAOwaioRXScs9wrGi3r8Q==
X-CSE-MsgGUID: d/upg8euQEGsMRAGuLB6+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="76523232"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="76523232"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 14:34:34 -0700
X-CSE-ConnectionGUID: LtHF4WYyTU+92vJDBETfmg==
X-CSE-MsgGUID: 3Y4JIcD4RnGCi1z8apTFhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="263657940"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.10])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 14:34:33 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2 0/3] cxl: support mixed-granularity regions
Date: Thu,  3 Sep 2026 14:34:15 -0700
Message-ID: <cover.1788469004.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an update to a series[1] that was previously sent out without a
cover letter. In v2 a fixup prerequisite patch is added and the tests
are expanded based on the kernel series review feedback [2].

[1] https://lore.kernel.org/all/fa5c109f08824180f58341ebd9055545a2ff3142.1780099216.git.alison.schofield@intel.com/
[2] https://lore.kernel.org/all/cover.1787255388.git.alison.schofield@intel.com/

Changes in v2:
Patch 1: cxl/region: round default region size within root decoder extent
- New patch to fixup the ALIGN_DOWN usage that doesn't always work
Patch 2: cxl/region: allow mixed-granularity regions
- Reject a granularity that is not power of 2
- Update man page -g section
Patch 3: test/cxl-region-mixed.sh: test mixed-granularity region creation
- Cover the third pmem window, a 3-way at 1KB across 3 HBs
- Add two test cases, a 6-way and 12-way, for more spec defined coverage
- Select endpoints by walking hierarchy instead of handbuilding lists per case
- Assert 2 switches below each HB and 2 EP below each switch
- Require negative test cases to fail at first target write
- Skip rather than fail when kernel has no registry
- Drop selector walk language to align with kernel language

The base commit is the current ndctl pending branch.

Alison Schofield (3):
  cxl/region: round default region size within root decoder extent
  cxl/region: allow mixed-granularity regions
  test/cxl-region-mixed.sh: test mixed-granularity region creation

 Documentation/cxl/cxl-create-region.txt |  21 +-
 cxl/region.c                            |  39 ++-
 test/cxl-region-mixed.sh                | 413 ++++++++++++++++++++++++
 test/meson.build                        |   2 +
 4 files changed, 462 insertions(+), 13 deletions(-)
 create mode 100644 test/cxl-region-mixed.sh


base-commit: ca9a1d69dc8894836999042ae6793fd7698b78fd
-- 
2.37.3

