Return-Path: <SRS0=MGD/=EM=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC71C388F2
	for <linux-nvdimm@archiver.kernel.org>; Fri,  6 Nov 2020 09:25:15 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E1222087E
	for <linux-nvdimm@archiver.kernel.org>; Fri,  6 Nov 2020 09:25:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E1222087E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1EDDB163F9794;
	Fri,  6 Nov 2020 01:25:15 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.191; helo=szxga05-in.huawei.com; envelope-from=liuzhiqiang26@huawei.com; receiver=<UNKNOWN> 
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 84850163F9792
	for <linux-nvdimm@lists.01.org>; Fri,  6 Nov 2020 01:25:13 -0800 (PST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CSFNJ20VHzLsPY
	for <linux-nvdimm@lists.01.org>; Fri,  6 Nov 2020 17:25:04 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.238) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Fri, 6 Nov 2020
 17:25:03 +0800
Subject: [ndctl PATCH 2/8] lib/libndctl: fix memory leakage problem in add_bus
To: <vishal.l.verma@intel.com>
References: <bed3b3b3-1f30-6751-c0bf-15ecf70192f9@huawei.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <8caac123-9d45-c848-d45a-3cb8be5a2708@huawei.com>
Date: Fri, 6 Nov 2020 17:25:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <bed3b3b3-1f30-6751-c0bf-15ecf70192f9@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.174.176.238]
X-CFilter-Loop: Reflected
Message-ID-Hash: CG5FBBEAESRGZURE5IPTNSLPTVEJWZ7C
X-Message-ID-Hash: CG5FBBEAESRGZURE5IPTNSLPTVEJWZ7C
X-MailFrom: liuzhiqiang26@huawei.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org, linfeilong <linfeilong@huawei.com>, liuzhiqiang26@huawei.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CG5FBBEAESRGZURE5IPTNSLPTVEJWZ7C/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


In add_bus(), bus->bus_path is set by calling parent_dev_path(),
which will finally adopt realpath(, NULL) to allocate new path.
However, bus->bus_path will not be freed in err_read tag, then,
memory leakage occurs.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 ndctl/lib/libndctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ad521d3..3926382 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -975,6 +975,7 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
 	free(bus->wait_probe_path);
 	free(bus->scrub_path);
 	free(bus->provider);
+	free(bus->bus_path);
 	free(bus->bus_buf);
 	free(bus);
  err_bus:
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
