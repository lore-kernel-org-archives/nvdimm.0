Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC425D500
	for <nvdimm@lists.linux.dev>; Sun,  6 Nov 2022 23:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667778412; x=1699314412;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hF7aOjqB6MekPgEgck3DysnpsehuCNY7mBILiSKV3V8=;
  b=gbjtXBmtMD0q8kCq22oBowwJHs/yGCQEPj2uV9zYEWzxhK0HXtV3T5KB
   83fHru0telt7vMMIjVpRLWjrYJD0aDgeZ3cMO4DY/GeVBnT8cJy3+DbtK
   1GXqvFP9pdFe8RGHmH10SQ/hkt6vf5JY95EEJw20ayS4DQ+pPcvF1qRN7
   X38tOWbUF0hcxFO3tcPz06rc7iYK/X2cGxMHdXdrWChu5zJAED//Qzq4l
   WB2tuA0ara6UnKSAA/3G9znJI+l0iFLCh8+hSRkBeSkgbKePkbvbaPHvC
   yvK79z+S+bZ0+so25/OfdjhSRzbzkbq5KaVl2hPRI9C8Nh76v6605nsCJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="337007902"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="337007902"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:46:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="880867099"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="880867099"
Received: from durgasin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.240.219])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:46:51 -0800
Subject: [ndctl PATCH 01/15] ndctl/test: Move firmware-update.sh to the
 'descructive' set
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 06 Nov 2022 15:46:51 -0800
Message-ID: <166777841122.1238089.5858907027462618446.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
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

