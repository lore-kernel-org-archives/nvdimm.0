Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC3521FF33
	for <nvdimm@lists.linux.dev>; Fri, 16 Jan 2026 02:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768531432; cv=none; b=rIhg0ApclR+5UA75oLPXo0m/QTXiuuqtlqrjsH3qF6nK98GFUB22oXlBhZhLcNtNHLmt5cYwhUbQBTgH2MqL1DzNvsubUzlE8QUSnV/VH8dc8CxhA82SWNBMEX7tebTPanTPaogeSuAnajK6E0lrmDplnSKNf5gMiZGN9dGxaMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768531432; c=relaxed/simple;
	bh=Tytle09Puavw7vPffIG02KnrLF3nSN2QypsezPHomyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GB//Pu8bnsBunLPu/Wa6GJCLxJG67OVjfRq/wE2DVM2pqf0n/D0oMI0+3uYNbtFrR0fTUrc4trCQ1yMzRQMt8yj43zkXEtjQNWHQxiAXTQHwylzuR74gcsd5kJgaVles2lH5BWASr0x0xbdHZfAdxP/4bJ1vM95l+xJR7l4mJg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SFsAxtT9; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SFsAxtT9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768531431; x=1800067431;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Tytle09Puavw7vPffIG02KnrLF3nSN2QypsezPHomyM=;
  b=SFsAxtT9F5/ymhzj0VwMqe4130bnlMWqCDSITDaQ2m7I22a6E7qQcUrl
   YTW+M06vUuGSOgjQ2DD2LSyjJM+Ba0UMlgSLK+mOlZNYK5IT6bDR7Q+Uc
   g4Fc9RxFF6bNnImoFMpX5T5pOpyNYMmrTAHNUMLZxKGjrY741ln5yftnb
   exWjPLkbaCXQuNRD33KiHA+Lr9izYuKeIjGXVUm9WkX5DDS7kHlQZDgsn
   eNUwPxZgYWetGclkY3YukgXvip7eNorVY2ZfrtwX1ncTvtQN7+BmjhO4w
   GeOCFIYm4UIu2pZUIkAWuyeLxlEYKbwW/bX+5XXanJDYBB0NpmLny5O4x
   A==;
X-CSE-ConnectionGUID: OnoZEoiBSNCCl88lPy9+xQ==
X-CSE-MsgGUID: wEa9Na32TlqqfPJTWNZ06A==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69759913"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69759913"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 18:43:51 -0800
X-CSE-ConnectionGUID: gb1t6S6PQVS9yU43olv5Kw==
X-CSE-MsgGUID: pi4QJCdWT86sThatGZVNoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="204324787"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.9])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 18:43:50 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 1/2] util/sysfs: save and use errno properly in read and write paths
Date: Thu, 15 Jan 2026 18:43:41 -0800
Message-ID: <b74bfd8623fcfc4cf1078991b22b8c899147f5fb.1768530600.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The close() system call may modify errno. In __sysfs_read_attr(),
errno is used after close() for both logging and the return value,
which can result in reporting the wrong error. In write_attr(),
errno is saved before close(), but the saved value was not used
for logging.

Without this fix, if close() modifies errno, users may see incorrect
error messages that don't reflect the actual failure and the function
may return the wrong error code causing the calling code to handle
the error incorrectly.

Save errno immediately after read() in __sysfs_read_attr(), matching
the existing write_attr() pattern, and use the saved values for both
logging and return paths.

Found while preparing a patch to expand the log messages in sysfs.c

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 util/sysfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/util/sysfs.c b/util/sysfs.c
index 968683b19f4e..5a12c639fe4d 100644
--- a/util/sysfs.c
+++ b/util/sysfs.c
@@ -21,18 +21,19 @@
 int __sysfs_read_attr(struct log_ctx *ctx, const char *path, char *buf)
 {
 	int fd = open(path, O_RDONLY|O_CLOEXEC);
-	int n;
+	int n, rc;
 
 	if (fd < 0) {
 		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
 		return -errno;
 	}
 	n = read(fd, buf, SYSFS_ATTR_SIZE);
+	rc = -errno;
 	close(fd);
 	if (n < 0 || n >= SYSFS_ATTR_SIZE) {
 		buf[0] = 0;
-		log_dbg(ctx, "failed to read %s: %s\n", path, strerror(errno));
-		return -errno;
+		log_dbg(ctx, "failed to read %s: %s\n", path, strerror(-rc));
+		return rc;
 	}
 	buf[n] = 0;
 	if (n && buf[n-1] == '\n')
@@ -57,7 +58,7 @@ static int write_attr(struct log_ctx *ctx, const char *path,
 	if (n < len) {
 		if (!quiet)
 			log_dbg(ctx, "failed to write %s to %s: %s\n", buf, path,
-					strerror(errno));
+					strerror(-rc));
 		return rc;
 	}
 	return 0;
-- 
2.37.3

