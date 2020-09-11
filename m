Return-Path: <SRS0=naoF=CU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 002D5C43461
	for <linux-nvdimm@archiver.kernel.org>; Fri, 11 Sep 2020 06:43:03 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5FDDE221EF
	for <linux-nvdimm@archiver.kernel.org>; Fri, 11 Sep 2020 06:43:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iOa8WVA0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FDDE221EF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id F23BC13E23E5E;
	Thu, 10 Sep 2020 23:43:02 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=batv+8b03dcf5e621e88c3391+6228+infradead.org+hch@casper.srs.infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 0E28B13E23E5B
	for <linux-nvdimm@lists.01.org>; Thu, 10 Sep 2020 23:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aIvY0q20GUY/DyC1n3nmNDnvd2ld2xPPMKNm8jNNfkM=; b=iOa8WVA07pDrSye4+Sgz/bCdG7
	rG9Wvg4hwkJeg9OyR+jG6wGqjzEWeTJPBPRlulGaPOS8UQZBVL3v+KPzz0WfLKwmrsxExuJ5t5xC5
	g3J0StagGG7heOkmNejJ2RO5a5Kvk0eL9K7O7byeRuioMbN3ZBxYUCJm8k9q6vSg+oLVpkaeIS9T+
	fZf53xjd66KreZwQg9XqEGbThYuwm+YofNf/i+KbJjLceEwM1rLoD+dVeahBKNYDwpYu/LwqinWqA
	hQy5DfAYGwoUs4wZuoGCRTDTlsjSnnTSPgon+3SyLB+AkkNy0/stPaoD3NvES6scv3l3F42l2mz3W
	VscFLl6Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kGclq-0007pp-Lt; Fri, 11 Sep 2020 06:42:54 +0000
Date: Fri, 11 Sep 2020 07:42:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: Re: [PATCH v2 9/9] iomap: Change calling convention for zeroing
Message-ID: <20200911064254.GA24511@infradead.org>
References: <20200910234707.5504-1-willy@infradead.org>
 <20200910234707.5504-10-willy@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200910234707.5504-10-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Message-ID-Hash: EXTG4MH5HTIQVOKNNRRJ3TROKDD3M6YB
X-Message-ID-Hash: EXTG4MH5HTIQVOKNNRRJ3TROKDD3M6YB
X-MailFrom: BATV+8b03dcf5e621e88c3391+6228+infradead.org+hch@casper.srs.infradead.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/EXTG4MH5HTIQVOKNNRRJ3TROKDD3M6YB/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 11, 2020 at 12:47:07AM +0100, Matthew Wilcox (Oracle) wrote:
> Pass the full length to iomap_zero() and dax_iomap_zero(), and have
> them return how many bytes they actually handled.  This is preparatory
> work for handling THP, although it looks like DAX could actually take
> advantage of it if there's a larger contiguous area.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
