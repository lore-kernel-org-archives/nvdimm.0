Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594F17B
	for <nvdimm@lists.linux.dev>; Fri, 29 Apr 2022 07:43:48 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 041A821872;
	Fri, 29 Apr 2022 07:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1651218220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cE02aE0M+NaUBzKQB+RLthaTB5Wl8xw0uBDzpADoSXw=;
	b=WJLmdyGX/0LbsFaPU6E6QtMrie4b9uRTjXaKGXITC20t16kfiMw0BEc6D39O3tqSjR87E+
	EMUqYeJiWQUmex28m4pVz/M0gSFbyGfxamwqgAZSQumZiNmtvnXWXnmoMpFM+yOJmoTgrq
	i4RI7qAc/ndrWnbCyIgT79H6rKDIM2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1651218220;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cE02aE0M+NaUBzKQB+RLthaTB5Wl8xw0uBDzpADoSXw=;
	b=CGQ7iQP4IJuGCrpaa/70FlQOSKWld0v5Dca+FO+1EOoG+lhS+bn4hWpqB1j7mBm3yrvZcG
	fYMz9CY4VUACvMDQ==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
	by relay2.suse.de (Postfix) with ESMTP id 973E32C142;
	Fri, 29 Apr 2022 07:43:39 +0000 (UTC)
From: Michal Suchanek <msuchanek@suse.de>
To: nvdimm@lists.linux.dev
Cc: Michal Suchanek <msuchanek@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Jane Chu <jane.chu@oracle.com>,
	Borislav Petkov <bp@suse.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] testing: nvdimm: asm/mce.h is not needed in nfit.c
Date: Fri, 29 Apr 2022 09:43:34 +0200
Message-Id: <20220429074334.21771-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

asm/mce.h is not available on arm, and it is not needed to build nfit.c.
Remove the include.

It was likely needed for COPY_MC_TEST

Fixes: 3adb776384f2 ("x86, libnvdimm/test: Remove COPY_MC_TEST")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 tools/testing/nvdimm/test/nfit.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 0bc91ffee257..b4743ba65b96 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -23,8 +23,6 @@
 #include "nfit_test.h"
 #include "../watermark.h"
 
-#include <asm/mce.h>
-
 /*
  * Generate an NFIT table to describe the following topology:
  *
-- 
2.34.1

