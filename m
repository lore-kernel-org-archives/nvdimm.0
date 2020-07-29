Return-Path: <SRS0=g18b=BI=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_40,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5257C433E1
	for <linux-nvdimm@archiver.kernel.org>; Wed, 29 Jul 2020 03:44:50 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B5902075F
	for <linux-nvdimm@archiver.kernel.org>; Wed, 29 Jul 2020 03:44:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B5902075F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 561C81268E95D;
	Tue, 28 Jul 2020 20:44:50 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=183.91.158.132; helo=heian.cn.fujitsu.com; envelope-from=lihao2018.fnst@cn.fujitsu.com; receiver=<UNKNOWN> 
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by ml01.01.org (Postfix) with ESMTP id B8B1511001AB9
	for <linux-nvdimm@lists.01.org>; Tue, 28 Jul 2020 20:44:46 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.75,408,1589212800";
   d="scan'208";a="97041138"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 29 Jul 2020 11:44:42 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 0B1834CE38CB;
	Wed, 29 Jul 2020 11:44:38 +0800 (CST)
Received: from G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Wed, 29 Jul 2020 11:44:37 +0800
Received: from localhost.localdomain (10.167.225.206) by
 G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Wed, 29 Jul 2020 11:44:37 +0800
From: Hao Li <lihao2018.fnst@cn.fujitsu.com>
To: <viro@zeniv.linux.org.uk>
Subject: [PATCH] dax: Fix wrong error-number passed into xas_set_err()
Date: Wed, 29 Jul 2020 11:44:36 +0800
Message-ID: <20200729034436.24267-1-lihao2018.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 0B1834CE38CB.A1DB9
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lihao2018.fnst@cn.fujitsu.com
Message-ID-Hash: 4E7FCQR37XXQPTQLAV2DHH6EPIJXPXFS
X-Message-ID-Hash: 4E7FCQR37XXQPTQLAV2DHH6EPIJXPXFS
X-MailFrom: lihao2018.fnst@cn.fujitsu.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: willy@infradead.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, lihao2018.fnst@cn.fujitsu.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4E7FCQR37XXQPTQLAV2DHH6EPIJXPXFS/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The error-number passed into xas_set_err() should be negative. Otherwise,
the xas_error() will return 0, and grab_mapping_entry() will return the
found entry instead of a SIGBUS error when the entry is not a value.
And then, the subsequent code path would be wrong.

Signed-off-by: Hao Li <lihao2018.fnst@cn.fujitsu.com>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 11b16729b86f..acac675fe7a6 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -488,7 +488,7 @@ static void *grab_mapping_entry(struct xa_state *xas,
 		if (dax_is_conflict(entry))
 			goto fallback;
 		if (!xa_is_value(entry)) {
-			xas_set_err(xas, EIO);
+			xas_set_err(xas, -EIO);
 			goto out_unlock;
 		}
 
-- 
2.28.0


_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
