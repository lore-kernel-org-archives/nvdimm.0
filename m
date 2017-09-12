Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E29221E8796F
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 21:42:35 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/3] .gitignore: ignore cscope files
Date: Mon, 11 Sep 2017 22:45:19 -0600
Message-Id: <20170912044521.22644-1-ross.zwisler@linux.intel.com>
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
To: fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 .gitignore | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/.gitignore b/.gitignore
index 28fe84d..2accc37 100644
--- a/.gitignore
+++ b/.gitignore
@@ -238,3 +238,7 @@
 /tests/xfs/033.out
 /tests/xfs/071.out
 /tests/xfs/096.out
+
+# cscope files
+cscope.*
+ncscope.*
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
