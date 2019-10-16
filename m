Return-Path: <SRS0=KBTq=YJ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DFCECE58F
	for <linux-nvdimm@archiver.kernel.org>; Wed, 16 Oct 2019 02:16:14 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6BD3D20650
	for <linux-nvdimm@archiver.kernel.org>; Wed, 16 Oct 2019 02:16:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BD3D20650
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id F2BE410FCC631;
	Tue, 15 Oct 2019 19:19:12 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=115.124.30.42; helo=out30-42.freemail.mail.aliyun.com; envelope-from=zhangliguang@linux.alibaba.com; receiver=<UNKNOWN> 
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id BB27710FCB783
	for <linux-nvdimm@lists.01.org>; Tue, 15 Oct 2019 19:19:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=zhangliguang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TfBKlGn_1571192160;
Received: from localhost(mailfrom:zhangliguang@linux.alibaba.com fp:SMTPD_---0TfBKlGn_1571192160)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Oct 2019 10:16:08 +0800
From: luanshi <zhangliguang@linux.alibaba.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Keith Busch <keith.busch@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH] libnvdimm: fix kernel-doc notation
Date: Wed, 16 Oct 2019 10:16:00 +0800
Message-Id: <1571192160-54202-1-git-send-email-zhangliguang@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Message-ID-Hash: TVSLKKKTCFNSQYWZCYRAIRSWUEVLJHMS
X-Message-ID-Hash: TVSLKKKTCFNSQYWZCYRAIRSWUEVLJHMS
X-MailFrom: zhangliguang@linux.alibaba.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/TVSLKKKTCFNSQYWZCYRAIRSWUEVLJHMS/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fix kernel-doc notation in drivers/nvdimm/namespace_devs.c.

Fixes: bf9bccc14c05 ("libnvdimm: pmem label sets and namespace instantiation.")
Signed-off-by: Liguang Zhang <zhangliguang@linux.alibaba.com>
---
 drivers/nvdimm/namespace_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index cca0a3b..5cfb1e9 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1900,7 +1900,7 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
 /**
  * create_namespace_pmem - validate interleave set labelling, retrieve label0
  * @nd_region: region with mappings to validate
- * @nspm: target namespace to create
+ * @ndindex: target namespace index to create
  * @nd_label: target pmem namespace label to evaluate
  */
 static struct device *create_namespace_pmem(struct nd_region *nd_region,
-- 
1.8.3.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
