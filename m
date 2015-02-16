Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54E1D19B.30405@plexistor.com>
Date: Mon, 16 Feb 2015 13:16:43 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [RFC 2/2] e820: Add the NvDIMM Memory type (type-12)
References: <54E1CF5B.9020905@plexistor.com>
In-Reply-To: <54E1CF5B.9020905@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
List-ID: <linux-nvdimm@lists.01.org>


There are multiple vendors of DDR3 NvDIMMs out in the market today.
At various stages of development/production. It is estimated that
there are already more the 100ds of thousands chips sold to
testers and sites.

All the vendors I know of, tagged these chips as type-12 memory.

[THIS IS A CALL FOR ALL NvDIMM Vendors if you have used other
 then type-12 NvDIMM, please email me and I will add support
 for it]

Now the ACPI comity, as far as I know, did not yet define a
standard type for NvDIMM. Also, as far as I know any NvDIMM
standard will be defined for DDR4. So DDR3 NvDIMM will continue
to be supported by the individual vendors.

I Wish and call the ACPI comity to Define that NvDIMM is type-12.
Also for DDR4

In this patch I name type-12 "NvDIMM-12", but if there
are positive responses I would like to just name it "NvDIMM",
For any kind of DDR-X.

Actually is there any reason why I should not submit the final
version as "NvDIMM" from the get go. Then if the ACPI defines
another new type-Y Memory we can name both types "NvDIMM", No?
Please comment

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 arch/x86/include/uapi/asm/e820.h | 2 +-
 arch/x86/kernel/e820.c           | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
index d993e33..a0977e0 100644
--- a/arch/x86/include/uapi/asm/e820.h
+++ b/arch/x86/include/uapi/asm/e820.h
@@ -32,7 +32,7 @@
 #define E820_ACPI	3
 #define E820_NVS	4
 #define E820_UNUSABLE	5
-
+#define E820_NvDIMM_12 12
 
 /*
  * reserved RAM used by kernel itself
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 8cfd25f..17f7496 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -149,6 +149,9 @@ static void __init e820_print_type(u32 type)
 	case E820_UNUSABLE:
 		printk(KERN_CONT "unusable");
 		break;
+	case E820_NvDIMM_12:
+		printk(KERN_CONT "NvDIMM-12");
+		break;
 	default:
 		printk(KERN_CONT "type %u", type);
 		break;
@@ -908,6 +911,7 @@ static inline const char *e820_type_to_string(int e820_type)
 	case E820_NVS:	return "ACPI Non-volatile Storage";
 	case E820_UNUSABLE:	return "Unusable memory";
 	case E820_RESERVED:	return "reserved";
+	case E820_NvDIMM_12:	return "NvDIMM-12";
 	default:	return "reserved-unkown";
 	}
 }
@@ -922,6 +926,7 @@ static bool _is_reserved_type(int e820_type)
 	case E820_UNUSABLE:
 		return false;
 	case E820_RESERVED:
+	case E820_NvDIMM_12:
 	default:
 		return true;
 	}
-- 
1.9.3

