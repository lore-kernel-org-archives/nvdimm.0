Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D3463DA
	for <nvdimm@lists.linux.dev>; Tue, 23 May 2023 03:58:27 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="117587475"
X-IronPort-AV: E=Sophos;i="6.00,185,1681138800"; 
   d="scan'208";a="117587475"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 12:57:16 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id C6ECBD4240
	for <nvdimm@lists.linux.dev>; Tue, 23 May 2023 12:57:14 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id CE723BF498
	for <nvdimm@lists.linux.dev>; Tue, 23 May 2023 12:57:13 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 3E92240FC2;
	Tue, 23 May 2023 12:57:13 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH 2/2] README.md: document CXL unit tests
Date: Tue, 23 May 2023 11:57:04 +0800
Message-Id: <20230523035704.826188-2-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230523035704.826188-1-lizhijian@fujitsu.com>
References: <20230523035704.826188-1-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--4.914400-10.000000
X-TMASE-MatchedRID: I8E55Gq38a7oRc6WqPysdk7nLUqYrlslFIuBIWrdOeNLjXXGQy6nlGNo
	keyvFnLM8BJmQCWBMFC4Dzk272eIPC01VXlcjcCUa87CDXaKRVI217sBakpdK5soi2XrUn/Jn6K
	dMrRsL14qtq5d3cxkNdp7S6pz2tVNuQgUUrAXVg/cfF98QxjS4ps/7s2bBGZ9qomCPfEtTyH1t1
	JTTds9P4RbXLmQnDP1no2xRMzjw4jgk114yn08DBlPNqSHOjQGFcUQf3Yp/ridO0/GUi4gFb0fO
	PzpgdcEKeJ/HkAZ8Is=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

It requires some CLX specific kconfigs and testing purpose module

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 README.md | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/README.md b/README.md
index 7c7cf0dd065d..521e2582fb05 100644
--- a/README.md
+++ b/README.md
@@ -39,8 +39,8 @@ https://nvdimm.wiki.kernel.org/start
 
 Unit Tests
 ==========
-The unit tests run by `meson test` require the nfit_test.ko module to be
-loaded.  To build and install nfit_test.ko:
+The unit tests run by `meson test` require the nfit_test.ko and cxl_test.ko modules to be
+loaded.  To build and install nfit_test.ko and cxl_test.ko:
 
 1. Obtain the kernel source.  For example,  
    `git clone -b libnvdimm-for-next git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git`  
@@ -70,6 +70,13 @@ loaded.  To build and install nfit_test.ko:
    CONFIG_NVDIMM_DAX=y
    CONFIG_DEV_DAX_PMEM=m
    CONFIG_ENCRYPTED_KEYS=y
+   CONFIG_CXL_BUS=m
+   CONFIG_CXL_PCI=m
+   CONFIG_CXL_ACPI=m
+   CONFIG_CXL_PMEM=m
+   CONFIG_CXL_MEM=m
+   CONFIG_CXL_PORT=m
+   CONFIG_DEV_DAX_CXL=m
    ```
 
 1. Build and install the unit test enabled libnvdimm modules in the
@@ -77,8 +84,14 @@ loaded.  To build and install nfit_test.ko:
    the `depmod` that runs during the final `modules_install`  
 
    ```
+   # For nfit_test.ko
    make M=tools/testing/nvdimm
    sudo make M=tools/testing/nvdimm modules_install
+
+   # For cxl_test.ko
+   make M=tools/testing/cxl
+   sudo make M=tools/testing/cxl modules_install
+
    sudo make modules_install
    ```
 
-- 
2.29.2

