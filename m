Return-Path: <SRS0=VNsK=B6=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39553C433E4
	for <linux-nvdimm@archiver.kernel.org>; Thu, 20 Aug 2020 02:17:37 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0C3F5207DA
	for <linux-nvdimm@archiver.kernel.org>; Thu, 20 Aug 2020 02:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C3F5207DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 26E5C13515B5E;
	Wed, 19 Aug 2020 19:17:35 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.191; helo=huawei.com; envelope-from=thunder.leizhen@huawei.com; receiver=<UNKNOWN> 
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 17ECA13515B4E
	for <linux-nvdimm@lists.01.org>; Wed, 19 Aug 2020 19:17:28 -0700 (PDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
	by Forcepoint Email with ESMTP id 78F5EA4A5C7AB868251C;
	Thu, 20 Aug 2020 10:17:25 +0800 (CST)
Received: from DESKTOP-C3MD9UG.china.huawei.com (10.174.177.253) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 20 Aug 2020 10:17:18 +0800
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Oliver O'Halloran <oohall@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Markus
 Elfring <Markus.Elfring@web.de>, linux-nvdimm <linux-nvdimm@lists.01.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 6/7] libnvdimm: make sure EXPORT_SYMBOL_GPL(nvdimm_flush) close to its function
Date: Thu, 20 Aug 2020 10:16:40 +0800
Message-ID: <20200820021641.3188-7-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20200820021641.3188-1-thunder.leizhen@huawei.com>
References: <20200820021641.3188-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.177.253]
X-CFilter-Loop: Reflected
Message-ID-Hash: LWVPU6N5VFWWVTYZ2VWQ7TMBSSEXY4LB
X-Message-ID-Hash: LWVPU6N5VFWWVTYZ2VWQ7TMBSSEXY4LB
X-MailFrom: thunder.leizhen@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Zhen Lei <thunder.leizhen@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/LWVPU6N5VFWWVTYZ2VWQ7TMBSSEXY4LB/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Move EXPORT_SYMBOL_GPL(nvdimm_flush) close to nvdimm_flush(), currently
it's near to generic_nvdimm_flush().

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/nvdimm/region_devs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 49be115c9189eff..909bf03edb132cf 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1183,6 +1183,8 @@ int nvdimm_flush(struct nd_region *nd_region, struct bio *bio)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(nvdimm_flush);
+
 /**
  * nvdimm_flush - flush any posted write queues between the cpu and pmem media
  * @nd_region: blk or interleaved pmem region
@@ -1214,7 +1216,6 @@ int generic_nvdimm_flush(struct nd_region *nd_region)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(nvdimm_flush);
 
 /**
  * nvdimm_has_flush - determine write flushing requirements
-- 
1.8.3

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
