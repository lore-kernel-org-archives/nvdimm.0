Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF1981746;
	Fri,  2 Feb 2024 21:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706907630; cv=none; b=nAthDv7G4Tbhk/TdfVVXvKAgBuk6KTJIa+wDINVuBggpl7unx5qsCCzWh8kCbXkaIaBK7j9p9TPG89zcx82Tm5UbwJFfnhAl8njrewvyTfTgYsN8KnK97r61BV4S53BmlSD4QRYvIJUHJXu4Vo55b5EudyCHJGv7g+30AvxQwjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706907630; c=relaxed/simple;
	bh=C9trdHKUBo0wvYK5DBzsNfOU9QCkPyPGO5T7CJRyOKU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FHR6He9pjXOluKumrZhRv+VE+B/tFThGYwg02/YxcZCzXULwzbzh2uXJ3ZCaXDMrv9Sb53yQPeTbgvCIQ3YDBm6M2b7Jzzoxs3d4EtHGgY8nVufni5/F2ImscVsYHQNdySiWXuBNXvtW6CN98eDUxggqr4nsO5wdCqPBQUAi2SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=olkQ8vHB; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="olkQ8vHB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1706907627;
	bh=C9trdHKUBo0wvYK5DBzsNfOU9QCkPyPGO5T7CJRyOKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olkQ8vHBDWpgDSm0PdwKANERNaZOsyNCOuQxCFFGVBsLD7Ag/CgydWr3+PnCboGWb
	 +hIPSsfeUgy6KlyuCCuiuPfERsK/mtMVZeN3F6hj24iXvLlqHKvWVMnhN+ewVfA/AA
	 9dSCFnRtTxiVUJqwb3fx9CGtZtzDHf3fYXJLNUajd1vzr7dv1k2M3iWpfI25zwFG2Y
	 1sm0tOKrJZdLKX/2FhGszkqnQD/SyOyzGMpy77l8cbhKZDwxeWGl8+MLyS8GNQ1C4F
	 KSQLZfAtqgBbSQzv5qJelyGnvDGQfHgCKVKnpkAWAutmUaRMOzjk4YKBMbe1yJBvkG
	 KJbJ7UojvG1Ww==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TRSpg0YQmzWvD;
	Fri,  2 Feb 2024 16:00:27 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Russell King <linux@armlinux.org.uk>,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [RFC PATCH v4 01/12] nvdimm/pmem: Fix leak on dax_add_host() failure
Date: Fri,  2 Feb 2024 16:00:08 -0500
Message-Id: <20240202210019.88022-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240202210019.88022-1-mathieu.desnoyers@efficios.com>
References: <20240202210019.88022-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a leak on dax_add_host() error, where "goto out_cleanup_dax" is done
before setting pmem->dax_dev, which therefore issues the two following
calls on NULL pointers:

out_cleanup_dax:
        kill_dax(pmem->dax_dev);
        put_dax(pmem->dax_dev);

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arch@vger.kernel.org
Cc: linux-cxl@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-xfs@vger.kernel.org
Cc: dm-devel@lists.linux.dev
Cc: nvdimm@lists.linux.dev
---
 drivers/nvdimm/pmem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 4e8fdcb3f1c8..9fe358090720 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -566,12 +566,11 @@ static int pmem_attach_disk(struct device *dev,
 	set_dax_nomc(dax_dev);
 	if (is_nvdimm_sync(nd_region))
 		set_dax_synchronous(dax_dev);
+	pmem->dax_dev = dax_dev;
 	rc = dax_add_host(dax_dev, disk);
 	if (rc)
 		goto out_cleanup_dax;
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
-	pmem->dax_dev = dax_dev;
-
 	rc = device_add_disk(dev, disk, pmem_attribute_groups);
 	if (rc)
 		goto out_remove_host;
-- 
2.39.2

