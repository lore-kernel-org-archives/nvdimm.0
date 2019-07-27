Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 40218212E15B5
 for <linux-nvdimm@lists.01.org>; Sat, 27 Jul 2019 14:56:21 -0700 (PDT)
Subject: [ndctl PATCH v2 03/26] ndctl/build: Drop -Wpointer-arith
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 27 Jul 2019 14:39:36 -0700
Message-ID: <156426357691.531577.10926120390253347067.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
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

It is common kernel practice to do pointer arithmetic on (void *). Drop
this warning for ndctl.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac |    1 -
 1 file changed, 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 6dca96eda395..4737cfff77f2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -207,7 +207,6 @@ my_CFLAGS="\
 -Wmissing-declarations \
 -Wmissing-prototypes \
 -Wnested-externs \
--Wpointer-arith \
 -Wshadow \
 -Wsign-compare \
 -Wstrict-prototypes \

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
