Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9439DF9EB
	for <nvdimm@lists.linux.dev>; Wed,  1 May 2024 20:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714595186; cv=none; b=J544F5a+w6pODlp2dZtWRJyf7dDqveDLIWP+V45+AxJj4oUUkfl31SAkvx/LimKK5pbq+h2aE2hd9gb889bAKB0ftFrgOpKU+4tBhQKikK9XiqFpsc2Fy34fD20ib8Oq8cZuAv7hmdwIXP7vq+lcqzxRAMXFMriFW5rH+BtRm1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714595186; c=relaxed/simple;
	bh=0Gw7liiJs4MkjWaq9iwqXK8+3lBpdC6UpwkeD1iO2R0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=H4wRA0YEyvkDmTsrV5S43IoGqWcrXT//AvRWJC84U4UiinyfAh3vYiAdZysZwyp128kz7PlnylvIByrgNkw/CDOzLJG3A3ufV4kexevaURt1aXFzih68glnUFQyptiOlRYdHPQEUGPlYerTbwEzyu42epIB7E2I8vtBTGbXfLIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eMg1q4Nv; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eMg1q4Nv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714595183; x=1746131183;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=0Gw7liiJs4MkjWaq9iwqXK8+3lBpdC6UpwkeD1iO2R0=;
  b=eMg1q4NvUMuXCITNStPshYmTGHdKELLDBejesa39FsIUc8N04yU3kHaZ
   xMXPT+pzAKMj8xqkJ2O9MbWx4/y7Zrh2575p9BQoYk9ZdyfrOQqtqfyxu
   6jf48oKtxK507WeXxMKSJi2fHZNe53xVpoTSnfd53KWP++/wFfmEhUS2N
   Xaf3Lnob0YliZIFZKH+El67kbO4raWi5E4zkUc1qoO7gT+FdDWrEYUVST
   q8Q/cwVI5KZYrVPSE+Ntlw79L3pzXTklcrHfnxu+yQ5TeFVZPbuUKfU9K
   dfBnBqOO77fJfo+SXP7MlJ/huP/ZO4o89xgZ3sJ+KkRU8P3fj0ubfjtM0
   g==;
X-CSE-ConnectionGUID: MDXX1pjlSrWYuNopCXtPEA==
X-CSE-MsgGUID: qk2+i8ydQpWvcFD21qQ68Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11061"; a="10220093"
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="10220093"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 13:26:23 -0700
X-CSE-ConnectionGUID: Y5gzx+iyQKe+RJB8qv3gxA==
X-CSE-MsgGUID: Mlox36/wT5iMhGY5oCfSmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="26941199"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.124.221.179])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 13:26:23 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 01 May 2024 14:25:53 -0600
Subject: [PATCH ndctl] Build: Fix deprecated str.format() usage
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240501-vv-build-fix-v1-1-792eecb2183b@intel.com>
X-B4-Tracking: v=1; b=H4sIAFClMmYC/x2MQQqAIBAAvyJ7bkGlCPtKdLBcayEslCQQ/550n
 IGZAokiU4JJFIiUOfEVGqhOwHbYsBOyawxa6l4OUmHOuD58OvT84uBG7Y0ZjbcOWnJHavrfzUu
 tH/Z9S9xeAAAA
To: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, alison.schofield@intel.com, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.14-dev-5ce50
X-Developer-Signature: v=1; a=openpgp-sha256; l=3397;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=j2uuYMc91DRZfMdj0a0SWADkHUWlzuq/InqqV75kDl0=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDGlGS2O37Z+0L37HZvcXCxbqGRoKiy+WUfTN8Ngkc37Gv
 lViR+ac7ShlYRDjYpAVU2T5u+cj4zG57fk8gQmOMHNYmUCGMHBxCsBEZrcwMlze/v3el7Yvch5P
 bria/pnQeaXc/fvSg0E7Tcwt1v54y/qe4b//TAXdr2bM0zaJ2ly4s3heb4xz2dqYfk3tyUlL2if
 drGQFAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

From: Dan Williams <dan.j.williams@intel.com>

New versions of Meson throw a warning around ndctl's use of
'str.format':

  WARNING: Broken features used:
   * 1.3.0: {'str.format: Value other than strings, integers, bools, options, dictionaries and lists thereof.'}

Fix this by explicit string concatenation for building paths for the
version script, whence the warnings originated.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/meson.build    |  9 +++++----
 daxctl/lib/meson.build | 10 ++++++----
 ndctl/lib/meson.build  |  9 +++++----
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/cxl/lib/meson.build b/cxl/lib/meson.build
index 422a3513..3f47e495 100644
--- a/cxl/lib/meson.build
+++ b/cxl/lib/meson.build
@@ -3,8 +3,9 @@ libcxl_version = '@0@.@1@.@2@'.format(
   LIBCXL_REVISION,
   LIBCXL_AGE)
 
-mapfile = files('libcxl.sym')
-vflag = '-Wl,--version-script,@0@/@1@'.format(project_source_root, mapfile[0])
+libcxl_dir_path = meson.current_source_dir()
+libcxl_sym = files('libcxl.sym')
+libcxl_sym_path = libcxl_dir_path / 'libcxl.sym'
 
 cxl = library('cxl',
   '../../util/sysfs.c',
@@ -21,8 +22,8 @@ cxl = library('cxl',
   version : libcxl_version,
   install : true,
   install_dir : rootlibdir,
-  link_args : vflag,
-  link_depends : mapfile,
+  link_args : '-Wl,--version-script=' + libcxl_sym_path,
+  link_depends : libcxl_sym,
 )
 cxl_dep = declare_dependency(link_with : cxl)
 
diff --git a/daxctl/lib/meson.build b/daxctl/lib/meson.build
index b79c6e59..b2c7a957 100644
--- a/daxctl/lib/meson.build
+++ b/daxctl/lib/meson.build
@@ -4,8 +4,10 @@ libdaxctl_version = '@0@.@1@.@2@'.format(
   LIBDAXCTL_AGE,
 )
 
-mapfile = files('libdaxctl.sym')
-vflag = '-Wl,--version-script,@0@/@1@'.format(project_source_root, mapfile[0])
+libdaxctl_dir_path = meson.current_source_dir()
+libdaxctl_sym = files('libdaxctl.sym')
+libdaxctl_sym_path = libdaxctl_dir_path / 'libdaxctl.sym'
+
 
 libdaxctl_src = [
   '../../util/iomem.c',
@@ -25,8 +27,8 @@ daxctl = library(
   ],
   install : true,
   install_dir : rootlibdir,
-  link_args : vflag,
-  link_depends : mapfile,
+  link_args : '-Wl,--version-script=' + libdaxctl_sym_path,
+  link_depends : libdaxctl_sym,
 )
 
 daxctl_dep = declare_dependency(link_with : daxctl)
diff --git a/ndctl/lib/meson.build b/ndctl/lib/meson.build
index abce8794..2907af7f 100644
--- a/ndctl/lib/meson.build
+++ b/ndctl/lib/meson.build
@@ -3,8 +3,9 @@ libndctl_version = '@0@.@1@.@2@'.format(
   LIBNDCTL_REVISION,
   LIBNDCTL_AGE)
 
-mapfile = files('libndctl.sym')
-vflag = '-Wl,--version-script,@0@/@1@'.format(project_source_root, mapfile[0])
+libndctl_dir_path = meson.current_source_dir()
+libndctl_sym = files('libndctl.sym')
+libndctl_sym_path = libndctl_dir_path / 'libndctl.sym'
 
 ndctl = library(
  'ndctl',
@@ -32,8 +33,8 @@ ndctl = library(
   version : libndctl_version,
   install : true,
   install_dir : rootlibdir,
-  link_args : vflag,
-  link_depends : mapfile,
+  link_args : '-Wl,--version-script=' + libndctl_sym_path,
+  link_depends : libndctl_sym,
 )
 ndctl_dep = declare_dependency(link_with : ndctl)
 

---
base-commit: 7c8c993b87ee8471b4c138de549c39d1267f0067
change-id: 20240501-vv-build-fix-5d72f9979fad

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

