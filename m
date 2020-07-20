Return-Path: <SRS0=HKnB=A7=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24943C433E1
	for <linux-nvdimm@archiver.kernel.org>; Mon, 20 Jul 2020 09:16:58 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E9563206F2
	for <linux-nvdimm@archiver.kernel.org>; Mon, 20 Jul 2020 09:16:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KD2SKYY0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9563206F2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D6882123757D4;
	Mon, 20 Jul 2020 02:16:57 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=peterz@infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9A4011236F6C3
	for <linux-nvdimm@lists.01.org>; Mon, 20 Jul 2020 02:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cqaPo6c/vbm75ZN40kWjbOeNcOmsa5cD3xE0rxriFws=; b=KD2SKYY0Vz7CTxTngq1V8OW17+
	8yc7CrhiRACK9sqKsxycaWO1WvV5WmEy2MdHZ0GX7NjeZ2QzKmUxYPYv9Y7E50BrD/04zU8IEM3+c
	vSy4mPNcIYnLS57Of5l7ZYoU0Mz4hueu0BsuOLLVJIxJ6ZQZLJbsiVF5Yu+gAbTD+2fy+w+2UQqBA
	rajGHu6G75zDYhe9xObUs9xqV4CuSgvh4Mibirb+fLOO6kn5SMLGcGqyU1FthlfD+zH4fjfV2gl+R
	lBk6ZSUlV1I371mjJjjuAjeKrCH0FrK0yiHVQm+3PvYqU7N2wT70KH0f/lCQZgH+IObMlynpcU2qE
	LuE2rMdg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1jxRua-0001Vp-0P; Mon, 20 Jul 2020 09:16:40 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 266A33010C8;
	Mon, 20 Jul 2020 11:16:39 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 19135205A7673; Mon, 20 Jul 2020 11:16:39 +0200 (CEST)
Date: Mon, 20 Jul 2020 11:16:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH RFC V2 12/17] memremap: Add zone device access protection
Message-ID: <20200720091639.GO10769@hirez.programming.kicks-ass.net>
References: <20200717072056.73134-1-ira.weiny@intel.com>
 <20200717072056.73134-13-ira.weiny@intel.com>
 <20200717091053.GZ10769@hirez.programming.kicks-ass.net>
 <20200718050650.GT3008823@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200718050650.GT3008823@iweiny-DESK2.sc.intel.com>
Message-ID-Hash: 4NV7XWPKAAIXAMJMF6OUQVWEYLXJRWA4
X-Message-ID-Hash: 4NV7XWPKAAIXAMJMF6OUQVWEYLXJRWA4
X-MailFrom: peterz@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4NV7XWPKAAIXAMJMF6OUQVWEYLXJRWA4/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 17, 2020 at 10:06:50PM -0700, Ira Weiny wrote:
> On Fri, Jul 17, 2020 at 11:10:53AM +0200, Peter Zijlstra wrote:
> > On Fri, Jul 17, 2020 at 12:20:51AM -0700, ira.weiny@intel.com wrote:
> > > +static pgprot_t dev_protection_enable_get(struct dev_pagemap *pgmap, pgprot_t prot)
> > > +{
> > > +	if (pgmap->flags & PGMAP_PROT_ENABLED && dev_page_pkey != PKEY_INVALID) {
> > > +		pgprotval_t val = pgprot_val(prot);
> > > +
> > > +		static_branch_inc(&dev_protection_static_key);
> > > +		prot = __pgprot(val | _PAGE_PKEY(dev_page_pkey));
> > > +	}
> > > +	return prot;
> > > +}
> > 
> > Every other pgprot modifying function is called pgprot_*(), although I
> > suppose we have the exceptions phys_mem_access_prot() and dma_pgprot().
> 
> Yea...  this function kind of morphed.  The issue is that this is also a 'get'
> with a corresponding 'put'.  So I'm at a loss for what makes sense between the
> 2 functions.
> 
> > 
> > How about we call this one devm_pgprot() ?
> 
> Dan Williams mentioned to me that the devm is not an appropriate prefix.  Thus
> the 'dev' prefix instead.
> 
> How about dev_pgprot_{get,put}()?

works for me, thanks!
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
