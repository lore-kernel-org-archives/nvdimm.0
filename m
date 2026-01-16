Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E35633986C
	for <nvdimm@lists.linux.dev>; Fri, 16 Jan 2026 02:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768531444; cv=none; b=S77tto6Pqs2ULHThBGx/YjBgHhWWKZ2cTeUUg3Y757bWwoBFrGJyXk6+GFoc+hFMJSVIJRsGAG5/sARAyftsJ8fawmeWXleGpRtLGAVj6TtmzV425xfRRdhfNmNJPO39whTm4UJb/Ibj6u9RYmBF9u9CWoTj4N4uRFgRpnDtvbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768531444; c=relaxed/simple;
	bh=DzGV1B0s1kIQOYtPtJrYHif1D9SxVv5mKCk4KRB19Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+fac6jvsZotx1lxkKXA9fGiRvJEl0XYVyo6Hss/vUbFs6Rvx4pbD7VPG3+EKtwJgYGs5cw4Qa9uLq4nENcV24nE6vpSn5K1PFtJrT8ASiZfuynHt4GRANpXqgtJPJRwSG2mcrqPrl9clbU7nT2cpqogcm/FHRNNV5wzzcVtJz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AKi+o+G/; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AKi+o+G/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768531441; x=1800067441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DzGV1B0s1kIQOYtPtJrYHif1D9SxVv5mKCk4KRB19Ac=;
  b=AKi+o+G/VkQqN+Ir5COE0XEqfTD/xWv+o8JAwqlJrAR7U0Bke+C/+Tu+
   xChDa5IHJCODYc5nSLLS0XoPc4sjJX0GH/5hI/Z/9mD1j8IKV/8Msx5Qa
   yEGeJbhrFC8a0EhZjrHdRVv7sKrM6oLpjR/KqyPV96W2THBbIw6jnoRkh
   CcaGvIc1E2jQHDXrZCd8PjZOSHWYPPRN0EQptfkK1/uolylYOcyUaqoz6
   UDYuoSJoKeFz+wW5LpNc2jpON34fvFCk8LtQQLSfw3KwyvZXAotB3W5Y1
   yof9hlJrgak6zjlzxrivUgslVaftdH+XCc0rnPaZzeekOMWlP+FYFhqhx
   g==;
X-CSE-ConnectionGUID: Zase/b54TSGFxBqsJgDuTw==
X-CSE-MsgGUID: 2uXDX8dKRcKZdeS13WpQMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="81212406"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="81212406"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 18:44:00 -0800
X-CSE-ConnectionGUID: kBpT8ci8RAaV2sNR3QGRBQ==
X-CSE-MsgGUID: 1lDgn8Q9SzmqVHWl8XJ8iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209986250"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.9])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 18:44:00 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	"Joel C. Chang" <joelcchangg@gmail.com>
Subject: [ndctl PATCH 2/2] util/sysfs: add hint for missing root privileges on sysfs access
Date: Thu, 15 Jan 2026 18:43:42 -0800
Message-ID: <4e4ba50b1130c2a76bd2f903aa00644e43faf047.1768530600.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <b74bfd8623fcfc4cf1078991b22b8c899147f5fb.1768530600.git.alison.schofield@intel.com>
References: <b74bfd8623fcfc4cf1078991b22b8c899147f5fb.1768530600.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A user reports that when running daxctl they do not get a hint to
use sudo or root when an action fails. They provided this example:

	libdaxctl: daxctl_dev_disable: dax0.0: failed to disable
	dax0.0: disable failed: Device or resource busy
	error reconfiguring devices: Device or resource busy
	reconfigured 0 devices

and noted that the message is misleading as the problem was a lack
of privileges, not a busy device.

Add a helpful hint when a sysfs open or write fails with EACCES or
EPERM, advising the user to run with root privileges or use sudo.

Only the log messages are affected and no functional behavior is
changed. To make the new hints visible without debug enabled, make
them error level instead of debug.

Reported-by: Joel C. Chang <joelcchangg@gmail.com>
Closes: https://lore.kernel.org/all/ZEJkI2i0GBmhtkI8@joel-gram-ubuntu/
Closes: https://github.com/pmem/ndctl/issues/237
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 util/sysfs.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/util/sysfs.c b/util/sysfs.c
index 5a12c639fe4d..e027e387c997 100644
--- a/util/sysfs.c
+++ b/util/sysfs.c
@@ -24,7 +24,14 @@ int __sysfs_read_attr(struct log_ctx *ctx, const char *path, char *buf)
 	int n, rc;
 
 	if (fd < 0) {
-		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
+		if (errno == EACCES || errno == EPERM)
+			log_err(ctx, "failed to open %s: %s "
+				"hint: try running as root or using sudo\n",
+				path, strerror(errno));
+		else
+			log_dbg(ctx, "failed to open %s: %s\n",
+				path, strerror(errno));
+
 		return -errno;
 	}
 	n = read(fd, buf, SYSFS_ATTR_SIZE);
@@ -49,16 +56,30 @@ static int write_attr(struct log_ctx *ctx, const char *path,
 
 	if (fd < 0) {
 		rc = -errno;
-		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
+		if (errno == EACCES || errno == EPERM)
+			log_err(ctx, "failed to open %s: %s "
+				"hint: try running as root or using sudo\n",
+				path, strerror(errno));
+		else
+			log_dbg(ctx, "failed to open %s: %s\n",
+				path, strerror(errno));
 		return rc;
 	}
 	n = write(fd, buf, len);
 	rc = -errno;
 	close(fd);
 	if (n < len) {
-		if (!quiet)
-			log_dbg(ctx, "failed to write %s to %s: %s\n", buf, path,
-					strerror(-rc));
+		if (quiet)
+			return rc;
+
+		if (rc == -EACCES || rc == -EPERM)
+			log_err(ctx, "failed to write %s to %s: %s "
+				"hint: try running as root or using sudo\n",
+				buf, path, strerror(-rc));
+		else
+			log_dbg(ctx, "failed to write %s to %s: %s\n",
+				buf, path, strerror(-rc));
+
 		return rc;
 	}
 	return 0;
-- 
2.37.3

