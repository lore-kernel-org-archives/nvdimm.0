Return-Path: <SRS0=Oj3b=JE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FF6C433B4
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Apr 2021 06:53:46 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 602F6613B8
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Apr 2021 06:53:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 602F6613B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 0FD93100F2268;
	Tue,  6 Apr 2021 23:53:45 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.35; helo=szxga07-in.huawei.com; envelope-from=zou_wei@huawei.com; receiver=<UNKNOWN> 
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 23AE5100F224B
	for <linux-nvdimm@lists.01.org>; Tue,  6 Apr 2021 23:53:41 -0700 (PDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FFZmv1Z5Qz93dQ;
	Wed,  7 Apr 2021 14:51:27 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Wed, 7 Apr 2021 14:53:30 +0800
From: Zou Wei <zou_wei@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>
Subject: [PATCH -next] tools/testing/nvdimm: Make symbol '__nfit_test_ioremap' static
Date: Wed, 7 Apr 2021 15:10:51 +0800
Message-ID: <1617779451-81730-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Message-ID-Hash: Q6ZLNNTXGP5ALOQGQSKAGFJZIO2P37US
X-Message-ID-Hash: Q6ZLNNTXGP5ALOQGQSKAGFJZIO2P37US
X-MailFrom: zou_wei@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Zou Wei <zou_wei@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/Q6ZLNNTXGP5ALOQGQSKAGFJZIO2P37US/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The sparse tool complains as follows:

tools/testing/nvdimm/test/iomap.c:65:14: warning:
 symbol '__nfit_test_ioremap' was not declared. Should it be static?

This symbol is not used outside of security.c, so this
commit marks it static.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 tools/testing/nvdimm/test/iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index c62d372..ed563bd 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -62,7 +62,7 @@ struct nfit_test_resource *get_nfit_res(resource_size_t resource)
 }
 EXPORT_SYMBOL(get_nfit_res);
 
-void __iomem *__nfit_test_ioremap(resource_size_t offset, unsigned long size,
+static void __iomem *__nfit_test_ioremap(resource_size_t offset, unsigned long size,
 		void __iomem *(*fallback_fn)(resource_size_t, unsigned long))
 {
 	struct nfit_test_resource *nfit_res = get_nfit_res(offset);
-- 
2.6.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
