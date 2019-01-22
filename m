Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com
 [148.163.147.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1FE0621959CB2
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 14:14:37 -0800 (PST)
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
 by mx0b-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x0MMBX0o006434
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 22:14:36 GMT
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 by mx0b-002e3701.pphosted.com with ESMTP id 2q68ay1hut-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 22:14:36 +0000
Received: from g4t3433.houston.hpecorp.net (g4t3433.houston.hpecorp.net
 [16.208.49.245])
 by g4t3426.houston.hpe.com (Postfix) with ESMTP id A0DC14F
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 22:14:35 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH] libnvdimm: normalize dev_debug failed and succeeded wording
Date: Tue, 22 Jan 2019 16:05:25 -0600
Message-Id: <20190122220525.5211-1-elliott@hpe.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Make dev_dbg prints use consistent wording for failed and succeeded, and
include the return code when reporting something failed.

Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 drivers/nvdimm/dimm.c     |  2 +-
 drivers/nvdimm/label.c    |  7 ++++---
 drivers/nvdimm/security.c | 53 ++++++++++++++++++++++++++++++++++-------------
 3 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 0cf58cabc9ed..3ff104f7ccaa 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -62,7 +62,7 @@ static int nvdimm_probe(struct device *dev)
 	 */
 	rc = nvdimm_security_unlock(dev);
 	if (rc < 0)
-		dev_dbg(dev, "failed to unlock dimm: %d\n", rc);
+		dev_dbg(dev, "unlock failed: %d\n", rc);
 
 
 	/*
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index a11bf4e6b451..235833a4881b 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -149,7 +149,7 @@ static int __nd_label_validate(struct nvdimm_drvdata *ndd)
 			labelsize = 128;
 
 		if (labelsize != sizeof_namespace_label(ndd)) {
-			dev_dbg(dev, "nsindex%d labelsize %d invalid\n",
+			dev_dbg(dev, "nsindex%d labelsize: %d invalid\n",
 					i, nsindex[i]->labelsize);
 			continue;
 		}
@@ -373,7 +373,8 @@ static bool slot_valid(struct nvdimm_drvdata *ndd,
 		sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
 		nd_label->checksum = __cpu_to_le64(sum_save);
 		if (sum != sum_save) {
-			dev_dbg(ndd->dev, "fail checksum. slot: %d expect: %#llx\n",
+			dev_dbg(ndd->dev,
+				"checksum failed. slot: %d expected: %#llx\n",
 				slot, sum);
 			return false;
 		}
@@ -535,7 +536,7 @@ int nd_label_data_init(struct nvdimm_drvdata *ndd)
 		read_size += label_read_size;
 	}
 
-	dev_dbg(ndd->dev, "len: %zu rc: %d\n", offset, rc);
+	dev_dbg(ndd->dev, "init config data area len: %zu succeeded\n", offset);
 out_err:
 	return rc;
 }
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index f8bb746a549f..b7f86846015a 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -58,7 +58,8 @@ static struct key *nvdimm_request_key(struct nvdimm *nvdimm)
 		if (PTR_ERR(key) == -ENOKEY)
 			dev_dbg(dev, "request_key() found no key\n");
 		else
-			dev_dbg(dev, "request_key() upcall failed\n");
+			dev_dbg(dev, "request_key() upcall failed: %ld\n",
+				PTR_ERR(key));
 		key = NULL;
 	} else {
 		struct encrypted_key_payload *epayload;
@@ -107,6 +108,7 @@ static struct key *nvdimm_lookup_user_key(struct nvdimm *nvdimm,
 
 static struct key *nvdimm_key_revalidate(struct nvdimm *nvdimm)
 {
+	struct device *dev = &nvdimm->dev;
 	struct key *key;
 	int rc;
 
@@ -126,7 +128,11 @@ static struct key *nvdimm_key_revalidate(struct nvdimm *nvdimm)
 	if (rc < 0) {
 		nvdimm_put_key(key);
 		key = NULL;
-	}
+		dev_dbg(dev, "key: %d revalidation failed: %d\n",
+			key_serial(key), rc);
+	} else
+		dev_dbg(dev, "key: %d revalidation succeeded\n",
+			key_serial(key));
 	return key;
 }
 
@@ -170,8 +176,11 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 		return -ENOKEY;
 
 	rc = nvdimm->sec.ops->unlock(nvdimm, key_data(key));
-	dev_dbg(dev, "key: %d unlock: %s\n", key_serial(key),
-			rc == 0 ? "success" : "fail");
+	if (rc)
+		dev_dbg(dev, "key: %d unlock failed: %d\n",
+			key_serial(key), rc);
+	else
+		dev_dbg(dev, "key: %d unlock succeeded\n", key_serial(key));
 
 	nvdimm_put_key(key);
 	nvdimm->sec.state = nvdimm_security_state(nvdimm, NVDIMM_USER);
@@ -219,8 +228,11 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 		return -ENOKEY;
 
 	rc = nvdimm->sec.ops->disable(nvdimm, key_data(key));
-	dev_dbg(dev, "key: %d disable: %s\n", key_serial(key),
-			rc == 0 ? "success" : "fail");
+	if (rc)
+		dev_dbg(dev, "key: %d disable failed: %d\n",
+			key_serial(key), rc);
+	else
+		dev_dbg(dev, "key: %d disable succeeded\n", key_serial(key));
 
 	nvdimm_put_key(key);
 	nvdimm->sec.state = nvdimm_security_state(nvdimm, NVDIMM_USER);
@@ -265,10 +277,15 @@ int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
 
 	rc = nvdimm->sec.ops->change_key(nvdimm, key ? key_data(key) : NULL,
 			key_data(newkey), pass_type);
-	dev_dbg(dev, "key: %d %d update%s: %s\n",
+	if (rc)
+		dev_dbg(dev, "key: %d %d update%s failed: %d\n",
 			key_serial(key), key_serial(newkey),
 			pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
-			rc == 0 ? "success" : "fail");
+			rc);
+	else
+		dev_dbg(dev, "key: %d %d update%s succeeded\n",
+			key_serial(key), key_serial(newkey),
+			pass_type == NVDIMM_MASTER ? "(master)" : "(user)");
 
 	nvdimm_put_key(newkey);
 	nvdimm_put_key(key);
@@ -324,9 +341,13 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
 		return -ENOKEY;
 
 	rc = nvdimm->sec.ops->erase(nvdimm, key_data(key), pass_type);
-	dev_dbg(dev, "key: %d erase%s: %s\n", key_serial(key),
+	if (rc)
+		dev_dbg(dev, "key: %d erase%s failed: %d\n", key_serial(key),
 			pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
-			rc == 0 ? "success" : "fail");
+			rc);
+	else
+		dev_dbg(dev, "key: %d erase%s succeeded\n", key_serial(key),
+			pass_type == NVDIMM_MASTER ? "(master)" : "(user)");
 
 	nvdimm_put_key(key);
 	nvdimm->sec.state = nvdimm_security_state(nvdimm, NVDIMM_USER);
@@ -377,8 +398,12 @@ int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 	}
 
 	rc = nvdimm->sec.ops->overwrite(nvdimm, key ? key_data(key) : NULL);
-	dev_dbg(dev, "key: %d overwrite submission: %s\n", key_serial(key),
-			rc == 0 ? "success" : "fail");
+	if (rc)
+		dev_dbg(dev, "key: %d overwrite submission failed: %d\n",
+			key_serial(key), rc);
+	else
+		dev_dbg(dev, "key: %d overwrite submission succeeded\n",
+			key_serial(key));
 
 	nvdimm_put_key(key);
 	if (rc == 0) {
@@ -429,9 +454,9 @@ void __nvdimm_security_overwrite_query(struct nvdimm *nvdimm)
 	}
 
 	if (rc < 0)
-		dev_dbg(&nvdimm->dev, "overwrite failed\n");
+		dev_dbg(&nvdimm->dev, "overwrite completion failed: %d\n", rc);
 	else
-		dev_dbg(&nvdimm->dev, "overwrite completed\n");
+		dev_dbg(&nvdimm->dev, "overwrite completion succeeded\n");
 
 	if (nvdimm->sec.overwrite_state)
 		sysfs_notify_dirent(nvdimm->sec.overwrite_state);
-- 
2.16.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
