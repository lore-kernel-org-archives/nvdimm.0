Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A061F462D;
	Wed, 17 Sep 2025 23:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758153059; cv=none; b=Ztqus/v98AHysmS3a+Cw/0+mgV3iJ7uvVzdwAjJjmBVySETLaCDWURe2tu1+nvgQ4w9XdSD+gCIwIANa3lHzlQwEstGs5ar2U8C9twMlWJSxKXRBOH8DK1SrxBVwAUaVW+qMxBB8Ra+ibA7jmVYQiDwXDQaJEjAwkMbGwBPEiYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758153059; c=relaxed/simple;
	bh=mhYKYK3c9xOsIUfpHxC7ByElmW429NamzPpzBN8kPSc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iFfnrWE7DXrYvLKLKpBNqSkX5xn6dPoVINUfkY4EqZF4TAi6DYIicYjmjBrJ9sR7WwfH1VGCWpypAkfWDMM4j9aN/ZgwnzIWdxS3jk0q4eQrlhos2i6j5lY8uwvi5AAz1CG5duWP1mHU0NorMHDfPJH4r5YW4zRRZewGLQwGCTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC40C4CEE7;
	Wed, 17 Sep 2025 23:50:58 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH] cxl: Add man page documentation to note the change to disable-port
Date: Wed, 17 Sep 2025 16:50:56 -0700
Message-ID: <20250917235056.427188-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a note to warn potential breakage of 'disable-port -m' option
when using an older CXL CLI with a newer kernel.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/cxl/cxl-enable-port.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/cxl/cxl-enable-port.txt b/Documentation/cxl/cxl-enable-port.txt
index 00c40509f09e..5d918f8658e5 100644
--- a/Documentation/cxl/cxl-enable-port.txt
+++ b/Documentation/cxl/cxl-enable-port.txt
@@ -33,6 +33,12 @@ OPTIONS
 	memdev is only enabled after all CXL ports in its device topology
 	ancestry are enabled.
 
+	Note: release before v83 will not work starting with kernel v6.18 for
+	the '-m' option. However v83 or later will work with all previous
+	kernels. The kernel starting with v6.18 enumerates the CXL ports
+	and dports differently and the CXL ports hierachy is not established
+	until the memdev is probed by the kernel.
+
 include::debug-option.txt[]
 
 include::../copyright.txt[]

base-commit: b4caae2ed720d2ba51eabf449fd1e1105bd07dd1
-- 
2.50.1

