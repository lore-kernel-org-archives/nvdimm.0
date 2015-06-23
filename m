Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20150623100757.GA24894@lst.de>
References: <20150622081028.35954.89885.stgit@dwillia2-desk3.jf.intel.com>
	<20150622082427.35954.73529.stgit@dwillia2-desk3.jf.intel.com>
	<20150622161002.GB8240@lst.de>
	<CAPcyv4gSMixA6KNpqXR8pkEpff=Z-N+LbQmuxpiVLs4yMfqZSg@mail.gmail.com>
	<20150623100757.GA24894@lst.de>
Date: Tue, 23 Jun 2015 08:04:47 -0700
Message-ID: <CAPcyv4hXwdsF0a1=FhK6wn5US9p-T9t7OxwVsiMiCM=M-a7o6Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/6] arch: unify ioremap prototypes and macro aliases
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Juergen Gross <jgross@suse.com>, X86 ML <x86@kernel.org>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Luis Rodriguez <mcgrof@suse.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefan Bader <stefan.bader@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>, Ralf Baechle <ralf@linux-mips.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, mpe@ellerman.id.au, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@samba.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 23, 2015 at 3:07 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Jun 22, 2015 at 10:12:40AM -0700, Dan Williams wrote:
>> Is that an acked-by for this cycle with a request to go deeper for 4.3?
>
> I wouldn't really expect something this wide reaching to be picked up
> for this cycle, but if you manage to get it in:
>
> Acked-by: Christoph Hellwig <hch@lst.de>

Thanks, definitely a long shot at this point, but this is what one
gets for fixing rather than working around broken base infrastructure.
It would be unfortunate if we went another cycle with pmem having both
poor performance and broken persistence guarantees.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
