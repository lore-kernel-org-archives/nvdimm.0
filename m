Return-Path: <SRS0=HKnB=A7=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79269C433E3
	for <linux-nvdimm@archiver.kernel.org>; Mon, 20 Jul 2020 09:17:52 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4ECC32080D
	for <linux-nvdimm@archiver.kernel.org>; Mon, 20 Jul 2020 09:17:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BwLB0hGg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4ECC32080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 0EEE9123757D6;
	Mon, 20 Jul 2020 02:17:52 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1231::1; helo=merlin.infradead.org; envelope-from=peterz@infradead.org; receiver=<UNKNOWN> 
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C06311236F6C3
	for <linux-nvdimm@lists.01.org>; Mon, 20 Jul 2020 02:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9k1ombCB/XhICcqxKFVOjQ1AGpkCxpa4eC8EdBJWgkY=; b=BwLB0hGgSaqBkwLtMWDBnHXKfa
	y7KAxz2bvDvF28yAcByni6ft1LZoY+n7qXz+5Poaoi7g+/6sfr6GteFHgRvelLQIKZNHsgFcjyqz1
	/AqTtFK1HwwxUaSbQIh77cuNL+w4fZNtWq+ryKADWQMt+4pqOMsCSvXicIUyJItyjjRkCcN18/M4m
	sIKPVkl/Toz0xyLQqTr4OjhenYlHlihU5FH2u4zr7B5dyinii+jIF/lP/ajnPkCRs9UrZkovvo0dH
	cbu7HHK7n/aOJC7/YrfYdPuIfqJK6w6DvqqGIsmDvMd7NIWQv8IueXLrH7qkCHuXA1pIwiFCtIwDh
	UYlS5ZNQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
	by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1jxRvZ-00061o-To; Mon, 20 Jul 2020 09:17:42 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B6F05301AC6;
	Mon, 20 Jul 2020 11:17:40 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id A63AA205A7673; Mon, 20 Jul 2020 11:17:40 +0200 (CEST)
Date: Mon, 20 Jul 2020 11:17:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH RFC V2 13/17] kmap: Add stray write protection for device
 pages
Message-ID: <20200720091740.GP10769@hirez.programming.kicks-ass.net>
References: <20200717072056.73134-1-ira.weiny@intel.com>
 <20200717072056.73134-14-ira.weiny@intel.com>
 <20200717092139.GC10769@hirez.programming.kicks-ass.net>
 <20200719041319.GA478573@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200719041319.GA478573@iweiny-DESK2.sc.intel.com>
Message-ID-Hash: CTNGUM43T2YD6TQYQSQXBS674ULTFQTS
X-Message-ID-Hash: CTNGUM43T2YD6TQYQSQXBS674ULTFQTS
X-MailFrom: peterz@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CTNGUM43T2YD6TQYQSQXBS674ULTFQTS/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 18, 2020 at 09:13:19PM -0700, Ira Weiny wrote:
> On Fri, Jul 17, 2020 at 11:21:39AM +0200, Peter Zijlstra wrote:
> > On Fri, Jul 17, 2020 at 12:20:52AM -0700, ira.weiny@intel.com wrote:
> > > @@ -31,6 +32,20 @@ static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
> > >  
> > >  #include <asm/kmap_types.h>
> > >  
> > > +static inline void enable_access(struct page *page)
> > > +{
> > > +	if (!page_is_access_protected(page))
> > > +		return;
> > > +	dev_access_enable();
> > > +}
> > > +
> > > +static inline void disable_access(struct page *page)
> > > +{
> > > +	if (!page_is_access_protected(page))
> > > +		return;
> > > +	dev_access_disable();
> > > +}
> > 
> > These are some very generic names, do we want them to be a little more
> > specific?
> 
> I had them named kmap_* but Dave (I think it was Dave) thought they did not
> really apply strictly to kmap_*.
> 
> They are static to this file which I thought may be sufficient to 'uniqify'
> them?

They're static to a .h, which means they're all over the place ;-)
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
