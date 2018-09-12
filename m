Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E6A3F2110A002
 for <linux-nvdimm@lists.01.org>; Wed, 12 Sep 2018 13:23:30 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, spec: Use pkgconfig for systemd
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Sep 2018 13:11:44 -0700
Message-ID: <153678310476.293708.4303503377745251982.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Decorate the BuildRequires for systemd with pkgconfig like all the other
dependencies.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl.spec.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index b782aeae12ad..98394a924030 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -20,7 +20,7 @@ BuildRequires:	pkgconfig(libudev)
 BuildRequires:	pkgconfig(uuid)
 BuildRequires:	pkgconfig(json-c)
 BuildRequires:	pkgconfig(bash-completion)
-BuildRequires:	systemd
+BuildRequires:	pkgconfig(systemd)
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
