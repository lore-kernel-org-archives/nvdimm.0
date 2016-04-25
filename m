Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id D58911A1ED1
 for <linux-nvdimm@lists.01.org>; Mon, 25 Apr 2016 12:50:43 -0700 (PDT)
Subject: [ndctl PATCH 1/7] ndctl,
 create-namespace: report failures due to namespace being mounted
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Apr 2016 12:49:54 -0700
Message-ID: <146161379487.21779.8389169524298318569.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In the case when a filesystem is mounted on a namespace targeted for
reconfiguration or destruction, emit a message so the user knows to
unmount the filesystem, or otherwise communicate why ndctl could not
exclusively open the device for writing.

Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 builtin-xaction-namespace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index 1f25cc18f5a2..97bb36525d7c 100644
--- a/builtin-xaction-namespace.c
+++ b/builtin-xaction-namespace.c
@@ -553,7 +553,9 @@ static int namespace_destroy(struct ndctl_region *region,
 			 * stopping the !bdev case from racing to mount an fs or
 			 * re-enabling the namepace.
 			 */
-			return -EBUSY;
+			error("%s: %s failed exlusive open: %s\n",
+					devname, bdev, strerror(errno));
+			return -errno;
 		}
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
