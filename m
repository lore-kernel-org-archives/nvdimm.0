Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1439332857.24434.37.camel@hp.com>
Subject: Re: [PATCH v2 08/25] arch: introduce memremap()
From: Toshi Kani <toshi.kani@hp.com>
Date: Tue, 11 Aug 2015 16:40:57 -0600
In-Reply-To: <20150811213021.GD30479@wotan.suse.de>
References: <20150726172527.GA29513@lst.de>
	 <CAPcyv4igoopDPpcCRU1TNYdwPhiYdcDiRA7L9Jdian=0rtexRg@mail.gmail.com>
	 <20150727051258.GB15836@lst.de>
	 <CAPcyv4jN6jYzw11qOOR-xd_w6s5dguQSoHyvmPFSWtL9S+tz3w@mail.gmail.com>
	 <20150729065004.GA17162@lst.de> <20150729182712.GI30479@wotan.suse.de>
	 <CAPcyv4iAeMAmU1QRZ1=WTav0cg2=-gqzzrt3nMC1QoD1+hOeBg@mail.gmail.com>
	 <1438203638.3214.418.camel@hp.com> <20150729214358.GK30479@wotan.suse.de>
	 <1438214404.3214.438.camel@hp.com> <20150811213021.GD30479@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@suse.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "H. Peter Anvin" <hpa@zytor.com>, Russell King <rmk+kernel@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2015-08-11 at 23:30 +0200, Luis R. Rodriguez wrote:
> On Wed, Jul 29, 2015 at 06:00:04PM -0600, Toshi Kani wrote:
> > On Wed, 2015-07-29 at 23:43 +0200, Luis R. Rodriguez wrote:
> > > On Wed, Jul 29, 2015 at 03:00:38PM -0600, Toshi Kani wrote:
> > > > On Wed, 2015-07-29 at 11:33 -0700, Dan Williams wrote:
  :
> > > That would depend on the purpose of the region and the driver 
> > > developer should in theory know best. One issue with this of course is 
> > > that, as we've discovered, the semantics of on the ioremap*() variant 
> > > front regarding cache types is not clearly well defined, or at least 
> > > it may be only well defined implicitly on x86 only, so the driver 
> > > developer can only *hope* for the best across architectures. Our 
> > > ambiguity on our semantics on ioremap*() variants therefore means 
> > > driver developers can resonably be puzzled by what fallbacks to use. 
> > > That also means architectures maintainers should not whip driver 
> > > developers for any misuse. Such considerations are why although we're 
> > > now revisiting semantics for ioremap*() variants I was in hopes we 
> > > could be at least somewhat pedantic about memremap() semantics.
> > 
> > I agree.  However, there are a few exceptions like /dev/mem, which can 
> > map a target range without knowledge.
> 
> Still, the expectation to require support for overlapping ioremap() calls 
> would seem to be more of an exception than the norm, so I'd argue that 
> requiring callers who know they do need overlapping support to be explicit 
> about it may help us simplify expecations on semantics in other areas of 
> the kernel.

Again, I agree.  I am simply saying that the fallback in an overlapping case
may need to remain supported for such exceptional cases, possibly with a
separate interface.

> > > For instance since memremap() only has 2 types right now can a 
> > > respective fallback be documented as an alternative to help with this 
> > > ? Or can we not generalize this ?  One for MEMREMAP_WB and one for 
> > > MEMREMAP_WT ?
> > 
> > Yes, if a target range can be only mapped by memremap().  However, there 
> > is no restriction that a range can be mapped with a single interface 
> > alone.  For example, a range can be mapped with remap_pfn_range() to 
> > user space with any cache type.  So, in theory, memremap() can overlap 
> > with any other types.
> 
> Shouldn't that be an issue or area of concern ? It seems the flakiness on
> ioremap() and its wide array flexibility would spill over the any 
> semantics which folks would be trying to set out with memremap(). That 
> should not stop the evolution of memremap() though, just pointing out that 
> perhaps we should be a bit more restrictive over how things can criss
> -cross and who areas can do it.

reserve_pfn_range() allows the caller to specify if the fallback needs to be
enabled or disabled with 'strict_prot'.  track_pfn_remap() called from
remap_pfn_range() enables it, and track_pfn_copy() disables it.  I think we
can do similar for the memremap and ioremap families as well.  The fallback
could be set disabled in the regular interfaces, and enabled in some
interface as necessary.  This also allows gradual transition, ex. disable in
memremap while ioremap remains enabled for now. 

> > > > ioremap() falls back to the cache type of an existing mapping to 
> > > > avoid aliasing.
> > > 
> > > Does that assume an existing ioremap*() call was used on a bigger 
> > > range?  Do you know if that happens to only be the case for x86 (I'd 
> > > think so) or if its the same for other architectures ?
> > 
> > In the /dev/mem example, it is remap_pfn_range().  I think other archs 
> > have the same issue, but I do not know if they fall back in case of
> > overlapping call.
> 
> What should happen if remap_pfn_range() was used with 
> pgprot_writecombine() and later memremap() is used for instance with a 
> smaller overlappin section, or perhaps bigger?

With the fallback disabled, memremap() should fail in this case. 

Thanks,
-Toshi
