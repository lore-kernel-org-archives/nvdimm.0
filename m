Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F2629A7
	for <nvdimm@lists.linux.dev>; Wed, 15 Jun 2022 22:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655333298; x=1686869298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jCpWOwYzHjw8QvhM/4XM25Qd2W1lZ7YWrqVX/rIMZuA=;
  b=anPYCDRMvdUfVcqGOjG8njLtFenjqL9aG/PQ7fxJjE0zoLMJgO5dOh9Y
   /jo6nhfrH/vn3E9WAmPbXxiIweA6nzKZNjCSsIyjgDnx+WDAxagej00Nu
   dRpkXfKy+Id3jShWpuVNkb9BDvBXg3ic+GbeFZ2dQxPLEqTAY2Gx3M7kG
   yk44Mxmtbdv9ab388JjPrxbvD5k+0FYrOFsSyxg/RVx/VluXMv04E+ryn
   bEYbzf6zM7qfKOpEGvVmBqIibMbPcoyd8bLyh8WBclfGVySYPBmsDJV93
   ZC10/00B4TVbk+S2GtRZok32iZFPMsjWdyQrHJfqGgxLFevKH2dw6dFS1
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="280150962"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="280150962"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 15:48:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="911896783"
Received: from rshirckx-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.81.6])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 15:48:16 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 2/5] ndctl: remove obsolete m4 directory
Date: Wed, 15 Jun 2022 16:48:10 -0600
Message-Id: <20220615224813.523053-3-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615224813.523053-1-vishal.l.verma@intel.com>
References: <20220615224813.523053-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=579; h=from:subject; bh=jCpWOwYzHjw8QvhM/4XM25Qd2W1lZ7YWrqVX/rIMZuA=; b=owGbwMvMwCXGf25diOft7jLG02pJDEmrEtcU6Fs/faRe/kp6te2p1y3pDKLXg95fy13vGTNRN51T vtG0o5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABMJz2f47/xm+et9wlvehk/Xrjmo6T thtx9XRfc69qd8IseLkssNmxgZlqZszZp8o2Kx478PP78kZNm16WTs8tBm9BI+lJzgWD+bGwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

With the conversion to meson, the m4 directory, which may have held
symlinks to libtool.m4 and friends, is no longer needed. Remove it.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 m4/.gitignore | 6 ------
 1 file changed, 6 deletions(-)
 delete mode 100644 m4/.gitignore

diff --git a/m4/.gitignore b/m4/.gitignore
deleted file mode 100644
index 8bab51c..0000000
--- a/m4/.gitignore
+++ /dev/null
@@ -1,6 +0,0 @@
-libtool.m4
-ltoptions.m4
-ltsugar.m4
-ltversion.m4
-lt~obsolete.m4
-
-- 
2.36.1

