Return-Path: <SRS0=1yzT=ZA=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8A4FA372C
	for <linux-nvdimm@archiver.kernel.org>; Fri,  8 Nov 2019 03:11:19 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D5B9E21882
	for <linux-nvdimm@archiver.kernel.org>; Fri,  8 Nov 2019 03:11:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5B9E21882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9943F100EA625;
	Thu,  7 Nov 2019 19:13:40 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=183.91.158.132; helo=heian.cn.fujitsu.com; envelope-from=ruansy.fnst@cn.fujitsu.com; receiver=<UNKNOWN> 
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by ml01.01.org (Postfix) with ESMTP id A08C8100EEB95
	for <linux-nvdimm@lists.01.org>; Thu,  7 Nov 2019 19:13:38 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.68,280,1569254400";
   d="scan'208";a="78040346"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 08 Nov 2019 11:10:57 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id A9B984B6AE15;
	Fri,  8 Nov 2019 11:02:52 +0800 (CST)
Received: from [10.167.225.140] (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Fri, 8 Nov 2019 11:11:05 +0800
Subject: Re: [RFC PATCH v2 0/7] xfs: reflink & dedupe for fsdax (read/write
 path).
To: <linux-xfs@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
	<darrick.wong@oracle.com>, <rgoldwyn@suse.de>, <hch@infradead.org>,
	<david@fromorbit.com>
References: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <e33532a2-a9e5-1578-bdd8-a83d4710a151@cn.fujitsu.com>
Date: Fri, 8 Nov 2019 11:10:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
Content-Language: en-US
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: A9B984B6AE15.AC5F9
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
Message-ID-Hash: ZORPBCBGU6SILWCINN3EB3HCWWOPVPMZ
X-Message-ID-Hash: ZORPBCBGU6SILWCINN3EB3HCWWOPVPMZ
X-MailFrom: ruansy.fnst@cn.fujitsu.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-kernel@vger.kernel.org, gujx@cn.fujitsu.com, qi.fuli@fujitsu.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ZORPBCBGU6SILWCINN3EB3HCWWOPVPMZ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit

Hi Darrick, Dave,

Do you have any comment on this?

On 10/30/19 12:13 PM, Shiyang Ruan wrote:
> This patchset aims to take care of this issue to make reflink and dedupe
> work correctly (actually in read/write path, there still has some problems,
> such as the page->mapping and page->index issue, in mmap path) in XFS under
> fsdax mode.
> 
> It is based on Goldwyn's patchsets: "v4 Btrfs dax support" and the latest
> iomap.  I borrowed some patches related and made a few fix to make it
> basically works fine.
> 
> For dax framework:
>    1. adapt to the latest change in iomap (two iomaps).
> 
> For XFS:
>    1. distinguish dax write/zero from normal write/zero.
>    2. remap extents after COW.
>    3. add file contents comparison function based on dax framework.
>    4. use xfs_break_layouts() instead of break_layout to support dax.
> 
> 
> Goldwyn Rodrigues (3):
>    dax: replace mmap entry in case of CoW
>    fs: dedup file range to use a compare function
>    dax: memcpy before zeroing range
> 
> Shiyang Ruan (4):
>    dax: Introduce dax_copy_edges() for COW.
>    dax: copy data before write.
>    xfs: handle copy-on-write in fsdax write() path.
>    xfs: support dedupe for fsdax.
> 
>   fs/btrfs/ioctl.c       |   3 +-
>   fs/dax.c               | 211 +++++++++++++++++++++++++++++++++++++----
>   fs/iomap/buffered-io.c |   8 +-
>   fs/ocfs2/file.c        |   2 +-
>   fs/read_write.c        |  11 ++-
>   fs/xfs/xfs_bmap_util.c |   6 +-
>   fs/xfs/xfs_file.c      |  10 +-
>   fs/xfs/xfs_iomap.c     |   3 +-
>   fs/xfs/xfs_iops.c      |  11 ++-
>   fs/xfs/xfs_reflink.c   |  79 ++++++++-------
>   include/linux/dax.h    |  16 ++--
>   include/linux/fs.h     |   9 +-
>   12 files changed, 291 insertions(+), 78 deletions(-)
> 

-- 
Thanks,
Shiyang Ruan.

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
