Return-Path: <SRS0=4eaP=C2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBFEC43464
	for <linux-nvdimm@archiver.kernel.org>; Thu, 17 Sep 2020 22:11:22 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9CC0921582
	for <linux-nvdimm@archiver.kernel.org>; Thu, 17 Sep 2020 22:11:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KzsKzrQO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CC0921582
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5177414FF87AC;
	Thu, 17 Sep 2020 15:11:21 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 4D1B314FC343E
	for <linux-nvdimm@lists.01.org>; Thu, 17 Sep 2020 15:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NBI0zralRPp5qM9j83BPA0ZseelW+oOID0UWHD+t4og=; b=KzsKzrQOFiNYuo7747mdvgEu+h
	/y6vK+gWvWW+Ft7JHbX6oHBluLZgw5hQerH8P9qpE/Y0pWNBozHaMRsaYKOw0TJ67J3Zh1sME4d4p
	5/WRc93gotekRCP0pM46FHb02uGNiRx0Y9tkqc5ZeWOxA9yw+PZCodQKjLNOKaHE77RMqHrdlr+uz
	ynmSPRuONtTmTjJyr/29IinJFAPemOrmyQcrxlr2aqSd7jacEC3lEnE3RxYzyKjOAKsci9D5rmyL8
	orTRI92pnQbCYFIWEAhtJoJ74RanEG2V+9wwfLvL1YxG/RmNxRGeQwb+oNeqPYCF2TDIoFZVeeIdp
	/eixEdeg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kJ27X-00048x-M7; Thu, 17 Sep 2020 22:11:15 +0000
Date: Thu, 17 Sep 2020 23:11:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 9/9] iomap: Change calling convention for zeroing
Message-ID: <20200917221115.GY5449@casper.infradead.org>
References: <20200910234707.5504-1-willy@infradead.org>
 <20200910234707.5504-10-willy@infradead.org>
 <20200917220500.GR7955@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200917220500.GR7955@magnolia>
Message-ID-Hash: B74IZT26P3HK6CPHTQF3FRDOL7G6V5ME
X-Message-ID-Hash: B74IZT26P3HK6CPHTQF3FRDOL7G6V5ME
X-MailFrom: willy@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/B74IZT26P3HK6CPHTQF3FRDOL7G6V5ME/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 17, 2020 at 03:05:00PM -0700, Darrick J. Wong wrote:
> > -static loff_t
> > -iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
> > -		void *data, struct iomap *iomap, struct iomap *srcmap)
> > +static loff_t iomap_zero_range_actor(struct inode *inode, loff_t pos,
> > +		loff_t length, void *data, struct iomap *iomap,
> 
> Any reason not to change @length and the return value to s64?

Because it's an actor, passed to iomap_apply, so its types have to match.
I can change that, but it'll be a separate patch series.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
