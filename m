Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA9FA460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534885; x=1702070885;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hF7aOjqB6MekPgEgck3DysnpsehuCNY7mBILiSKV3V8=;
  b=eP9l7+Ii5a0n4UnOfKHxjn8YryWbMUrYXE+K5aNwa7w8HsxGDpCvRc/J
   xYDVm1TTMyHVec+rNKun0ikqGsgFWl/k2zdSCN+vRNldK12i38gVtCeL+
   2Qaonea13ReRziazlO6Ssjol3XOXWH9PIXdsBn8GYd0MdOhdsgPkqxwwW
   HHcpbkRhUZM7EvvI/H+EFHnVbDkejx2/xu7rkxqdJRv4b8/UO6RIKEHt2
   +ojSRY2ItGQJYmkt7TGwymCMakRXWxhnXAuW/fK8DYzV9rbPFRjqiLsjS
   afvzdXApokQjSZIOgbUJdj4liIcBvO5zoVlBb4GmIJHR+NXrfcVyv6AvM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318458727"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="318458727"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="976046997"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="976046997"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:04 -0800
Subject: [ndctl PATCH v2 01/18] ndctl/test: Move firmware-update.sh to the
 'destructive' set
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Yi Zhang <yi.zhang@redhat.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:28:03 -0800
Message-ID: <167053488383.582963.12851797514973259163.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The firmware update test attempts a system-suspend test which may break
systems that have a broken driver, or otherwise are not prepared to support
suspend.

Link: https://github.com/pmem/ndctl/issues/221
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/meson.build |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/meson.build b/test/meson.build
index 5953c286d13f..c31d8eac66c5 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -170,7 +170,6 @@ tests = [
   [ 'btt-errors.sh',          btt_errors,	  'ndctl' ],
   [ 'hugetlb',                hugetlb,		  'ndctl' ],
   [ 'btt-pad-compat.sh',      btt_pad_compat,	  'ndctl' ],
-  [ 'firmware-update.sh',     firmware_update,	  'ndctl' ],
   [ 'ack-shutdown-count-set', ack_shutdown_count, 'ndctl' ],
   [ 'rescan-partitions.sh',   rescan_partitions,  'ndctl' ],
   [ 'inject-smart.sh',        inject_smart,	  'ndctl' ],
@@ -196,6 +195,7 @@ if get_option('destructive').enabled()
   mmap_test = find_program('mmap.sh')
 
   tests += [
+    [ 'firmware-update.sh',     firmware_update,	  'ndctl' ],
     [ 'pmem-ns',           pmem_ns,	   'ndctl' ],
     [ 'sub-section.sh',    sub_section,	   'dax'   ],
     [ 'dax-dev',           dax_dev,	   'dax'   ],

