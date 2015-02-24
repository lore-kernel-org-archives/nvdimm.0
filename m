Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54EC38CA.6050607@plexistor.com>
Date: Tue, 24 Feb 2015 10:39:38 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 2/3 v3] resource: Add new flag IORESOURCE_MEM_WARN
References: <54EB1D33.3050107@plexistor.com> <54EB206E.4010009@plexistor.com> <CALCETrXBwJdAarXVgO7VaEkTHtnO=-+n7mXy02PbS+sLqNiMyA@mail.gmail.com>
In-Reply-To: <CALCETrXBwJdAarXVgO7VaEkTHtnO=-+n7mXy02PbS+sLqNiMyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>


Resource providers set this flag if they want
that request_region_XXX will print a warning in dmesg
if this particular resource is locked by a driver.

Thous acting as a Protocol Police about experimental
devices that did not pass a comity approval.

The Only user of  this flag is x86/kernel/e820.c that
wants to WARN about UNKNOWN memory types.

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 arch/x86/kernel/e820.c | 3 +++
 include/linux/ioport.h | 2 +-
 kernel/resource.c      | 7 ++++++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 1a8a1c3..105bb37 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -961,6 +961,9 @@ void __init e820_reserve_resources(void)
 
 		res->flags = IORESOURCE_MEM;
 
+		if (_is_unknown_type(e820.map[i].type))
+			res->flags |= IORESOURCE_MEM_WARN;
+
 		/*
 		 * don't register the region that could be conflicted with
 		 * pci device BAR resource and insert them later in
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 2c525022..183af93 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -90,6 +90,7 @@ struct resource {
 #define IORESOURCE_MEM_32BIT		(3<<3)
 #define IORESOURCE_MEM_SHADOWABLE	(1<<5)	/* dup: IORESOURCE_SHADOWABLE */
 #define IORESOURCE_MEM_EXPANSIONROM	(1<<6)
+#define IORESOURCE_MEM_WARN		(1<<7)	/* WARN if requested by driver */
 
 /* PnP I/O specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_IO_16BIT_ADDR	(1<<0)
@@ -255,6 +256,5 @@ static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
        return (r1->start <= r2->end && r1->end >= r2->start);
 }
 
-
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/kernel/resource.c b/kernel/resource.c
index 19f2357..fca23ff 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1075,8 +1075,13 @@ struct resource * __request_region(struct resource *parent,
 			break;
 		if (conflict != parent) {
 			parent = conflict;
-			if (!(conflict->flags & IORESOURCE_BUSY))
+			if (!(conflict->flags & IORESOURCE_BUSY)) {
+				if (conflict->flags & IORESOURCE_MEM_WARN)
+					pr_warn("request unknown region [mem %#010llx-%#010llx] %s\n",
+						conflict->start, conflict->end,
+						conflict->name);
 				continue;
+			}
 		}
 		if (conflict->flags & flags & IORESOURCE_MUXED) {
 			add_wait_queue(&muxed_resource_wait, &wait);
-- 
1.9.3


