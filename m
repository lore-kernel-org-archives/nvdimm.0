Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <1431551151-19124-11-git-send-email-toshi.kani@hp.com>
References: <1431551151-19124-1-git-send-email-toshi.kani@hp.com>
	<1431551151-19124-11-git-send-email-toshi.kani@hp.com>
Date: Thu, 14 May 2015 14:52:18 -0700
Message-ID: <CAPcyv4je=q92aytAXLR=Eqc3yD8pdmSuyuCF+4QJRb34LFU=VQ@mail.gmail.com>
Subject: Re: [PATCH v9 10/10] drivers/block/pmem: Map NVDIMM with ioremap_wt()
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, jgross@suse.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, mcgrof@suse.com, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stefan.bader@canonical.com, Andy Lutomirski <luto@amacapital.net>, linux-mm@kvack.org, hmh@hmh.eng.br, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 13, 2015 at 2:05 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> The pmem driver maps NVDIMM with ioremap_nocache() as we cannot
> write back the contents of the CPU caches in case of a crash.
>
> This patch changes to use ioremap_wt(), which provides uncached
> writes but cached reads, for improving read performance.

I'm thinking that for the libnd integration we don't want the pmem
driver hard coding the cache-policy decision.  This is something that
should be specified to nd_pmem_region_create().  Especially
considering that platform firmware tables (NFIT) may specify the cache
policy for the range.  As Matthew Wilcox mentioned offline we also
must match the DAX-to-mmap cache policy with the policy for the driver
mapping  for architectures that are not capable of multiple mappings
of the same physical address with different policies.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
