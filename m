Return-Path: <SRS0=P5fg=CY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB046C43461
	for <linux-nvdimm@archiver.kernel.org>; Tue, 15 Sep 2020 13:00:38 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 05160206A2
	for <linux-nvdimm@archiver.kernel.org>; Tue, 15 Sep 2020 13:00:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i5K3OE7S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05160206A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5861F1412E9B6;
	Tue, 15 Sep 2020 06:00:36 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 4161E13DBACD4
	for <linux-nvdimm@lists.01.org>; Tue, 15 Sep 2020 06:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lkoNIbONVqF9nSz1AszaHz6Z+J30dE2f9beUAwTaZcc=; b=i5K3OE7SFBGKzf1l2VQ+66Mgjc
	bAqGc9muaSLpQwTotBgO8IOZXrdplnjJkOelvBrS7Y2om70xTTevSBiI6srw7p9lO9YWSvXzR+3aT
	OI0QDSkVCwnpLyigJD4S+HMgv2Hke5iB274kwKSnVnHs6Tfm7OVNa92ecpFHVQ2+4HiHuVcgImdJs
	TXeO+8wDrn+X0IXPb0gSeid49s6FLwffFpoQnnZVT2JdkC1NFDBck5+NFyFV+oB6Y8fJg/6gb5a6Y
	k7dZT5Sv2ITb0v2FhsM2Wy21Yj1Zbj1lPhtsdJC4uBZQ/oE4XqI2iJLFZO0e+EVJVMelT+C1QfdeK
	4dM8T94Q==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kIAZA-0000EE-Mf; Tue, 15 Sep 2020 13:00:12 +0000
Date: Tue, 15 Sep 2020 14:00:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC] nvfs: a filesystem for persistent memory
Message-ID: <20200915130012.GC5449@casper.infradead.org>
References: <alpine.LRH.2.02.2009140852030.22422@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2009140852030.22422@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID-Hash: A2HA5JB5EDOF5GFJHT2OKWWM3IMFGPBH
X-Message-ID-Hash: A2HA5JB5EDOF5GFJHT2OKWWM3IMFGPBH
X-MailFrom: willy@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Eric Sandeen <esandeen@redhat.com>, Dave Chinner <dchinner@redhat.com>, "Tadakamadla, Rajesh (DCIG/CDI/HPS Perf)" <rajesh.tadakamadla@hpe.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/A2HA5JB5EDOF5GFJHT2OKWWM3IMFGPBH/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 15, 2020 at 08:34:41AM -0400, Mikulas Patocka wrote:
> - when the fsck.nvfs tool mmaps the device /dev/pmem0, the kernel uses 
> buffer cache for the mapping. The buffer cache slows does fsck by a factor 
> of 5 to 10. Could it be possible to change the kernel so that it maps DAX 
> based block devices directly?

Oh, because fs/block_dev.c has:
        .mmap           = generic_file_mmap,

I don't see why we shouldn't have a blkdev_mmap modelled after
ext2_file_mmap() with the corresponding blkdev_dax_vm_ops.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
