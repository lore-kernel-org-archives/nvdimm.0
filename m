Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20150617113121.GC9246@lst.de>
References: <20150611211354.10271.57950.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150611211947.10271.80768.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617113121.GC9246@lst.de>
Date: Wed, 17 Jun 2015 07:54:14 -0700
Message-ID: <CAPcyv4hkS+3iTqJkcuES13vZKNYdWKufAqjD3+Pf4BaZ88nZEQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] arch, x86: pmem api for ensuring durability of
 persistent memory updates
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Juergen Gross <jgross@suse.com>, X86 ML <x86@kernel.org>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Luis Rodriguez <mcgrof@suse.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefan Bader <stefan.bader@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>, Ralf Baechle <ralf@linux-mips.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, mpe@ellerman.id.au, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@samba.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 17, 2015 at 4:31 AM, Christoph Hellwig <hch@lst.de> wrote:
> This mess with arch_ methods and an ops vecor is almost unreadable.
>
> What's the problem with having something like:
>
> pmem_foo()
> {
>         if (arch_has_pmem)              // or sync_pmem
>                 arch_pmem_foo();
>         generic_pmem_foo();
> }
>
> This adds a branch at runtime, but that shoudn't really be any slower
> than an indirect call on architectures that matter.

No doubt it's premature optimization, but it bothered me that we'll
end up calling cpuid perhaps multiple times every i/o.  If it's just a
readability concern I could wrap it in helpers.  Getting it upstream
is my primary concern at this point so I have no strong attachment to
the indirect calls if that's all that is preventing an ack.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
