Return-Path: <SRS0=MGD/=EM=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_40,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995FFC2D0A3
	for <linux-nvdimm@archiver.kernel.org>; Fri,  6 Nov 2020 09:23:37 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 77F83208B3
	for <linux-nvdimm@archiver.kernel.org>; Fri,  6 Nov 2020 09:23:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77F83208B3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A82461673C06E;
	Fri,  6 Nov 2020 01:23:35 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.191; helo=szxga05-in.huawei.com; envelope-from=liuzhiqiang26@huawei.com; receiver=<UNKNOWN> 
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9DBF41673C068
	for <linux-nvdimm@lists.01.org>; Fri,  6 Nov 2020 01:23:33 -0800 (PST)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CSFLQ1Cz7zhdXb
	for <linux-nvdimm@lists.01.org>; Fri,  6 Nov 2020 17:23:26 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.238) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Fri, 6 Nov 2020
 17:23:23 +0800
To: <vishal.l.verma@intel.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [ndctl PATCH 0/8] fix serverl issues reported by Coverity
Message-ID: <bed3b3b3-1f30-6751-c0bf-15ecf70192f9@huawei.com>
Date: Fri, 6 Nov 2020 17:23:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Language: en-US
X-Originating-IP: [10.174.176.238]
X-CFilter-Loop: Reflected
Message-ID-Hash: TRBHY4EVDWZ2CE7T2FD6FYR5ZWY4RSIB
X-Message-ID-Hash: TRBHY4EVDWZ2CE7T2FD6FYR5ZWY4RSIB
X-MailFrom: liuzhiqiang26@huawei.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org, linfeilong <linfeilong@huawei.com>, liuzhiqiang26@huawei.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/TRBHY4EVDWZ2CE7T2FD6FYR5ZWY4RSIB/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Recently, we use Coverity to analysis the ndctl package.
Several issues should be resolved to make Coverity happy.

lihaotian9 (8):
  namespace: check whether pfn|dax|btt is NULL in setup_namespace
  lib/libndctl: fix memory leakage problem in add_bus
  libdaxctl: fix memory leakage in add_dax_region()
  dimm: fix potential fd leakage in dimm_action()
  util/help: check whether strdup returns NULL in exec_man_konqueror
  lib/inject: check whether cmd is created successfully
  libndctl: check whether ndctl_btt_get_namespace returns NULL in
    callers
  namespace: check whether seed is NULL in validate_namespace_options

 daxctl/lib/libdaxctl.c |  3 +++
 ndctl/dimm.c           | 12 +++++++-----
 ndctl/lib/inject.c     |  8 ++++++++
 ndctl/lib/libndctl.c   |  1 +
 ndctl/namespace.c      | 23 ++++++++++++++++++-----
 test/libndctl.c        | 16 +++++++++++-----
 test/parent-uuid.c     |  2 +-
 util/help.c            |  8 +++++++-
 util/json.c            |  3 +++
 9 files changed, 59 insertions(+), 17 deletions(-)

-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
