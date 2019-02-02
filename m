Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0AB6A211B6C26
 for <linux-nvdimm@lists.01.org>; Fri,  1 Feb 2019 17:52:58 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/4] ndctl, keys: fix a memory leak in dimm_create_key()
Date: Fri,  1 Feb 2019 18:52:50 -0700
Message-Id: <20190202015253.20051-1-vishal.l.verma@intel.com>
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

Static analysis reports that we are leaking 'fp' in the above function.
Add an fclose() to close the leak.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/util/keys.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
index 85818c0..acc2ff3 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/util/keys.c
@@ -260,14 +260,15 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 
 	 wrote = fwrite(buffer, 1, size, fp);
 	 if (wrote != size) {
-		 if (wrote == -1)
-			 rc = -errno;
-		 else
-			 rc = -EIO;
-		 fprintf(stderr, "Failed to write to %s: %s\n",
-				 path, strerror(-rc));
-		 free(buffer);
-		 return rc;
+		if (wrote == -1)
+			rc = -errno;
+		else
+			rc = -EIO;
+		fprintf(stderr, "Failed to write to %s: %s\n",
+				path, strerror(-rc));
+		fclose(fp);
+		free(buffer);
+		return rc;
 	 }
 
 	 fclose(fp);
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
