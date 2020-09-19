Return-Path: <SRS0=/MmL=C4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2988DC43464
	for <linux-nvdimm@archiver.kernel.org>; Sat, 19 Sep 2020 11:13:06 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B54FD2158C
	for <linux-nvdimm@archiver.kernel.org>; Sat, 19 Sep 2020 11:13:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B54FD2158C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 741CD152A3651;
	Sat, 19 Sep 2020 04:13:05 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.35; helo=huawei.com; envelope-from=thunder.leizhen@huawei.com; receiver=<UNKNOWN> 
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 40074152BD437
	for <linux-nvdimm@lists.01.org>; Sat, 19 Sep 2020 04:12:54 -0700 (PDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
	by Forcepoint Email with ESMTP id 47FCEF26C25183634819;
	Sat, 19 Sep 2020 19:12:52 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.253) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 19:12:43 +0800
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Oliver O'Halloran <oohall@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Markus
 Elfring <Markus.Elfring@web.de>, linux-nvdimm <linux-nvdimm@lists.01.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] libnvdimm: slightly simplify available_slots_show()
Date: Sat, 19 Sep 2020 19:11:12 +0800
Message-ID: <20200919111112.4074-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.177.253]
X-CFilter-Loop: Reflected
Message-ID-Hash: YR7DGSMFSGJHGAFQ2MP7JOAQ2TMEGK5O
X-Message-ID-Hash: YR7DGSMFSGJHGAFQ2MP7JOAQ2TMEGK5O
X-MailFrom: thunder.leizhen@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Zhen Lei <thunder.leizhen@huawei.com>, Libin <huawei.libin@huawei.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YR7DGSMFSGJHGAFQ2MP7JOAQ2TMEGK5O/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The type of "nfree" is u32, so "nfree - 1" can only be overflowed when
"nfree" is zero. Replace "if (nfree - 1 > nfree)" with "if (nfree == 0)"
seems more clear. And remove the assignment "nfree = 0", no need for it.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
v1 --> v2:
No change, just sent separately

v1:
https://lkml.org/lkml/2020/8/19/1465

 drivers/nvdimm/dimm_devs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index b59032e0859b7f3..d6835f127d83055 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -347,10 +347,9 @@ static ssize_t available_slots_show(struct device *dev,
 
 	nvdimm_bus_lock(dev);
 	nfree = nd_label_nfree(ndd);
-	if (nfree - 1 > nfree) {
+	if (nfree == 0)
 		dev_WARN_ONCE(dev, 1, "we ate our last label?\n");
-		nfree = 0;
-	} else
+	else
 		nfree--;
 	rc = sprintf(buf, "%d\n", nfree);
 	nvdimm_bus_unlock(dev);
-- 
1.8.3

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
