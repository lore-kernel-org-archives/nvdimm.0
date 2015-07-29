Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 29 Jul 2015 23:52:30 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v2 08/25] arch: introduce memremap()
Message-ID: <20150729215230.GL30479@wotan.suse.de>
References: <20150726172527.GA29513@lst.de>
 <CAPcyv4igoopDPpcCRU1TNYdwPhiYdcDiRA7L9Jdian=0rtexRg@mail.gmail.com>
 <20150727051258.GB15836@lst.de>
 <CAPcyv4jN6jYzw11qOOR-xd_w6s5dguQSoHyvmPFSWtL9S+tz3w@mail.gmail.com>
 <20150729065004.GA17162@lst.de>
 <20150729182712.GI30479@wotan.suse.de>
 <CAPcyv4iAeMAmU1QRZ1=WTav0cg2=-gqzzrt3nMC1QoD1+hOeBg@mail.gmail.com>
 <1438203638.3214.418.camel@hp.com>
 <20150729214358.GK30479@wotan.suse.de>
 <CAPcyv4j67493ROvnC1EZBEFMiWB=gLu=C-Y-PrJf0BvO3A=y2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4j67493ROvnC1EZBEFMiWB=gLu=C-Y-PrJf0BvO3A=y2w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "H. Peter Anvin" <hpa@zytor.com>, Russell King <rmk+kernel@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 29, 2015 at 02:47:40PM -0700, Dan Williams wrote:
> On Wed, Jul 29, 2015 at 2:43 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > While at it, Dan, will / should memremap() support overlapping calls ?
> > What is the expectation on behaviour ?
> 
> It will be the same as ioremap().  Each mapping gets its own virtual
> address and overlapping calls are permitted.  The only protection is
> that RAM is never mapped with an alias.

If you could document this as part of your next respin that'd be
highly appreciated.

  Luis
