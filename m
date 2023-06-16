Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5A71ACB0
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 16:13:16 +0000 (UTC)
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1qAC4U-00G6bb-9h; Fri, 16 Jun 2023 17:13:10 +0100
Received: from ben by rainbowdash with local (Exim 4.96)
	(envelope-from <ben@rainbowdash>)
	id 1qAC4T-0005pI-3C;
	Fri, 16 Jun 2023 17:13:09 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	linux-cxl@vger.kernel.org,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] dax: include bus.h for definition of run_dax()
Date: Fri, 16 Jun 2023 17:13:09 +0100
Message-Id: <20230616161309.22387-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The run_dax() prototype is defined in "bus.h" but drivers/dax/super.c
does not include this. Include bus.h to silece the following sparse
warning:

drivers/dax/super.c:337:6: warning: symbol 'run_dax' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 drivers/dax/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index c4c4728a36e4..8c05dae19bfe 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -14,6 +14,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include "dax-private.h"
+#include "bus.h"
 
 /**
  * struct dax_device - anchor object for dax services
-- 
2.39.2

