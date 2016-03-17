Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 1663C1A1DED
 for <linux-nvdimm@lists.01.org>; Wed, 16 Mar 2016 17:55:21 -0700 (PDT)
Subject: [ndctl PATCH 1/5] ndctl: update pkg-config description
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Mar 2016 17:54:35 -0700
Message-ID: <20160317005435.3025.49300.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160317005429.3025.395.stgit@dwillia2-desk3.jf.intel.com>
References: <20160317005429.3025.395.stgit@dwillia2-desk3.jf.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Use the same description as rpmspec file which references "libnvdimm"
instead of "nd".

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 lib/libndctl.pc.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/libndctl.pc.in b/lib/libndctl.pc.in
index a8ac4b799fdc..2af9ad18a6fc 100644
--- a/lib/libndctl.pc.in
+++ b/lib/libndctl.pc.in
@@ -4,7 +4,7 @@ libdir=@libdir@
 includedir=@includedir@
 
 Name: libndctl
-Description: Device discovery and manipulation for the "nd" subsystem
+Description: Manage "libnvdimm" subsystem devices (Non-volatile Memory)
 Version: @VERSION@
 Libs: -L${libdir} -lndctl
 Libs.private:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
