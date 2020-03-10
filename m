Return-Path: <SRS0=xhOP=43=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF83C10F27
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Mar 2020 21:06:20 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D877D222D9
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Mar 2020 21:06:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSxML8CZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D877D222D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C1A9810FC3633;
	Tue, 10 Mar 2020 14:07:10 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=song@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id CE58210FC3174
	for <linux-nvdimm@lists.01.org>; Tue, 10 Mar 2020 14:07:07 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 3681B2253D
	for <linux-nvdimm@lists.01.org>; Tue, 10 Mar 2020 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583874376;
	bh=vhxZrp2Lx5DeATCenHy71j1LATXknii/r2+vE+Yb5m0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VSxML8CZIv6TujbXRjRw9Ndm8hswQ0Iy4czB2jk6b7uVrcoP7w2FT3QpRGHO/Gfw8
	 1PAC8sWmIxLgfBwLT0IoBg95GgOQJewHjIgNWqAF9o7XsmOF2nFAtuL0aHnkZz6PQW
	 ByM8dtKGpYIidv0mnusE83YjNVcG4UXW3V9qqpcY=
Received: by mail-lf1-f48.google.com with SMTP id x22so12154691lff.5
        for <linux-nvdimm@lists.01.org>; Tue, 10 Mar 2020 14:06:16 -0700 (PDT)
X-Gm-Message-State: ANhLgQ2VSl9A7foEelFLnn1W6C1xGZwV9QdiKOg/Oa4l3jyYEheNtN+r
	bXVO0zcmdLg+HvIH3Z8n+Z6Drrpu7O1p4WvwcJ0=
X-Google-Smtp-Source: ADFU+vudBQrw1oSvW+1z/bikz1NjhAJyNp9q/S1l7eZSBzV8bqzYmhmQtaOP3eZbtp4E2HGJaK7++RE5+JjVfD/y/h8=
X-Received: by 2002:ac2:554d:: with SMTP id l13mr39638lfk.82.1583874374294;
 Tue, 10 Mar 2020 14:06:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200223165724.23816-1-mcroce@redhat.com>
In-Reply-To: <20200223165724.23816-1-mcroce@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 10 Mar 2020 14:06:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6DOkyvscJhxXPE+KLsw=WH6CQ=8_5uThzf7_pmD3E8JA@mail.gmail.com>
Message-ID: <CAPhsuW6DOkyvscJhxXPE+KLsw=WH6CQ=8_5uThzf7_pmD3E8JA@mail.gmail.com>
Subject: Re: [PATCH] block: refactor duplicated macros
To: Matteo Croce <mcroce@redhat.com>
Message-ID-Hash: UZDLE7BPO3XXJ2AG6YV4C36SA22C64PF
X-Message-ID-Hash: UZDLE7BPO3XXJ2AG6YV4C36SA22C64PF
X-MailFrom: song@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-block@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org, linux-bcache@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, linux-mmc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-nfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Ulf Hansson <ulf.hansson@linaro.org>, Anna Schumaker <anna.schumaker@netapp.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/UZDLE7BPO3XXJ2AG6YV4C36SA22C64PF/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Feb 23, 2020 at 8:58 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> The macros PAGE_SECTORS, PAGE_SECTORS_SHIFT and SECTOR_MASK are defined
> several times in different flavours across the whole tree.
> Define them just once in a common header.
>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  block/blk-lib.c                  |  2 +-
>  drivers/block/brd.c              |  3 ---
>  drivers/block/null_blk_main.c    |  4 ----
>  drivers/block/zram/zram_drv.c    |  8 ++++----
>  drivers/block/zram/zram_drv.h    |  2 --
>  drivers/dax/super.c              |  2 +-
>  drivers/md/bcache/util.h         |  2 --
>  drivers/md/dm-bufio.c            |  6 +++---
>  drivers/md/dm-integrity.c        | 10 +++++-----
>  drivers/md/md.c                  |  4 ++--
>  drivers/md/raid1.c               |  2 +-
>  drivers/mmc/core/host.c          |  3 ++-
>  drivers/scsi/xen-scsifront.c     |  4 ++--
>  fs/iomap/buffered-io.c           |  2 +-
>  fs/nfs/blocklayout/blocklayout.h |  2 --
>  include/linux/blkdev.h           |  4 ++++
>  include/linux/device-mapper.h    |  1 -
>  17 files changed, 26 insertions(+), 35 deletions(-)

For md:

Acked-by: Song Liu <song@kernel.org>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
