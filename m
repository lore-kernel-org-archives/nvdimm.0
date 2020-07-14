Return-Path: <SRS0=ES6B=AZ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D941BC433E4
	for <linux-nvdimm@archiver.kernel.org>; Tue, 14 Jul 2020 19:29:44 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF281227C3
	for <linux-nvdimm@archiver.kernel.org>; Tue, 14 Jul 2020 19:29:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tzoYhF+n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF281227C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 97B57116FE12F;
	Tue, 14 Jul 2020 12:29:44 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1231::1; helo=merlin.infradead.org; envelope-from=peterz@infradead.org; receiver=<UNKNOWN> 
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 271EF116BF628
	for <linux-nvdimm@lists.01.org>; Tue, 14 Jul 2020 12:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DxRaLkjpUaoEf0xxT682sMuthlbkUQaqou9xBSEthzs=; b=tzoYhF+ndXteGbrYuyAmg/q9ql
	lJtaI0FuH3c8J42sQR/E2uYkhCpFeXPc7FOgJmI68T+H7bkQ1q0y60RT2NqowxnJ3StJLPeHeFkX+
	OJQuj30D3GKP79EnnrdKlWLBIRpGW8Uk7sk/geT4GGepsLX1EzHvB6k7GgVEqZNBr8+N0VDQGEOvL
	qCTLoXPiM68Ko3DHDHTOU+jyhW0vavjCzO+PW93pSARAtS+smk4XeVnWr5NFiSvSl/91dIrVZy0Kj
	3iEsiKrDzeyxoXFNxo7ATz5CUBvlf0xCdP/0GAON2pptcLhSZ1rsMxpICMN616g+xltCbAX7YAnS8
	Yffd4cvw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
	by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1jvQcO-0002xP-EN; Tue, 14 Jul 2020 19:29:32 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
	id AA08A9817E0; Tue, 14 Jul 2020 21:29:30 +0200 (CEST)
Date: Tue, 14 Jul 2020 21:29:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 12/15] kmap: Add stray write protection for device
 pages
Message-ID: <20200714192930.GH5523@worktop.programming.kicks-ass.net>
References: <20200714070220.3500839-1-ira.weiny@intel.com>
 <20200714070220.3500839-13-ira.weiny@intel.com>
 <20200714084451.GQ10769@hirez.programming.kicks-ass.net>
 <20200714190615.GC3008823@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200714190615.GC3008823@iweiny-DESK2.sc.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID-Hash: NETN6VSEOK2WABJQXR32EHZR2PHWC5U5
X-Message-ID-Hash: NETN6VSEOK2WABJQXR32EHZR2PHWC5U5
X-MailFrom: peterz@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/NETN6VSEOK2WABJQXR32EHZR2PHWC5U5/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 14, 2020 at 12:06:16PM -0700, Ira Weiny wrote:
> On Tue, Jul 14, 2020 at 10:44:51AM +0200, Peter Zijlstra wrote:

> > So, if I followed along correctly, you're proposing to do a WRMSR per
> > k{,un}map{_atomic}(), sounds like excellent performance all-round :-(
> 
> Only to pages which have this additional protection, ie not DRAM.
> 
> User mappings of this memory is not affected (would be covered by User PKeys if
> desired).  User mappings to persistent memory are the primary use case and the
> performant path.

Because performance to non-volatile memory doesn't matter? I think Dave
has a better answer here ...
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
