Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0209481B03
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jan 2017 17:12:03 -0800 (PST)
Subject: [PATCH 6/9] daxctl: add daxctl to rpm spec
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 09 Jan 2017 17:07:56 -0800
Message-ID: <148401047657.16217.8534925819484716867.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl.spec.in |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index 6453edd1954c..b4817622e0b2 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -114,9 +114,15 @@ make check
 %defattr(-,root,root)
 %license util/COPYING licenses/BSD-MIT licenses/CC0
 %{_bindir}/ndctl
-%{_mandir}/man1/*
+%{_mandir}/man1/ndctl*
 %{bashcompdir}/
 
+%files -n daxctl
+%defattr(-,root,root)
+%license util/COPYING licenses/BSD-MIT licenses/CC0
+%{_bindir}/daxctl
+%{_mandir}/man1/daxctl*
+
 %files -n LNAME
 %defattr(-,root,root)
 %doc README.md

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
