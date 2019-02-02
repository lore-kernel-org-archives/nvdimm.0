Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BA18211B6C26
 for <linux-nvdimm@lists.01.org>; Fri,  1 Feb 2019 17:52:59 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/4] ndctl, keys: fix a resource leak in verify_kek()
Date: Fri,  1 Feb 2019 18:52:51 -0700
Message-Id: <20190202015253.20051-2-vishal.l.verma@intel.com>
In-Reply-To: <20190202015253.20051-1-vishal.l.verma@intel.com>
References: <20190202015253.20051-1-vishal.l.verma@intel.com>
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

Static analysis reports that we were leaking key_handle in the above
function. Fix the error handling to properly free it for every error
case.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/util/keys.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
index acc2ff3..c1f2e84 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/util/keys.c
@@ -393,6 +393,7 @@ static int verify_kek(struct ndctl_dimm *dimm, const char *kek)
 {
 	char *type, *desc, *key_handle;
 	key_serial_t key;
+	int rc = 0;
 
 	key_handle = strdup(kek);
 	if (!key_handle)
@@ -401,29 +402,34 @@ static int verify_kek(struct ndctl_dimm *dimm, const char *kek)
 	type = strtok(key_handle, ":");
 	if (!type) {
 		fprintf(stderr, "No key type found for kek handle\n");
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out;
 	}
 
 	if (strcmp(type, "trusted") != 0 &&
 			strcmp(type, "user") != 0) {
 		fprintf(stderr, "No such key type: %s", type);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out;
 	}
 
 	desc = strtok(NULL, ":");
 	if (!desc) {
 		fprintf(stderr, "No description found for kek handle\n");
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out;
 	}
 
 	key = keyctl_search(KEY_SPEC_USER_KEYRING, type, desc, 0);
 	if (key < 0) {
 		fprintf(stderr, "No key encryption key found\n");
-		return key;
+		rc = key;
+		goto out;
 	}
 
+out:
 	free(key_handle);
-	return 0;
+	return rc;
 }
 
 int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek,
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
