Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C479F132C19;
	Thu, 15 Feb 2024 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708008404; cv=none; b=YNe6YbCYQORKwN+AK94HRG1NoMabsoQqGacL9JcCc2KQnY1/2aVmbRs4fVPOiUcvnWrzXdqprSnoUgewhyIWJPA2g70wqsbjJZ3pp7BNcDtZYsvcAilyAgYudOKAr8Zyu/xNbwq2pw0cjoHbohbkZW6xy7rlZCg34zpld3WNckI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708008404; c=relaxed/simple;
	bh=+A5CzyStXl3uuRu7VAvAaofgyGw3Ro+0xr6rIKIjCf8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QRnjYG8S07IIbf/tGJ/FQ+kMSKj23aD6vHoTxOoYIxMvslkqCrSrUNDTMqhr5SvaEWeWqktuBLAZF03uUTgJCP1kfg3HZWKjf+Ws0uvpNFxEcfK3f/wKNKsoNBZn4zEEWGd9cjgHPJF2bXabH3bnkZ6azMbkqtGu/t0UakJUJOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=YtP1iOrG; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="YtP1iOrG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1708008401;
	bh=+A5CzyStXl3uuRu7VAvAaofgyGw3Ro+0xr6rIKIjCf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtP1iOrGBZ2DFcfkMrFn0KrohYHueOZWWxnb1yMeBkD/1lvsW2xGteSYalPZKSM84
	 dPZuexmp1ywRE4ZTQOjFAgKyIAvz+xWNg3zjhDySnvi/5JJ+HqV6yNHbJnIgA2V+Cz
	 LrEIdoTvdqClLxE1CDwMu7BvH4kU+HynYTL8FGvWqQVF+ZUtTFmBtps3Fll4hy5iYb
	 VWfnhivvj+Lue04BRQYIzFUyJj/QJixaTtTpM98rtcdyFCecmfELtoqdx9qmJ4d3Cn
	 Wpo8Zfth0EElxlDfWMpTqDJD6h2d2p2Z/MvkLxve0QsVGqva4CwWkicSMaV5TpJXl8
	 BS4uFSpfm9ZuQ==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TbHvP59RfzZKm;
	Thu, 15 Feb 2024 09:46:41 -0500 (EST)
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
	linux-s390@vger.kernel.org
Subject: [PATCH v6 7/9] dax: Check for data cache aliasing at runtime
Date: Thu, 15 Feb 2024 09:46:31 -0500
Message-Id: <20240215144633.96437-8-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215144633.96437-1-mathieu.desnoyers@efficios.com>
References: <20240215144633.96437-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the following fs/Kconfig:FS_DAX dependency:

  depends on !(ARM || MIPS || SPARC)

By a runtime check within alloc_dax(). This runtime check returns
ERR_PTR(-EOPNOTSUPP) if the @ops parameter is non-NULL (which means
the kernel is using an aliased mapping) on an architecture which
has data cache aliasing.

Change the return value from NULL to PTR_ERR(-EOPNOTSUPP) for
CONFIG_DAX=n for consistency.

This is done in preparation for using cpu_dcache_is_aliasing() in a
following change which will properly support architectures which detect
data cache aliasing at runtime.

Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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
 drivers/dax/super.c | 10 ++++++++++
 fs/Kconfig          |  1 -
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 205b888d45bf..ce5bffa86bba 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -450,6 +450,16 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
 	dev_t devt;
 	int minor;
 
+	/*
+	 * Unavailable on architectures with virtually aliased data caches,
+	 * except for device-dax (NULL operations pointer), which does
+	 * not use aliased mappings from the kernel.
+	 */
+	if (ops && (IS_ENABLED(CONFIG_ARM) ||
+	    IS_ENABLED(CONFIG_MIPS) ||
+	    IS_ENABLED(CONFIG_SPARC)))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (WARN_ON_ONCE(ops && !ops->zero_page_range))
 		return ERR_PTR(-EINVAL);
 
diff --git a/fs/Kconfig b/fs/Kconfig
index 42837617a55b..e5efdb3b276b 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -56,7 +56,6 @@ endif # BLOCK
 config FS_DAX
 	bool "File system based Direct Access (DAX) support"
 	depends on MMU
-	depends on !(ARM || MIPS || SPARC)
 	depends on ZONE_DEVICE || FS_DAX_LIMITED
 	select FS_IOMAP
 	select DAX
-- 
2.39.2

