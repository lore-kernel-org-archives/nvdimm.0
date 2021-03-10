Return-Path: <SRS0=QSYE=II=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B092FC433E0
	for <linux-nvdimm@archiver.kernel.org>; Wed, 10 Mar 2021 08:43:40 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1AA1E64FC0
	for <linux-nvdimm@archiver.kernel.org>; Wed, 10 Mar 2021 08:43:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1AA1E64FC0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8056E100EB847;
	Wed, 10 Mar 2021 00:43:39 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=batv+d0112929388aaa884b04+6408+infradead.org+hch@casper.srs.infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id EF4F2100EBBB1
	for <linux-nvdimm@lists.01.org>; Wed, 10 Mar 2021 00:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vuo0YO0EmNV+mXqkprYzB4nCqf8LGaGX/f4JDhgk+/c=; b=p5AuWvLaCuU/C/3qq+kaSkAvEX
	vKtvFB/7Pp0l8OQ3Hjlgt+Gdlmojl2GcVfJbK4oNDb9uSkjuuv+5a031m7RPru5IcZ4nDfGvAcPLP
	/o4zZS1IoPw8SJiu9OZJ0Faw4XwOc/+hE7aaJPNXsN38Rncqkt3JkXuCv1yFBvP3t3Fnwn8PMRTSb
	fOURb9Y8kLuFYaShP/FZCe6WHdluCvBaxzGooPslnZlVQyZzqVgJTgt6AMwprhJyZWlwvJYkLMIMC
	d2+KDFOGqNEsTMq2HRRaKT0CRvQEdZ3/Z/YXqWFBshlfHqLYe81+af++AJslw0/Tk8BFBQVLYj/+a
	FrK7yhRA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
	id 1lJuR7-002uDa-4t; Wed, 10 Mar 2021 08:43:24 +0000
Date: Wed, 10 Mar 2021 08:43:21 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: Re: [PATCH v2] include: Remove pagemap.h from blkdev.h
Message-ID: <20210310084321.GA682482@infradead.org>
References: <20210309195747.283796-1-willy@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210309195747.283796-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Message-ID-Hash: HWW3DRLXLYKJK2CCJG534VQRJPXBKDFZ
X-Message-ID-Hash: HWW3DRLXLYKJK2CCJG534VQRJPXBKDFZ
X-MailFrom: BATV+d0112929388aaa884b04+6408+infradead.org+hch@casper.srs.infradead.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/HWW3DRLXLYKJK2CCJG534VQRJPXBKDFZ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 09, 2021 at 07:57:47PM +0000, Matthew Wilcox (Oracle) wrote:
> My UEK-derived config has 1030 files depending on pagemap.h before
> this change.  Afterwards, just 326 files need to be rebuilt when I
> touch pagemap.h.  I think blkdev.h is probably included too widely,
> but untangling that dependency is harder and this solves my problem.
> x86 allmodconfig builds, but there may be implicit include problems
> on other architectures.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
> v2: Fix CONFIG_SWAP=n implicit use of pagemap.h by swap.h.  Increases
>     the number of files from 240, but that's still a big win -- 68%
>     reduction instead of 77%.

Looks good.  I suspect blkdev.h also has penty of other includes that
aren't needed either..

Reviewed-by: Christoph Hellwig <hch@lst.de>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
