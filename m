Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jEhoYsW_M3SPG1_YVQCXtnytg6Wi+BfXU=idFSp-2wYg@mail.gmail.com>
References: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617231408.11597.28725.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CAMuHMdVMxoJFmzBZ_qAx5gDfZxsGUo2wJzawgMxS5TER==VUWQ@mail.gmail.com>
	<CAPcyv4jEhoYsW_M3SPG1_YVQCXtnytg6Wi+BfXU=idFSp-2wYg@mail.gmail.com>
Date: Wed, 1 Jul 2015 18:49:35 +0200
Message-ID: <CAMuHMdU8z7iUVaUaGs3f1kUcDus5Qg1+EQQ5uu7uCWrHO_kBaw@mail.gmail.com>
Subject: Re: [PATCH v7 09/16] libnvdimm, pmem: move pmem to drivers/nvdimm/
From: Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rafael@kernel.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 1, 2015 at 6:41 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Jul 1, 2015 at 6:13 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Thu, Jun 18, 2015 at 1:14 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> Prepare the pmem driver to consume PMEM namespaces emitted by regions of
>>> an nvdimm_bus instance.  No functional change.
>>
>> As LIBNVDIMM depends on PHYS_ADDR_T_64BIT, the driver can no
>> longer be enabled on pure 32-bit platforms. Is that intended?
>
> Yes it was intentional.  It still allows 32-bit platforms with 64-bit
> resource_size_t to compile. Do you otherwise have a 32-bit use case
> for pmem?  I'm of course open to working through the changes to add
> wider architecture support.

Nope, just wondering, as the original didn't depend on PHYS_ADDR_T_64BIT.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
