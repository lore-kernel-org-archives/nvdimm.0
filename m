Return-Path: <SRS0=T0KY=IX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B02C433E2
	for <linux-nvdimm@archiver.kernel.org>; Thu, 25 Mar 2021 06:52:16 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E404361A21
	for <linux-nvdimm@archiver.kernel.org>; Thu, 25 Mar 2021 06:52:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E404361A21
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=vivo.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 6686A100F2245;
	Wed, 24 Mar 2021 23:52:15 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=59.111.176.37; helo=mail-m17637.qiye.163.com; envelope-from=wanjiabing@vivo.com; receiver=<UNKNOWN> 
Received: from mail-m17637.qiye.163.com (mail-m17637.qiye.163.com [59.111.176.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C4A22100EB343
	for <linux-nvdimm@lists.01.org>; Wed, 24 Mar 2021 23:52:12 -0700 (PDT)
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
	by mail-m17637.qiye.163.com (Hmail) with ESMTPA id 4F00E9803C7;
	Thu, 25 Mar 2021 14:52:07 +0800 (CST)
From: Wan Jiabing <wanjiabing@vivo.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-nvdimm@lists.01.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH] include: linux: struct device is declared twice
Date: Thu, 25 Mar 2021 14:51:53 +0800
Message-Id: <20210325065153.855812-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
	oVCBIfWUFZS08fTR9LHh1KSx9KVkpNSk1NTk5KSUxNSk9VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
	FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NjI6Pyo4Sz8LKD4hSwwxFEoX
	QhoKCkNVSlVKTUpNTU5OSklMQ09CVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
	TVVKTklVSk9OVUpDSVlXWQgBWUFKQklCNwY+
X-HM-Tid: 0a78682793edd992kuws4f00e9803c7
Message-ID-Hash: 445VBFSLY7EKHDW7RTVCICPHYDA3EFDZ
X-Message-ID-Hash: 445VBFSLY7EKHDW7RTVCICPHYDA3EFDZ
X-MailFrom: wanjiabing@vivo.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/445VBFSLY7EKHDW7RTVCICPHYDA3EFDZ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

struct device has been declared at 133rd line. 
Remove the duplicate.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 include/linux/libnvdimm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 01f251b6e36c..89b69e645ac7 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -141,7 +141,6 @@ static inline void __iomem *devm_nvdimm_ioremap(struct device *dev,
 
 struct nvdimm_bus;
 struct module;
-struct device;
 struct nd_blk_region;
 struct nd_blk_region_desc {
 	int (*enable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
-- 
2.25.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
