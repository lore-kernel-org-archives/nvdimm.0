Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x241.google.com (mail-pl0-x241.google.com
 [IPv6:2607:f8b0:400e:c01::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 51B1A226085BC
 for <linux-nvdimm@lists.01.org>; Tue,  3 Apr 2018 07:25:22 -0700 (PDT)
Received: by mail-pl0-x241.google.com with SMTP id 61-v6so7044534plb.2
 for <linux-nvdimm@lists.01.org>; Tue, 03 Apr 2018 07:25:22 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [RESEND v2 4/4] powerpc/powernv: Create platform devs for nvdimm buses
Date: Wed,  4 Apr 2018 00:24:15 +1000
Message-Id: <20180403142415.30083-4-oohall@gmail.com>
In-Reply-To: <20180403142415.30083-1-oohall@gmail.com>
References: <20180403142415.30083-1-oohall@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Scan the devicetree for an nvdimm-bus compatible and create
a platform device for them.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 arch/powerpc/platforms/powernv/opal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index c15182765ff5..c37485a3c5c9 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -821,6 +821,9 @@ static int __init opal_init(void)
 	/* Create i2c platform devices */
 	opal_pdev_init("ibm,opal-i2c");
 
+	/* Handle non-volatile memory devices */
+	opal_pdev_init("pmem-region");
+
 	/* Setup a heatbeat thread if requested by OPAL */
 	opal_init_heartbeat();
 
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
