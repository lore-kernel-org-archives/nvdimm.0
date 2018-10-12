Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 72FFD2116DFA2
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 13:40:11 -0700 (PDT)
Subject: [PATCH v2 4/4] libnvdimm: address state where dimm is unlocked in
 preOS
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 13:40:10 -0700
Message-ID: <153937681048.70378.10708098545828426905.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153937659078.70378.7857051533055879370.stgit@djiang5-desk3.ch.intel.com>
References: <153937659078.70378.7857051533055879370.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When the nvdimm security state is unlocked during unlock, we will do a
request_key() and verify the key against the hardware. If we fail, we
will freeze the security configuration.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/security.c |   55 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index eb778667cd93..3a905c58a935 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -245,6 +245,42 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 	return rc;
 }
 
+static int nvdimm_self_verify_key(struct nvdimm *nvdimm)
+{
+	struct key *key;
+	struct user_key_payload *payload;
+	void *data;
+	int rc;
+
+	lockdep_assert_held(&nvdimm->key_mutex);
+
+	key = nvdimm_request_key(nvdimm);
+	if (!key)
+		return -ENOKEY;
+
+	if (key->datalen != NVDIMM_PASSPHRASE_LEN) {
+		key_put(key);
+		return -EINVAL;
+	}
+
+	down_read(&key->sem);
+	payload = key->payload.data[0];
+	data = payload->data;
+
+	/*
+	 * We send the same key to the hardware as new and old key to
+	 * verify that the key is good.
+	 */
+	rc = nvdimm->security_ops->change_key(nvdimm, data, data);
+	if (rc < 0) {
+		key_put(key);
+		return rc;
+	}
+	up_read(&key->sem);
+	nvdimm->key = key;
+	return 0;
+}
+
 int nvdimm_security_unlock_dimm(struct nvdimm *nvdimm)
 {
 	struct key *key;
@@ -255,12 +291,27 @@ int nvdimm_security_unlock_dimm(struct nvdimm *nvdimm)
 	if (!nvdimm->security_ops)
 		return 0;
 
-	if (nvdimm->state == NVDIMM_SECURITY_UNLOCKED ||
-			nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED ||
+	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED ||
 			nvdimm->state == NVDIMM_SECURITY_DISABLED)
 		return 0;
 
 	mutex_lock(&nvdimm->key_mutex);
+	/*
+	 * If the pre-OS has unlocked the DIMM, we will attempt to send
+	 * the key from request_key() to the hardware for verification.
+	 * If we are not able to verify the key against the hardware we
+	 * will freeze the security configuration. This will prevent any
+	 * other security operations.
+	 */
+	if (nvdimm->state == NVDIMM_SECURITY_UNLOCKED) {
+		rc = nvdimm_self_verify_key(nvdimm);
+		if (rc < 0) {
+			rc = nvdimm_security_freeze_lock(nvdimm);
+			mutex_unlock(&nvdimm->key_mutex);
+			return rc;
+		}
+	}
+
 	key = nvdimm->key;
 	if (!key) {
 		key = nvdimm_request_key(nvdimm);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
