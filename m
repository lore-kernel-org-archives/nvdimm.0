Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321281CFBC
	for <nvdimm@lists.linux.dev>; Thu, 15 May 2025 02:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747275529; cv=none; b=aAjZSOLuVFa9UvyOar0KOEKMhFoD7ERBehEuWremGypDUNbdDjxIR9fOA4frlUpWEgP8m+odTnp7hzj2R/Zrd8tkqQZptVy7JDwhC16DhU6Jm4ntQpQsGjSzFem6t45W9H4qoNr+UJrix/4pFJXbP1EDbS1NF74J3JXGjWxsNzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747275529; c=relaxed/simple;
	bh=wN5rDH56DrHhY+AkxZioAxFuoyv/HBhzURbdog7wjz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQvMsoZh/RDHhMekxWghOISZ1ULjRySlDpOpJ4at2ipneehJkGjnE/qeu3oHKbTvv/hgLfNgBQLtM9rIWdN/Jbd8PRgKqtsGcjIiKi8rOPnp81RpupHCPlRtRAAo+vV98s22eUN6xyg4HQ5VaYgVV9Hil5joNkjJ3ZUHLx5mZfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EgWOpOgu; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EgWOpOgu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747275528; x=1778811528;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wN5rDH56DrHhY+AkxZioAxFuoyv/HBhzURbdog7wjz8=;
  b=EgWOpOgusD5eOhrbx2PqCpbjHvRY0gypslW0TIS57iF+6CbUwnTP9JpU
   ihN2akeVCJFvR5KyiW7bLcSJsnqnwvIN6iOGNBpMZCj6kBtsaKq+p+obB
   kTQCnj+bP8Z0JCD//2EENXm7981ZzR+LnjYKRpmcvOYF+cqWis5Jr6Vmf
   8XkVxiAWoc+dUQ7kdEn8mXCnbatqplnKpEcdTVCwvVQy2GsDtj5YFWzBH
   h6CZf+A5BSwoaqLXnHhkzMJm2yB/Dpz6Z0kzkm7vb0Uz8vAYXkc5OLdUT
   6ryNb7lQlYBdd6wbnmPh4IUKlihW9dhlNfrtFY0zlodoOdf/HWIPe8+6q
   Q==;
X-CSE-ConnectionGUID: 9egViFCzT4y9FjrdwbXyEQ==
X-CSE-MsgGUID: /zwRK6K/TfeSK8f0TyQQyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="60600542"
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="60600542"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 19:18:37 -0700
X-CSE-ConnectionGUID: KAHTot70S0m08yd5Z+lH2Q==
X-CSE-MsgGUID: ublbCbkOTuCEQMYOjkcpVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="138724797"
Received: from unknown (HELO hyperion.jf.intel.com) ([10.243.61.29])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 19:18:37 -0700
From: marc.herbert@linux.intel.com
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	alison.schofield@intel.com
Cc: Marc Herbert <marc.herbert@linux.intel.com>
Subject: [ndctl PATCH v2 1/2] test: move err() function at the top
Date: Thu, 15 May 2025 02:14:45 +0000
Message-ID: <20250515021730.1201996-2-marc.herbert@linux.intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250515021730.1201996-1-marc.herbert@linux.intel.com>
References: <aCKWR4DdzdUh1VN6@aschofie-mobl2.lan>
 <20250515021730.1201996-1-marc.herbert@linux.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Herbert <marc.herbert@linux.intel.com>

move err() function at the top so we can fail early. err() does not have
any dependency so it can be first.

Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
---
 test/common | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/test/common b/test/common
index 75ff1a6e12be..74e74dd4fff9 100644
--- a/test/common
+++ b/test/common
@@ -1,6 +1,20 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (C) 2018, FUJITSU LIMITED. All rights reserved.
 
+# err
+# $1: line number which error detected
+# $2: cleanup function (optional)
+#
+
+test_basename=$(basename "$0")
+
+err()
+{
+	echo test/"$test_basename": failed at line "$1"
+	[ -n "$2" ] && "$2"
+	exit "$rc"
+}
+
 # Global variables
 
 # NDCTL
@@ -53,17 +67,6 @@ E820_BUS="e820"
 
 # Functions
 
-# err
-# $1: line number which error detected
-# $2: cleanup function (optional)
-#
-err()
-{
-	echo test/$(basename $0): failed at line $1
-	[ -n "$2" ] && "$2"
-	exit $rc
-}
-
 reset()
 {
 	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-- 
2.49.0

