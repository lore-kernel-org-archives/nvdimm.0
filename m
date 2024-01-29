Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA3215A480
	for <nvdimm@lists.linux.dev>; Mon, 29 Jan 2024 21:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706562417; cv=none; b=SEhbx94sHMc4lo485YK8/4uI2IAN6V9noZ+b01WWztM6f6oTbFvWmaEqbBVEamdn2jQwDEZsZkzXysd1/ZEOPzsEAep4YEBofiZdBOCI9R2L0LkOAf2WTbhGwG1aTHxC95vMsRokkzTX9E5SnpLrKPXnp9FoB6XZ3U3Zz1BR4lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706562417; c=relaxed/simple;
	bh=+9KVNYBLuRYpTotbk2zGsoJXymuo5SYIdtEsNtMMAo8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pdQnMT8l2kbAX9/sTrZmM/rweriNxQMZ1gzhghPU12rjyQvEpH0m0y1GBE9S091M/LdePfgvpmNRdEjJeixVwvhrkiVrFXEwZzRisFhiFwhMr76TMN/ztt3IgzK3qtT/hda6KxxMZTby77uHLG1BKI5rQX0nnGRNxAYvyhswreQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=CcOYTXBC; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="CcOYTXBC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1706562411;
	bh=+9KVNYBLuRYpTotbk2zGsoJXymuo5SYIdtEsNtMMAo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcOYTXBC+giecQFAnLXwCTdIA57noQj2OFLZSCDKOIqpDr07dTVy1a8yJ3JryQJFV
	 2W5WB4QDkxTlNWbKpDcCfDCV1Yk9/dIKfFXxGJuTQcgowNhMsO3Yukg02bjPIMQFRv
	 /baVDZYZtLVEz5A+3KUgQ0PgbI8sFNR5jmvB/7Vj1O8CCBTsO3bSZG9kBumQzDZiac
	 Bm8evVOKtcBoj9wUdK5Wg/PiFVXjpfyrc41vpv1g5ItzalsHpw3MmQJYQPi57b1jWs
	 DvIBjtghpS+h8EJifX32P3NqBz5VyeY9kNGlqU4+zvabpczDg6wWwsmvAwIDe9N3Eq
	 k/288u39p8m6w==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TP17v2W6RzVfr;
	Mon, 29 Jan 2024 16:06:51 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [RFC PATCH 7/7] xfs: Use dax_is_supported()
Date: Mon, 29 Jan 2024 16:06:31 -0500
Message-Id: <20240129210631.193493-8-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129210631.193493-1-mathieu.desnoyers@efficios.com>
References: <20240129210631.193493-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use dax_is_supported() to validate whether the architecture has
virtually aliased caches at mount time.

This is relevant for architectures which require a dynamic check
to validate whether they have virtually aliased data caches
(ARCH_HAS_CACHE_ALIASING_DYNAMIC=y).

Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-arch@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
---
 fs/xfs/xfs_super.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 764304595e8b..b27ecb11db66 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1376,14 +1376,22 @@ xfs_fs_parse_param(
 	case Opt_nodiscard:
 		parsing_mp->m_features &= ~XFS_FEAT_DISCARD;
 		return 0;
-#ifdef CONFIG_FS_DAX
 	case Opt_dax:
-		xfs_mount_set_dax_mode(parsing_mp, XFS_DAX_ALWAYS);
-		return 0;
+		if (dax_is_supported()) {
+			xfs_mount_set_dax_mode(parsing_mp, XFS_DAX_ALWAYS);
+			return 0;
+		} else {
+			xfs_warn(parsing_mp, "dax option not supported.");
+			return -EINVAL;
+		}
 	case Opt_dax_enum:
-		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
-		return 0;
-#endif
+		if (dax_is_supported()) {
+			xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
+			return 0;
+		} else {
+			xfs_warn(parsing_mp, "dax option not supported.");
+			return -EINVAL;
+		}
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
 		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_IKEEP, true);
-- 
2.39.2

