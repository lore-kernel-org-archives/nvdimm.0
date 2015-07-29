Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1438204274.3214.421.camel@hp.com>
Subject: Re: [PATCH v2 08/25] arch: introduce memremap()
From: Toshi Kani <toshi.kani@hp.com>
Date: Wed, 29 Jul 2015 15:11:14 -0600
In-Reply-To: <1438203638.3214.418.camel@hp.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150725023842.8664.97620.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150726172527.GA29513@lst.de>
	 <CAPcyv4igoopDPpcCRU1TNYdwPhiYdcDiRA7L9Jdian=0rtexRg@mail.gmail.com>
	 <20150727051258.GB15836@lst.de>
	 <CAPcyv4jN6jYzw11qOOR-xd_w6s5dguQSoHyvmPFSWtL9S+tz3w@mail.gmail.com>
	 <20150729065004.GA17162@lst.de> <20150729182712.GI30479@wotan.suse.de>
	 <CAPcyv4iAeMAmU1QRZ1=WTav0cg2=-gqzzrt3nMC1QoD1+hOeBg@mail.gmail.com>
	 <1438203638.3214.418.camel@hp.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Russell King <rmk+kernel@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2015-07-29 at 15:00 -0600, Toshi Kani wrote:
> On Wed, 2015-07-29 at 11:33 -0700, Dan Williams wrote:
> > On Wed, Jul 29, 2015 at 11:27 AM, Luis R. Rodriguez <mcgrof@suse.com> 
> > wrote:
> > > On Wed, Jul 29, 2015 at 08:50:04AM +0200, Christoph Hellwig wrote:
> > > > On Mon, Jul 27, 2015 at 04:26:03PM -0700, Dan Williams wrote:
> > > > > Oh, because all we have at this point is ioremap_cache() which
> > > > > silently falls back.  It's not until the introduction of
> > > > > arch_memremp() where we update the arch code to break that 
> > > > > behavior.
> > > > 
> > > > Ok, makes sense.  Might be worth to document in the changelog.
> > > > 
> > > > > That said, I think it may be beneficial to allow a fallback if 
> > > > > the
> > > > > user cares.  So maybe memremap() can call plain ioremap() if
> > > > > MEMREMAP_STRICT is not set and none of the other mapping types 
> > > > > are
> > > > > satisfied.
> > > > 
> > > > Is there a real use case for it?  Fallback APIs always seem 
> > > > confusing
> > > > and it might make more sense to do this in the caller(s) that 
> > > > actually
> > > > need it.
> > > 
> > > It seems semantics-wise we are trying to separate these two really, 
> > > so 
> > > I agree
> > > with this. Having a fallback would onloy make things more complicated 
> > > 
> > > for any
> > > sanitizer / checker / etc, and I don't think the practical gains of 
> > > having a
> > > fallback outweight the gains of having a clear semantic separation on 
> > > 
> > > intended
> > > memory type and interactions with it.
> > > 
> > 
> > Yup, consider it dropped.  Drivers that want fallback behavior can do
> > it explicitly.
> 
> I agree in general.  However, for the drivers to be able to fall back
> properly, they will need to know the cache type they can fall back with. 
>  ioremap() falls back to the cache type of an existing mapping to avoid
> aliasing.

Never mind...  In this context, we are talking about fallback in case of "
API not implemented" on arch.  I was talking about fallback in case of
aliasing.

Thanks,
-Toshi





