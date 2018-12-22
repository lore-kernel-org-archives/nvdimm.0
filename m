Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F94121A143EF
 for <linux-nvdimm@lists.01.org>; Sat, 22 Dec 2018 11:57:02 -0800 (PST)
Subject: [PATCH] libnvdimm/security: Quiet security operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 22 Dec 2018 11:44:26 -0800
Message-ID: <154550786663.3967862.7106966856597406852.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The security implementation is too chatty. For example, the common case
is that security is not enabled / setup, and booting a qemu
configuration currently yields:

    nvdimm nmem0: request_key() found no key
    nvdimm nmem0: failed to unlock dimm: -126
    nvdimm nmem1: request_key() found no key
    nvdimm nmem1: failed to unlock dimm: -126

Convert all security related log messages to debug level.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm.c     |    2 +-
 drivers/nvdimm/security.c |   30 +++++++++++++++---------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 1b3d9e7b2ffe..0cf58cabc9ed 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -62,7 +62,7 @@ static int nvdimm_probe(struct device *dev)
 	 */
 	rc = nvdimm_security_unlock(dev);
 	if (rc < 0)
-		dev_err(dev, "failed to unlock dimm: %d\n", rc);
+		dev_dbg(dev, "failed to unlock dimm: %d\n", rc);
 
 
 	/*
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index d9a39dc251e9..f8bb746a549f 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -56,9 +56,9 @@ static struct key *nvdimm_request_key(struct nvdimm *nvdimm)
 	key = request_key(&key_type_encrypted, desc, "");
 	if (IS_ERR(key)) {
 		if (PTR_ERR(key) == -ENOKEY)
-			dev_warn(dev, "request_key() found no key\n");
+			dev_dbg(dev, "request_key() found no key\n");
 		else
-			dev_warn(dev, "request_key() upcall failed\n");
+			dev_dbg(dev, "request_key() upcall failed\n");
 		key = NULL;
 	} else {
 		struct encrypted_key_payload *epayload;
@@ -145,7 +145,7 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 		return -EIO;
 
 	if (test_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags)) {
-		dev_warn(dev, "Security operation in progress.\n");
+		dev_dbg(dev, "Security operation in progress.\n");
 		return -EBUSY;
 	}
 
@@ -204,13 +204,13 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 		return -EOPNOTSUPP;
 
 	if (nvdimm->sec.state >= NVDIMM_SECURITY_FROZEN) {
-		dev_warn(dev, "Incorrect security state: %d\n",
+		dev_dbg(dev, "Incorrect security state: %d\n",
 				nvdimm->sec.state);
 		return -EIO;
 	}
 
 	if (test_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags)) {
-		dev_warn(dev, "Security operation in progress.\n");
+		dev_dbg(dev, "Security operation in progress.\n");
 		return -EBUSY;
 	}
 
@@ -244,7 +244,7 @@ int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
 		return -EOPNOTSUPP;
 
 	if (nvdimm->sec.state >= NVDIMM_SECURITY_FROZEN) {
-		dev_warn(dev, "Incorrect security state: %d\n",
+		dev_dbg(dev, "Incorrect security state: %d\n",
 				nvdimm->sec.state);
 		return -EIO;
 	}
@@ -297,24 +297,24 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
 		return -EOPNOTSUPP;
 
 	if (atomic_read(&nvdimm->busy)) {
-		dev_warn(dev, "Unable to secure erase while DIMM active.\n");
+		dev_dbg(dev, "Unable to secure erase while DIMM active.\n");
 		return -EBUSY;
 	}
 
 	if (nvdimm->sec.state >= NVDIMM_SECURITY_FROZEN) {
-		dev_warn(dev, "Incorrect security state: %d\n",
+		dev_dbg(dev, "Incorrect security state: %d\n",
 				nvdimm->sec.state);
 		return -EIO;
 	}
 
 	if (test_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags)) {
-		dev_warn(dev, "Security operation in progress.\n");
+		dev_dbg(dev, "Security operation in progress.\n");
 		return -EBUSY;
 	}
 
 	if (nvdimm->sec.ext_state != NVDIMM_SECURITY_UNLOCKED
 			&& pass_type == NVDIMM_MASTER) {
-		dev_warn(dev,
+		dev_dbg(dev,
 			"Attempt to secure erase in wrong master state.\n");
 		return -EOPNOTSUPP;
 	}
@@ -348,23 +348,23 @@ int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 		return -EOPNOTSUPP;
 
 	if (atomic_read(&nvdimm->busy)) {
-		dev_warn(dev, "Unable to overwrite while DIMM active.\n");
+		dev_dbg(dev, "Unable to overwrite while DIMM active.\n");
 		return -EBUSY;
 	}
 
 	if (dev->driver == NULL) {
-		dev_warn(dev, "Unable to overwrite while DIMM active.\n");
+		dev_dbg(dev, "Unable to overwrite while DIMM active.\n");
 		return -EINVAL;
 	}
 
 	if (nvdimm->sec.state >= NVDIMM_SECURITY_FROZEN) {
-		dev_warn(dev, "Incorrect security state: %d\n",
+		dev_dbg(dev, "Incorrect security state: %d\n",
 				nvdimm->sec.state);
 		return -EIO;
 	}
 
 	if (test_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags)) {
-		dev_warn(dev, "Security operation in progress.\n");
+		dev_dbg(dev, "Security operation in progress.\n");
 		return -EBUSY;
 	}
 
@@ -429,7 +429,7 @@ void __nvdimm_security_overwrite_query(struct nvdimm *nvdimm)
 	}
 
 	if (rc < 0)
-		dev_warn(&nvdimm->dev, "overwrite failed\n");
+		dev_dbg(&nvdimm->dev, "overwrite failed\n");
 	else
 		dev_dbg(&nvdimm->dev, "overwrite completed\n");
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
