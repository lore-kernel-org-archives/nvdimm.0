Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CD708185B
 for <linux-nvdimm@lists.01.org>; Fri, 30 Dec 2016 18:26:09 -0800 (PST)
Date: Sat, 31 Dec 2016 02:25:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [RFC] memcpy_nocache() and memcpy_writethrough()
Message-ID: <20161231022558.GW1555@ZenIV.linux.org.uk>
References: <20161026155021.20892-1-brian.boylston@hpe.com>
 <20161026155021.20892-2-brian.boylston@hpe.com>
 <58110959.90901@plexistor.com>
 <CS1PR84MB011975E5DCF3B091E53A3FB38EAD0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <5818A5C8.6040300@plexistor.com>
 <20161228234321.GA27417@ZenIV.linux.org.uk>
 <CAPcyv4gg1XNJ3E=+0HDZnx08_dvvX+Prj-rLOsXcuHHO1pBLzg@mail.gmail.com>
 <20161230035252.GV1555@ZenIV.linux.org.uk>
 <CAPcyv4gC0gaT7csVb=CbwhVNxGePDcSzOMZ_RXu+Q55uY3ScnA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gC0gaT7csVb=CbwhVNxGePDcSzOMZ_RXu+Q55uY3ScnA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Moreno," Oliver" <oliver.moreno@hpe.com>, "x86@kernel.org, " <x86@kernel.org>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, "boylston@burromesa.net" <boylston@burromesa.net>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 29, 2016 at 08:56:13PM -0800, Dan Williams wrote:

> > Um...  Then we do have a problem - nocache variant of uaccess primitives
> > does *not* guarantee that clwb is redundant.
> >
> > What about the requirements of e.g. tcp_sendmsg() with its use of
> > skb_add_data_nocache()?  What warranties do we need there?
> 
> Yes, we need to distinguish the existing "nocache" that tries to avoid
> unnecessary cache pollution and this new "must write through" semantic
> for writing to persistent memory. I suspect usages of
> skb_add_data_nocache() are ok since they are in the transmit path.
> Receiving directly into a buffer that is expected to be persisted
> immediately is where we would need to be careful, but that is already
> backstopped by dirty cacheline tracking. So as far as I can see, we
> should only need a new memcpy_writethrough() (?) for the pmem
> direct-i/o path at present.

OK...  Right now we have several places playing with nocache:
	* dax_iomap_actor().  Writethrough warranties needed, nocache
side serves to reduce the cache impact *and* avoid the need for clwb
for writethrough.
	* several memcpy_to_pmem() users - acpi_nfit_blk_single_io(),
nsio_rw_bytes(), write_pmem().  No clwb attempted; is it needed there?
	* hfi1_copy_sge().  Cache pollution avoidance?  The source is
in the kernel, looks like memcpy_nocache() candidate.
	* ntb_memcpy_tx().  Really fishy one - it's from kernel to iomem,
with nocache userland->kernel copying primitive abused on x86.  As soon
as e.g. powerpc or sparc grows ARCH_HAS_NOCACHE_UACCESS, we are in trouble
there.  What is it actually trying to achieve?  memcpy_toio() with
cache pollution avoidance?
	* networking copy_from_iter_full_nocache() users - cache pollution
avoidance, AFAICS; no writethrough warranties sought.

Why does pmem need writethrough warranties, anyway?  All explanations I've
found on the net had been along the lines of "we should not store a pointer
to pmem data structure until the structure itself had been committed to
pmem itself" and it looks like something that ought to be a job for barriers
- after all, we don't want the pointer store to be observed by _anything_
in the system until the earlier stores are visible, so what makes pmem
different from e.g. another CPU or a PCI busmaster, or...

I'm trying to figure out what would be the right API here; sure, we can
add separate memcpy_writethrough()/__copy_from_user_inatomic_writethrough()/
copy_from_iter_writethrough(), but I would like to understand what's going
on first.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
