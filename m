Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
 by ml01.01.org (Postfix) with ESMTP id DB5F521954066
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 04:37:20 -0700 (PDT)
Date: Mon, 24 Apr 2017 13:37:18 +0200
From: Borislav Petkov <bp@alien8.de>
Subject: [PATCH 2/2] x86/ras/mce_amd_inj: Preset MCE injection struct
Message-ID: <20170424113718.hhycno5my6fbjebv@pd.tnic>
References: <20170420221818.23522-1-vishal.l.verma@intel.com>
 <CAPcyv4ijU2V-4WOPysL12ByOovAXDO=Mci1D4wNDFqxRjdvT2w@mail.gmail.com>
 <1492804517.2738.25.camel@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F6127653B@ORSMSX114.amr.corp.intel.com>
 <CAPcyv4jAkCE2QBuxfxxmZfQZLCVOGLrLXqDu5TyGCVA+xJMEVg@mail.gmail.com>
 <20170421202741.GA16423@intel.com>
 <20170421210704.c5pvpn6zivvruzx3@pd.tnic>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170421210704.c5pvpn6zivvruzx3@pd.tnic>
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Borislav Petkov <bp@suse.de>
Date: Mon, 24 Apr 2017 13:19:34 +0200
Subject: [PATCH 2/2] x86/ras/mce_amd_inj: Preset MCE injection struct

Populate the MCE injection struct before doing initial injection so that
values which don't change already have proper values.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/ras/mce_amd_inj.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/ras/mce_amd_inj.c b/arch/x86/ras/mce_amd_inj.c
index 8730c2882fff..e3b5d7e7e9ee 100644
--- a/arch/x86/ras/mce_amd_inj.c
+++ b/arch/x86/ras/mce_amd_inj.c
@@ -463,6 +463,8 @@ static int __init init_mce_inject(void)
 			goto err_dfs_add;
 	}
 
+	mce_setup(&i_mce);
+
 	return 0;
 
 err_dfs_add:
-- 
2.11.0

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
