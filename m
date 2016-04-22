Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 1AF371A20D1
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 12:47:57 -0700 (PDT)
Subject: [ndctl PATCH 1/8] ndctl,
 create-namespace: make zero_info_block() more robust
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Apr 2016 12:47:07 -0700
Message-ID: <146135442769.4228.5883488750920483205.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Arrange for zero_info_block() to continue in the case when the namespace
cannot be enabled.  This allows a partially configured namespace to be
reset.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 builtin-xaction-namespace.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index d83ad91a7258..3e13a1c0c3a1 100644
--- a/builtin-xaction-namespace.c
+++ b/builtin-xaction-namespace.c
@@ -463,12 +463,17 @@ static int zero_info_block(struct ndctl_namespace *ndns)
 	char path[50];
 	void *buf;
 
+	ndctl_namespace_set_raw_mode(ndns, 1);
+	rc = ndctl_namespace_enable(ndns);
+	if (rc < 0) {
+		debug("%s failed to enable for zeroing, continuing\n", devname);
+		rc = 0;
+		goto out;
+	}
+
 	if (posix_memalign(&buf, 4096, 4096) != 0)
 		return -ENXIO;
 
-	ndctl_namespace_set_raw_mode(ndns, 1);
-	ndctl_namespace_enable(ndns);
-
 	sprintf(path, "/dev/%s", ndctl_namespace_get_block_device(ndns));
 	fd = open(path, O_RDWR|O_DIRECT|O_EXCL);
 	if (fd < 0) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
