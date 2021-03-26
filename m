Return-Path: <SRS0=Jy9+=IY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F612C433DB
	for <linux-nvdimm@archiver.kernel.org>; Fri, 26 Mar 2021 11:27:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B220661A02
	for <linux-nvdimm@archiver.kernel.org>; Fri, 26 Mar 2021 11:27:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B220661A02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=vivo.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 7FB13100F2270;
	Fri, 26 Mar 2021 04:27:56 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=59.111.176.37; helo=mail-m17637.qiye.163.com; envelope-from=wanjiabing@vivo.com; receiver=<UNKNOWN> 
Received: from mail-m17637.qiye.163.com (mail-m17637.qiye.163.com [59.111.176.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id E8B5A100EC1D9
	for <linux-nvdimm@lists.01.org>; Fri, 26 Mar 2021 04:27:53 -0700 (PDT)
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
	by mail-m17637.qiye.163.com (Hmail) with ESMTPA id 07D5F9804A3;
	Fri, 26 Mar 2021 19:27:47 +0800 (CST)
From: Wan Jiabing <wanjiabing@vivo.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	linux-nvdimm@lists.01.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nvdimm/nd-core.h: struct nd_region is declared twice
Date: Fri, 26 Mar 2021 19:26:47 +0800
Message-Id: <20210326112647.903329-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
	oVCBIfWUFZHUtDGUlOQ05KTx1CVkpNSk1MTkNLTUNJTU1VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
	FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Oio6MCo*CT8RTzwZDx5NViMt
	GjcaClFVSlVKTUpNTE5DS01DTUtKVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
	TVVKTklVSk9OVUpDSVlXWQgBWUFKTE1JNwY+
X-HM-Tid: 0a786e4a53d4d992kuws07d5f9804a3
Message-ID-Hash: OMXASWCCM7XAPX5WGNCUWIEPHJKY5LGW
X-Message-ID-Hash: OMXASWCCM7XAPX5WGNCUWIEPHJKY5LGW
X-MailFrom: wanjiabing@vivo.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/OMXASWCCM7XAPX5WGNCUWIEPHJKY5LGW/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

struct nd_region has been declared at 118th line.
Remove the duplicate.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/nvdimm/nd-core.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 564faa36a3ca..e54551caf335 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -128,7 +128,6 @@ void __nd_device_register(struct device *dev);
 struct nd_label_id;
 char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags);
 bool nd_is_uuid_unique(struct device *dev, u8 *uuid);
-struct nd_region;
 struct nvdimm_drvdata;
 struct nd_mapping;
 void nd_mapping_free_labels(struct nd_mapping *nd_mapping);
-- 
2.25.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
