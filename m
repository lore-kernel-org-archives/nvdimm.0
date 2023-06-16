Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F92171D8
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 16:36:42 +0000 (UTC)
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1qABy1-00G6Sm-I7; Fri, 16 Jun 2023 17:06:30 +0100
Received: from ben by rainbowdash with local (Exim 4.96)
	(envelope-from <ben@rainbowdash>)
	id 1qABy1-00034Y-0C;
	Fri, 16 Jun 2023 17:06:29 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] nvdimm: make nd_class variable static
Date: Fri, 16 Jun 2023 17:06:28 +0100
Message-Id: <20230616160628.11801-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nd_class is not used outside of drivers/nvdimm/bus.c and thus sparse
is generating the following warning. Remove this by making it static:

drivers/nvdimm/bus.c:28:14: warning: symbol 'nd_class' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 drivers/nvdimm/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 954dbc105fc8..5852fe290523 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -25,7 +25,7 @@
 
 int nvdimm_major;
 static int nvdimm_bus_major;
-struct class *nd_class;
+static struct class *nd_class;
 static DEFINE_IDA(nd_ida);
 
 static int to_nd_device_type(const struct device *dev)
-- 
2.39.2

