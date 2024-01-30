Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB771292E9
	for <nvdimm@lists.linux.dev>; Tue, 30 Jan 2024 16:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706633593; cv=none; b=V8HcXijxoZgxrBesbC2l+pM3aYJhm7OHx7keRObz9Hfzr7wtCjVMZT881XxD8FMVrlCFO73IQx77284a5Kgfxx2X1zxA0TREAstz8gfuYzIIXR1cCOAJllrYvSXehN2BDYBTvW2WDfZ02+HBk/7cEyTi3NUpJxNPGML0p7tU8w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706633593; c=relaxed/simple;
	bh=TeqAlXONUU5nqUDfGe4PPPm1rluqnLU8fKx0/5MP6+4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=slXjZsNo9Ml0KwV5kOfkD7Xu5oPp9J7YcT2ySRFdLRaOekYQgTzshN4FXF8d8OI/HM9v+/cioL6ax0jKOiUk8tyUnxMwuwyICHz6mTDm+q6oSBn0qhxBz4qtBYMJ+f1ecqxh5lRvA98HLlvlbCIIFLVfgxiSi1oPcQs+qR2/dOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=pqI8Vxqf; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="pqI8Vxqf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1706633584;
	bh=TeqAlXONUU5nqUDfGe4PPPm1rluqnLU8fKx0/5MP6+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqI8VxqfmApmjaDjKQX349yC1ZLj6cXG8NnjM6GRv0T0PqIXwhiwEPrza6mt1yGYj
	 bPAMgS7faIoPvOFK2j2p8dbPw+IGautTYGnIeOJ8GcJ/S/4+3Tgn4lSKJxsLiC/5sG
	 4fvfrTpcL6JBjlv+dua8XbJsXqQyTP0mHbPrjpe3/oKtSxJQUFlSzrrBBSK3nUXR69
	 4Q7uQJi1R+AfVFW2LhIChPTjmyLDehNjjBOeS0GsHokH9TPg3wr/Lki3C6hyecKDio
	 UYOhuErVYy275XFsBOAFeY8gqUTg1T9MkuzoJO0Owfc488XdmddiKhpHV0zLY4x73X
	 JoaEMIwFP6lkA==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TPWSc0vhmzVgK;
	Tue, 30 Jan 2024 11:53:04 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Russell King <linux@armlinux.org.uk>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [RFC PATCH v2 5/8] fuse: Use dax_is_supported()
Date: Tue, 30 Jan 2024 11:52:52 -0500
Message-Id: <20240130165255.212591-6-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240130165255.212591-1-mathieu.desnoyers@efficios.com>
References: <20240130165255.212591-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use dax_is_supported() to validate whether the architecture has
virtually aliased data caches at mount time. Silently disable
DAX if dax=always is requested as a mount option on an architecture
which does not support DAX.

This is relevant for architectures which require a dynamic check
to validate whether they have virtually aliased data caches.

Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-arch@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
---
 fs/fuse/dax.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 12ef91d170bb..36e1c1abbf8e 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -1336,6 +1336,13 @@ static bool fuse_should_enable_dax(struct inode *inode, unsigned int flags)
 	if (dax_mode == FUSE_DAX_NEVER)
 		return false;
 
+	/*
+	 * Silently fallback to 'never' mode if the architecture does
+	 * not support DAX.
+	 */
+	if (!dax_is_supported())
+		return false;
+
 	/*
 	 * fc->dax may be NULL in 'inode' mode when filesystem device doesn't
 	 * support DAX, in which case it will silently fallback to 'never' mode.
-- 
2.39.2

