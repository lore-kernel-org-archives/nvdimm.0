Return-Path: <SRS0=Oj3b=JE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E612C43461
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Apr 2021 06:32:29 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 741FB613C0
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Apr 2021 06:32:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 741FB613C0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C4382100F225A;
	Tue,  6 Apr 2021 23:32:27 -0700 (PDT)
Received-SPF: Neutral (mailfrom) identity=mailfrom; client-ip=183.91.158.132; helo=heian.cn.fujitsu.com; envelope-from=ruansy.fnst@fujitsu.com; receiver=<UNKNOWN> 
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by ml01.01.org (Postfix) with ESMTP id 55871100F2251
	for <linux-nvdimm@lists.01.org>; Tue,  6 Apr 2021 23:32:24 -0700 (PDT)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A/Djejqsh0w9I/QyV1ybf6HI87skDltV00zAX?=
 =?us-ascii?q?/kB9WHVpW+afkN2jm+le6A/shF8qKRUdsP2jGI3Fe3PT8pZp/ZIcVI3OYCDKsH?=
 =?us-ascii?q?alRbsN0aLMzzHsECX19Kp8+M5bGZRWJ8b3CTFB7PrSxCmdP5IezMKc8Kau7N2u?=
 =?us-ascii?q?qktFaQ1xcalv40NYJ2+gYy5LbTJLD5Y4C5aQj/Avz1WdUE4KZce2DGRtZZmgm/?=
 =?us-ascii?q?T3kvvdASIuNloO7QmiqXeS4qfmLh7w5HwjegIK7bA80WWtqWDE2pk=3D?=
X-IronPort-AV: E=Sophos;i="5.82,201,1613404800";
   d="scan'208";a="106725722"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 07 Apr 2021 14:32:22 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 3DFE44D0B8AA;
	Wed,  7 Apr 2021 14:32:21 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Wed, 7 Apr 2021 14:32:10 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Wed, 7 Apr 2021 14:32:10 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-nvdimm@lists.01.org>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/3] fsdax: Factor helper functions to simplify the code
Date: Wed, 7 Apr 2021 14:32:04 +0800
Message-ID: <20210407063207.676753-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 3DFE44D0B8AA.A2CF3
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
Message-ID-Hash: LCX4ZBKDTCUNDGR3CP6P67I66DX27P24
X-Message-ID-Hash: LCX4ZBKDTCUNDGR3CP6P67I66DX27P24
X-MailFrom: ruansy.fnst@fujitsu.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: darrick.wong@oracle.com, willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk, linux-btrfs@vger.kernel.org, david@fromorbit.com, hch@lst.de, rgoldwyn@suse.de
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/LCX4ZBKDTCUNDGR3CP6P67I66DX27P24/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The page fault part of fsdax code is little complex. In order to add CoW
feature and make it easy to understand, I was suggested to factor some
helper functions to simplify the current dax code.

(Rebased on v5.12-rc5)
==

Shiyang Ruan (3):
  fsdax: Factor helpers to simplify dax fault code
  fsdax: Factor helper: dax_fault_actor()
  fsdax: Output address in dax_iomap_pfn() and rename it

 fs/dax.c | 438 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 232 insertions(+), 206 deletions(-)

-- 
2.31.0


_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
