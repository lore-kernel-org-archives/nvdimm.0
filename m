Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1007B
	for <nvdimm@lists.linux.dev>; Fri, 29 Apr 2022 13:40:51 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id EE0BE1F893;
	Fri, 29 Apr 2022 13:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1651239643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7/OT12bMaVJ8TZ8rwZER5jmYmgYuDxOm3+8lCfUkhW8=;
	b=A8g2YPoRJ/CgXxC35/JX2XekZo1hSpp7MDNVfUJsLJEhX8CzSIDPet5XicETkLYXWyU3qN
	h/CEA2Wy9fDA//7/vuSIZQhpbbiSbNrirL31Vt2qTjtWIGQijif18izawcgYC4DfZqUoH2
	1LtJJ0I8/kuBE4lOp1gb0XrhUzKeO38=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1651239643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7/OT12bMaVJ8TZ8rwZER5jmYmgYuDxOm3+8lCfUkhW8=;
	b=a2+Ca1QE0+BJ+0sViBO/4cTXWciUIi1Ht7BSd525Kz4Td9BtigdLzMfV45waX4SVA6h0JG
	8TR8+HOj/cMFj7BA==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
	by relay2.suse.de (Postfix) with ESMTP id 7C4C92C141;
	Fri, 29 Apr 2022 13:40:43 +0000 (UTC)
From: Michal Suchanek <msuchanek@suse.de>
To: nvdimm@lists.linux.dev
Cc: Michal Suchanek <msuchanek@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Zou Wei <zou_wei@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] testing: nvdimm: iomap: make __nfit_test_ioremap a macro
Date: Fri, 29 Apr 2022 15:40:39 +0200
Message-Id: <20220429134039.18252-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ioremap passed as argument to __nfit_test_ioremap can be a macro so
it cannot be passed as function argument. Make __nfit_test_ioremap into
a macro so that ioremap can be passed as untyped macro argument.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 tools/testing/nvdimm/test/iomap.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index b752ce47ead3..ea956082e6a4 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -62,16 +62,14 @@ struct nfit_test_resource *get_nfit_res(resource_size_t resource)
 }
 EXPORT_SYMBOL(get_nfit_res);
 
-static void __iomem *__nfit_test_ioremap(resource_size_t offset, unsigned long size,
-		void __iomem *(*fallback_fn)(resource_size_t, unsigned long))
-{
-	struct nfit_test_resource *nfit_res = get_nfit_res(offset);
-
-	if (nfit_res)
-		return (void __iomem *) nfit_res->buf + offset
-			- nfit_res->res.start;
-	return fallback_fn(offset, size);
-}
+#define __nfit_test_ioremap(offset, size, fallback_fn) ({		\
+	struct nfit_test_resource *nfit_res = get_nfit_res(offset);	\
+	nfit_res ?							\
+		(void __iomem *) nfit_res->buf + (offset)		\
+			- nfit_res->res.start				\
+	:								\
+		fallback_fn((offset), (size)) ;				\
+})
 
 void __iomem *__wrap_devm_ioremap(struct device *dev,
 		resource_size_t offset, unsigned long size)
-- 
2.34.1

