Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2577A
	for <nvdimm@lists.linux.dev>; Wed,  9 Mar 2022 05:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646803686; x=1678339686;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nlclmCKPL90ZYT0UjwvVBUmDB9WLHSEGOD/2sH519Gc=;
  b=YdbjkpknUKO1w0mEOXd7gTp55LDsO2iIDxxJH8Nc06TgmQk8bM4PM+S4
   BUUlk08Cxfg0ITcEbCs4Gqf+Sx4AUa4o+ZtCDqkAokLlehFsQDQu1Y/eI
   hv0ODRSZLDphJ9GJeGnl6S2pm/wjI44j+aSEd3qo2ARz00z7aGgxf8LQ1
   FiRt61acg7n+dqYfy1wkBQ/+NIt3KIrcvnO9MKgJxIJ7pObjsDYuM81ie
   rza24Xy6owMV+LTOrgui3VLU1GxQLPCqf/1b05+3O0MhbuTElsrEx02db
   THrmxTXnyhctIJO/r747hVdfcFvcY+ruh3PxGcOUuW2Rxesr6+5+lsEpw
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="318119757"
X-IronPort-AV: E=Sophos;i="5.90,166,1643702400"; 
   d="scan'208";a="318119757"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 21:28:05 -0800
X-IronPort-AV: E=Sophos;i="5.90,166,1643702400"; 
   d="scan'208";a="632493168"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 21:28:05 -0800
Subject: [ndctl PATCH] build: Fix systemd unit directory detection
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev
Date: Tue, 08 Mar 2022 21:28:05 -0800
Message-ID: <164680368507.2861995.11649228118524518218.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Older distributions (like CentOS Stream 8) define the systemd unit
directory variable in pkgconfig as ${systemdsystemunitdir}, instead of
${systemd_system_unit_dir}. Newer systemd pkgconfig uses both. Pick the
older more compatible name for use.

Fixes: 4e5faa1726d2 ("build: Add meson build infrastructure")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 meson.build |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index f25ec6c47e7b..5e97e1ce3068 100644
--- a/meson.build
+++ b/meson.build
@@ -150,7 +150,7 @@ endif
 
 if get_option('systemd').enabled()
   systemd = dependency('systemd', required : true)
-  systemdunitdir = systemd.get_pkgconfig_variable('systemd_system_unit_dir')
+  systemdunitdir = systemd.get_pkgconfig_variable('systemdsystemunitdir')
   udev = dependency('udev', required : true)
   udevdir = udev.get_pkgconfig_variable('udevdir')
   udevrulesdir = udevdir / 'rules.d'

