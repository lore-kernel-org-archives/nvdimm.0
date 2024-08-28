Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52CF131BDD
	for <nvdimm@lists.linux.dev>; Wed, 28 Aug 2024 03:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724814861; cv=none; b=UbJ28m6peF3NGk69svHaYtAu7zPbz+tGKtifmYLlJMeHgunvFpu1usDv16KIcG4Xv3C+IJcA22eBy8Bl74tYocu4DOW6Pza9sQNT5m1uKqC7IfuGgr4QtQ2hlBN7HWl1T6SvQuDas270gDIte4a9tFW/Qw0TN5d3nr+pY/oicNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724814861; c=relaxed/simple;
	bh=1YC0DcpLKh3UqoWFLYJHhTbYFCzPEfdvDjHStTeZdCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIY1MRhJQc8cRDT5hGbwkjZmW3uIjYb74Al4+axz7ValtNEgRbJtAiCeMA3NZFudpFpORvxajdRlVDLhifelxiRH2XL88AUx8w+q6SW8t0PLDLN/6ZXwbasSy3c5XyhlmPz1zOTP4C7uSxS/fJurEVEdnZZzNufhfi8j7GtAqkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T3eokiv5; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T3eokiv5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724814859; x=1756350859;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1YC0DcpLKh3UqoWFLYJHhTbYFCzPEfdvDjHStTeZdCA=;
  b=T3eokiv5usk+udQLdFvN3t/s4zJfOoyQcQIpdvvpf5zrBAnglU/IFEKg
   HCN1Ppua1PHQ5objXxQjop757H0AB1LYG9hX4RO4GcXvoCsNbrOkq5rdg
   HLvCM8PgGoI2GNQ4lQHBbcCqZInPzQHTbROptNORKgjFUy45YgPb3r/UN
   iGTyC2XjCajt4YaA/lZjqhC61QT5Z6SGM9dyYkDXfm71SNmnf/EFu4qpe
   U3YB/j7tI4Dl5hNQRGNtlHKYdsgVG9f0m85Yb3IuWK17NlMEaBANq10ln
   iGVboiKBhBisYsM8PkVxuWoRHzSAbdaMTMtvzixxgzEKFIuA+lhaiyLRF
   g==;
X-CSE-ConnectionGUID: eBJ9kmGmRj2ziO4F54G6hQ==
X-CSE-MsgGUID: sLW+kLfpT4Sx/3Ix00+Bmg==
X-IronPort-AV: E=McAfee;i="6700,10204,11177"; a="23285728"
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="23285728"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 20:14:18 -0700
X-CSE-ConnectionGUID: fnq0qw7HR9SGxDUP4GGAoQ==
X-CSE-MsgGUID: 3DxqvrJOTKW7729mUFCO3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="63039282"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.111.50])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 20:14:18 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 1/2] test/daxctl-create.sh: use bash math syntax to find available size
Date: Tue, 27 Aug 2024 20:14:04 -0700
Message-ID: <865e28870eb8c072c2e368362a6d86fc4fb9cb61.1724813664.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1724813664.git.alison.schofield@intel.com>
References: <cover.1724813664.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The check for 1GB of available space in a DAX region always returned
true due to being wrapped inside a [[ ... ]] test, even when space
wasn't available. That caused set size to fail.

Update to use bash arithmetic evaluation instead.

This issue likely went unnoticed because users allocated >= 1GB of
efi_fake_mem. This fix is part of the transition to use CXL regions
in this test as efi_fake_mem support is being removed from the kernel.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/daxctl-create.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/daxctl-create.sh b/test/daxctl-create.sh
index c093cb9e306a..d968e7bedd82 100755
--- a/test/daxctl-create.sh
+++ b/test/daxctl-create.sh
@@ -363,7 +363,7 @@ daxctl_test6()
 
 	# Use 2M by default or 1G if supported
 	align=2097152
-	if [[ $((available >= 1073741824 )) ]]; then
+	if (( available >= 1073741824 )); then
 		align=1073741824
 		size=$align
 	fi
-- 
2.37.3

