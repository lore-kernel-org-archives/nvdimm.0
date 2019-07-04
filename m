Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C80DD212B0811
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jul 2019 06:58:08 -0700 (PDT)
Date: Thu, 4 Jul 2019 06:58:04 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190704135804.GL1729@bombadil.infradead.org>
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org>
 <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <f23a1c71-d1b1-b279-c922-ce0f48cb4448@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f23a1c71-d1b1-b279-c922-ce0f48cb4448@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Seema Pandit <seema.pandit@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 04, 2019 at 04:00:00PM +0300, Boaz Harrosh wrote:
> On 04/07/2019 06:27, Matthew Wilcox wrote:
> > On Wed, Jul 03, 2019 at 02:28:41PM -0700, Dan Williams wrote:
> >>> +#ifdef CONFIG_XARRAY_MULTI
> >>> +       unsigned int sibs = xas->xa_sibs;
> >>> +
> >>> +       while (sibs) {
> >>> +               order++;
> >>> +               sibs /= 2;
> >>> +       }
> >>
> >> Use ilog2() here?
> > 
> > Thought about it.  sibs is never going to be more than 31, so I don't
> > know that it's worth eliminating 5 add/shift pairs in favour of whatever
> > the ilog2 instruction is on a given CPU.  In practice, on x86, sibs is
> > going to be either 0 (PTEs) or 7 (PMDs).  We could also avoid even having
> > this function by passing PMD_ORDER or PTE_ORDER into get_unlocked_entry().
> > 
> > It's probably never going to be noticable in this scenario because it's
> > the very last thing checked before we put ourselves on a waitqueue and
> > go to sleep.
> 
> Matthew you must be kidding an ilog2 in binary is zero clocks
> (Return the highest bit or something like that)

You might want to actually check the documentation instead of just
making shit up.

https://www.agner.org/optimize/instruction_tables.pdf

I think in this instance what we want is BSR (aka ffz) since the input is
going to be one of 0, 1, 3, 7, 15 or 31 (and we want 0, 1, 2, 3, 4, 5 as
results).

> In any way. It took me 5 minutes to understand what you are doing
> here. And I only fully got it when Dan gave his comment. So please for
> the sake of stupid guys like me could you please make it ilog2() so
> to make it easier to understand?
> (And please don't do the compiler's job. If in some arch the loop
>  is the fastest let the compiler decide?)

The compiler doesn't know the range of 'sibs'.  Unless we do the
profile-feedback thing.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
