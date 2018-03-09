Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AF542220C2A54
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 08:32:16 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] MAINTAINERS: add coverage for drivers/block
Date: Fri,  9 Mar 2018 09:38:26 -0700
Message-Id: <20180309163826.25042-1-ross.zwisler@linux.intel.com>
In-reply-to: <92dc07f1-dfbd-2449-ce76-502455f56136@kernel.dk>
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
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

To help folks like me that use scripts/get_maintainer.pl.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4623caf8d72d..7ff83f4c9aeb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2685,6 +2685,7 @@ L:	linux-block@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
 S:	Maintained
 F:	block/
+F:	drivers/block/
 F:	kernel/trace/blktrace.c
 F:	lib/sbitmap.c
 
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
