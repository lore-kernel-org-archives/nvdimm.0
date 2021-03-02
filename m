Return-Path: <SRS0=5iuj=IA=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB847C433DB
	for <linux-nvdimm@archiver.kernel.org>; Tue,  2 Mar 2021 09:55:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2DA8E64E56
	for <linux-nvdimm@archiver.kernel.org>; Tue,  2 Mar 2021 09:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DA8E64E56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 69043100EB845;
	Tue,  2 Mar 2021 01:55:56 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=115.124.30.42; helo=out30-42.freemail.mail.aliyun.com; envelope-from=jiapeng.chong@linux.alibaba.com; receiver=<UNKNOWN> 
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 98DFB100EBB9E
	for <linux-nvdimm@lists.01.org>; Tue,  2 Mar 2021 01:55:53 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UQ4en6v_1614678946;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UQ4en6v_1614678946)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 02 Mar 2021 17:55:50 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: dan.j.williams@intel.com
Subject: [PATCH] dax-device: Switch to using the new API kobj_to_dev()
Date: Tue,  2 Mar 2021 17:55:44 +0800
Message-Id: <1614678944-26544-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Message-ID-Hash: AXPM54POIDNYLRPF3SV3PZVXMKKH7MIF
X-Message-ID-Hash: AXPM54POIDNYLRPF3SV3PZVXMKKH7MIF
X-MailFrom: jiapeng.chong@linux.alibaba.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/AXPM54POIDNYLRPF3SV3PZVXMKKH7MIF/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fix the following coccicheck warnings:

./drivers/dax/bus.c:489:60-61: WARNING opportunity for kobj_to_dev().
./drivers/dax/bus.c:1218:60-61: WARNING opportunity for kobj_to_dev().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/dax/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 452e85a..37d7cc6 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -486,7 +486,7 @@ static ssize_t delete_store(struct device *dev, struct device_attribute *attr,
 static umode_t dax_region_visible(struct kobject *kobj, struct attribute *a,
 		int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 
 	if (is_static(dax_region))
@@ -1215,7 +1215,7 @@ static ssize_t numa_node_show(struct device *dev,
 
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 	struct dax_region *dax_region = dev_dax->region;
 
-- 
1.8.3.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
