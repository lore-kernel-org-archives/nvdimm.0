Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7886921A143F5
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 14:05:56 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] libnvdimm, btt: use %z format string modifier for size_t
Date: Fri,  8 Sep 2017 23:08:08 +0200
Message-Id: <20170908210830.525785-1-arnd@arndb.de>
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
To: Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
List-ID: <linux-nvdimm@lists.01.org>

We get a warning about an two incorrect format strings:

drivers/nvdimm/btt.c: In function 'btt_map_init':
include/linux/device.h:1472:23: error: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type 'size_t {aka unsigned int}' [-Werror=format=]

This changes the %lx to %zx as it should be.

Fixes: 86652d2eb347 ("libnvdimm, btt: clean up warning and error messages")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/nvdimm/btt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 5bc686e9195a..d5612bd1cc81 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -428,7 +428,7 @@ static int btt_map_init(struct arena_info *arena)
 		size_t size = min(mapsize, chunk_size);
 
 		dev_WARN_ONCE(to_dev(arena), size < 512,
-			"chunk size: %#lx is unaligned\n", size);
+			"chunk size: %#zx is unaligned\n", size);
 		ret = arena_write_bytes(arena, arena->mapoff + offset, zerobuf,
 				size, 0);
 		if (ret)
@@ -472,7 +472,7 @@ static int btt_log_init(struct arena_info *arena)
 		size_t size = min(logsize, chunk_size);
 
 		dev_WARN_ONCE(to_dev(arena), size < 512,
-			"chunk size: %#lx is unaligned\n", size);
+			"chunk size: %#zx is unaligned\n", size);
 		ret = arena_write_bytes(arena, arena->logoff + offset, zerobuf,
 				size, 0);
 		if (ret)
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
