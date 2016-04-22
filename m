Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 5A5701A2070
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 12:48:12 -0700 (PDT)
Subject: [ndctl PATCH 4/8] ndctl,
 create-namespace: report failures due to namespace being mounted
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Apr 2016 12:47:23 -0700
Message-ID: <146135444310.4228.7151000859132505494.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
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
unmount the filesystem.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 builtin-xaction-namespace.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index 53ff82bc2c8d..e2e6d518c64d 100644
--- a/builtin-xaction-namespace.c
+++ b/builtin-xaction-namespace.c
@@ -550,6 +550,8 @@ static int namespace_destroy(struct ndctl_region *region,
 			 * stopping the !bdev case from racing to mount an fs or
 			 * re-enabling the namepace.
 			 */
+			error("%s: %s is mounted, failing operation\n",
+					devname, bdev);
 			return -EBUSY;
 		}
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
