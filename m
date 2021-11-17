Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E592168
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 01:17:58 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="231327113"
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="231327113"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 17:17:58 -0800
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="672197047"
Received: from jamespje-mobl2.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.26.9])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 17:17:57 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: <linux-cxl@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: install bash-completion symlinks
Date: Tue, 16 Nov 2021 18:17:48 -0700
Message-Id: <20211117011748.3109100-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2222; h=from:subject; bh=wmRlXi/bbhOSaMilE+0PdE8W/a4pBa5RQ/aWs0apYdw=; b=owGbwMvMwCHGf25diOft7jLG02pJDIlTIkxvx/vKKzXahVWf7bm3UnyVg5jyKuPdRkF+JRwbsthr lwd3lLIwiHEwyIopsvzd85HxmNz2fJ7ABEeYOaxMIEMYuDgFYCK2/xgZPi+afsZKvs7BWW8G534Pa3 uZ/3fjhDQfaTDkymrsDiibx/A/67HDIolS3vxJGQnP29K3h5mFT5zQu3NdzOZCM/M3gnlcAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Install symlinks for other utilities (daxctl, cxl-cli) in the
completions directory so that the dynamic completion loader can pick up
their respective names. Without this, completions for daxctl and cxl
would only work after a prior invocation of ndctl's completion.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac  | 1 +
 Makefile.am   | 3 +++
 ndctl.spec.in | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 00497ae..9ac785f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -31,6 +31,7 @@ AC_PREFIX_DEFAULT([/usr])
 
 AC_PROG_SED
 AC_PROG_MKDIR_P
+AC_PROG_LN_S
 
 AC_ARG_ENABLE([docs],
         AS_HELP_STRING([--disable-docs],
diff --git a/Makefile.am b/Makefile.am
index fa2010a..bd0037e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -49,6 +49,9 @@ sles/ndctl.spec: sles/header ndctl.spec.in Makefile.am version.m4
 if ENABLE_BASH_COMPLETION
 bashcompletiondir = $(BASH_COMPLETION_DIR)
 dist_bashcompletion_DATA = contrib/ndctl
+install-data-hook:
+	$(LN_S) -f $(BASH_COMPLETION_DIR)/ndctl $(DESTDIR)/$(BASH_COMPLETION_DIR)/daxctl
+	$(LN_S) -f $(BASH_COMPLETION_DIR)/ndctl $(DESTDIR)/$(BASH_COMPLETION_DIR)/cxl
 endif
 
 modprobe_file = contrib/nvdimm-security.conf
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 4b08c05..27ca097 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -140,7 +140,7 @@ make check
 %license LICENSES/preferred/GPL-2.0 LICENSES/other/MIT LICENSES/other/CC0-1.0
 %{_bindir}/ndctl
 %{_mandir}/man1/ndctl*
-%{bashcompdir}/
+%{bashcompdir}/ndctl
 %{_unitdir}/ndctl-monitor.service
 %{_sysconfdir}/ndctl/keys/keys.readme
 %{_sysconfdir}/modprobe.d/nvdimm-security.conf
@@ -153,12 +153,14 @@ make check
 %{_bindir}/daxctl
 %{_mandir}/man1/daxctl*
 %{_datadir}/daxctl/daxctl.conf
+%{bashcompdir}/daxctl
 
 %files -n cxl-cli
 %defattr(-,root,root)
 %license LICENSES/preferred/GPL-2.0 LICENSES/other/MIT LICENSES/other/CC0-1.0
 %{_bindir}/cxl
 %{_mandir}/man1/cxl*
+%{bashcompdir}/cxl
 
 %files -n LNAME
 %defattr(-,root,root)

base-commit: 1baaa9035ca5402561a94b9d322b2edbcba4f249
-- 
2.31.1

