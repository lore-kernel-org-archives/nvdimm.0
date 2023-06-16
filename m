Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A658F59
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 16:33:57 +0000 (UTC)
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1qAC0s-009YG5-IA; Fri, 16 Jun 2023 17:09:27 +0100
Received: from ben by rainbowdash with local (Exim 4.96)
	(envelope-from <ben@rainbowdash>)
	id 1qAC0t-0004bU-0f;
	Fri, 16 Jun 2023 17:09:27 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] nvdimm: make security_show static
Date: Fri, 16 Jun 2023 17:09:25 +0100
Message-Id: <20230616160925.17687-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The security_show function is not used outsid of drivers/nvdimm/dimm_devs.c
and the attribute it is for is also already static. Silence the sparse
warning for this not being declared by making it static. Fixes:

drivers/nvdimm/dimm_devs.c:352:9: warning: symbol 'security_show' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 drivers/nvdimm/dimm_devs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 957f7c3d17ba..1273873582be 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -349,8 +349,8 @@ static ssize_t available_slots_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_slots);
 
-ssize_t security_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t security_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 
-- 
2.39.2

