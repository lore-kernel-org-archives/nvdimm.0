Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54E1D0F3.2030809@plexistor.com>
Date: Mon, 16 Feb 2015 13:13:55 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 1/2] e820: Don't let unknown DIMM type come out BUSY
References: <54E1CF5B.9020905@plexistor.com>
In-Reply-To: <54E1CF5B.9020905@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
List-ID: <linux-nvdimm@lists.01.org>


There is something not very nice (Gentlemen nice) In current
e820.c code.

At Multiple place for example @ memblock_x86_fill(), it will
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

An example of such "UNKNOWN" type is the not Standard type-12
DDR3-NvDIMM which is used by multiple vendors for a while
now. (Estimated 100ds of thousands sold world wide)
A later patch adds type-12 to the list of "KNOWN", types.

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 arch/x86/kernel/e820.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 46201de..8cfd25f 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -907,7 +907,23 @@ static inline const char *e820_type_to_string(int e820_type)
 	case E820_ACPI:	return "ACPI Tables";
 	case E820_NVS:	return "ACPI Non-volatile Storage";
 	case E820_UNUSABLE:	return "Unusable memory";
-	default:	return "reserved";
+	case E820_RESERVED:	return "reserved";
+	default:	return "reserved-unkown";
+	}
+}
+
+static bool _is_reserved_type(int e820_type)
+{
+	switch (e820_type) {
+	case E820_RESERVED_KERN:
+	case E820_RAM:
+	case E820_ACPI:
+	case E820_NVS:
+	case E820_UNUSABLE:
+		return false;
+	case E820_RESERVED:
+	default:
+		return true;
 	}
 }
 
@@ -940,7 +956,7 @@ void __init e820_reserve_resources(void)
 		 * pci device BAR resource and insert them later in
 		 * pcibios_resource_survey()
 		 */
-		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20)) {
+		if (!_is_reserved_type(e820.map[i].type) || res->start < (1ULL<<20)) {
 			res->flags |= IORESOURCE_BUSY;
 			insert_resource(&iomem_resource, res);
 		}
-- 
1.9.3


