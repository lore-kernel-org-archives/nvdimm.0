Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54EB206E.4010009@plexistor.com>
Date: Mon, 23 Feb 2015 14:43:26 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 2/3] resource: Add new flag IORESOURCE_WARN (64bit)
References: <54EB1D33.3050107@plexistor.com>
In-Reply-To: <54EB1D33.3050107@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>


Resource providers set this flag if they want
that request_region_XXX will print a warning in dmesg
if this particular resource is locked by a driver.

Thous acting as a Protocol Police about experimental
devices that did not pass a comity approval.

The warn print looks like this:
  [Feb22 19:59] resource: request unknown region [mem 0x100000000-0x1ffffffff] unkown-12
Where the unkown-12 is taken from the res->name

The Only user of  this flag is x86/kernel/e820.c that
wants to WARN about UNKNOWN memory types.

NOTE: This patch looks very simple, a bit flag
  communicates between a resource provider ie e820.c
  that a warning should be printed, and resource.c
  prints such a message, when the resource is locked
  for use.

  BUT the basic flaw here is that we have run out of flags
  for a 32-bit long. My route here is to create wrappers
  that at 32-bit do nothing.

  Since only current user is e820.c for DDR3-NvDIMMs, this
  should be fine, because DDR3-NvDIMMs are not very useful
  with 32-bit ARCHES. In fact the smallest chip I know is
  4G, and NvDIMM is not currently supported as highmem (nor
  are there any plans to support it)

  OR: Maybe there is an extra bit that can be used at:
      /* PnP memory I/O specific bits */
        @@ -92,6 +90,7 @@ struct resource {
	 #define IORESOURCE_MEM_32BIT		(3<<3)
	 #define IORESOURCE_MEM_SHADOWABLE	(1<<5)	/* dup: IORESOURCE_SHADOWABLE */
	 #define IORESOURCE_MEM_EXPANSIONROM	(1<<6)
	+#define IORESOURCE_MEM_WARN		(1<<7)	/* WARN if used by drivers */

	 /* PnP I/O specific bits (IORESOURCE_BITS) */
	 #define IORESOURCE_IO_16BIT_ADDR	(1<<0)

    And get rid of the wrappers, Please advise ?

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
CC: Dan Williams <dan.j.williams@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 arch/x86/kernel/e820.c |  3 +++
 include/linux/ioport.h | 23 +++++++++++++++++++++++
 kernel/resource.c      |  7 ++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 1a8a1c3..18a9850 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -961,6 +961,9 @@ void __init e820_reserve_resources(void)
 
 		res->flags = IORESOURCE_MEM;
 
+		if (_is_unknown_type(e820.map[i].type))
+			resource_set_warn_on_use(res, true);
+
 		/*
 		 * don't register the region that could be conflicted with
 		 * pci device BAR resource and insert them later in
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 2c525022..9a51738 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -54,6 +54,8 @@ struct resource {
 #define IORESOURCE_UNSET	0x20000000	/* No address assigned yet */
 #define IORESOURCE_AUTO		0x40000000
 #define IORESOURCE_BUSY		0x80000000	/* Driver has marked this resource busy */
+/* Flags only on 64bit */
+#define IORESOURCE_WARN		0x100000000	/* Use with wrapper Only */
 
 /* PnP IRQ specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_IRQ_HIGHEDGE		(1<<0)
@@ -255,6 +257,27 @@ static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
        return (r1->start <= r2->end && r1->end >= r2->start);
 }
 
+static inline void resource_set_warn_on_use(struct resource *r, bool warn)
+{
+	if (sizeof(r->flags) > sizeof(u32)) {
+		if (warn)
+			r->flags |= IORESOURCE_WARN;
+		else
+			r->flags &= ~IORESOURCE_WARN;
+	}
+	/* I'm not doing any prints here for the else case because I do not want
+	 * to add the extra chain of includes this needs. This is a pretty low
+	 *  level Header
+	 */
+}
+
+static inline bool resource_warn_on_use(struct resource *r)
+{
+	if (sizeof(r->flags) > sizeof(u32))
+		return (r->flags & IORESOURCE_WARN) != 0;
+	else
+		return false;
+}
 
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/kernel/resource.c b/kernel/resource.c
index 19f2357..eca6920 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1075,8 +1075,13 @@ struct resource * __request_region(struct resource *parent,
 			break;
 		if (conflict != parent) {
 			parent = conflict;
-			if (!(conflict->flags & IORESOURCE_BUSY))
+			if (!(conflict->flags & IORESOURCE_BUSY)) {
+				if (resource_warn_on_use(conflict))
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


