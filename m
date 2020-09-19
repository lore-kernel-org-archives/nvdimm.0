Return-Path: <SRS0=/MmL=C4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3D8C43463
	for <linux-nvdimm@archiver.kernel.org>; Sat, 19 Sep 2020 09:37:12 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4F19721582
	for <linux-nvdimm@archiver.kernel.org>; Sat, 19 Sep 2020 09:37:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F19721582
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D080313F6D0AD;
	Sat, 19 Sep 2020 02:37:11 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.190; helo=huawei.com; envelope-from=thunder.leizhen@huawei.com; receiver=<UNKNOWN> 
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id BF5661356823F
	for <linux-nvdimm@lists.01.org>; Sat, 19 Sep 2020 02:37:08 -0700 (PDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
	by Forcepoint Email with ESMTP id D23E5170A5BB9ACD5BC3;
	Sat, 19 Sep 2020 17:37:05 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.253) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 17:36:56 +0800
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Oliver O'Halloran <oohall@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Markus
 Elfring <Markus.Elfring@web.de>, linux-nvdimm <linux-nvdimm@lists.01.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] libnvdimm/namespace: avoid repeated judgment in nvdimm_namespace_disk_name()
Date: Sat, 19 Sep 2020 17:36:29 +0800
Message-ID: <20200919093629.3792-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.177.253]
X-CFilter-Loop: Reflected
Message-ID-Hash: 75MAXMFSVLRUBBUDI7UY5XTKV5KIDZIP
X-Message-ID-Hash: 75MAXMFSVLRUBBUDI7UY5XTKV5KIDZIP
X-MailFrom: thunder.leizhen@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Zhen Lei <thunder.leizhen@huawei.com>, Libin <huawei.libin@huawei.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/75MAXMFSVLRUBBUDI7UY5XTKV5KIDZIP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The judgment (suffix ? suffix : "") appears three times, we do this just
because the initial value of local variable "suffix" is NULL, should be
replaced with empty string "" to avoid null pointer reference. It's easy
to get rid of it as below:
-	const char *suffix = NULL;
+	const char *suffix = "";

To avoid having rows that exceed 80 columns, add a new local variable
"region_id".

No functional change, but it can reduce the code size.
Before:
   text    data     bss     dec     hex filename
  41749    3697      16   45462    b196 drivers/nvdimm/namespace_devs.o

After:
   text    data     bss     dec     hex filename
  41653    3697      16   45366    b136 drivers/nvdimm/namespace_devs.o

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
v1 --> v2:
1. Only the title and description are modified.

v1:
https://lore.kernel.org/patchwork/patch/1292584/

 drivers/nvdimm/namespace_devs.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 6da67f4d641a27c..ef2800c5da4c99c 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -157,7 +157,8 @@ const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 		char *name)
 {
 	struct nd_region *nd_region = to_nd_region(ndns->dev.parent);
-	const char *suffix = NULL;
+	const char *suffix = "";
+	int region_id = nd_region->id;
 
 	if (ndns->claim && is_nd_btt(ndns->claim))
 		suffix = "s";
@@ -173,17 +174,14 @@ const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 		}
 
 		if (nsidx)
-			sprintf(name, "pmem%d.%d%s", nd_region->id, nsidx,
-					suffix ? suffix : "");
+			sprintf(name, "pmem%d.%d%s", region_id, nsidx, suffix);
 		else
-			sprintf(name, "pmem%d%s", nd_region->id,
-					suffix ? suffix : "");
+			sprintf(name, "pmem%d%s", region_id, suffix);
 	} else if (is_namespace_blk(&ndns->dev)) {
 		struct nd_namespace_blk *nsblk;
 
 		nsblk = to_nd_namespace_blk(&ndns->dev);
-		sprintf(name, "ndblk%d.%d%s", nd_region->id, nsblk->id,
-				suffix ? suffix : "");
+		sprintf(name, "ndblk%d.%d%s", region_id, nsblk->id, suffix);
 	} else {
 		return NULL;
 	}
-- 
1.8.3

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
