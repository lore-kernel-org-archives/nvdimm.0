Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3463FCE
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 22:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639175693; x=1670711693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ha3yZh4Ego36MnXclpeYoj8UGEKNn64IgRgFoXU+zTY=;
  b=fI20D5XqWkFx9h/DGfUMFNEZkZO9F45u77fAIDp8beB7ubFI2IgI68LL
   oL40Xik4zQjYWgvmFrE9JVntplxZhyQv2hh50IvC5iMbukpF/q3dvNsYw
   pgVGYVtwHqd4LM69UIabuOSOk0T4b/xUvkN0QAKKUYXb9ULcVEGmsX0KM
   QTnylUnLbPY4WdCTiV+EyePBQgGff0ZqZla/3niicwpSFgFtr45cJYJVP
   PL95C4Dd29EGQR2YuVA1j2pFf0Zb28duGqajAjYIwO1Vaph74pdZKDzJI
   AC/gRLuTWT4w/IvOzsJqGRU2+eZiWYNJEnSd/gG2PZAD8VgUtbAi3XVsf
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="301843361"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="301843361"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="504113667"
Received: from fpchan-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.0.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:45 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v3 05/11] ndctl: Update ndctl.spec.in for 'ndctl.conf'
Date: Fri, 10 Dec 2021 15:34:34 -0700
Message-Id: <20211210223440.3946603-6-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210223440.3946603-1-vishal.l.verma@intel.com>
References: <20211210223440.3946603-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=909; h=from:subject; bh=Ha3yZh4Ego36MnXclpeYoj8UGEKNn64IgRgFoXU+zTY=; b=owGbwMvMwCXGf25diOft7jLG02pJDImbr/4LyP5uyGu2gK3EJnLWa7nz4qWOPTIv5f/t8n71y2/G zy9GHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiIXQXD//Dy8OtOTcbBYeEcszsMzr SemXP/4epuz6y9F2IkuAzUJRkZetKyP3yYzn44O+d49oOmKs/p78W1Ov88kv1eZbfowEUXdgA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

The new config system introduces and installs a sample config file
called ndctl.conf. Update the RPM spec to include this in the %files
section for ndctl.

Cc: QI Fuli <qi.fuli@fujitsu.com>
Reviewed-by: QI Fuli <qi.fuli@jp.fujitsu.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl.spec.in | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index 0563b2d..b46bd74 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -117,7 +117,8 @@ make check
 %{_sysconfdir}/ndctl/keys/keys.readme
 %{_sysconfdir}/modprobe.d/nvdimm-security.conf
 
-%config(noreplace) %{_sysconfdir}/ndctl/monitor.conf
+%config(noreplace) %{_sysconfdir}/ndctl.conf.d/monitor.conf
+%config(noreplace) %{_sysconfdir}/ndctl.conf.d/ndctl.conf
 
 %files -n daxctl
 %defattr(-,root,root)
-- 
2.33.1

