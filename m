Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 17 Jun 2015 13:14:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 1/6] arch: unify ioremap prototypes and macro aliases
Message-ID: <20150617111412.GA9079@lst.de>
References: <20150611211354.10271.57950.stgit@dwillia2-desk3.amr.corp.intel.com> <20150611211918.10271.74243.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150611211918.10271.74243.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: arnd@arndb.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de, ross.zwisler@linux.intel.com, akpm@linux-foundation.org, jgross@suse.com, x86@kernel.org, toshi.kani@hp.com, konrad.wilk@oracle.com, benh@kernel.crashing.org, mcgrof@suse.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stefan.bader@canonical.com, luto@amacapital.net, linux-mm@kvack.org, geert@linux-m68k.org, ralf@linux-mips.org, hmh@hmh.eng.br, mpe@ellerman.id.au, tj@kernel.org, paulus@samba.org, kbuild test robot <fengguang.wu@intel.com>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 11, 2015 at 05:19:18PM -0400, Dan Williams wrote:
> Some archs define the first parameter to ioremap() as unsigned long,
> while the balance define it as resource_size_t.  Unify on
> resource_size_t to enable passing ioremap function pointers.  Also, some
> archs use function-like macros for defining ioremap aliases, but
> asm-generic/iomap.h expects object-like macros, unify on the latter.

Not urgent:  but maybe this is a big hint that we should not define
the prototypes on a per-architecture basis but in a common header
file.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
