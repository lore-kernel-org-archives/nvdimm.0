Return-Path: <SRS0=iZWN=XH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C47BC49ED6
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 02:55:28 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DCBDD2085B
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 02:55:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCBDD2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 6DD84202C80B5;
	Wed, 11 Sep 2019 19:55:33 -0700 (PDT)
Received-SPF: None (no SPF record) identity=mailfrom; client-ip=216.40.44.75;
 helo=smtprelay.hostedemail.com; envelope-from=joe@perches.com;
 receiver=linux-nvdimm@lists.01.org 
Received: from smtprelay.hostedemail.com (smtprelay0075.hostedemail.com
 [216.40.44.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 383F2202C80B4
 for <linux-nvdimm@lists.01.org>; Wed, 11 Sep 2019 19:55:32 -0700 (PDT)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net
 [216.40.38.60])
 by smtprelay01.hostedemail.com (Postfix) with ESMTP id E907C100E86C4;
 Thu, 12 Sep 2019 02:55:24 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: girls87_86643b0d66e00
X-Filterd-Recvd-Size: 2319
Received: from joe-laptop.perches.com (unknown [47.151.152.152])
 (Authenticated sender: joe@perches.com)
 by omf16.hostedemail.com (Postfix) with ESMTPA;
 Thu, 12 Sep 2019 02:55:23 +0000 (UTC)
From: Joe Perches <joe@perches.com>
To: Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Keith Busch <keith.busch@intel.com>, Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH 10/13] nvdimm: namespace_devs: Move assignment operators
Date: Wed, 11 Sep 2019 19:54:40 -0700
Message-Id: <95bbd3ef7a6b06384d1ec6f5bfd691a728b31831.1568256708.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <cover.1568256705.git.joe@perches.com>
References: <cover.1568256705.git.joe@perches.com>
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
 linux-nvdimm@lists.01.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

Kernel code uses assignment operators where the statement is split
on multiple lines on the first line.

Move 2 unusual uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/nvdimm/namespace_devs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 70e1d752c12c..8c75ef84bad7 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2023,8 +2023,8 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 		nspm->lbasize = __le64_to_cpu(label0->lbasize);
 		ndd = to_ndd(nd_mapping);
 		if (namespace_label_has(ndd, abstraction_guid))
-			nspm->nsio.common.claim_class
-				= to_nvdimm_cclass(&label0->abstraction_guid);
+			nspm->nsio.common.claim_class =
+				to_nvdimm_cclass(&label0->abstraction_guid);
 	}
 
 	if (!nspm->alt_name || !nspm->uuid) {
@@ -2267,8 +2267,8 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
 	nsblk->uuid = kmemdup(nd_label->uuid, NSLABEL_UUID_LEN,
 			      GFP_KERNEL);
 	if (namespace_label_has(ndd, abstraction_guid))
-		nsblk->common.claim_class
-			= to_nvdimm_cclass(&nd_label->abstraction_guid);
+		nsblk->common.claim_class =
+			to_nvdimm_cclass(&nd_label->abstraction_guid);
 	if (!nsblk->uuid)
 		goto blk_err;
 	memcpy(name, nd_label->name, NSLABEL_NAME_LEN);
-- 
2.15.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
