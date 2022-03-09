Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2F717C0
	for <nvdimm@lists.linux.dev>; Wed,  9 Mar 2022 23:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646869013; x=1678405013;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qdEo60QuRBLpkDG9qZ0llpqweNPHFgN5NfnzxqbA+dU=;
  b=S79dAMZpxkksvz6OKuGAfGrqFvh8/JD235plnP9MmeTEstkxCcAEs68O
   GRSXW5UkjMcWe102nzZubIXfkMgPAexeHcCJiPFDgvuy/emgmLS48GJPW
   iB2l1CR7p7LPRO8OxuBsArZMQJMbzv7ewCeRxvdMP5aotoo1oT/W4tV/w
   ObjpiUilz7qw1ZNci/O9kuxaNQY965ftBFaxt8kthImMujfhEMK19gdSw
   ro/i/D8cfytjyH0tTfiUfOoEXV/JmwftdoICKeimSH7ry2ZsNYdhVce8h
   wf8UPX5UIz8/tLPvlEK/HpSH+UNuxYp4vEIfUkSuwpxAwCX6HHFX5pmer
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="253946024"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="253946024"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 15:36:52 -0800
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="554349178"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 15:36:52 -0800
Subject: [ndctl PATCH] build: Fix '-Wall' and '-O2' warnings
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev
Date: Wed, 09 Mar 2022 15:36:52 -0800
Message-ID: <164686901240.2874657.8473455139820858036.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Stop specifying '-Wall and '-O2' in cc_flags, and rely on the buildtype
and warning_level options. Fixup the '-D_FORTIFY_SOURCE=2' option to
optionally be enabled for optimizated builds rather then forcing -O2.

Fixes: 4e5faa1726d2 ("build: Add meson build infrastructure")
Reported-by: Steve Scargall <steve.scargall@intel.com>
Link: https://github.com/pmem/ndctl/issues/195
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 meson.build |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/meson.build b/meson.build
index 5e97e1ce3068..a4149bb7b08c 100644
--- a/meson.build
+++ b/meson.build
@@ -57,7 +57,6 @@ sed -e s,@VERSION@,@0@,g
 '''.format(meson.project_version(), prefixdir, libdir, includedir).split()
 
 cc_flags = [
-  '-Wall',
   '-Wchar-subscripts',
   '-Wformat-security',
   '-Wmissing-declarations',
@@ -70,9 +69,12 @@ cc_flags = [
   '-Wmaybe-uninitialized',
   '-Wdeclaration-after-statement',
   '-Wunused-result',
-  '-D_FORTIFY_SOURCE=2',
-  '-O2',
 ]
+
+if get_option('optimization') != '0'
+  cc_flags += [ '-D_FORTIFY_SOURCE=2' ]
+endif
+
 cc = meson.get_compiler('c')
 add_project_arguments(cc.get_supported_arguments(cc_flags), language : 'c')
 

