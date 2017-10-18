Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8BB4121CE7411
 for <linux-nvdimm@lists.01.org>; Wed, 18 Oct 2017 08:36:36 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/2] MAINTAINERS: Add entry for device DAX
Date: Wed, 18 Oct 2017 09:40:06 -0600
Message-Id: <20171018154006.15431-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20171018154006.15431-1-ross.zwisler@linux.intel.com>
References: <20171018154006.15431-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

And update the entry for filesystem DAX to differentiate them.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 MAINTAINERS | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a74227a..b2b2e75 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4162,7 +4162,7 @@ L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/i2c/busses/i2c-diolan-u2c.c
 
-DIRECT ACCESS (DAX)
+FILESYSTEM DIRECT ACCESS (DAX)
 M:	Matthew Wilcox <mawilcox@microsoft.com>
 M:	Ross Zwisler <ross.zwisler@linux.intel.com>
 L:	linux-fsdevel@vger.kernel.org
@@ -4171,6 +4171,12 @@ F:	fs/dax.c
 F:	include/linux/dax.h
 F:	include/trace/events/fs_dax.h
 
+DEVICE DIRECT ACCESS (DAX)
+M:	Dan Williams <dan.j.williams@intel.com>
+L:	linux-nvdimm@lists.01.org
+S:	Supported
+F:	drivers/dax/
+
 DIRECTORY NOTIFICATION (DNOTIFY)
 M:	Jan Kara <jack@suse.cz>
 R:	Amir Goldstein <amir73il@gmail.com>
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
