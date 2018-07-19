Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 995E72098EA7B
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 11:47:49 -0700 (PDT)
From: Ross Zwisler <zwisler@kernel.org>
Subject: [PATCH 2/2] MAINTAINERS: Add Jan Kara for filesystem DAX
Date: Thu, 19 Jul 2018 12:47:22 -0600
Message-Id: <20180719184722.19164-3-zwisler@kernel.org>
In-Reply-To: <20180719184722.19164-1-zwisler@kernel.org>
References: <20180719184722.19164-1-zwisler@kernel.org>
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
To: Jan Kara <jack@suse.cz>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org
Cc: Ross Zwisler <zwisler@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Jan has been developing and reviewing filesystem DAX related changes for
quite a while now, and has agreed to help maintain this code going forward.

Thanks, Jan!

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d56b802a0fb..746a31f97353 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4274,6 +4274,7 @@ F:	drivers/i2c/busses/i2c-diolan-u2c.c
 FILESYSTEM DIRECT ACCESS (DAX)
 M:	Matthew Wilcox <mawilcox@microsoft.com>
 M:	Ross Zwisler <zwisler@kernel.org>
+M:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported
 F:	fs/dax.c
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
