Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x232.google.com (mail-wm0-x232.google.com
 [IPv6:2a00:1450:400c:c09::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 332FD1A1E03
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 01:32:33 -0700 (PDT)
Received: by mail-wm0-x232.google.com with SMTP id r190so25661938wmr.0
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 01:31:58 -0700 (PDT)
From: Yigal Korman <yigal@plexistor.com>
Subject: [RESEND PATCH] x86/mm: only allow memmap=XX!YY over existing RAM
Date: Tue, 28 Jun 2016 11:31:11 +0300
Message-Id: <1467102671-593138-1-git-send-email-yigal@plexistor.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Before this patch, passing a range that is beyond the physical memory
range will succeed, the user will see a /dev/pmem0 and will be able to
access it. Reads will always return 0 and writes will be silently
ignored.

I've gotten more than one bug report about mkfs.{xfs,ext4} or nvml
failing that were eventually tracked down to be wrong values passed to
memmap.

This patch prevents the above issue by instead of adding a new memory
range, only update a RAM memory range with the PRAM type. This way,
passing the wrong memmap will either not give you a pmem at all or give
you a smaller one that actually has RAM behind it.

And if someone still needs to fake a pmem that doesn't have RAM behind
it, they can simply do memmap=XX@YY,XX!YY.

Signed-off-by: Yigal Korman <yigal@plexistor.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Boaz Harrosh <boaz@plexistor.com>
---
 arch/x86/kernel/e820.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 621b501..4bd4207 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -878,7 +878,7 @@ static int __init parse_memmap_one(char *p)
 		e820_add_region(start_at, mem_size, E820_RESERVED);
 	} else if (*p == '!') {
 		start_at = memparse(p+1, &p);
-		e820_add_region(start_at, mem_size, E820_PRAM);
+		e820_update_range(start_at, mem_size, E820_RAM, E820_PRAM);
 	} else
 		e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
-- 
1.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
