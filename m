Return-Path: <SRS0=5Q6F=A5=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5E4C433E0
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Jul 2020 05:08:18 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3B2662083E
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Jul 2020 05:08:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B2662083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1511012017E3C;
	Fri, 17 Jul 2020 22:08:18 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.126; helo=mga18.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 64CBF11EB8E1A
	for <linux-nvdimm@lists.01.org>; Fri, 17 Jul 2020 22:06:51 -0700 (PDT)
IronPort-SDR: KAzwwTFiqRQ6e7YpiMJLwLd7c5Y2xF7hoDR++goIH+OR5g6WmgKZse8P4OQZLhKeWSG9Nw3dyv
 jouP3F/bznEw==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="137184357"
X-IronPort-AV: E=Sophos;i="5.75,365,1589266800";
   d="scan'208";a="137184357"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 22:06:50 -0700
IronPort-SDR: PY3XuV+vuuAtpY8rxRvZ+3vMP/33Vq1wquR8p4Yg18XVLAL6vT+hjMFvaGQsieLHuShfCSaRfd
 pufbVEiCB0pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,365,1589266800";
   d="scan'208";a="270979648"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.147])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jul 2020 22:06:50 -0700
Date: Fri, 17 Jul 2020 22:06:50 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 12/17] memremap: Add zone device access protection
Message-ID: <20200718050650.GT3008823@iweiny-DESK2.sc.intel.com>
References: <20200717072056.73134-1-ira.weiny@intel.com>
 <20200717072056.73134-13-ira.weiny@intel.com>
 <20200717091053.GZ10769@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200717091053.GZ10769@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.11.1 (2018-12-01)
Message-ID-Hash: KSBH42P4TEXWJFAOPF5IZOORYWVVXJ5Z
X-Message-ID-Hash: KSBH42P4TEXWJFAOPF5IZOORYWVVXJ5Z
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/KSBH42P4TEXWJFAOPF5IZOORYWVVXJ5Z/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 17, 2020 at 11:10:53AM +0200, Peter Zijlstra wrote:
> On Fri, Jul 17, 2020 at 12:20:51AM -0700, ira.weiny@intel.com wrote:
> > +static pgprot_t dev_protection_enable_get(struct dev_pagemap *pgmap, pgprot_t prot)
> > +{
> > +	if (pgmap->flags & PGMAP_PROT_ENABLED && dev_page_pkey != PKEY_INVALID) {
> > +		pgprotval_t val = pgprot_val(prot);
> > +
> > +		static_branch_inc(&dev_protection_static_key);
> > +		prot = __pgprot(val | _PAGE_PKEY(dev_page_pkey));
> > +	}
> > +	return prot;
> > +}
> 
> Every other pgprot modifying function is called pgprot_*(), although I
> suppose we have the exceptions phys_mem_access_prot() and dma_pgprot().

Yea...  this function kind of morphed.  The issue is that this is also a 'get'
with a corresponding 'put'.  So I'm at a loss for what makes sense between the
2 functions.

> 
> How about we call this one devm_pgprot() ?

Dan Williams mentioned to me that the devm is not an appropriate prefix.  Thus
the 'dev' prefix instead.

How about dev_pgprot_{get,put}()?

Ira
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
