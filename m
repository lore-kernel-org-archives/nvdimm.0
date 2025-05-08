Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0523183CCA
	for <nvdimm@lists.linux.dev>; Thu,  8 May 2025 18:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746729142; cv=none; b=oKIwNQf+wns8SbW4wMetHSn+RSm4nSa8dW0FTENxf+kEMrGzOC+z1zc1Z9vJEOn3xI7bfSUDQisy2IXOZITJL7rpL7EyweLPAwJRz9MGgR3URIlYd6XuI1mbUg5M4pYMnjZ7UFfy9ccKnWbTs4hhy+KmR/j7oFiHCoGcqEBrNo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746729142; c=relaxed/simple;
	bh=lAq8zuHaARzowCmPNTfqyE10F/pKIKw6rFPQyBkzGoA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i586oS3W5ROUIkq/AONBBEu7Pa1a3cwPaJ4U6sR8m/zggVksEeR5/ea8M2Lh3rUFUv+M/mZ4i9SktHjZ3sxExgoZJxQmErwMmapZ+tlEnE1zJakC0Oye6YZjQgV3pyJoXKSG22BmA9D6KmG1M38a3QFh2vSf5fU9xpMsfr2WAUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=igHTCAUK; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="igHTCAUK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746729141; x=1778265141;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lAq8zuHaARzowCmPNTfqyE10F/pKIKw6rFPQyBkzGoA=;
  b=igHTCAUKbDVxljmp32mtUgYG+95RZjK6Dz59F3EgO/Tm/01Hu2mLPa9l
   LK1phfZUo8t0By0k0AEb7yoii+mJMV16IXsGVcW18neN7HR96fIcuszMv
   iBZ1HEhetrL04VrgIovaee8kVG7Da7pBLRF63nhvSFhNKghctdfwKQsPR
   Bs7Ozi0TQEML2nY4lvoru5zwNpSrDnyX5m0Z3I+tIfEpSbwGbsebW4dtd
   MWYpT3AmrLctsAO0I91QQ8yvUk6yjmJVFl5JnvOHkwv32bxmWrAih8/GB
   harefRPNr5QjDttPsFxgAQYhyWyGwmXahrGVsI+ycS84Np4EjGK2iYA5G
   w==;
X-CSE-ConnectionGUID: Nr6NXO1JQQ6I8L8aRdi19Q==
X-CSE-MsgGUID: QQIo4JcaRZ+HD3KvadbFKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48614073"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48614073"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 11:32:20 -0700
X-CSE-ConnectionGUID: wQcuwihbTG+HV/abX4ReVQ==
X-CSE-MsgGUID: hJhNj//MT3qUZuFdWzG4Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141281420"
Received: from unknown (HELO hyperion.jf.intel.com) ([10.243.61.29])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 11:32:20 -0700
From: marc.herbert@linux.intel.com
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: Marc Herbert <marc.herbert@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v2] test: set the $CXL environment variable in meson.build
Date: Thu,  8 May 2025 18:31:42 +0000
Message-ID: <20250508183142.743047-1-marc.herbert@linux.intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Herbert <marc.herbert@linux.intel.com>

This fixes the ability to copy and paste the helpful meson output when a
test fails, in order to re-run a failing test directly outside meson and
from any current directory.

meson never had that problem because it always switches to a constant
directory before running the tests.

Fixes: ef85ab79e7a4 ("cxl/test: Add topology enumeration and hotplug test")

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
---
 test/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/meson.build b/test/meson.build
index d871e28e17ce..2fd7df5211dd 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -255,6 +255,7 @@ foreach t : tests
     env : [
       'NDCTL=@0@'.format(ndctl_tool.full_path()),
       'DAXCTL=@0@'.format(daxctl_tool.full_path()),
+      'CXL=@0@'.format(cxl_tool.full_path()),
       'TEST_PATH=@0@'.format(meson.current_build_dir()),
       'DATA_PATH=@0@'.format(meson.current_source_dir()),
     ],
-- 
2.49.0

