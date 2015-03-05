Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F82CE0.4040502@plexistor.com>
Date: Thu, 05 Mar 2015 12:16:00 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 0/3 v5] e820: Fix handling of NvDIMM chips
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi

[v5]
* [PATCH 2/3] Added the add_taint(TAINT_FIRMWARE_WORKAROUND,...)
   and changed the printed message as requested
* Use IORESOURCE_MEM_WARN bit from the mem specific bit range
  (not 64bit only anymore, only works with memory resources)
* Fix user visible typo reserved-unkown => reserved-unknown &&
	unkown-12 => unknown-12
* Select [PATCH 3A/3] (over [PATCH 3B/3])
* ...
* Also posting RFC of pmem as reference

[v2]
* Added warning at bring up about unknown type
* Added an extra patch to warn-print in request_resource
* changed name from NvDIMM-12 => unknown-12
  I wish we would reconsider this. So we need to suffer until some unknown
  future when ACPI decides to reuse type-12. When this happens we can fix
  it then, NO?
* Now based on 4.0-rc1

[v1]
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

For all the pmem people. I maintain a tree with these patches
and latest pmem code here:
	git://git.open-osd.org/pmem.git (pmem branch)
	[web-view:http://git.open-osd.org/gitweb.cgi?p=pmem.git;a=summary]

List of patches:
 [PATCH 1/3] e820: Don't let unknown DIMM type come out BUSY
	The main fix

 [PATCH 2/3] resource: Add new flag IORESOURCE_MEM_WARN
	Warn in request_resource

 [PATCH 3/3] e820: Add the unknown-12 Memory type (DDR3-NvDIMM)

Also submitted as reference is an RFC of the pmem driver that demonstrates
the use of the add_resource API for the NvDIMM chips. This can be seen in
pmem-patch-1. Also please see pmem-patch-8 an out-of-tree patch that
ignores the add_resource failure so it can work with NvDIMMs with old
kernels.

Thanks
Boaz

