Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F82E41.9050203@plexistor.com>
Date: Thu, 05 Mar 2015 12:21:53 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 2/3] resource: Add new flag IORESOURCE_MEM_WARN
References: <54F82CE0.4040502@plexistor.com>
In-Reply-To: <54F82CE0.4040502@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>


memory resource providers set this flag if they want
that request_region will print a warning in dmesg
if this particular memory resource is locked by a driver.

Thous acting as a Protocol Police about experimental
devices that did not pass a committee approval.

The Only user of  this flag is x86/kernel/e820.c that
wants to WARN about UNKNOWN memory types.

NOTE: It would be preferred if I defined a general flag say
      IORESOURCE_WARN, where any kind of resource provider
      can WARN on use, but we have run out of flags in the
      32bit long systems. So I defined a free bit from the
      resource specific flags for mem resources. This is
      why I need to check if this is a memory resource first
      so not to conflict with other resource specific flags.
      (Though actually no one is using this specific bit)

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
 include/linux/ioport.h |  1 +
 kernel/resource.c      | 11 ++++++++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index c3a11cd..c2f2da2 100644
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
index 2c525022..f78972b 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -90,6 +90,7 @@ struct resource {
 #define IORESOURCE_MEM_32BIT		(3<<3)
 #define IORESOURCE_MEM_SHADOWABLE	(1<<5)	/* dup: IORESOURCE_SHADOWABLE */
 #define IORESOURCE_MEM_EXPANSIONROM	(1<<6)
+#define IORESOURCE_MEM_WARN		(1<<7)	/* WARN if requested by driver */
 
 /* PnP I/O specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_IO_16BIT_ADDR	(1<<0)
diff --git a/kernel/resource.c b/kernel/resource.c
index 19f2357..f886666 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1075,8 +1075,17 @@ struct resource * __request_region(struct resource *parent,
 			break;
 		if (conflict != parent) {
 			parent = conflict;
-			if (!(conflict->flags & IORESOURCE_BUSY))
+			if (!(conflict->flags & IORESOURCE_BUSY)) {
+				if ((resource_type(conflict) == IORESOURCE_MEM)
+				    && (conflict->flags & IORESOURCE_MEM_WARN)) {
+					add_taint(TAINT_FIRMWARE_WORKAROUND,
+						  LOCKDEP_STILL_OK);
+					pr_warn("%s requested an unknown memory type [mem %#010llx-%#010llx] %s\n",
+						name, conflict->start,
+						conflict->end, conflict->name);
+				}
 				continue;
+			}
 		}
 		if (conflict->flags & flags & IORESOURCE_MUXED) {
 			add_wait_queue(&muxed_resource_wait, &wait);
-- 
1.9.3


