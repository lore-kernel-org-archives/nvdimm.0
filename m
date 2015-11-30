Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: Cleaning up e820_pmem?
Date: Mon, 30 Nov 2015 18:11:12 +0000
Message-ID: <1448907065.25710.0.camel@intel.com>
References: <CALCETrX_9WD=awMKLPoG81+W2K2gzWLSatbZr98w5m5-TujCzA@mail.gmail.com>
In-Reply-To: <CALCETrX_9WD=awMKLPoG81+W2K2gzWLSatbZr98w5m5-TujCzA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <33B403EA7E9E054D9C8FDF43CBAAD890@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "luto@amacapital.net" <luto@amacapital.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, 2015-11-29 at 22:26 -0800, Andy Lutomirski wrote:
+AD4- My laptop has /sys/devices/platform/e820+AF8-pmem and autoloads all the
+AD4- nvdimm infrastructure.+AKAAoA-While it would be really cool if my laptop
+AD4- had
+AD4- pmem, that's a bit of a pipe dream right now.+AKAAoA-(Even if it did have
+AD4- it, this laptop is brand new -- it should use NFIT, not e820+AF8-pmem.)
+AD4- 
+AD4- Could we move the iomem+AF8-resource loop from drivers/nvdimm/e820.c to
+AD4- arch/x86/kernel/pmem.c and actually list the iomem resources the
+AD4- standard way as resources belonging to the platform device?+AKAAoA-That
+AD4- would match accepted practice, and it would keep the grossly
+AD4- x86-specific part of the driver in arch/x86.+AKAAoA-Then we could further
+AD4- tweak it to skip creating the platform device at all if there are no
+AD4- resources, and we'd avoid needlessly loading the module.
+AD4- 
+AD4- I'd do this myself, except that my lovely machine that +ACo-does+ACo- support
+AD4- e820 pmem has been repurposed, so testing on a machine that actually
+AD4- supports this turd is awkward for me.

This works for me...

8+ADw----
Subject: libnvdimm, e820: skip module loading when no type-12

From: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

If there are no persistent memory ranges present then don't bother
creating the platform device.+AKAAoA-Otherwise, it loads the full libnvdimm
sub-system only to discover no resources present.

Reported-by: Andy Lutomirski +ADw-luto+AEA-amacapital.net+AD4-
Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
---
+AKA-arch/x86/kernel/pmem.c +AHwAoACgAKA-12 +-+-+-+-+-+-+-+-+-+-+-+-
+AKA-1 file changed, 12 insertions(+-)

diff --git a/arch/x86/kernel/pmem.c b/arch/x86/kernel/pmem.c
index 4f00b63d7ff3..14415aff1813 100644
--- a/arch/x86/kernel/pmem.c
+-+-+- b/arch/x86/kernel/pmem.c
+AEAAQA- -4,10 +-4,22 +AEAAQA-
+AKA- +ACo-/
+AKAAIw-include +ADw-linux/platform+AF8-device.h+AD4-
+AKAAIw-include +ADw-linux/module.h+AD4-
+-+ACM-include +ADw-linux/ioport.h+AD4-
+-
+-static int found(u64 start, u64 end, void +ACo-data)
+-+AHs-
+-	return 1+ADs-
+-+AH0-
+AKA-
+AKA-static +AF8AXw-init int register+AF8-e820+AF8-pmem(void)
+AKAAew-
+-	char +ACo-pmem +AD0- +ACI-Persistent Memory (legacy)+ACIAOw-
+AKA-	struct platform+AF8-device +ACo-pdev+ADs-
+-	int rc+ADs-
+-
+-	rc +AD0- walk+AF8-iomem+AF8-res(pmem, IORESOURCE+AF8-MEM, 0, -1, NULL, found)+ADs-
+-	if (rc +ADwAPQ- 0)
+-		return 0+ADs-
+AKA-
+AKA-	/+ACo-
+AKA-	+AKAAKg- See drivers/nvdimm/e820.c for the implementation, this is