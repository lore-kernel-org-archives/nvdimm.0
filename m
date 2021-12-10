Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D342EA2
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 22:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639175696; x=1670711696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BTd8Y+BXD+awPWHh011/OnGpNvDzUL4gkb/OU0PDJbI=;
  b=SkNLTcSM07eTOvGQ7KrploYDV/iez6AGe1Rm5Erl9XfDIz9xyhLasgux
   R3C+xqFL1THW1DX0aA1lEL1qNb5qlXS1r1YEAE/juwgNDs1SZSyqrYGd0
   v9/nSmXLTme5H/a1c4NJl7PctH30Aq3fCg8/T+UvFLSY43zXSpJ9tpm1K
   hT32jzXprTjbkVMwC9j1TnFo5PRQuBcujkPzlf112MW5UHJW2JkMxs5/X
   mrPt+uwNx96xYfM4Nb8AwN/aU1bATpvyccTTC17strRv/wAhW8sooJtlZ
   iiyVcnxjpwvJG+fT/ZqUkYnf3SEeGPkmUt6jRLC2DYk/cIyYeVXUYzt5M
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="301843386"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="301843386"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="504113703"
Received: from fpchan-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.0.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:48 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 11/11] daxctl: add and install an example config file
Date: Fri, 10 Dec 2021 15:34:40 -0700
Message-Id: <20211210223440.3946603-12-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210223440.3946603-1-vishal.l.verma@intel.com>
References: <20211210223440.3946603-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2687; h=from:subject; bh=BTd8Y+BXD+awPWHh011/OnGpNvDzUL4gkb/OU0PDJbI=; b=owGbwMvMwCXGf25diOft7jLG02pJDImbrzHcqdyul5NgvLm1erGkzfZ7N35tflCzIDRnj9u6hTsY GRQ7OkpZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCRFVMZ/mfaKxqa9m1aeOia2ZPENI 54xVlaUxmj7we7i04+9f+tbR/DX9nCY3tDPgrLvYvzy/2obnlJecH1F4rTzUqCVY6dV9pxgB8A
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add an example config file, and install it with 'make install' and via
the RPM, so that the config path gets established, and there is an
easily available template to edit as needed.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 daxctl/Makefile.am         |  3 +++
 daxctl/daxctl.example.conf | 27 +++++++++++++++++++++++++++
 ndctl.spec.in              |  1 +
 3 files changed, 31 insertions(+)
 create mode 100644 daxctl/daxctl.example.conf

diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index 36dfc55..d1bf9fb 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -32,6 +32,9 @@ daxctl_LDADD =\
 udevrulesdir = $(UDEVRULESDIR)
 udevrules_DATA = 90-daxctl-device.rules
 
+daxctl_configdir = $(daxctl_confdir)
+daxctl_config_DATA = daxctl.example.conf
+
 if ENABLE_SYSTEMD_UNITS
 systemd_unit_DATA = daxdev-reconfigure@.service
 endif
diff --git a/daxctl/daxctl.example.conf b/daxctl/daxctl.example.conf
new file mode 100644
index 0000000..8181863
--- /dev/null
+++ b/daxctl/daxctl.example.conf
@@ -0,0 +1,27 @@
+# This is an example config file for daxctl
+# daxctl supports multiple configuration files. All files with the
+# .conf suffix under {sysconfdir}/daxctl.conf.d/ are valid config files.
+# Lines beginning with a '#' are treated as comments and ignored
+# The (section-name, subsection-name) tuple must be unique across all
+# config files.
+
+# The following example config snippet is used to automatically reconfigure
+# an nvdimm namespace with the specified UUID from 'devdax' mode to
+# 'system-ram'.
+
+# Uncomment the lines to activate it, and substitute the correct UUIDs and
+# other parameters for the desired behavior.
+
+# This can be replicated as many times as necessary to handle multiple
+# namespaces/dax devices, so long as the subsection name (e.g.
+# "unique_identifier_foo" in the example below) is unique across all
+# sections and all config files in the config path.
+
+# The nvdimm.uuid can be obtained from a command such as:
+#   "ndctl list --device-dax"
+
+# [reconfigure-device unique_identifier_foo]
+# nvdimm.uuid=ed93e918-e165-49d8-921d-383d7b9660c5
+# mode = system-ram
+# online = true
+# movable = false
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 642670a..ce80f9d 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -129,6 +129,7 @@ make check
 %{_datadir}/daxctl/daxctl.conf
 %{_unitdir}/daxdev-reconfigure@.service
 %config %{_udevrulesdir}/90-daxctl-device.rules
+%config(noreplace) %{_sysconfdir}/daxctl.conf.d/daxctl.example.conf
 
 %files -n LNAME
 %defattr(-,root,root)
-- 
2.33.1

