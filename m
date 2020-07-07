Return-Path: <SRS0=hiqq=AS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF34C433E0
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 11:13:46 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BEF0620702
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 11:13:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEF0620702
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9E07C1108DEAA;
	Tue,  7 Jul 2020 04:13:45 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.190; helo=huawei.com; envelope-from=weiyongjun1@huawei.com; receiver=<UNKNOWN> 
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 4465511075BCD
	for <linux-nvdimm@lists.01.org>; Tue,  7 Jul 2020 04:13:43 -0700 (PDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
	by Forcepoint Email with ESMTP id 380C099C154655064D94;
	Tue,  7 Jul 2020 19:13:40 +0800 (CST)
Received: from kernelci-master.huawei.com (10.175.101.6) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Tue, 7 Jul 2020 19:13:31 +0800
From: Wei Yongjun <weiyongjun1@huawei.com>
To: Hulk Robot <hulkci@huawei.com>, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH -next] device-dax: make dev_dax_kmem_probe() static
Date: Tue, 7 Jul 2020 19:23:40 +0800
Message-ID: <20200707112340.9178-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Message-ID-Hash: CT7TGF4BX54VALIK4BZ4ASSBHPIG52LH
X-Message-ID-Hash: CT7TGF4BX54VALIK4BZ4ASSBHPIG52LH
X-MailFrom: weiyongjun1@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Wei Yongjun <weiyongjun1@huawei.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CT7TGF4BX54VALIK4BZ4ASSBHPIG52LH/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

sparse report warning as follows:

drivers/dax/kmem.c:22:5: warning:
 symbol 'dev_dax_kmem_probe' was not declared. Should it be static?

dev_dax_kmem_probe() is not used outside of kmem.c, so marks
it static.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/dax/kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 275aa5f87399..87e271668170 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -19,7 +19,7 @@ static const char *kmem_name;
 /* Set if any memory will remain added when the driver will be unloaded. */
 static bool any_hotremove_failed;
 
-int dev_dax_kmem_probe(struct device *dev)
+static int dev_dax_kmem_probe(struct device *dev)
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 	struct resource *res = &dev_dax->region->res;
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
