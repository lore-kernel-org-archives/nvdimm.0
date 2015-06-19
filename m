Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 3/3] mm: Fix bugs in region_is_ram()
Date: Fri, 19 Jun 2015 15:44:05 -0600
Message-Id: <1434750245-6304-4-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1434750245-6304-1-git-send-email-toshi.kani@hp.com>
References: <1434750245-6304-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org
Cc: travis@sgi.com, roland@purestorage.com, dan.j.williams@intel.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

region_is_ram(), which looks up the resource to check if
a target range is RAM, always returns -1 due to a bug in
the range check.  It always breaks the loop at the first
entry of the resouce table.

The function compares p->flags and flags, which also has
a bug.  The flags is declared as int, which makes it as
a negative value with IORESOURCE_BUSY (0x80000000) set
while p->flags is unsigned long.

Fix the range check and flags so that region_is_ram()
works as advertised.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 kernel/resource.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 90552aa..fed052a 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -504,13 +504,13 @@ int region_is_ram(resource_size_t start, unsigned long size)
 {
 	struct resource *p;
 	resource_size_t end = start + size - 1;
-	int flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	unsigned long flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	const char *name = "System RAM";
 	int ret = -1;
 
 	read_lock(&resource_lock);
 	for (p = iomem_resource.child; p ; p = p->sibling) {
-		if (end < p->start)
+		if (p->end < start)
 			continue;
 
 		if (p->start <= start && end <= p->end) {
@@ -521,7 +521,7 @@ int region_is_ram(resource_size_t start, unsigned long size)
 				ret = 1;
 			break;
 		}
-		if (p->end < start)
+		if (end < p->start)
 			break;	/* not found */
 	}
 	read_unlock(&resource_lock);
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
