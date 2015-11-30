Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 29 Nov 2015 22:26:34 -0800
Message-ID: <CALCETrX_9WD=awMKLPoG81+W2K2gzWLSatbZr98w5m5-TujCzA@mail.gmail.com>
Subject: Cleaning up e820_pmem?
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

My laptop has /sys/devices/platform/e820_pmem and autoloads all the
nvdimm infrastructure.  While it would be really cool if my laptop had
pmem, that's a bit of a pipe dream right now.  (Even if it did have
it, this laptop is brand new -- it should use NFIT, not e820_pmem.)

Could we move the iomem_resource loop from drivers/nvdimm/e820.c to
arch/x86/kernel/pmem.c and actually list the iomem resources the
standard way as resources belonging to the platform device?  That
would match accepted practice, and it would keep the grossly
x86-specific part of the driver in arch/x86.  Then we could further
tweak it to skip creating the platform device at all if there are no
resources, and we'd avoid needlessly loading the module.

I'd do this myself, except that my lovely machine that *does* support
e820 pmem has been repurposed, so testing on a machine that actually
supports this turd is awkward for me.

--Andy
