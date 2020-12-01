Return-Path: <SRS0=kHQN=FF=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217C0C71155
	for <linux-nvdimm@archiver.kernel.org>; Tue,  1 Dec 2020 20:49:12 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 298A020679
	for <linux-nvdimm@archiver.kernel.org>; Tue,  1 Dec 2020 20:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JJv/jUDU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 298A020679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 91EB7100EBBA0;
	Tue,  1 Dec 2020 12:49:10 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B659C100EC1FC
	for <linux-nvdimm@lists.01.org>; Tue,  1 Dec 2020 12:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dyBlRLPwKTQ0rIK/KfQyG6Ob+vSn1EgfGLIeGxV2yms=; b=JJv/jUDUAQHzh744cKMjYelWef
	QTIfn+k/elN1QSMiCosaURKxQ2fWjh8q5u2jiv6QfFKVvUpCoopn/ASQfT2etb0mpcaFppKzMYJXm
	Go2y9Rwev3yIt6lHEo1tzZH2Wx2Q6u9PRMkr63pL1mC/IMEd1XbOi4IkeJ+0HK/hwir/XDFgjgrEN
	cdhpbGfdToA0xP9TZ7gkSGag0nCbiIVH+0pdZciOchpvAvCRGfkDtBJxnzM40g2ajgf/GCFJ2W11C
	YBwt2vpgu5H8EUX4Boxoe/hCjSfDn7VgdY9T2yM55nPU61QYzgqXbURWXBFMxxDDvUGPOpG8UlTrn
	97JljK1A==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kkCa4-0002i8-S3; Tue, 01 Dec 2020 20:49:00 +0000
Date: Tue, 1 Dec 2020 20:49:00 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: mapcount corruption regression
Message-ID: <20201201204900.GC11935@casper.infradead.org>
References: <CAPcyv4isen63tJ7q02rvVuu_Rm6QPdT0Bu-P_HJ2zePMySFNNg@mail.gmail.com>
 <20201201022412.GG4327@casper.infradead.org>
 <CAPcyv4j7wtjOSg8vL5q0PPjWdaknY-PC7m9x-Q1R_YL5dhE+bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4j7wtjOSg8vL5q0PPjWdaknY-PC7m9x-Q1R_YL5dhE+bQ@mail.gmail.com>
Message-ID-Hash: DRUDYA4GYMM4FZYZOZAO2QMVKYSJV6P7
X-Message-ID-Hash: DRUDYA4GYMM4FZYZOZAO2QMVKYSJV6P7
X-MailFrom: willy@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Vlastimil Babka <vbabka@suse.cz>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DRUDYA4GYMM4FZYZOZAO2QMVKYSJV6P7/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 01, 2020 at 12:42:39PM -0800, Dan Williams wrote:
> On Mon, Nov 30, 2020 at 6:24 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Mon, Nov 30, 2020 at 05:20:25PM -0800, Dan Williams wrote:
> > > Kirill, Willy, compound page experts,
> > >
> > > I am seeking some debug ideas about the following splat:
> > >
> > > BUG: Bad page state in process lt-pmem-ns  pfn:121a12
> > > page:0000000051ef73f7 refcount:0 mapcount:-1024
> > > mapping:0000000000000000 index:0x0 pfn:0x121a12
> >
> > Mapcount of -1024 is the signature of:
> >
> > #define PG_guard        0x00000400
> 
> Oh, thanks for that. I overlooked how mapcount is overloaded. Although
> in v5.10-rc4 that value is:
> 
> #define PG_table        0x00000400

Ah, I was looking at -next, where Roman renumbered it.

I know UML had a problem where it was not clearing PG_table, but you
seem to be running on bare metal.  SuperH did too, but again, you're
not using SuperH.

> >
> > (the bits are inverted, so this turns into 0xfffffbff which is reported
> > as -1024)
> >
> > I assume you have debug_pagealloc enabled?
> 
> Added it, but no extra spew. I'll dig a bit more on how PG_table is
> not being cleared in this case.

I only asked about debug_pagealloc because that sets PG_guard.  Since
the problem is actually PG_table, it's not relevant.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
