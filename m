Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 6C9F51A1E4D
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 09:45:11 -0800 (PST)
Subject: [ndctl PATCH] ndctl: remove %defattr from spec file template
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Mar 2016 09:44:28 -0800
Message-ID: <20160311174428.33053.76522.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: Ralf Corsepius <rc040203@freenet.de>
List-ID: <linux-nvdimm@lists.01.org>

Per Ralf Corsepius:
"Except if you want to support very outdated distros (IIRC, < rhel5),
%defattr(-,root,root) is not necessary, anymore and should not be used
in specs anymore."

Reported-by: Ralf Corsepius <rc040203@freenet.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl.spec.in |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index e24b31cc54f0..6f6e99bd743b 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -65,19 +65,16 @@ make check
 %postun -n LNAME -p /sbin/ldconfig
 
 %files
-%defattr(-,root,root)
 %license licenses/GPLv2 licenses/BSD-MIT licenses/CC0
 %{_bindir}/ndctl
 %{_mandir}/man1/*
 
 %files -n LNAME
-%defattr(-,root,root)
 %doc README.md
 %license COPYING licenses/BSD-MIT licenses/CC0
 %{_libdir}/libndctl.so.*
 
 %files -n DNAME
-%defattr(-,root,root)
 %license COPYING
 %{_includedir}/ndctl/
 %{_libdir}/libndctl.so

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
