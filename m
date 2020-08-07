Return-Path: <SRS0=04Zv=BR=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF04C433E1
	for <linux-nvdimm@archiver.kernel.org>; Fri,  7 Aug 2020 13:13:50 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3A7A92224D
	for <linux-nvdimm@archiver.kernel.org>; Fri,  7 Aug 2020 13:13:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A7A92224D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 0DA2E12C2F60A;
	Fri,  7 Aug 2020 06:13:50 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=183.91.158.132; helo=heian.cn.fujitsu.com; envelope-from=ruansy.fnst@cn.fujitsu.com; receiver=<UNKNOWN> 
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by ml01.01.org (Postfix) with ESMTP id 2173212C2F605
	for <linux-nvdimm@lists.01.org>; Fri,  7 Aug 2020 06:13:46 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.75,445,1589212800";
   d="scan'208";a="97774911"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 07 Aug 2020 21:13:42 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 807F34CE34DD;
	Fri,  7 Aug 2020 21:13:36 +0800 (CST)
Received: from G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 7 Aug 2020 21:13:38 +0800
Received: from localhost.localdomain (10.167.225.141) by
 G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Fri, 7 Aug 2020 21:13:36 +0800
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-nvdimm@lists.01.org>
Subject: [RFC PATCH 0/8] fsdax: introduce FS query interface to support reflink
Date: Fri, 7 Aug 2020 21:13:28 +0800
Message-ID: <20200807131336.318774-1-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 807F34CE34DD.AD5BB
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
Message-ID-Hash: YNPPXHQZLJZRFFUFINVTVZOX7G3TIGPD
X-Message-ID-Hash: YNPPXHQZLJZRFFUFINVTVZOX7G3TIGPD
X-MailFrom: ruansy.fnst@cn.fujitsu.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, hch@lst.de, rgoldwyn@suse.de, qi.fuli@fujitsu.com, y-goto@fujitsu.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YNPPXHQZLJZRFFUFINVTVZOX7G3TIGPD/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset is a try to resolve the problem of tracking shared page
for fsdax.

Instead of per-page tracking method, this patchset introduces a query
interface: get_shared_files(), which is implemented by each FS, to
obtain the owners of a shared page.  It returns an owner list of this
shared page.  Then, the memory-failure() iterates the list to be able
to notify each process using files that sharing this page.

The design of the tracking method is as follow:
1. dax_assocaite_entry() associates the owner's info to this page
- For non-reflink case:
  page->mapping,->index stores the file's mapping, offset in file.
    A dax page is not shared by other files. dax_associate_entry() is
    called only once.  So, use page->mapping,->index to store the
    owner's info.
- For reflink case:
  page->mapping,->index stores the block device, offset in device.
    A dax page is shared more than once.  So, dax_assocaite_entry()
    will be called more than once.  We introduce page->zone_device_data
    as reflink counter, to indicate that this page is shared and how
    many owners now is using this page. The page->mapping,->index is
    used to store the block_device of the fs and page offset of this
    device.

2. dax_lock_page() calls query interface to lock each dax entry
- For non-reflink case:
  owner's info is stored in page->mapping,->index.
    So, It is easy to lock its dax entry.
- For reflink case:
  owner's info is obtained by calling get_shared_files(), which is
  implemented by FS.
    The FS context could be found in block_device that stored by
    page->mapping.  Then lock the dax entries of the owners.

In memory-failure(), since the owner list has been obtained in 
dax_lock_page(), just iterate the list and handle the error.  This
patchset didn't handle the memory failure on metadata of FS because
I haven't found a way to distinguish whether this page contains
matadata yet.  Still working on it.

==
I also borrowed and made some changes on Goldwyn's patchsets.
These patches makes up for the lack of CoW mechanism in fsdax.

The rests are dax & reflink support for xfs.

(Rebased on v5.8)
==
Shiyang Ruan (8):
  fs: introduce get_shared_files() for dax&reflink
  fsdax, mm: track files sharing dax page for memory-failure
  fsdax: introduce dax_copy_edges() for COW
  fsdax: copy data before write
  fsdax: replace mmap entry in case of CoW
  fsdax: dedup file range to use a compare function
  fs/xfs: handle CoW for fsdax write() path
  fs/xfs: support dedupe for fsdax

 fs/btrfs/reflink.c     |   3 +-
 fs/dax.c               | 302 +++++++++++++++++++++++++++++++++++------
 fs/ocfs2/file.c        |   2 +-
 fs/read_write.c        |  11 +-
 fs/xfs/xfs_bmap_util.c |   6 +-
 fs/xfs/xfs_file.c      |  10 +-
 fs/xfs/xfs_iomap.c     |   3 +-
 fs/xfs/xfs_iops.c      |  11 +-
 fs/xfs/xfs_reflink.c   |  80 ++++++-----
 fs/xfs/xfs_super.c     |  67 +++++++++
 include/linux/dax.h    |  18 ++-
 include/linux/fs.h     |  11 +-
 include/linux/mm.h     |   8 ++
 mm/memory-failure.c    | 138 ++++++++++++-------
 14 files changed, 529 insertions(+), 141 deletions(-)

-- 
2.27.0


_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
