Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com
 [IPv6:2607:f8b0:4864:20::331])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A65C20081A62
 for <linux-nvdimm@lists.01.org>; Mon, 25 Feb 2019 21:03:12 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id v62so10056713otb.3
 for <linux-nvdimm@lists.01.org>; Mon, 25 Feb 2019 21:03:12 -0800 (PST)
MIME-Version: 1.0
References: <CAPcyv4gs7nGnf81Lj-Hf04uhmMb2wxKzi42ajaNVCHty7PAsAQ@mail.gmail.com>
 <20190216153511.GM12668@bombadil.infradead.org>
 <20190216172948.GN12668@bombadil.infradead.org>
 <20190216211105.GO12668@bombadil.infradead.org>
In-Reply-To: <20190216211105.GO12668@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Feb 2019 21:03:00 -0800
Message-ID: <CAPcyv4j8G0S4Z2ngzrz_OhFjp8+4tqCtpRRE6Eq33uczh0QBRA@mail.gmail.com>
Subject: Re: find_get_entries_tag regression bisected
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
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Balcer,
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Feb 16, 2019 at 1:11 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sat, Feb 16, 2019 at 09:29:48AM -0800, Matthew Wilcox wrote:
> > On Sat, Feb 16, 2019 at 07:35:11AM -0800, Matthew Wilcox wrote:
> > > Another way to fix this would be to mask the address in dax_entry_mkclean(),
> > > but I think this is cleaner.
> >
> > That's clearly rubbish, dax_entry_mkclean() can't possibly mask the
> > address.  It might be mis-aligned in another process.  But ... if it's
> > misaligned in another process, dax_entry_mkclean() will only clean the first
> > PTE associated with the PMD; it won't clean the whole thing.  I think we need
> > something like this:
>
> Nope, this isn't enough.  It's _necessary_ to find the processes that
> have part of this PMD page mapped, but not the start of it.  But it's
> not _sufficient_ because it'll still only mkclean the first PTE.  So we
> need a loop.  I'm feeling a bit over my head here.  I may have a go at
> a fuller fix, but if someone else wants to have a go at it, be my guest!

Nothing comes to mind outside of pseudo-reverting this conversion by
introducing a way to get back to the old semantics. If you don't see a
path forward, us mere Xarray-mortals stand no chance.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
