Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 1 Jul 2015 08:23:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 2/6] arch: unify ioremap prototypes and macro aliases
Message-ID: <20150701062352.GA3739@lst.de>
References: <20150622081028.35954.89885.stgit@dwillia2-desk3.jf.intel.com> <20150622082427.35954.73529.stgit@dwillia2-desk3.jf.intel.com> <20150622161002.GB8240@lst.de> <CAPcyv4h5OXyRvZvLGD5ZknO-YUPn675YGv0XdtW1QOO9qmZsug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4h5OXyRvZvLGD5ZknO-YUPn675YGv0XdtW1QOO9qmZsug@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Juergen Gross <jgross@suse.com>, X86 ML <x86@kernel.org>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Luis Rodriguez <mcgrof@suse.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefan Bader <stefan.bader@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>, Ralf Baechle <ralf@linux-mips.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, mpe@ellerman.id.au, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@samba.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 30, 2015 at 03:57:16PM -0700, Dan Williams wrote:
> > void __iomem *ioremap_flags(resource_size_t offset, unsigned long size,
> >                         unsigned long prot_val, unsigned flags);
> 
> Doesn't 'flags' imply a specific 'prot_val'?

Looks like the values are arch specific.  So as a first step I'd like
to keep them separate.  As a second step we could look into unifying
the actual ioremap implementations which look mostly the same.  Once
that is done we could look into collapsing the flags and prot_val
arguments.

> One useful feature of the ifdef mess as implemented in the patch is
> that you could test for whether ioremap_cache() is actually
> implemented or falls back to default ioremap().  I think for
> completeness archs should publish an ioremap type capabilities mask
> for drivers that care... (I can imagine pmem caring), or default to
> being permissive if something like IOREMAP_STRICT is not set.  There's
> also the wrinkle of archs that can only support certain types of
> mappings at a given alignment.

I think doing this at runtime might be a better idea.  E.g. a
ioremap_flags with the CACHED argument will return -EOPNOTSUP unless
actually implemented.  On various architectures different CPUs or
boards will have different capabilities in this area.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
