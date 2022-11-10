Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8059361
	for <nvdimm@lists.linux.dev>; Thu, 10 Nov 2022 00:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668038884; x=1699574884;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9bYf4uzMvSiwyh8AUjn4qN7a2n9nebGOpPbY+vozG/0=;
  b=JOqYkP4Rcb8k+5yHKKZGk5jmur9t5rOQNextYrOCbpqDJnN4epfQs15w
   M4RKHg62FnEidS8sq5HrEYH1oxRqRE3iS9pwjzEhr8T9i5wKbJB+i0LuX
   B0595wE9IYnA/ulaQa+VVS91aB8roKvSzGpWV2BptHDsBJvN5hKjxu/qM
   UcIaLFsXC6TU9e3IP33Ob203Meiu5GVQuB6k15ac/SYHZnC+uNqxUjXLp
   OUkfVZOG2ksa9snB5f4eIb8X3Ay78y6vDwZs51aXc/pFT3J3l4cIvf39i
   iLW3yLgk3vWDECKLfEpVCCrys18Fm9AfzGATKTNMaP10FDfmKbgujGWa+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="312288046"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="312288046"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 16:08:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="882130295"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="882130295"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 16:08:03 -0800
Subject: [PATCH v5 6/7] ndctl: cxl: add systemd service for monitor
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, rostedt@goodmis.org
Date: Wed, 09 Nov 2022 17:08:02 -0700
Message-ID: 
 <166803888294.145141.16866651060328585251.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166803877747.145141.11853418648969334939.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166803877747.145141.11853418648969334939.stgit@djiang5-desk3.ch.intel.com>
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
index 000000000000..66de39d883be
--- /dev/null
+++ b/cxl/cxl-monitor.service
@@ -0,0 +1,9 @@
+[Unit]
+Description=CXL Monitor Daemon
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


