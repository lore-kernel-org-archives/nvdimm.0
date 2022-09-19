Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D68A747E
	for <nvdimm@lists.linux.dev>; Mon, 19 Sep 2022 23:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663631242; x=1695167242;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DeqOUaGy2SP0BpG6nmA3vfDOX3XIVNbyvfzpqIRcQuk=;
  b=LrDx65XY/b9UDdV58iULtpmnlI64m/D/wVHFuRsMFryZO1gcrluFuJ4n
   2ojw7n3xl4VRe6G17aE6CAxlZRLYEsX7+6ZsrLN8QcNUS6jZCsspmWi1D
   4U42016Fon9XcpRuHNNvJqDWxr9xuB9wrU8YhrTV5LzXuPf9lPZvnV+Ra
   C68QvpRlC0AoQPCnxPjFmdbzqYatUVo9JFIIkUAxqnDXpWsgGwqu7FacN
   l0rgWxADTmxBOAULP3Qe779XpGSE3riI/Xc0aB4ZRkZrBQ31Ym5ZXM5nL
   heNiMcwI8J1QjDtMcyI4AiYpHO6/EIq+3S/hWiR8BU02GFXRKpWntLNHx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="363509413"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="363509413"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:47:22 -0700
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="744305552"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:47:21 -0700
Subject: [PATCH v2 8/9] cxl: add systemd service for monitor
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 bwidawsk@kernel.org, dan.j.williams@intel.com, nafonten@amd.com,
 nvdimm@lists.linux.dev
Date: Mon, 19 Sep 2022 16:47:21 -0700
Message-ID: 
 <166363124160.3861186.3220416283275929155.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add a systemd service file for cxl monitor to start the monitoring service
on boot initialization. Add the installation setup for the service file.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/cxl-monitor.service |    9 +++++++++
 cxl/meson.build         |    4 ++++
 ndctl.spec.in           |    1 +
 3 files changed, 14 insertions(+)
 create mode 100644 cxl/cxl-monitor.service

diff --git a/cxl/cxl-monitor.service b/cxl/cxl-monitor.service
new file mode 100644
index 000000000000..87c842b6f595
--- /dev/null
+++ b/cxl/cxl-monitor.service
@@ -0,0 +1,9 @@
+[Unit]
+Description=Cxl Monitor Daemon
+
+[Service]
+Type=simple
+ExecStart=/usr/bin/cxl monitor
+
+[Install]
+WantedBy=multi-user.target
diff --git a/cxl/meson.build b/cxl/meson.build
index eb8b2b1070ed..fc2e946707a8 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -11,6 +11,10 @@ cxl_src = [
   'monitor.c',
 ]
 
+if get_option('systemd').enabled()
+  install_data('cxl-monitor.service', install_dir : systemdunitdir)
+endif
+
 cxl_tool = executable('cxl',
   cxl_src,
   include_directories : root_inc,
diff --git a/ndctl.spec.in b/ndctl.spec.in
index cfcafa2ba816..c883317c5ce7 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -194,6 +194,7 @@ fi
 %{_bindir}/cxl
 %{_mandir}/man1/cxl*
 %{bashcompdir}/cxl
+%{_unitdir}/cxl-monitor.service
 
 %files -n LNAME
 %defattr(-,root,root)


