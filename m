Return-Path: <SRS0=TU+8=CE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_40,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB71C433E4
	for <linux-nvdimm@archiver.kernel.org>; Wed, 26 Aug 2020 02:26:30 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 577A52074A
	for <linux-nvdimm@archiver.kernel.org>; Wed, 26 Aug 2020 02:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ncJE4xT0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 577A52074A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2F45311FC44AF;
	Tue, 25 Aug 2020 19:26:30 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id E4807111F31E2
	for <linux-nvdimm@lists.01.org>; Tue, 25 Aug 2020 19:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sxFvO/GLCLgBRfmkOAspDUyP4lpcTibuAN2MiSmiuaE=; b=ncJE4xT0RV0DL88DyjXY0ZZWNX
	c5H0dGv17CatAlJxzga6RRk56Q8fwDpXIuW7EEgf7tICAzbPlgtNvK36sFxtwQvfroJ8qKcfn9ct+
	v4xOejFU30Eo6Um3PIONALTAT6Ii6GySy9Kynet63yIETPr4X7Oj3m9vt0bUhKXato+jPPJgzIcmN
	xCRFwAEBsbxCuWcC3955WsJF+6u+RN5YmHIZREM7WnjcBaZxITdzSi1qvAFtPV8idzN0tt+oTQK6S
	sSkJThXGSEmeNs+teYiAx47mwssooc7xfO79kmW10tUeb6CG3YyCKJVsgR67CM/sfzG2kQmIpROjy
	HXDE9yLQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kAl8p-0003AS-OR; Wed, 26 Aug 2020 02:26:23 +0000
Date: Wed, 26 Aug 2020 03:26:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/9] iomap: Support arbitrarily many blocks per page
Message-ID: <20200826022623.GQ17456@casper.infradead.org>
References: <20200824145511.10500-1-willy@infradead.org>
 <20200824145511.10500-6-willy@infradead.org>
 <20200825210203.GJ6096@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200825210203.GJ6096@magnolia>
Message-ID-Hash: FBBZ3OIQ7PKPI433YMZP2IGNYJAXYVRV
X-Message-ID-Hash: FBBZ3OIQ7PKPI433YMZP2IGNYJAXYVRV
X-MailFrom: willy@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/FBBZ3OIQ7PKPI433YMZP2IGNYJAXYVRV/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 25, 2020 at 02:02:03PM -0700, Darrick J. Wong wrote:
> >  /*
> > - * Structure allocated for each page when block size < PAGE_SIZE to track
> > + * Structure allocated for each page when block size < page size to track
> >   * sub-page uptodate status and I/O completions.
> 
> "for each regular page or head page of a huge page"?  Or whatever we're
> calling them nowadays?

Well, that's what I'm calling a "page" ;-)

How about "for each page or THP"?  The fact that it's stored in the
head page is incidental -- it's allocated for the THP.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
