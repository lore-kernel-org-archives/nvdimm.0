Return-Path: <SRS0=BDGy=FS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_40,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3368EC4361B
	for <linux-nvdimm@archiver.kernel.org>; Mon, 14 Dec 2020 13:45:03 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3F6BD229C5
	for <linux-nvdimm@archiver.kernel.org>; Mon, 14 Dec 2020 13:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F6BD229C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8F35A100ED48D;
	Mon, 14 Dec 2020 05:45:01 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.35; helo=szxga07-in.huawei.com; envelope-from=zhengyongjun3@huawei.com; receiver=<UNKNOWN> 
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 61C44100ED489
	for <linux-nvdimm@lists.01.org>; Mon, 14 Dec 2020 05:44:58 -0800 (PST)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CvjKj1Xt5z7DCm;
	Mon, 14 Dec 2020 21:44:09 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 14 Dec 2020 21:44:35 +0800
From: Zheng Yongjun <zhengyongjun3@huawei.com>
To: <linux-nvdimm@lists.01.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] dax: pmem: convert comma to semicolon
Date: Mon, 14 Dec 2020 21:45:06 +0800
Message-ID: <20201214134506.4831-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Message-ID-Hash: X5JRL3ONEGNRGJFUWQFWBODRDUHCEMY7
X-Message-ID-Hash: X5JRL3ONEGNRGJFUWQFWBODRDUHCEMY7
X-MailFrom: zhengyongjun3@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Zheng Yongjun <zhengyongjun3@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/X5JRL3ONEGNRGJFUWQFWBODRDUHCEMY7/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/dax/pmem/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/pmem/core.c b/drivers/dax/pmem/core.c
index 62b26bfceab1..062e8bc14223 100644
--- a/drivers/dax/pmem/core.c
+++ b/drivers/dax/pmem/core.c
@@ -52,7 +52,7 @@ struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys subsys)
 
 	/* adjust the dax_region range to the start of data */
 	range = pgmap.range;
-	range.start += offset,
+	range.start += offset;
 	dax_region = alloc_dax_region(dev, region_id, &range,
 			nd_region->target_node, le32_to_cpu(pfn_sb->align),
 			IORESOURCE_DAX_STATIC);
-- 
2.22.0
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
