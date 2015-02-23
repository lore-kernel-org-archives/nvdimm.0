Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54EB219F.5050706@plexistor.com>
Date: Mon, 23 Feb 2015 14:48:31 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 3B/3 fat] e820: dynamic unknown-xxx names (for DDR3-NvDIMM)
References: <54EB1D33.3050107@plexistor.com>
In-Reply-To: <54EB1D33.3050107@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
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

In this patch I dynamically sprintf names into a static buffer
(max two unknown names) of the form "unknown-XXX" where XXX
is the type number. This is so we can return static string to
caller.

If there are too many types or type is bigger than 999 we
name the unknown region as "unknown-xxx"

I hope this patch is not accepted and that the simple patch
that just names above as "unknown-12" is. KISS right?

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 arch/x86/include/uapi/asm/e820.h |  1 -
 arch/x86/kernel/e820.c           | 29 ++++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
index d993e33..1f11303 100644
--- a/arch/x86/include/uapi/asm/e820.h
+++ b/arch/x86/include/uapi/asm/e820.h
@@ -33,7 +33,6 @@
 #define E820_NVS	4
 #define E820_UNUSABLE	5
 
-
 /*
  * reserved RAM used by kernel itself
  * if CONFIG_INTEL_TXT is enabled, memory of this type will be
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 18a9850..3e06bab 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -919,6 +919,33 @@ void __init finish_e820_parsing(void)
 	}
 }
 
+static const char *_unknown_name(uint e820_type)
+{
+	enum {
+		MAX_UNKNOWN_TYPES = 1,
+		UNKNOWN_NAME_SIZE =  16, /* unknown-xxx\0 */
+	};
+	static struct __unknown_name__ {
+		int type;
+		char name[UNKNOWN_NAME_SIZE];
+	} names[MAX_UNKNOWN_TYPES];
+	static int num_names;
+
+	int i;
+
+	for (i = 0; i < num_names; ++i)
+		if (e820_type == names[i].type)
+			return names[i].name;
+
+	if ((num_names == MAX_UNKNOWN_TYPES) || (e820_type > 999))
+		return "unknown-xxx";
+
+	snprintf(names[++num_names].name, UNKNOWN_NAME_SIZE,
+		 "unknown-%03d", e820_type);
+	names[num_names].type = e820_type;
+	return names[num_names].name;
+}
+
 static inline const char *e820_type_to_string(int e820_type)
 {
 	switch (e820_type) {
@@ -928,7 +955,7 @@ static inline const char *e820_type_to_string(int e820_type)
 	case E820_NVS:	return "ACPI Non-volatile Storage";
 	case E820_UNUSABLE:	return "Unusable memory";
 	case E820_RESERVED:	return "reserved";
-	default:	return "reserved-unkown";
+	default:	return _unknown_name(e820_type);
 	}
 }
 
-- 
1.9.3


