Return-Path: <SRS0=7jdq=B5=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21774C433DF
	for <linux-nvdimm@archiver.kernel.org>; Wed, 19 Aug 2020 02:05:52 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 030342067C
	for <linux-nvdimm@archiver.kernel.org>; Wed, 19 Aug 2020 02:05:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 030342067C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5CD82134CA7F7;
	Tue, 18 Aug 2020 19:05:51 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.32; helo=huawei.com; envelope-from=thunder.leizhen@huawei.com; receiver=<UNKNOWN> 
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9C75B134CA7F2
	for <linux-nvdimm@lists.01.org>; Tue, 18 Aug 2020 19:05:47 -0700 (PDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
	by Forcepoint Email with ESMTP id A92CA3F694DDC345A29A;
	Wed, 19 Aug 2020 10:05:44 +0800 (CST)
Received: from DESKTOP-C3MD9UG.china.huawei.com (10.174.177.253) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 10:05:33 +0800
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Oliver O'Halloran <oohall@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Markus
 Elfring <Markus.Elfring@web.de>, linux-nvdimm <linux-nvdimm@lists.01.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/4] libnvdimm: add sanity check for provider_name in of_pmem_region_probe()
Date: Wed, 19 Aug 2020 10:05:01 +0800
Message-ID: <20200819020503.3079-3-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20200819020503.3079-1-thunder.leizhen@huawei.com>
References: <20200819020503.3079-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.177.253]
X-CFilter-Loop: Reflected
Message-ID-Hash: GHRTMOW7ZFMR32YGNVYB32WEPPH6QN4P
X-Message-ID-Hash: GHRTMOW7ZFMR32YGNVYB32WEPPH6QN4P
X-MailFrom: thunder.leizhen@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Zhen Lei <thunder.leizhen@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/GHRTMOW7ZFMR32YGNVYB32WEPPH6QN4P/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

kstrdup() may return NULL because of no memory, check it.

Fixes: 49bddc73d15c ("libnvdimm/of_pmem: Provide a unique name for bus provider")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/nvdimm/of_pmem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
index 1292ffca7b2ecc0..13c4c274ca6ea88 100644
--- a/drivers/nvdimm/of_pmem.c
+++ b/drivers/nvdimm/of_pmem.c
@@ -31,6 +31,11 @@ static int of_pmem_region_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv->bus_desc.provider_name = kstrdup(pdev->name, GFP_KERNEL);
+	if (!priv->bus_desc.provider_name) {
+		kfree(priv);
+		return -ENOMEM;
+	}
+
 	priv->bus_desc.module = THIS_MODULE;
 	priv->bus_desc.of_node = np;
 
-- 
1.8.3

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
