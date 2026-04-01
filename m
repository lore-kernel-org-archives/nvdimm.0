Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE07D204F8B
	for <nvdimm@lists.linux.dev>; Wed,  1 Apr 2026 04:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775018997; cv=none; b=pD4gGcrk2iE9HGWtqroKJBFrgUUPk/GcpeWQK5HnS/OzORlXMyB0U1ZWg1FPhEZDM0lvZEZ0xUUwKeB1sC2tRczuX9KZxlk3aaVbxG5wO0JWY9NJsapkuoGq0iMfl27KiCEwrq5i+p70kHMAID+OUZbralhVTC7pQtngXZbNM4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775018997; c=relaxed/simple;
	bh=RyjD+RQ1xgwTZznj6S50NGFuTPrSXU7ewOb4Q4iiZuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KU9yEn2ECZVc+f+7FfkEF7M5NUxwNQTll6R76ZNb079odNmAXPNh7NEUCeqwX7ySYIlQGW/RYP1utX9+Clda7xyzhyP6eFQ8zABCTF2AJcmtcl6cQt5vyEhXxGLJ3QCvExF3OorWI0Z/rR9uACKL3fLUxPpCyAWXcYQSHmxAoYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C5LmVlU/; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C5LmVlU/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775018996; x=1806554996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RyjD+RQ1xgwTZznj6S50NGFuTPrSXU7ewOb4Q4iiZuk=;
  b=C5LmVlU/FbMtJGRcqUPw8TASQ/5p6FCfX1OGPeXHmT4fkwn9H3UX3uI0
   A3J2nCBDm5DEhCoH/doRnIQAcfveXkfiJowdUw5KlQgLTQjOWGBqwhG/A
   f3DwIyejPvnVpuFFUwr2+o7HsUhoqreEwSMk8IfSbrWi5cozVu+qM4SGY
   /UKFAooE9nhg7F04KrEyBudzobdtKecyYjXrmq9yTvxa0KoVcBMctgxgJ
   PhfEu57K5xVdJ9eC+R53IOb6m88WJb1ga4Q00oUjn2V5X89aNY8XiVqtp
   NEY4xUjbVxu4ccbSkMI/c+N6HiKHpfEfu4nu6WA+ddyhta2eyKtw+LFNY
   w==;
X-CSE-ConnectionGUID: TTDCs3sISfi2zTlLGPDnmQ==
X-CSE-MsgGUID: vJ5xiVyOShGq8rXyi+Jq0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="75218256"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="75218256"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 21:49:55 -0700
X-CSE-ConnectionGUID: yyw06A2bTlmC16Dpxs50SQ==
X-CSE-MsgGUID: YBQ2O+TfTEO8Xz/auNYOPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="249781868"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.4])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 21:49:55 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 3/3] test/mmap.sh: reduce fallocate size from 1GiB to 256MiB
Date: Tue, 31 Mar 2026 21:49:47 -0700
Message-ID: <f2ab6877b5895a95e2f7eccaa452ab29e6bc3b9c.1775018517.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <09ef1cacb6dcb0accae1756561b0f761a764aaba.1775018517.git.alison.schofield@intel.com>
References: <09ef1cacb6dcb0accae1756561b0f761a764aaba.1775018517.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mmap test allocates a 1 GiB file and exercises a matrix of mmap
flag combinations across ext4+dax and xfs+dax, performing multiple
full-range read and write passes for each case.

The coverage of this test comes from the mmap modes and access
patterns it exercises (MAP_SHARED vs MAP_PRIVATE, MAP_POPULATE,
mlock/munlock, and read-only mappings), not from the size of the
mapping itself. These behaviors are not size-dependent, and no test
assertions rely on a 1 GiB mapping.

Long CI runtimes prompted a closer look at this test, but the
reduction stands on its own merits: a 256 MiB mapping still spans many
PMD (2 MiB) DAX mappings and exercises the same access patterns, while
avoiding unnecessary work in each test case.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/mmap.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/mmap.sh b/test/mmap.sh
index 7d0053da0e1a..c517d5b0f50b 100755
--- a/test/mmap.sh
+++ b/test/mmap.sh
@@ -59,12 +59,12 @@ rc=1
 
 mkfs.ext4 $DEV
 mount $DEV $MNT -o dax
-fallocate -l 1GiB $MNT/$FILE
+fallocate -l 256MiB $MNT/$FILE
 test_mmap
 umount $MNT
 
 mkfs.xfs -f $DEV -m reflink=0
 mount $DEV $MNT -o dax
-fallocate -l 1GiB $MNT/$FILE
+fallocate -l 256MiB $MNT/$FILE
 test_mmap
 umount $MNT
-- 
2.37.3

