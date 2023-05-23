Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846536FCB
	for <nvdimm@lists.linux.dev>; Tue, 23 May 2023 03:57:19 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="118727736"
X-IronPort-AV: E=Sophos;i="6.00,185,1681138800"; 
   d="scan'208";a="118727736"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 12:57:16 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 4A4F9E428A
	for <nvdimm@lists.linux.dev>; Tue, 23 May 2023 12:57:14 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 8589AD5EB1
	for <nvdimm@lists.linux.dev>; Tue, 23 May 2023 12:57:13 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id E81F140FC0;
	Tue, 23 May 2023 12:57:12 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH 1/2] CONTRIBUTING.md: document cxl mailing list
Date: Tue, 23 May 2023 11:57:03 +0800
Message-Id: <20230523035704.826188-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27644.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27644.004
X-TMASE-Result: 10--6.981600-10.000000
X-TMASE-MatchedRID: Ws93scA2AKdTorztX3wKRE7nLUqYrlslFIuBIWrdOeOjEIt+uIPPOP/G
	MtOzOpELoDygFaGdGdDGp/huIU6WTAUOfEwe75QIrMZ+BqQt2Nr4qCLIu0mtIL42hLbi424DN1N
	eJEsbqQ7Nc3GjcAzz4qZMOr9som97lI9wYQFSXLyfrLSY2RbRpDWRH7TlULWGzAKTiuEfBeJ/KC
	gekkQUpQac8ZIsTvB5xMqtK+ju5GcfE8yM4pjsDwtuKBGekqUpI/NGWt0UYPBKQ5c45GfIgTkZA
	R8SebWVYLjK29AKgworMFEbiFB7CeSPyTK27pvM
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Any change and question relevant to should also CC to the CXL mailing
list.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 CONTRIBUTING.md | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 4f4865db9da4..c5eb391122d5 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -5,15 +5,21 @@ Thank you for taking the time to contribute to ndctl.
 The following is a set of guidelines that we adhere to, and request that
 contributors follow.
 
+1. **NOTE**: ndctl utils have extended to support CXL CLI, so any change
+   and question relevant to CXL should also CC to the CXL mailing list
+   **```linux-cxl@vger.kernel.org```**.
+
 1. The libnvdimm (kernel subsystem) and ndctl developers primarily use
    the [nvdimm](https://subspace.kernel.org/lists.linux.dev.html)
    mailing list for everything. It is recommended to send patches to
-   **```nvdimm@lists.linux.dev```**
-   An archive is available on [lore](https://lore.kernel.org/nvdimm/)
+   **```nvdimm@lists.linux.dev```** and CC **```linux-cxl@vger.kernel.org```** if needed.
+   The archives are available on [nvdimm](https://lore.kernel.org/nvdimm/) and
+   [cxl](https://lore.kernel.org/linux-cxl/)
 
 1. Github [issues](https://github.com/pmem/ndctl/issues) are an acceptable
    way to report a problem, but if you just have a question,
-   [email](mailto:nvdimm@lists.linux.dev) the above list.
+   [email](mailto:nvdimm@lists.linux.dev) the above list and CC `linux-cxl@linux-cxl@vger.kernel.org`
+   if needed.
 
 1. We follow the Linux Kernel [Coding Style Guide][cs] as applicable.
 
-- 
2.29.2

