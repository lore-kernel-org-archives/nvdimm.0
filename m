Return-Path: <SRS0=BojM=GC=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A49C433DB
	for <linux-nvdimm@archiver.kernel.org>; Wed, 30 Dec 2020 16:58:45 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 41DB0216C4
	for <linux-nvdimm@archiver.kernel.org>; Wed, 30 Dec 2020 16:58:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41DB0216C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 86CA0100EC1D9;
	Wed, 30 Dec 2020 08:58:44 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=183.91.158.132; helo=heian.cn.fujitsu.com; envelope-from=ruansy.fnst@cn.fujitsu.com; receiver=<UNKNOWN> 
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by ml01.01.org (Postfix) with ESMTP id 91F95100EC1D6
	for <linux-nvdimm@lists.01.org>; Wed, 30 Dec 2020 08:58:41 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.78,461,1599494400";
   d="scan'208";a="103085829"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Dec 2020 00:58:39 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id 0FEBE4CE601C;
	Thu, 31 Dec 2020 00:58:34 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 31 Dec 2020 00:58:34 +0800
Received: from irides.mr (10.167.225.141) by G08CNEXCHPEKD04.g08.fujitsu.local
 (10.167.33.209) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 31 Dec 2020 00:58:33 +0800
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-nvdimm@lists.01.org>, <linux-mm@kvack.org>
Subject: [PATCH 01/10] pagemap: Introduce ->memory_failure()
Date: Thu, 31 Dec 2020 00:55:52 +0800
Message-ID: <20201230165601.845024-2-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201230165601.845024-1-ruansy.fnst@cn.fujitsu.com>
References: <20201230165601.845024-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 0FEBE4CE601C.A1747
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
Message-ID-Hash: CSPUW5CYUR3AQBRCTSIIDN55RSQFRPOD
X-Message-ID-Hash: CSPUW5CYUR3AQBRCTSIIDN55RSQFRPOD
X-MailFrom: ruansy.fnst@cn.fujitsu.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, hch@lst.de, song@kernel.org, rgoldwyn@suse.de, qi.fuli@fujitsu.com, y-goto@fujitsu.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CSPUW5CYUR3AQBRCTSIIDN55RSQFRPOD/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When memory-failure occurs, we call this function which is implemented
by each kind of devices.  For the fsdax case, pmem device driver
implements it.  Pmem device driver will find out the block device where
the error page locates in, and try to get the filesystem on this block
device.  And finally call filesystem handler to deal with the error.
The filesystem will try to recover the corrupted data if possiable.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 include/linux/memremap.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 79c49e7f5c30..0bcf2b1e20bd 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -87,6 +87,14 @@ struct dev_pagemap_ops {
 	 * the page back to a CPU accessible page.
 	 */
 	vm_fault_t (*migrate_to_ram)(struct vm_fault *vmf);
+
+	/*
+	 * Handle the memory failure happens on one page.  Notify the processes
+	 * who are using this page, and try to recover the data on this page
+	 * if necessary.
+	 */
+	int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
+			      int flags);
 };
 
 #define PGMAP_ALTMAP_VALID	(1 << 0)
-- 
2.29.2


_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
