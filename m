Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F060C2194D3B8
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 16:35:34 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/2] ndctl.spec.in: remove obsolete ldconfig scriptlets
Date: Wed, 30 Jan 2019 17:35:17 -0700
Message-Id: <20190131003518.10934-1-vishal.l.verma@intel.com>
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
Cc: Igor Gnatenko <ignatenkobrain@fedoraproject.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Igor Gnatenko <ignatenkobrain@fedoraproject.org>

Pulled in via Fedora packaging.

References: https://fedoraproject.org/wiki/Changes/RemoveObsoleteScriptlets
Signed-off-by: Igor Gnatenko <ignatenkobrain@fedoraproject.org>
[vishal: update patch so it applies to ndctl.spec.in]
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl.spec.in | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index bc65a47..25d5296 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -101,13 +101,9 @@ find $RPM_BUILD_ROOT -name '*.la' -exec rm -f {} ';'
 %check
 make check
 
-%post -n LNAME -p /sbin/ldconfig
+%ldconfig_scriptlets -n LNAME
 
-%postun -n LNAME -p /sbin/ldconfig
-
-%post -n DAX_LNAME -p /sbin/ldconfig
-
-%postun -n DAX_LNAME -p /sbin/ldconfig
+%ldconfig_scriptlets -n DAX_LNAME
 
 %define bashcompdir %(pkg-config --variable=completionsdir bash-completion)
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
