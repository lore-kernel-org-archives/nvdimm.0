Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 30 Jul 2015 23:10:26 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v3 01/24] mm: enhance region_is_ram() to
 region_intersects()
Message-ID: <20150730211026.GR30479@wotan.suse.de>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150730165345.33962.80299.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150730204249.GN30479@wotan.suse.de>
 <CAPcyv4hywBvt85E6LAznxQaDug17+_YxoyVzhf6fWu+GpsrmKw@mail.gmail.com>
 <20150730205449.GO30479@wotan.suse.de>
 <CAPcyv4g1cMCDUZGrWz6Epmp4XvYuuLOPneiOTqrRsX1PoOS9gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4g1cMCDUZGrWz6Epmp4XvYuuLOPneiOTqrRsX1PoOS9gA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Christoph Hellwig <hch@lst.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 30, 2015 at 01:59:20PM -0700, Dan Williams wrote:
> On Thu, Jul 30, 2015 at 1:54 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > On Thu, Jul 30, 2015 at 01:44:44PM -0700, Dan Williams wrote:
> >> On Thu, Jul 30, 2015 at 1:42 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> >> > On Thu, Jul 30, 2015 at 12:53:45PM -0400, Dan Williams wrote:
> >> >> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >> >> index 2e872f92dbac..84b05ebedb2d 100644
> >> >> --- a/include/linux/mm.h
> >> >> +++ b/include/linux/mm.h
> >> >> @@ -369,7 +369,14 @@ static inline int put_page_unless_one(struct page *page)
> >> >>  }
> >> >>
> >> >>  extern int page_is_ram(unsigned long pfn);
> >> >> -extern int region_is_ram(resource_size_t phys_addr, unsigned long size);
> >> >> +
> >> >> +enum {
> >> >> +     REGION_INTERSECTS,
> >> >> +     REGION_DISJOINT,
> >> >> +     REGION_MIXED,
> >> >> +};
> >> >> +
> >> >
> >> > Can you Kdoc'ify this? Part of the reason for the enum request was this
> >> > could be then documented really well. The helper is documented but here
> >> > you can go into more detail about each region intersection.
> >>
> >> Given region_intersects() has its own kdoc I'd probably just say "See
> >> region_intersects() for details".
> >
> > With the kdoc in place in the enum you'd kick people to elaborate when
> > extending the enums, whereas without this you'd hope they do it. With
> > the enum in place you can also be more verbose.
> >
> 
> Care to send a patch on what you are thinking?  I wasn't planning on
> this enum growing any other entries.

I mean something like this:

/**
 * enum region_intersect_type
 *
 * @REGION_INTERSECTS: explain and you you can go into any elaborate
 *	detail as you wish.
 * @REGION_DISJOINT: explain
 * @REGION_MIXED: explain
 */
enum region_intersect_type {
     REGION_INTERSECTS,
     REGION_DISJOINT,
     REGION_MIXED,
};

  Luis
