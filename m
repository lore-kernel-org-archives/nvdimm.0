Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1252CAB
	for <nvdimm@lists.linux.dev>; Mon,  6 Dec 2021 22:28:44 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="300804831"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="300804831"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:43 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="502310441"
Received: from ponufryk-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:43 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v2 06/12] ndctl: Update ndctl.spec.in for 'ndctl.conf'
Date: Mon,  6 Dec 2021 15:28:24 -0700
Message-Id: <20211206222830.2266018-7-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211206222830.2266018-1-vishal.l.verma@intel.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=728; h=from:subject; bh=10cHrrDXZDVIoR8oSMifEvozAt3pTpAZaVY0KbkOEqs=; b=owGbwMvMwCXGf25diOft7jLG02pJDInr+no7Q3gnBWnzsvBNPnCmaZNH1z+v/86Np9ZMnao6Ud7h 14WijlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEzkmwwjQ7NYyZFfTcvO8/nu4ehp3Z fq8XXvqf7tvdrJ+i0VXSv/6DEy3Aw5FDVXVszf7OUcjSvG/YYCf2Zf+tk598Yn6e+br6Zk8QAA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

The new config system introduces and installs a sample config file
called ndctl.conf. Update the RPM spec to include this in the %files
section for ndctl.

Cc: QI Fuli <qi.fuli@fujitsu.com>
Reviewed-by: QI Fuli <qi.fuli@jp.fujitsu.com>
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
2.33.1

