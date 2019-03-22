Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9C800211E831B
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 14:35:17 -0700 (PDT)
Subject: [PATCH] dsactl: add support to allow keyless secure erase
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 22 Mar 2019 14:35:16 -0700
Message-ID: <155329051601.45122.5794344301281956392.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When security is not enabled, we reject secure erase currently. Add
support to allow secure erase to occur without key.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-sanitize-dimm.txt |    2 ++
 ndctl/util/keys.c                           |   16 +++++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index 7f57a115..d9450dd3 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -33,6 +33,8 @@ erase. The default is 'crypto-erase', but additionally, an 'overwrite' option
 is available which overwrites not only the data area, but also the label area,
 thus losing record of any namespaces the given NVDIMM participates in.
 
+It is possible to crypto-erase or overwrite without a key.
+
 OPTIONS
 -------
 <dimm>::
diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
index c1f2e843..82c16539 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/util/keys.c
@@ -612,12 +612,18 @@ int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
 		enum ndctl_key_type key_type)
 {
-	key_serial_t key;
+	key_serial_t key = 0;
 	int rc;
+	enum ndctl_security_state state;
 
-	key = check_dimm_key(dimm, true, key_type);
-	if (key < 0)
-		return key;
+	state = ndctl_dimm_get_security(dimm);
+
+	if (key_type != ND_MASTER_KEY &&
+			state != NDCTL_SECURITY_DISABLED) {
+		key = check_dimm_key(dimm, true, key_type);
+		if (key < 0)
+			return key;
+	}
 
 	if (key_type == ND_MASTER_KEY)
 		rc = run_key_op(dimm, key, ndctl_dimm_master_secure_erase,
@@ -630,7 +636,7 @@ int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
 	if (rc < 0)
 		return rc;
 
-	if (key_type == ND_USER_KEY)
+	if (key_type == ND_USER_KEY && key != 0)
 		return discard_key(dimm);
 
 	return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
