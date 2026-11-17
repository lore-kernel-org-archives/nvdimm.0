Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794954677;
	b=RgX4n/aiqNoUER0DREjTlUKkMBHR9DwXN6KA70iPxsY31vlLstvzvcMdMl8fdQ1iB+T4
	 7y/xc++Yq3m8XNQEGaYn8u9InBwXvrJBk7FxXT04Yax+VbBt7YBUWF9e0dP1y/6fHKGX4
	 qKNOwKKzokEQLS2fj7vs4Hcbi9qq7PWETtK1HEkpMp6Ix8QwVbSqNO9++AGh8YQIYZRYZ
	 VKoMUtC3p2Xl69lJ+oTA6KG6TPLlTRg/k8hRB+GwUQF5TxFxBh8q97Evkf7C6cpmlJHF7
	 1ghWph9lFaPRMuL1nu/GW3NTrJ/QYTcRzUxZZCiziQ8Z7x9hixwSs97oMDw+3nPFElQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794954677;
	h=Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XXytHcccords72kUO6jPYQjhLx7JqC8Xd3OFvr3C46E=;
	b=P8PniHQfAwE0va/YfEEQHNth6q+7YZSdLKkU+ZACimlAuESZ304Vjtd0+itUoG//Zi2V
	 SvFEWEeeJHiaFMVDKUxb5u6nEQrohgxrbakhOPNb67I2Ap0vlHa4YR3b1fTWsr1BRE6Ni
	 iroN7gealZ9wzDUBdPJcLDByU0FOu77PeLwM2++r5Pbt4fYiFmsN1fnYiYskVygdARuyl
	 urulQrdxVrQYoStW9CGHr/xyq7P7yPgtm4WI21ixSboV1dDdVMfwI2Dx3V65Qi13j8cUC
	 318EaLGKcSRrer09OkzDWOngAgKUzRDa2cl4AB+pfC+lnCa+n6v45cujm4woylqwC+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A38606A31C
	for <nvdimm@lists.linux.dev>; Tue, 17 Nov 2026 22:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4035F1F000C4;
	Tue, 17 Nov 2026 22:31:17 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com,
	vishal.l.verma@intel.com
Subject: [PATCH] nvdimm/namespace: Nest mapping locks under the bus lock
Date: Tue, 17 Nov 2026 15:31:16 -0700
Message-ID: <20261117223116.3478672-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

create_namespaces() takes every mapping lock in a region with
mutex_lock_nested() and uses the mapping index as the subclass. Lockdep
supports only 8 subclasses. A region with more mappings, such as a
12-way CXL pmem region, triggers:

  DEBUG_LOCKS_WARN_ON(subclass >= MAX_LOCKDEP_SUBCLASSES)

and lockdep turns itself off.

The caller holds the nvdimm bus reconfig_mutex. Take the mapping locks
with mutex_lock_nest_lock() under that lock instead. Lockdep then
tracks any number of mapping locks.

Fixes: ae8219f186d8 ("libnvdimm, label: convert label tracking to a linked list")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/namespace_devs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 557fe0cb43e2..3aa0a9026efa 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2031,6 +2031,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
 
 static struct device **create_namespaces(struct nd_region *nd_region)
 {
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
 	struct nd_mapping *nd_mapping;
 	struct device **devs;
 	int i;
@@ -2038,10 +2039,16 @@ static struct device **create_namespaces(struct nd_region *nd_region)
 	if (nd_region->ndr_mappings == 0)
 		return NULL;
 
-	/* lock down all mappings while we scan labels */
+	/*
+	 * Lock down all mappings while we scan labels. A region can have
+	 * more mappings than lockdep has subclasses, so nest the mapping
+	 * locks under the bus lock rather than giving each its own subclass.
+	 */
+	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		nd_mapping = &nd_region->mapping[i];
-		mutex_lock_nested(&nd_mapping->lock, i);
+		mutex_lock_nest_lock(&nd_mapping->lock,
+				     &nvdimm_bus->reconfig_mutex);
 	}
 
 	devs = scan_labels(nd_region);

base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.54.0

