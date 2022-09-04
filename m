Received: from smtp.smtpout.orange.fr (smtp-17.smtpout.orange.fr [80.12.242.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03BB72F23
	for <nvdimm@lists.linux.dev>; Sun,  4 Sep 2022 13:57:26 +0000 (UTC)
Received: from pop-os.home ([90.11.190.129])
	by smtp.orange.fr with ESMTPA
	id Uq0Sotkkhez1rUq0So1Snz; Sun, 04 Sep 2022 15:49:49 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 04 Sep 2022 15:49:49 +0200
X-ME-IP: 90.11.190.129
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	nvdimm@lists.linux.dev
Subject: [PATCH] nvdimm: Avoid wasting some memory.
Date: Sun,  4 Sep 2022 15:49:47 +0200
Message-Id: <8355cb2b720f8cd0f1315b06d70b541ba38add30.1662299370.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sizeof(struct btt_sb) is 4096.

When using devm_kzalloc(), there is a small memory overhead and, on most
systems, this leads to 40 bytes of extra memory allocation.
So 5036 bytes are expected to be allocated.

The memory allocator works with fixed size hunks of memory. In this case,
it will require 8192 bytes of memory because more than 4096 bytes are
required.

In order to avoid wasting 4ko of memory, just use kzalloc() and add a
devm action to free it when needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/nvdimm/btt_devs.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index fabbb31f2c35..7b79fb0b0338 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -332,6 +332,11 @@ static int __nd_btt_probe(struct nd_btt *nd_btt,
 	return 0;
 }
 
+void nd_btt_free(void *data)
+{
+	kfree(data);
+}
+
 int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns)
 {
 	int rc;
@@ -356,7 +361,17 @@ int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns)
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!btt_dev)
 		return -ENOMEM;
-	btt_sb = devm_kzalloc(dev, sizeof(*btt_sb), GFP_KERNEL);
+
+	/*
+	 * 'struct btt_sb' is 4096. Using devm_kzalloc() would waste 4 ko of
+	 * memory because, because of a small memory over head, 8192 bytes
+	 * would be allocated. So keep this kzalloc()+devm_add_action_or_reset()
+	 */
+	btt_sb = kzalloc(sizeof(*btt_sb), GFP_KERNEL);
+	rc = devm_add_action_or_reset(dev, nd_btt_free, btt_sb);
+	if (rc)
+		return rc;
+
 	rc = __nd_btt_probe(to_nd_btt(btt_dev), ndns, btt_sb);
 	dev_dbg(dev, "btt: %s\n", rc == 0 ? dev_name(btt_dev) : "<none>");
 	if (rc < 0) {
-- 
2.34.1

