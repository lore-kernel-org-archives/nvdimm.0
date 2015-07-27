Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 27 Jul 2015 07:12:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 08/25] arch: introduce memremap()
Message-ID: <20150727051258.GB15836@lst.de>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com> <20150725023842.8664.97620.stgit@dwillia2-desk3.amr.corp.intel.com> <20150726172527.GA29513@lst.de> <CAPcyv4igoopDPpcCRU1TNYdwPhiYdcDiRA7L9Jdian=0rtexRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4igoopDPpcCRU1TNYdwPhiYdcDiRA7L9Jdian=0rtexRg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org, "Kani, Toshimitsu" <toshi.kani@hp.com>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@arm.linux.org.uk>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jul 26, 2015 at 10:49:39AM -0700, Dan Williams wrote:
> On Sun, Jul 26, 2015 at 10:25 AM, Christoph Hellwig <hch@lst.de> wrote:
> > On Fri, Jul 24, 2015 at 10:38:42PM -0400, Dan Williams wrote:
> >> The behavior change to return NULL on an unsupported request is reserved
> >> for a later patch.
> >
> > Why?
> 
> This is for drivers like pmem that care about the mapping type.  For
> example, if pmem can't get a cache-enabled mapping it is potentially
> putting the write durability of the persistent media at risk.

I understand that part, but the question is why the old behavior
is retained for now and only changed later.
