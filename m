Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737EB1DED7B
	for <nvdimm@lists.linux.dev>; Sun,  9 Feb 2025 18:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739124236; cv=none; b=NCdpyhd2TWXTkUQ2y+VGjyr79NIZqGlZfdIjsx6n6z7VKuSL511xRovN/QtVYLmh3kNu5T8ly+cNOZN3U7LQrThaKfPwXsNON5bkLRCXjuYU3Wd88jwiHU6Fro6gZ/mDDuABcGPqddffW9oj+uvjBqrODkLhIO0vFsxEwTyVCyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739124236; c=relaxed/simple;
	bh=k/wPYoXVmXxE9VVdoJBka2YSyjoQRHtWu9m0kOccbv0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EILnPd6oTC11UPq+OXRuKVyzfNZaqom2YGkcR3InRUFXR9BW04MeWOsNUB1lUcgTRkKiN5FFtvNP/rARsLQA34AOdFrj6D4HzfXGlWnXjcoSEcJQkQn2W9vL+KlE9CZAgbLZiBW3h+b174YlayoDbq9BMLnVxfSWjMSgw9ZB4J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JMdlb2Xu; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JMdlb2Xu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739124234; x=1770660234;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=k/wPYoXVmXxE9VVdoJBka2YSyjoQRHtWu9m0kOccbv0=;
  b=JMdlb2XuSbT4oz82JppUThJJIpMSha969EzvQGSOokYs1+AewRcBgc3T
   A0j8HFuWK0wwC939PSL2d1GdughapBcOG2UmafbTpkQ2WIM4Uk+3xsqy1
   euDsnB3SGbJK0lNSY8glnSlI/U7wrukJtQC2/LZfPZw6l7lxGeA9dNOsu
   kUGAMiq3lNiqaNjH62qAFB7S00MSWWEMMv9WZPLKc/lRVvhThT3HxvOYj
   6uTXppo/d/538k7KYtnDs1uO+3Zxz7Hwqh3feKCZoaZVa1ObNJqdLcVXA
   fld3rWsJKYFMBckWvh5KhzNCfLmxHLc0peC/E3p5kCoacAWe2jZbrBYGI
   g==;
X-CSE-ConnectionGUID: lle22bdRQo2qloQ/TMk7pQ==
X-CSE-MsgGUID: Z/Piy1f5SECsmN3T2k//kQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11340"; a="50344996"
X-IronPort-AV: E=Sophos;i="6.13,272,1732608000"; 
   d="scan'208";a="50344996"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2025 10:03:52 -0800
X-CSE-ConnectionGUID: YqO9hTyNSIaySJJiDts+sA==
X-CSE-MsgGUID: lNdly5qdS82uFAUM5XBEJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,272,1732608000"; 
   d="scan'208";a="111754743"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.111.149])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2025 10:03:52 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Michal Suchanek <msuchanek@suse.de>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] cxl/json: remove prefix from tracefs.h #include
Date: Sun,  9 Feb 2025 10:03:46 -0800
Message-ID: <20250209180348.1773179-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Michal Suchanek <msuchanek@suse.de>

Distros vary on whether tracefs.h is placed in {prefix}/libtracefs/
or {prefix}/tracefs/. Since the library ships with pkgconfig info
to determine the exact include path the #include statement can drop
the tracefs/ prefix.

This was previously found and fixed elsewhere:
a59866328ec5 ("cxl/monitor: fix include paths for tracefs and traceevent")
but was introduced anew with cxl media-error support in ndctl v80.

Reposted here from github pull request:
https://github.com/pmem/ndctl/pull/268/

[ alison: commit msg and log edits ]

Fixes: 9873123fce03 ("cxl/list: collect and parse media_error records")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/json.c b/cxl/json.c
index 5066d3bed13f..e65bd803b706 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -9,7 +9,7 @@
 #include <json-c/json.h>
 #include <json-c/printbuf.h>
 #include <ccan/short_types/short_types.h>
-#include <tracefs/tracefs.h>
+#include <tracefs.h>
 
 #include "filter.h"
 #include "json.h"

base-commit: 04815e5f8b87e02a4fb5a61aeebaa5cad25a15c3
-- 
2.37.3

