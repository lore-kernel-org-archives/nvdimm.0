Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7C329A8
	for <nvdimm@lists.linux.dev>; Wed, 22 Feb 2023 20:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677097234; x=1708633234;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=G8ViUERPTgtOSoevmVJc8MG4EFSsbkHnvexIpUy/brM=;
  b=f4k6vGq6gRkf8T327k9ImMxOKYiGG4nAw3Ka+9+vzxfI6PSkx5fv+3bF
   EEl0aAvxVy7MX5VhYKJfu0AJOr+FbO+t7UsAeo9JlUgBqhus7zv/1k85I
   TL90CFJPPTsdq17c5vF7tbwqweoLTcmhnCuz/JqN1WjpI32jLmjI/Hr0R
   leffei1KJoxeZdk6xYCLUbTGyGtM2deizuR7NbMTaLZNAeTEcn02vtmGJ
   tipMzD83I3AdG9LOuQ//yulPL/621wjZk/Zm9JSVksrjybZom6Y0TglDl
   3zd1KWpS9j9GY7WgoYQ1E1wlrOdDgJ+QdTlGLQze5iFd1owewVFw65K/I
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="312657319"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="312657319"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 12:20:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="1001122141"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="1001122141"
Received: from sdmishr-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.212.236.12])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 12:20:33 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 22 Feb 2023 13:20:24 -0700
Subject: [PATCH ndctl] ndctl.spec.in: Add build dependencies for
 libtraceevent and libtracefs
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230222-fix-rpm-spec-v1-1-e6d8668ea421@intel.com>
X-B4-Tracking: v=1; b=H4sIAAd59mMC/x3N0QqDMAyF4VeRXBvoMmSwVxEv0prOXLQrCQxBf
 HfrLv8DH+cAF1NxeA8HmPzU9Vt7PMYB0sb1I6hrb6BAz0BEmHVHawW9SUKSNU/8yommCJ1EdsF
 oXNN2o8Ja77mZdPZ/mZfzvADfIocTdQAAAA==
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dave Jiang <dave.jiang@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=1157;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=G8ViUERPTgtOSoevmVJc8MG4EFSsbkHnvexIpUy/brM=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMnfKgUtlvxUjrd9zjz5pqCWmvCkbReX5FZ2bGYUeBef8
 Xdnp9nLjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEykNIThn5X5wucLk/U/JdwS
 PbtWJS+DZ/7KH8lCEftuqk+/1FSSPY+R4emrZOfzvfqndm7z1FH6JVHHOHHtl9bDa/6VNkq8i3r
 nwwEA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The cxl-monitor additions pull in new dependencies on libtraceevent and
libtracefs. While the commits below added these to the meson build
system, they neglected to also update the RPM spec file. Add them to
the spec.

Fixes: 8dedc6cf5e85 ("cxl: add a helper to parse trace events into a json object")
Fixes: 7b237bc7a8ae ("cxl: add a helper to go through all current events and parse them")
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl.spec.in | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index 35c63e6..0543c48 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -31,6 +31,8 @@ BuildRequires:	keyutils-libs-devel
 BuildRequires:	systemd-rpm-macros
 BuildRequires:	iniparser-devel
 BuildRequires:	meson
+BuildRequires:	libtraceevent-devel
+BuildRequires:	libtracefs-devel
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"

---
base-commit: 835b09602cdcae8d324eeaf5bb4f17ae959c5e6d
change-id: 20230222-fix-rpm-spec-2edf5a7fc25b

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

