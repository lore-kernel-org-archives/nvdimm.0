Return-Path: <SRS0=3PS1=BX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D2CC433DF
	for <linux-nvdimm@archiver.kernel.org>; Thu, 13 Aug 2020 03:27:21 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4057F207DA
	for <linux-nvdimm@archiver.kernel.org>; Thu, 13 Aug 2020 03:27:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4057F207DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vivo.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 21C7812FDF5EE;
	Wed, 12 Aug 2020 20:27:21 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=59.111.176.18; helo=m17618.mail.qiye.163.com; envelope-from=wangqing@vivo.com; receiver=<UNKNOWN> 
Received: from m17618.mail.qiye.163.com (m17618.mail.qiye.163.com [59.111.176.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B2D2012FDF5EB
	for <linux-nvdimm@lists.01.org>; Wed, 12 Aug 2020 20:27:17 -0700 (PDT)
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.226])
	by m17618.mail.qiye.163.com (Hmail) with ESMTPA id 486F04E181E;
	Thu, 13 Aug 2020 11:27:14 +0800 (CST)
From: Wang Qing <wangqing@vivo.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	linux-nvdimm@lists.01.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/dax: Use kobj_to_dev() instead
Date: Thu, 13 Aug 2020 11:27:02 +0800
Message-Id: <1597289224-19897-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
	oVCBIfWUFZSxlNSEpPGkJJGUsYVkpOQkxJQ0JJSE9NS05VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
	FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PxQ6PAw4CD8aKUMZNDc6EhQp
	CRcaCUlVSlVKTkJMSUNCSUhOS0pIVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
	SU5KVUxPVUlJTVlXWQgBWUFKTklDNwY+
X-HM-Tid: 0a73e5db803d9376kuws486f04e181e
Message-ID-Hash: RHDJH2X7F4K5CLIILIXFNOFOQGSVIFCY
X-Message-ID-Hash: RHDJH2X7F4K5CLIILIXFNOFOQGSVIFCY
X-MailFrom: wangqing@vivo.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Wang Qing <wangqing@vivo.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/RHDJH2X7F4K5CLIILIXFNOFOQGSVIFCY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use kobj_to_dev() instead of container_of()

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/dax/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index df238c8..24625d2
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -331,7 +331,7 @@ static DEVICE_ATTR_RO(numa_node);
 
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 
 	if (a == &dev_attr_target_node.attr && dev_dax_target_node(dev_dax) < 0)
-- 
2.7.4
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
