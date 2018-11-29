Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com
 [IPv6:2607:f8b0:4864:20::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 97CE521B02822
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 22:09:35 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id u18so659501oie.10
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 22:09:35 -0800 (PST)
MIME-Version: 1.0
References: <118cae852d1dbcc582261ae364e75a7bdf3d43ed.camel@intel.com>
 <20181106144848.GE3074@bombadil.infradead.org>
 <35429d15f7dfd2c551b9d61512abe2e04376d2a0.camel@intel.com>
 <20181110082918.GC21824@bombadil.infradead.org>
 <CAPcyv4hotPj0YKnyo1WpoFGKaq_9L3=h3zxDNMHoSU+qUaoh4g@mail.gmail.com>
 <20181113142519.GX21824@bombadil.infradead.org>
In-Reply-To: <20181113142519.GX21824@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Nov 2018 22:09:23 -0800
Message-ID: <CAPcyv4gDDMUK+_e_d5Kzqt6kunKrt-ktOhPWepoXepPP4juj0g@mail.gmail.com>
Subject: Re: fsdax memory error handling regression
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 13, 2018 at 6:25 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sat, Nov 10, 2018 at 09:08:10AM -0800, Dan Williams wrote:
> > On Sat, Nov 10, 2018 at 12:29 AM Matthew Wilcox <willy@infradead.org> wrote:
[..]
> > > If we get an internal entry in this case, we know we were looking up
> > > a PMD entry and found a PTE entry.
> >
> > Oh, so I may have my understanding of internal entries backwards? I.e.
> > I thought they were returned if you have an order-0 xas and passed
> > xas_load() an unaligned index, but the entry is multi-order. You're
> > saying they are only returned when we have a multi-order xas and
> > xas_load() finds an order-0 entry at the unaligned index. So
> > "internal" isn't Xarray private state it's an order-0 entry when the
> > user wanted multi-order?
>
> This sounds much more like what I just re-described above.  When you say
> an unaligned index, I suspect you mean something like having a PMD entry
> and specifying an index which is not PMD-aligned?  That always returns
> the PMD entry, just like the radix tree used to.

...ok, so I think I may have evidence to the contrary or something
else is going wrong in the api. At the very least we're inching
towards root cause. If I modify dax_to_pfn() like so:

diff --git a/fs/dax.c b/fs/dax.c
index 3f592dc18d67..7fd3529fe859 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -88,9 +88,17 @@ fs_initcall(init_dax_wait_table);
 #define DAX_ZERO_PAGE  (1UL << 2)
 #define DAX_EMPTY      (1UL << 3)

-static unsigned long dax_to_pfn(void *entry)
+static unsigned long dax_is_pmd_entry(void *entry)
 {
-       return xa_to_value(entry) >> DAX_SHIFT;
+       return xa_to_value(entry) & DAX_PMD;
+}
+
+static noinline unsigned long dax_to_pfn(void *entry)
+{
+       unsigned long val = xa_to_value(entry) >> DAX_SHIFT;
+
+       WARN_ON_ONCE(dax_is_pmd_entry(entry) && val & ((1UL << PMD_ORDER) - 1));
+       return val;
 }

...it triggers. The same change on top 4.19 does not. So somehow we
are able to lookup a pmd entry, but the value of the entry is pte
aligned. This is the precursor to the original failure because ext4
tries to invalidate the page with the memory failure, but the
resulting dax_disassociate_entry() starts its for_each_mapped_pfn() at
an unaligned pfn, and likely spills over into unrelated pages. Later
dax_insert_entry() sees ->mapping still set for the first few pfns
relative to the original pmd entry when it should have been set to
NULL.

Do you see anything in __dax_invalidate_entry() path that would lead
to this or do I need to peel the onion a bit more?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
