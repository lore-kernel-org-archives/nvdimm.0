Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 10802212AB4C4
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jun 2019 05:30:43 -0700 (PDT)
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 04/39] docs: nvdimm: add it to the driver-api book
Date: Fri, 28 Jun 2019 09:29:57 -0300
Message-Id: <bd756f3565213887a1fe82a382f7dfe7f9119f1f.1561724493.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1561724493.git.mchehab+samsung@kernel.org>
References: <cover.1561724493.git.mchehab+samsung@kernel.org>
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
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

The descriptions here are from Kernel driver's PoV.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/driver-api/index.rst                 | 1 +
 Documentation/{ => driver-api}/nvdimm/btt.rst      | 0
 Documentation/{ => driver-api}/nvdimm/index.rst    | 2 --
 Documentation/{ => driver-api}/nvdimm/nvdimm.rst   | 0
 Documentation/{ => driver-api}/nvdimm/security.rst | 0
 drivers/nvdimm/Kconfig                             | 2 +-
 6 files changed, 2 insertions(+), 3 deletions(-)
 rename Documentation/{ => driver-api}/nvdimm/btt.rst (100%)
 rename Documentation/{ => driver-api}/nvdimm/index.rst (94%)
 rename Documentation/{ => driver-api}/nvdimm/nvdimm.rst (100%)
 rename Documentation/{ => driver-api}/nvdimm/security.rst (100%)

diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index 93c6c9a98c41..41f5ce7dc34c 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -43,6 +43,7 @@ available subsections can be seen below.
    mtdnand
    miscellaneous
    mei/index
+   nvdimm/index
    w1
    rapidio/index
    s390-drivers
diff --git a/Documentation/nvdimm/btt.rst b/Documentation/driver-api/nvdimm/btt.rst
similarity index 100%
rename from Documentation/nvdimm/btt.rst
rename to Documentation/driver-api/nvdimm/btt.rst
diff --git a/Documentation/nvdimm/index.rst b/Documentation/driver-api/nvdimm/index.rst
similarity index 94%
rename from Documentation/nvdimm/index.rst
rename to Documentation/driver-api/nvdimm/index.rst
index 1a3402d3775e..19dc8ee371dc 100644
--- a/Documentation/nvdimm/index.rst
+++ b/Documentation/driver-api/nvdimm/index.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===================================
 Non-Volatile Memory Device (NVDIMM)
 ===================================
diff --git a/Documentation/nvdimm/nvdimm.rst b/Documentation/driver-api/nvdimm/nvdimm.rst
similarity index 100%
rename from Documentation/nvdimm/nvdimm.rst
rename to Documentation/driver-api/nvdimm/nvdimm.rst
diff --git a/Documentation/nvdimm/security.rst b/Documentation/driver-api/nvdimm/security.rst
similarity index 100%
rename from Documentation/nvdimm/security.rst
rename to Documentation/driver-api/nvdimm/security.rst
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index e89c1c332407..a5fde15e91d3 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -33,7 +33,7 @@ config BLK_DEV_PMEM
 	  Documentation/admin-guide/kernel-parameters.rst).  This driver converts
 	  these persistent memory ranges into block devices that are
 	  capable of DAX (direct-access) file system mappings.  See
-	  Documentation/nvdimm/nvdimm.rst for more details.
+	  Documentation/driver-api/nvdimm/nvdimm.rst for more details.
 
 	  Say Y if you want to use an NVDIMM
 
-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
