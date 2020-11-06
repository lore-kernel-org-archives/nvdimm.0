Return-Path: <SRS0=MGD/=EM=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790B6C2D0A3
	for <linux-nvdimm@archiver.kernel.org>; Fri,  6 Nov 2020 09:26:54 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 16E40208B3
	for <linux-nvdimm@archiver.kernel.org>; Fri,  6 Nov 2020 09:26:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16E40208B3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9D9771674C0F1;
	Fri,  6 Nov 2020 01:26:53 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.191; helo=szxga05-in.huawei.com; envelope-from=liuzhiqiang26@huawei.com; receiver=<UNKNOWN> 
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3ACDA1674C0EF
	for <linux-nvdimm@lists.01.org>; Fri,  6 Nov 2020 01:26:50 -0800 (PST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CSFQ942QbzLtmq
	for <linux-nvdimm@lists.01.org>; Fri,  6 Nov 2020 17:26:41 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.238) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 6 Nov 2020
 17:26:39 +0800
Subject: [ndctl PATCH 5/8] util/help: check whether strdup returns NULL in
 exec_man_konqueror
To: <vishal.l.verma@intel.com>
References: <bed3b3b3-1f30-6751-c0bf-15ecf70192f9@huawei.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <889d3dc7-2532-9f91-b0d8-5eeab45d6bb7@huawei.com>
Date: Fri, 6 Nov 2020 17:26:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <bed3b3b3-1f30-6751-c0bf-15ecf70192f9@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.174.176.238]
X-CFilter-Loop: Reflected
Message-ID-Hash: MS2AGY5AN4V7EAP275FP4TAMFWM6GOBG
X-Message-ID-Hash: MS2AGY5AN4V7EAP275FP4TAMFWM6GOBG
X-MailFrom: liuzhiqiang26@huawei.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org, linfeilong <linfeilong@huawei.com>, liuzhiqiang26@huawei.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/MS2AGY5AN4V7EAP275FP4TAMFWM6GOBG/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


In exec_man_konqueror(), new is allocated by calling strdup(),
which may return NULL. We should check whether new is NULL before
using it.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 util/help.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/util/help.c b/util/help.c
index 2d57fa1..f867944 100644
--- a/util/help.c
+++ b/util/help.c
@@ -44,8 +44,14 @@ static void exec_man_konqueror(const char *path, const char *page)
 		if (path) {
 			const char *file = strrchr(path, '/');
 			if (file && !strcmp(file + 1, "konqueror")) {
+				char *dest;
 				char *new = strdup(path);
-				char *dest = strrchr(new, '/');
+				if (!new) {
+					pr_err("strdup(path) fails.\n");
+					exit(1);
+				}
+
+				dest = strrchr(new, '/');

 				/* strlen("konqueror") == strlen("kfmclient") */
 				strcpy(dest + 1, "kfmclient");
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
