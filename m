Received: from jpms-ob01-os7.noc.sony.co.jp (jpms-ob01-os7.noc.sony.co.jp [211.125.139.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BEA27F756
	for <nvdimm@lists.linux.dev>; Tue, 30 Sep 2025 05:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.139.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759211678; cv=none; b=bQ8NVdm3m/IYBhRE3PaX6kfLPkPwtfOW1SC9tG/Sz3kzgio7FJatuki6nqZIpzywWdiUhGLa3P9ve3diTwKJFht95ukdyIAdboX0mJog3ht3+JY0F0KTHOw/lx7WXO91woffIHi2k5VskxLVxipP/CRLGfWd2xwB3n9U6aRG+SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759211678; c=relaxed/simple;
	bh=75Ez7Llij/FP+65V0SEWePsRytsP9jwhJzUu3dNd6FE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PIBZpJdHDs9V0rowlQr7P+KiUpmafLGWKMJr4mDZzY/tZXt8QhuWjgmMQ/VBa6rBihHcLJNqM8nYpWSoIlDGD0JCOFIFGI0ElrIbMFFYS2Ec734QOuuOpGSLpBVTAHMmF73yhz+Poo8ZslyCfWRhYqMd5XbDtlezi8Jg/SWLjoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=fail smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=xs4KcPnu; arc=none smtp.client-ip=211.125.139.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=sony.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="xs4KcPnu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1759211674; x=1790747674;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Jrcsq7Bu0Yk3UAMt03x6tUgoyIW9LMRiz/7TzP+TiEw=;
  b=xs4KcPnuwtmwIAcv8JTeEnRrwS4uAqd4Rh5+KLz1pkNj/HhC4yhhuS1J
   3aVgeB+fX0pUduaLu4+LoNK1j1PR3BOOFpmAZQ2suGwbBTTVn1U+boSG3
   KL4as9vf9azEooMSNURY1Q0UzZB77+4TVxdNMLYE8q9a2YpoP9S58kFbR
   GWhZW7MHYXVfZ/DXnbrqQTLhkmRXCyk1dkxS9TysFgMC4HdCDI5n4qQpq
   SHfBd3qtN+VvKkIqmN2vhVUiI+GawcaqVSsQaWU7Gv//0IM/O8l4Hw7S/
   CvgC67UyWKU3t94FgVljk3fgKLj4t9gr5mS/tz8z3UQJfJanzhEGm6raH
   A==;
Received: from unknown (HELO jpmta-ob01-os7.noc.sony.co.jp) ([IPv6:2001:cf8:acf:1104::6])
  by jpms-ob01-os7.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 14:44:24 +0900
X-IronPort-AV: E=Sophos;i="6.18,303,1751209200"; 
   d="scan'208";a="39195439"
Received: from unknown (HELO cscsh-7000014390..) ([43.82.111.225])
  by jpmta-ob01-os7.noc.sony.co.jp with ESMTP; 30 Sep 2025 14:44:24 +0900
From: Yuezhang Mo <Yuezhang.Mo@sony.com>
To: linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	hch@lst.de,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Friendy Su <friendy.su@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>
Subject: [PATCH v1] dax: skip read lock assertion for read-only filesystems
Date: Tue, 30 Sep 2025 13:42:57 +0800
Message-ID: <20250930054256.2461984-2-Yuezhang.Mo@sony.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit 168316db3583("dax: assert that i_rwsem is held
exclusive for writes") added lock assertions to ensure proper
locking in DAX operations. However, these assertions trigger
false-positive lockdep warnings since read lock is unnecessary
on read-only filesystems(e.g., erofs).

This patch skips the read lock assertion for read-only filesystems,
eliminating the spurious warnings while maintaining the integrity
checks for writable filesystems.

Fixes: 168316db3583 ("dax: assert that i_rwsem is held exclusive for writes")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 20ecf652c129..260e063e3bc2 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1752,7 +1752,7 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_rw(iter) == WRITE) {
 		lockdep_assert_held_write(&iomi.inode->i_rwsem);
 		iomi.flags |= IOMAP_WRITE;
-	} else {
+	} else if (!sb_rdonly(iomi.inode->i_sb)) {
 		lockdep_assert_held(&iomi.inode->i_rwsem);
 	}
 
-- 
2.43.0

