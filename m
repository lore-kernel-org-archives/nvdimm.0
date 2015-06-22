Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 22 Jun 2015 18:01:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 1/6] arch, drivers: don't include <asm/io.h>
	directly, use <linux/io.h> instead
Message-ID: <20150622160105.GA8240@lst.de>
References: <20150622081028.35954.89885.stgit@dwillia2-desk3.jf.intel.com> <20150622082422.35954.42399.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150622082422.35954.42399.stgit@dwillia2-desk3.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: arnd@arndb.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de, ross.zwisler@linux.intel.com, akpm@linux-foundation.org, jgross@suse.com, x86@kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, mcgrof@suse.com, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, stefan.bader@canonical.com, luto@amacapital.net, linux-mm@kvack.org, geert@linux-m68k.org, ralf@linux-mips.org, hmh@hmh.eng.br, mpe@ellerman.id.au, tj@kernel.org, paulus@samba.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 22, 2015 at 04:24:22AM -0400, Dan Williams wrote:
> Preparation for uniform definition of ioremap, ioremap_wc, ioremap_wt,
> and ioremap_cache, tree-wide.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
