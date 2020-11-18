Return-Path: <SRS0=2dSd=EY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BA9C6369E
	for <linux-nvdimm@archiver.kernel.org>; Wed, 18 Nov 2020 07:36:33 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 868A0221E9
	for <linux-nvdimm@archiver.kernel.org>; Wed, 18 Nov 2020 07:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 868A0221E9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id EEFAD100EBBC0;
	Tue, 17 Nov 2020 23:36:31 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.190; helo=szxga04-in.huawei.com; envelope-from=thunder.leizhen@huawei.com; receiver=<UNKNOWN> 
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 0AB3C100EC1D5
	for <linux-nvdimm@lists.01.org>; Tue, 17 Nov 2020 23:36:28 -0800 (PST)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CbZP56gTbz15MsB;
	Wed, 18 Nov 2020 15:36:09 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.176.144) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Wed, 18 Nov 2020 15:36:13 +0800
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown
	<lenb@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-acpi
	<linux-acpi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] ACPI/nfit: avoid accessing uninitialized memory in acpi_nfit_ctl()
Date: Wed, 18 Nov 2020 15:35:17 +0800
Message-ID: <20201118073517.1884-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.176.144]
X-CFilter-Loop: Reflected
Message-ID-Hash: LUU3R4CN6W7VKJQO4T7QBJZJG76XKFAY
X-Message-ID-Hash: LUU3R4CN6W7VKJQO4T7QBJZJG76XKFAY
X-MailFrom: thunder.leizhen@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Zhen Lei <thunder.leizhen@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/LUU3R4CN6W7VKJQO4T7QBJZJG76XKFAY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The ACPI_ALLOCATE() does not zero the "buf", so when the condition
"integer->type != ACPI_TYPE_INTEGER" in int_to_buf() is met, the result
is unpredictable in acpi_nfit_ctl().

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/acpi/nfit/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 442608220b5c..cda7b6c52504 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -282,18 +282,19 @@ static union acpi_object *pkg_to_buf(union acpi_object *pkg)
 
 static union acpi_object *int_to_buf(union acpi_object *integer)
 {
-	union acpi_object *buf = ACPI_ALLOCATE(sizeof(*buf) + 4);
+	union acpi_object *buf = NULL;
 	void *dst = NULL;
 
-	if (!buf)
-		goto err;
-
 	if (integer->type != ACPI_TYPE_INTEGER) {
 		WARN_ONCE(1, "BIOS bug, unexpected element type: %d\n",
 				integer->type);
 		goto err;
 	}
 
+	buf = ACPI_ALLOCATE(sizeof(*buf) + 4);
+	if (!buf)
+		goto err;
+
 	dst = buf + 1;
 	buf->type = ACPI_TYPE_BUFFER;
 	buf->buffer.length = 4;
-- 
2.26.0.106.g9fadedd

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
