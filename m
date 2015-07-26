Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sun, 26 Jul 2015 19:33:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 25/25] pmem: convert to generic memremap
Message-ID: <20150726173317.GD29513@lst.de>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com> <20150725024020.8664.52581.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150725024020.8664.52581.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com, linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 24, 2015 at 10:40:20PM -0400, Dan Williams wrote:
> Update memremap_pmem() to query the architecture for the mapping type of
> the given persistent memory range  and then pass those flags to generic
> memremap().  arch_memremap_pmem_flags() is provided an address range to
> evaluate in the event an arch has a need for different mapping types by
> address range.  For example the ACPI NFIT carries EFI mapping types in
> its memory range description table.

I don't think the pmem driver should look at a arch hook here, please
communicate this through the nvdimm subsystem.

Btw, looking at these changes I also think the __pmem annotations
are mistake.  We might have all kinds of ways to write to pmem,
and as long as we properly flush it we don't need to force it
through the special accessors.  This becomes really interesting
for PCI DMA access.
