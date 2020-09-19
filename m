Return-Path: <SRS0=/MmL=C4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3B1C43463
	for <linux-nvdimm@archiver.kernel.org>; Sat, 19 Sep 2020 10:47:04 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1CACF21D42
	for <linux-nvdimm@archiver.kernel.org>; Sat, 19 Sep 2020 10:47:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CACF21D42
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id EDD99152ACFA3;
	Sat, 19 Sep 2020 03:47:03 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.35; helo=huawei.com; envelope-from=thunder.leizhen@huawei.com; receiver=<UNKNOWN> 
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 01D36152A3652
	for <linux-nvdimm@lists.01.org>; Sat, 19 Sep 2020 03:46:53 -0700 (PDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
	by Forcepoint Email with ESMTP id E731E4417A714F281C9A;
	Sat, 19 Sep 2020 18:46:50 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.253) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 18:46:41 +0800
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Oliver O'Halloran <oohall@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Markus
 Elfring <Markus.Elfring@web.de>, linux-nvdimm <linux-nvdimm@lists.01.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] libnvdimm/badrange: eliminate a meaningless spinlock operation
Date: Sat, 19 Sep 2020 18:45:46 +0800
Message-ID: <20200919104546.3848-3-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20200919104546.3848-1-thunder.leizhen@huawei.com>
References: <20200919104546.3848-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.177.253]
X-CFilter-Loop: Reflected
Message-ID-Hash: 5UZI3WJS62547D27FVWY6HWRPKECRAAI
X-Message-ID-Hash: 5UZI3WJS62547D27FVWY6HWRPKECRAAI
X-MailFrom: thunder.leizhen@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Zhen Lei <thunder.leizhen@huawei.com>, Libin <huawei.libin@huawei.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/5UZI3WJS62547D27FVWY6HWRPKECRAAI/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

badrange_add() take the lock "badrange->lock", but it's released
immediately in add_badrange(), protect nothing.

The pseudo code is as follows:
In badrange_add():
	spin_lock(&badrange->lock);	<---------------
	rc = add_badrange(badrange, addr, length);	|
In add_badrange():					|
	//do nothing					|
	spin_unlock(&badrange->lock);	<---------------
	bre_new = kzalloc(sizeof(*bre_new), GFP_KERNEL);
	spin_lock(&badrange->lock);	<--- lock again

This lock/unlock operation is meaningless.

Because the static function add_badrange() is only called by
badrange_add(), so move its content into badrange_add() then delete it.
By the way, move "kfree(bre_new)" out of the lock protection, it really
doesn't need.

Fixes: b3b454f694db ("libnvdimm: fix clear poison locking with spinlock ...")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/nvdimm/badrange.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
index 9fdba8c43e8605e..7f78b659057902d 100644
--- a/drivers/nvdimm/badrange.c
+++ b/drivers/nvdimm/badrange.c
@@ -45,12 +45,12 @@ static int alloc_and_append_badrange_entry(struct badrange *badrange,
 	return 0;
 }
 
-static int add_badrange(struct badrange *badrange, u64 addr, u64 length)
+int badrange_add(struct badrange *badrange, u64 addr, u64 length)
 {
 	struct badrange_entry *bre, *bre_new;
 
-	spin_unlock(&badrange->lock);
 	bre_new = kzalloc(sizeof(*bre_new), GFP_KERNEL);
+
 	spin_lock(&badrange->lock);
 
 	/*
@@ -63,6 +63,7 @@ static int add_badrange(struct badrange *badrange, u64 addr, u64 length)
 			/* If length has changed, update this list entry */
 			if (bre->length != length)
 				bre->length = length;
+			spin_unlock(&badrange->lock);
 			kfree(bre_new);
 			return 0;
 		}
@@ -72,22 +73,15 @@ static int add_badrange(struct badrange *badrange, u64 addr, u64 length)
 	 * as any overlapping ranges will get resolved when the list is consumed
 	 * and converted to badblocks
 	 */
-	if (!bre_new)
+	if (!bre_new) {
+		spin_unlock(&badrange->lock);
 		return -ENOMEM;
-	append_badrange_entry(badrange, bre_new, addr, length);
-
-	return 0;
-}
-
-int badrange_add(struct badrange *badrange, u64 addr, u64 length)
-{
-	int rc;
+	}
 
-	spin_lock(&badrange->lock);
-	rc = add_badrange(badrange, addr, length);
+	append_badrange_entry(badrange, bre_new, addr, length);
 	spin_unlock(&badrange->lock);
 
-	return rc;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(badrange_add);
 
-- 
1.8.3

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
