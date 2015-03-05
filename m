Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F82DD7.90600@plexistor.com>
Date: Thu, 05 Mar 2015 12:20:07 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 1/3] e820: Don't let unknown DIMM type come out BUSY
References: <54F82CE0.4040502@plexistor.com>
In-Reply-To: <54F82CE0.4040502@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>


There is something not very nice (Gentlemen nice) In current
e820.c code.

At Multiple places for example @memblock_x86_fill() it will
add the different memory resources *except the E820_RESERVED type*

Then at e820_reserve_resources() it will mark all !E820_RESERVED
as busy.

This is all fine when we have only the known types one of:
	E820_RESERVED_KERN:
	E820_RAM:
	E820_ACPI:
	E820_NVS:
	E820_UNUSABLE:
	E820_RESERVED:

But if the system encounters a brand new memory type it will
not add it to any memory list, But will proceed to mark it
BUSY. So now any other Driver in the system that does know
how to deal with this new type, is not able to call
request_mem_region_exclusive() on this new type because it is
hard coded BUSY even though nothing really uses it.

So make any unknown type behave like E820_RESERVED memory,
it will show up as available to first caller of
request_mem_region_exclusive().

I Also change the string representation of an unknown type
from "reserved" (So to not confuse with memmap "reserved"
region). And call it "reserved-unknown"
I wish I could return "reserved-type-X" But this is not possible
because one must return a constant, code-segment, string.

(NOTE: These unknown-types where called "reserved" in
 /proc/iomem and in dmesg but behaved differently. What this
 patch does is name them differently but let them behave
 the same)

By Popular demand An Extra WARNING message is printed if
an "UNKNOWN" is found. It will look like this:
  e820: WARNING [mem 0x100000000-0x1ffffffff] is unknown type 12

An example of such "UNKNOWN" type is the not Standard type-12
DDR3-NvDIMM which is used by multiple vendors for a while
now. (Estimated 100ds of thousands sold world wide)

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
CC: Dan Williams <dan.j.williams@intel.com>
CC: Matthew Wilcox <willy@linux.intel.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 arch/x86/kernel/e820.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 46201de..c3a11cd 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -104,6 +104,21 @@ int __init e820_all_mapped(u64 start, u64 end, unsigned type)
 	return 0;
 }
 
+static bool _is_unknown_type(int e820_type)
+{
+	switch (e820_type) {
+	case E820_RESERVED_KERN:
+	case E820_RAM:
+	case E820_ACPI:
+	case E820_NVS:
+	case E820_UNUSABLE:
+	case E820_RESERVED:
+		return false;
+	default:
+		return true;
+	}
+}
+
 /*
  * Add a memory region to the kernel e820 map.
  */
@@ -119,6 +134,11 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 		return;
 	}
 
+	if (unlikely(_is_unknown_type(type)))
+		pr_warn("e820: WARNING [mem %#010llx-%#010llx] is unknown type %d\n",
+		       (unsigned long long) start,
+		       (unsigned long long) (start + size - 1), type);
+
 	e820x->map[x].addr = start;
 	e820x->map[x].size = size;
 	e820x->map[x].type = type;
@@ -907,10 +927,16 @@ static inline const char *e820_type_to_string(int e820_type)
 	case E820_ACPI:	return "ACPI Tables";
 	case E820_NVS:	return "ACPI Non-volatile Storage";
 	case E820_UNUSABLE:	return "Unusable memory";
-	default:	return "reserved";
+	case E820_RESERVED:	return "reserved";
+	default:		return "reserved-unknown";
 	}
 }
 
+static bool _is_reserved_type(int e820_type)
+{
+	return (e820_type == E820_RESERVED) || _is_unknown_type(e820_type);
+}
+
 /*
  * Mark e820 reserved areas as busy for the resource manager.
  */
@@ -940,7 +966,8 @@ void __init e820_reserve_resources(void)
 		 * pci device BAR resource and insert them later in
 		 * pcibios_resource_survey()
 		 */
-		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20)) {
+		if (!_is_reserved_type(e820.map[i].type) ||
+		    res->start < (1ULL<<20)) {
 			res->flags |= IORESOURCE_BUSY;
 			insert_resource(&iomem_resource, res);
 		}
-- 
1.9.3


