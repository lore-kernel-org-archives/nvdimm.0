Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1466C1846
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 02:26:03 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="118391941"
X-IronPort-AV: E=Sophos;i="6.00,205,1681138800"; 
   d="scan'208";a="118391941"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 11:24:52 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 3A1C4E4289
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 11:24:49 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 895BECF7D1
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 11:24:48 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.234.230])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id E9A592007AA82;
	Wed, 31 May 2023 11:24:47 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	dave.jiang@intel.com,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v2 1/2] CONTRIBUTING.md: document cxl mailing list
Date: Wed, 31 May 2023 10:24:13 +0800
Message-Id: <20230531022414.7604-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27662.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27662.004
X-TMASE-Result: 10--7.585600-10.000000
X-TMASE-MatchedRID: E/g93qo2P+FTorztX3wKRKoXHZz/dXlxwTlc9CcHMZerwqxtE531VIPc
	XuILVCbaGBKlWUwuGkazIl9yuO/5TfWzx4I556JguFdP7vaalM1AApRfVHzqNBHfiujuTbedAVU
	qe0H38EqAAna+Q7+KBIfO35fV1SF6buWRvIwrG23lMFX0LZQzce9Bi8r8zoNMmfCW/sLDo1BrqM
	MR8f2KK9hjV/rOEii5gts6uXSYOZ6XBXaJoB9JZxRFJJyf5BJe3QfwsVk0UbtuRXh7bFKB7tmP2
	EOiWBNtkvU19ytASnPtIcbc5zr2DDYIHp9W/7lPsBTJSD2iAW0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Any change and question relevant to should also CC to the CXL mailing
list.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V2: add reviewed tag
---
 CONTRIBUTING.md | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 4f4865db9da4..7d1e7f64984f 100644
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
+   [email](mailto:nvdimm@lists.linux.dev) the above list and CC
+   `linux-cxl@linux-cxl@vger.kernel.org` if needed.
 
 1. We follow the Linux Kernel [Coding Style Guide][cs] as applicable.
 
-- 
2.29.2

