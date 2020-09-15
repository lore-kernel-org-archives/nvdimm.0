Return-Path: <SRS0=P5fg=CY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D84C43461
	for <linux-nvdimm@archiver.kernel.org>; Tue, 15 Sep 2020 10:13:26 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4AAB4206E6
	for <linux-nvdimm@archiver.kernel.org>; Tue, 15 Sep 2020 10:13:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AAB4206E6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 012C814C1D6C1;
	Tue, 15 Sep 2020 03:13:26 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=183.91.158.132; helo=heian.cn.fujitsu.com; envelope-from=ruansy.fnst@cn.fujitsu.com; receiver=<UNKNOWN> 
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by ml01.01.org (Postfix) with ESMTP id 415981412ED97
	for <linux-nvdimm@lists.01.org>; Tue, 15 Sep 2020 03:13:22 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.76,429,1592841600";
   d="scan'208";a="99252004"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 15 Sep 2020 18:13:19 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 2B52448990DF;
	Tue, 15 Sep 2020 18:13:14 +0800 (CST)
Received: from G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.203) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 15 Sep 2020 18:13:12 +0800
Received: from localhost.localdomain (10.167.225.141) by
 G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Tue, 15 Sep 2020 18:13:11 +0800
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-nvdimm@lists.01.org>, <linux-mm@kvack.org>
Subject: [RFC PATCH 0/4] fsdax: introduce fs query to support reflink
Date: Tue, 15 Sep 2020 18:13:07 +0800
Message-ID: <20200915101311.144269-1-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 2B52448990DF.AB1A2
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
Message-ID-Hash: XPZTCYNJYQV4TSXMOVD43GJA3FD54KS3
X-Message-ID-Hash: XPZTCYNJYQV4TSXMOVD43GJA3FD54KS3
X-MailFrom: ruansy.fnst@cn.fujitsu.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, hch@lst.de, rgoldwyn@suse.de, qi.fuli@fujitsu.com, y-goto@fujitsu.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/XPZTCYNJYQV4TSXMOVD43GJA3FD54KS3/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset is a try to resolve the problem of tracking shared page
for fsdax.

This patchset moves owner tracking from dax_assocaite_entry() to pmem
device, by introducing an interface ->memory_failure() of struct
pagemap.  The interface is called by memory_failure() in mm, and
implemented by pmem device.  Then pmem device find the filesystem
which the damaged page located in, and call ->storage_lost() to track
files or metadata assocaited with this page.  Finally we are able to
try to fix the damaged data in filesystem and do other necessary
processing, such as killing processes who are using the files
affected.

The call trace is like this:
 memory_failure()
   pgmap->ops->memory_failure()      => pmem_pgmap_memory_failure()
     bdev->bd_super->storage_lost()  => xfs_fs_storage_lost()
       xfs_rmap_query_range()
         xfs_storage_lost_helper()
           mf_recover_controller->recover_fn => \ 
                            memory_failure_dev_pagemap_kill_procs()

The collect_procs() and kill_procs() are moved into a callback which
is passed from memory_failure() to xfs_storage_lost_helper().  So we
can call it when a file assocaited is found, instead of creating a
file list and iterate it.

The fsdax & reflink support for XFS is not contained in this patchset.

(Rebased on v5.9-rc2)
==

Shiyang Ruan (4):
  fs: introduce ->storage_lost() for memory-failure
  pagemap: introduce ->memory_failure()
  mm, fsdax: refactor dax handler in memory-failure
  fsdax: remove useless (dis)associate functions

 block/genhd.c            |  12 ++++
 drivers/nvdimm/pmem.c    |  31 ++++++++++
 fs/dax.c                 |  64 ++------------------
 fs/xfs/xfs_super.c       |  80 ++++++++++++++++++++++++
 include/linux/dax.h      |   5 +-
 include/linux/fs.h       |   1 +
 include/linux/genhd.h    |   2 +
 include/linux/memremap.h |   3 +
 include/linux/mm.h       |  14 +++++
 mm/memory-failure.c      | 127 ++++++++++++++++++++++++---------------
 10 files changed, 229 insertions(+), 110 deletions(-)

-- 
2.28.0


_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
