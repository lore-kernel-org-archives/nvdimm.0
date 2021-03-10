Return-Path: <SRS0=QSYE=II=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D9FC433E0
	for <linux-nvdimm@archiver.kernel.org>; Wed, 10 Mar 2021 14:21:49 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B694E64FF2
	for <linux-nvdimm@archiver.kernel.org>; Wed, 10 Mar 2021 14:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B694E64FF2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 96F98100EB346;
	Wed, 10 Mar 2021 06:21:48 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=195.135.220.15; helo=mx2.suse.de; envelope-from=rgoldwyn@suse.de; receiver=<UNKNOWN> 
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 10E15100EB338
	for <linux-nvdimm@lists.01.org>; Wed, 10 Mar 2021 06:21:44 -0800 (PST)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 7ACEEAEB6;
	Wed, 10 Mar 2021 14:21:42 +0000 (UTC)
Date: Wed, 10 Mar 2021 08:21:59 -0600
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 00/10] fsdax,xfs: Add reflink&dedupe support for fsdax
Message-ID: <20210310142159.kudk7q2ogp4yqn36@fiona>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
 <CAEg-Je-OLidbfzHCJvY55x+-cOfiUxX8CJ1AeN8VxXAVuVyxKQ@mail.gmail.com>
 <20210310130227.GN3479805@casper.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210310130227.GN3479805@casper.infradead.org>
Message-ID-Hash: 2RVWIM5ARZGGMCM2FRE2LDY7QTZ75DKK
X-Message-ID-Hash: 2RVWIM5ARZGGMCM2FRE2LDY7QTZ75DKK
X-MailFrom: rgoldwyn@suse.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Neal Gompa <ngompa13@gmail.com>, Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, darrick.wong@oracle.com, jack@suse.cz, viro@zeniv.linux.org.uk, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com, david@fromorbit.com, hch@lst.de
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/2RVWIM5ARZGGMCM2FRE2LDY7QTZ75DKK/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 13:02 10/03, Matthew Wilcox wrote:
> On Wed, Mar 10, 2021 at 07:30:41AM -0500, Neal Gompa wrote:
> > Forgive my ignorance, but is there a reason why this isn't wired up to
> > Btrfs at the same time? It seems weird to me that adding a feature
> 
> btrfs doesn't support DAX.  only ext2, ext4, XFS and FUSE have DAX support.
> 
> If you think about it, btrfs and DAX are diametrically opposite things.
> DAX is about giving raw access to the hardware.  btrfs is about offering
> extra value (RAID, checksums, ...), none of which can be done if the
> filesystem isn't in the read/write path.
> 
> That's why there's no DAX support in btrfs.  If you want DAX, you have
> to give up all the features you like in btrfs.  So you may as well use
> a different filesystem.

DAX on btrfs has been attempted[1]. Of course, we could not
have checksums or multi-device with it. However, got stuck on
associating a shared extent on the same page mapping: basically the
TODO above dax_associate_entry().

Shiyang has proposed a way to disassociate existing mapping, but I
don't think that is the best solution. DAX for CoW will not work until
we have a way of mapping a page to multiple inodes (page->mapping),
which will convert a 1-N inode-page mapping to M-N inode-page mapping.

[1] https://lore.kernel.org/linux-btrfs/20190429172649.8288-1-rgoldwyn@suse.de/

-- 
Goldwyn
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
