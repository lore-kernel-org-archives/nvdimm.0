Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54E1CF5B.9020905@plexistor.com>
Date: Mon, 16 Feb 2015 13:07:07 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 0/2] e820: Fix handling of NvDIMM chips
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi

There is a deficiency in current e820.c handling where unknown new memory-chip
types come up as a BUSY resource when some other driver (like pmem) tries to
call request_mem_region_exclusive() on that resource. Even though, actually
there is nothing using it.
>From inspecting the code and the history of e820.c it looks like a BUG.

In any way this is a problem for the new type-12 NvDIMM memory chips that
are circulating around. (It is estimated that there are already 100ds of
thousands NvDIMM chips in active use)

The patches below first fixes the above problem for any future type
memory, so external drivers can access these mem chips.

I then also add the NvDIMM type-12 memory constant so it comes up
nice in dprints and at /proc/iomem

Just as before all these chips are very much usable with the pmem
driver. This lets us remove the hack for type-12 NvDIMMs that ignores
the return code from request_mem_region_exclusive() in pmem.c.

There is a 3rd patch just for reference to pmem.c which enables
pmem to work also on Old Kernels which do not include these 2
patches.

For all the pmem people. I maintain a tree with these patches
and latest pmem code (Also including DAX) here:
	git://git.open-osd.org/pmem.git
	[web-view:http://git.open-osd.org/gitweb.cgi?p=pmem.git;a=summary]

List of patches:
[PATCH 1/2] e820: Don't let unknown DIMM type come out BUSY
[RFC 2/2] e820: Add the NvDIMM Memory type (type-12)
	These are for submission

[PATCH 3/3] pmem: Allow request_mem to fail (CONFIG_BLK_DEV_PMEM_IGNORE_REQUEST_MEM_RET)
	Just for reference

Thanks
Boaz

