Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C36272
	for <nvdimm@lists.linux.dev>; Tue, 31 Aug 2021 09:06:19 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="304009048"
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="304009048"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:06 -0700
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="577062976"
Received: from msgunjal-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.30.4])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:06 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH 1/7] ndctl: Update ndctl.spec.in for 'ndctl.conf'
Date: Tue, 31 Aug 2021 03:04:53 -0600
Message-Id: <20210831090459.2306727-2-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210831090459.2306727-1-vishal.l.verma@intel.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=681; h=from:subject; bh=LZY45W83hKig2zhf1D0Q5I7sLWp//vT8BdsLoQPCMx4=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm6HxY3V765NPe3qulPxdbTL4XvHf1/xPHNEhaW0yXf4par mMqs6ihlYRDjYJAVU2T5u+cj4zG57fk8gQmOMHNYmUCGMHBxCsBEPjsx/A9UCvt3OpLp8t7nvd0SN1 NXvNiw89RS3ZRlQr3BW6d5TStl+GdV2+LV6vK6YpnjzleXlI62uV911WhNfSv1SXDfvWSHekYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

The new config system introduces and installs a sample config file
called ndctl.conf. Update the RPM spec to include this in the %files
section for ndctl.

Cc: QI Fuli <qi.fuli@fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl.spec.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index 0563b2d..07c36ec 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -118,6 +118,7 @@ make check
 %{_sysconfdir}/modprobe.d/nvdimm-security.conf
 
 %config(noreplace) %{_sysconfdir}/ndctl/monitor.conf
+%config(noreplace) %{_sysconfdir}/ndctl/ndctl.conf
 
 %files -n daxctl
 %defattr(-,root,root)
-- 
2.31.1

