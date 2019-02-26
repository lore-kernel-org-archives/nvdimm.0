Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 812F920886F3F
 for <linux-nvdimm@lists.01.org>; Tue, 26 Feb 2019 04:08:22 -0800 (PST)
Date: Tue, 26 Feb 2019 04:08:21 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: find_get_entries_tag regression bisected
Message-ID: <20190226120820.GB11592@bombadil.infradead.org>
References: <CAPcyv4gs7nGnf81Lj-Hf04uhmMb2wxKzi42ajaNVCHty7PAsAQ@mail.gmail.com>
 <20190216153511.GM12668@bombadil.infradead.org>
 <20190216172948.GN12668@bombadil.infradead.org>
 <20190216211105.GO12668@bombadil.infradead.org>
 <CAPcyv4j8G0S4Z2ngzrz_OhFjp8+4tqCtpRRE6Eq33uczh0QBRA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4j8G0S4Z2ngzrz_OhFjp8+4tqCtpRRE6Eq33uczh0QBRA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Balcer,
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 25, 2019 at 09:03:00PM -0800, Dan Williams wrote:
> On Sat, Feb 16, 2019 at 1:11 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Sat, Feb 16, 2019 at 09:29:48AM -0800, Matthew Wilcox wrote:
> > > On Sat, Feb 16, 2019 at 07:35:11AM -0800, Matthew Wilcox wrote:
> > > > Another way to fix this would be to mask the address in dax_entry_mkclean(),
> > > > but I think this is cleaner.
> > >
> > > That's clearly rubbish, dax_entry_mkclean() can't possibly mask the
> > > address.  It might be mis-aligned in another process.  But ... if it's
> > > misaligned in another process, dax_entry_mkclean() will only clean the first
> > > PTE associated with the PMD; it won't clean the whole thing.  I think we need
> > > something like this:
> >
> > Nope, this isn't enough.  It's _necessary_ to find the processes that
> > have part of this PMD page mapped, but not the start of it.  But it's
> > not _sufficient_ because it'll still only mkclean the first PTE.  So we
> > need a loop.  I'm feeling a bit over my head here.  I may have a go at
> > a fuller fix, but if someone else wants to have a go at it, be my guest!
> 
> Nothing comes to mind outside of pseudo-reverting this conversion by
> introducing a way to get back to the old semantics. If you don't see a
> path forward, us mere Xarray-mortals stand no chance.

This is a pre-existing bug.  Fixing the regression is easy.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
