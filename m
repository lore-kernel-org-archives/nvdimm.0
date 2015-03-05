Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F82ED1.8030900@plexistor.com>
Date: Thu, 05 Mar 2015 12:24:17 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 3/3] e820: Add the unknown-12 Memory type (DDR3-NvDIMM)
References: <54F82CE0.4040502@plexistor.com>
In-Reply-To: <54F82CE0.4040502@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>


There are multiple vendors of DDR3 NvDIMMs out in the market today.
At various stages of development/production. It is estimated that
there are already more the 100ds of thousands chips sold to
testers and sites.

All the BIOS vendors I know of, tagged these chips at e820 table
as type-12 memory.

Now the ACPI comity, as far as I know, did not yet define a
standard type for NvDIMM. Also, as far as I know any NvDIMM
standard will only be defined for DDR4. So DDR3 NvDIMM is
probably stuck with this none STD type.

I Wish and call the ACPI comity to Define that NvDIMM is type-12.
Also for DDR4

The motivation of this patch is to be able to differentiate
this NvDIMM type from a real future "unknown-reserved" type.

In this patch I name type-12 "unknown-12". This is because of
ACPI politics that refuse to reserve type-12 as DDR3-NvDIMM
and members keep saying:
	"What if ACPI assigns type-12 for something else in future"

[And I say: Then just don't. Please?]

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 arch/x86/kernel/e820.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index c2f2da2..4bf574a 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -25,6 +25,11 @@
 #include <asm/proto.h>
 #include <asm/setup.h>
 
+/* These are nonstandard Memory types that we do not want in the exported
+ * header.
+ */
+#define E820_UNKNOWN_12 12	/* This is the unofficial DDR3-NVDIMM */
+
 /*
  * The e820 map is the map that gets modified e.g. with command line parameters
  * and that is also registered with modifications in the kernel resource tree
@@ -169,6 +174,9 @@ static void __init e820_print_type(u32 type)
 	case E820_UNUSABLE:
 		printk(KERN_CONT "unusable");
 		break;
+	case E820_UNKNOWN_12:
+		printk(KERN_CONT "unknown-12");
+		break;
 	default:
 		printk(KERN_CONT "type %u", type);
 		break;
@@ -928,6 +936,7 @@ static inline const char *e820_type_to_string(int e820_type)
 	case E820_NVS:	return "ACPI Non-volatile Storage";
 	case E820_UNUSABLE:	return "Unusable memory";
 	case E820_RESERVED:	return "reserved";
+	case E820_UNKNOWN_12:	return "unknown-12";
 	default:		return "reserved-unknown";
 	}
 }
-- 
1.9.3


