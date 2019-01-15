Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C45F12194D3B9
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 20:08:08 -0800 (PST)
Subject: [ndctl PATCH] ndctl, rpm: Mark monitor.conf as a configuration file
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Jan 2019 19:55:31 -0800
Message-ID: <154752453130.1624444.5980546681656304647.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In case a user has made local modifications to /etc/ndctl/monitor.conf,
instrument the spec file to not clobber those changes.

Cc: Qi Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl.spec.in |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index 26396d4abad7..bc4d65c1f988 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -117,9 +117,10 @@ make check
 %{_bindir}/ndctl
 %{_mandir}/man1/ndctl*
 %{bashcompdir}/
-%{_sysconfdir}/ndctl/monitor.conf
 %{_unitdir}/ndctl-monitor.service
 
+%config(noreplace) %{_sysconfdir}/ndctl/monitor.conf
+
 %files -n daxctl
 %defattr(-,root,root)
 %license util/COPYING licenses/BSD-MIT licenses/CC0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
