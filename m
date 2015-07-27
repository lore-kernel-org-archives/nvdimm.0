Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 27 Jul 2015 07:14:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 25/25] pmem: convert to generic memremap
Message-ID: <20150727051413.GC15836@lst.de>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com> <20150725024020.8664.52581.stgit@dwillia2-desk3.amr.corp.intel.com> <20150726173317.GD29513@lst.de> <CAPcyv4jsnQ1CzgXkkpzJnfjnKMmxiwyhQ_3osgo9vmjceP+rZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jsnQ1CzgXkkpzJnfjnKMmxiwyhQ_3osgo9vmjceP+rZA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jul 26, 2015 at 11:11:44AM -0700, Dan Williams wrote:
> I don't follow.  We have __iomem for the cpu mapping of a resource and
> dma_map() for a PCI device.  __pmem works the same and is there to
> make sure someone doesn't simply de-reference a pointer to pmem and
> hope that the write is persistent.

But no deference of a kernel pointer is magily persistent, so I'm
not really worried about that.  It just means whenever we want to
pass it to anything we'll need to cast.  And anything that does
I/O falls into that category.
