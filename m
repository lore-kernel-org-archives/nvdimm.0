Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150617231408.11597.28725.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617231408.11597.28725.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Wed, 1 Jul 2015 15:13:00 +0200
Message-ID: <CAMuHMdVMxoJFmzBZ_qAx5gDfZxsGUo2wJzawgMxS5TER==VUWQ@mail.gmail.com>
Subject: Re: [PATCH v7 09/16] libnvdimm, pmem: move pmem to drivers/nvdimm/
From: Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rafael@kernel.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

On Thu, Jun 18, 2015 at 1:14 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> Prepare the pmem driver to consume PMEM namespaces emitted by regions of
> an nvdimm_bus instance.  No functional change.

As LIBNVDIMM depends on PHYS_ADDR_T_64BIT, the driver can no
longer be enabled on pure 32-bit platforms. Is that intended?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
