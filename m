Return-Path: <SRS0=A0fy=GM=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD08C433E0
	for <linux-nvdimm@archiver.kernel.org>; Sat,  9 Jan 2021 17:37:43 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 62ABD22E03
	for <linux-nvdimm@archiver.kernel.org>; Sat,  9 Jan 2021 17:37:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62ABD22E03
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D3FDE100ED4AE;
	Sat,  9 Jan 2021 09:37:41 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.151; helo=mga17.intel.com; envelope-from=redhairer.li@intel.com; receiver=<UNKNOWN> 
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B3BE4100EF25B
	for <linux-nvdimm@lists.01.org>; Sat,  9 Jan 2021 09:37:38 -0800 (PST)
IronPort-SDR: ivQ/2HcOtHaggoGAZXB4PORzO2vXZeCsXIIM/skKC+G5efUitfTIAp287KBo7fZ02p7CHhhPnt
 Q45Fa7RWZCQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9859"; a="157496709"
X-IronPort-AV: E=Sophos;i="5.79,334,1602572400";
   d="scan'208";a="157496709"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2021 09:37:37 -0800
IronPort-SDR: Tm/o7rmA51qWe6JfIz2EBxK2aHl9TQ1n/tGyfSdXrDkXQ+2URPiGCM5rmBdRnZf9GwNkyyQKAd
 dYv6no4piiHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,334,1602572400";
   d="scan'208";a="347676254"
Received: from unknown (HELO localhost.itwn.intel.com) ([10.5.250.7])
  by orsmga003.jf.intel.com with ESMTP; 09 Jan 2021 09:37:36 -0800
From: redhairer <redhairer.li@intel.com>
To: linux-nvdimm@lists.01.org,
	dan.j.williams@intel.com
Subject: [PATCH 1/1] msft: Add xlat_firmware_status for JEDEC Byte Addressable Energy Backed DSM
Date: Sat,  9 Jan 2021 23:36:33 +0800
Message-Id: <20210109153633.8493-1-redhairer.li@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Message-ID-Hash: QKOU44YYSH5LRH37VJFZYX2J3DMG5UNT
X-Message-ID-Hash: QKOU44YYSH5LRH37VJFZYX2J3DMG5UNT
X-MailFrom: redhairer.li@intel.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Redhairer Li <redhairer.li@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/QKOU44YYSH5LRH37VJFZYX2J3DMG5UNT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Redhairer Li <redhairer.li@intel.com>

Translate the status codes of the result of JEDEC Byte Addressable Energy Backed
DSM to generic errno style error codes.

Signed-off-by: Li Redhairer <redhairer.li@intel.com>
---
 ndctl/lib/msft.c | 22 ++++++++++++++++++++++
 ndctl/lib/msft.h |  6 ++++++
 2 files changed, 28 insertions(+)

diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
index 145872c..3112799 100644
--- a/ndctl/lib/msft.c
+++ b/ndctl/lib/msft.c
@@ -149,10 +149,32 @@ static unsigned int msft_cmd_smart_get_life_used(struct ndctl_cmd *cmd)
 	return 100 - CMD_MSFT_SMART(cmd)->nvm_lifetime;
 }
 
+static int msft_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
+{
+	unsigned int status;
+
+	status = cmd->get_firmware_status(cmd) & NDN_MSFT_STATUS_MASK;
+
+	/* Common statuses */
+	switch (status) {
+	case NDN_MSFT_STATUS_SUCCESS:
+		return 0;
+	case NDN_MSFT_STATUS_NOTSUPP:
+		return -EOPNOTSUPP;
+	case NDN_MSFT_STATUS_INVALPARM:
+		return -EINVAL;
+	case NDN_MSFT_STATUS_I2CERR:
+		return -EIO;
+	}
+
+	return -ENOMSG;
+}
+
 struct ndctl_dimm_ops * const msft_dimm_ops = &(struct ndctl_dimm_ops) {
 	.new_smart = msft_dimm_cmd_new_smart,
 	.smart_get_flags = msft_cmd_smart_get_flags,
 	.smart_get_health = msft_cmd_smart_get_health,
 	.smart_get_media_temperature = msft_cmd_smart_get_media_temperature,
 	.smart_get_life_used = msft_cmd_smart_get_life_used,
+	.xlat_firmware_status = msft_cmd_xlat_firmware_status,
 };
diff --git a/ndctl/lib/msft.h b/ndctl/lib/msft.h
index 7cfd26f..978cc11 100644
--- a/ndctl/lib/msft.h
+++ b/ndctl/lib/msft.h
@@ -50,4 +50,10 @@ struct ndn_pkg_msft {
 	union ndn_msft_cmd	u;
 } __attribute__((packed));
 
+#define NDN_MSFT_STATUS_MASK		0xffff
+#define NDN_MSFT_STATUS_SUCCESS	0
+#define NDN_MSFT_STATUS_NOTSUPP	1
+#define NDN_MSFT_STATUS_INVALPARM	2
+#define NDN_MSFT_STATUS_I2CERR		3
+
 #endif /* __NDCTL_MSFT_H__ */
-- 
2.27.0.windows.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
