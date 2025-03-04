Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8147E73176
	for <nvdimm@lists.linux.dev>; Tue,  4 Mar 2025 00:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048643; cv=none; b=bYH7c5uWmI9Ao06/kJ+o1Sinv3PeiJCpBkW7XaTjvocgcjg4yku8O/2XoqZrNjxgCXZmJdqohwiuhuOoKE/CmI/v6/5bWkF6yvnDbXQvfVGyoatU0QUlzmz4oCs2Hprv8Fpp62qWosjVa4qMQkspvIT1dMtYoJ6baNgDaFFdtXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048643; c=relaxed/simple;
	bh=zDY5+qppEEd0Q3iP6qv7jz2cpU7m4khlkmPqhxhyktI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPY1o5lE0apPh8CBldYIkhZ9pnqOO0wkYJIzwig4P1TeG/td/BIzImr7zerBdLTdaDvjd/Fzr9M9G40BPeKCvvPoEtTtR9U9LtUVmaPw8Y+IiCfXK1yXKFUFzouAFXgOJ9EsNX5Db63lS+wu0bmsYJiMG3S7JcDVFMrwoOhWHEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SJtg5wWL; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SJtg5wWL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741048642; x=1772584642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zDY5+qppEEd0Q3iP6qv7jz2cpU7m4khlkmPqhxhyktI=;
  b=SJtg5wWLub7w5pGgO8vcxPu9yfgNXwUoONcX7V9Bql2TyI/dd7SxJa6n
   2D/S3p80lIilhiutXypX5TVgBaOYnJXnwr6feYEBwNvw2EmbBl+SExKci
   fblx5uaVDILsyMaEbZdpQHq0yjfNsNIa60KxOdZ/h7KyXSDqxAsjoqAFO
   sYb55OlS9/6nLbX1WhoXZOlnOnzFVz6EHZDBZNyHFaKDH+3XIXjM6oE+8
   1l+E1gAkYUNosdvhPgr/jJxRCbaNYgZYVu8iiJxHZcbgNI+bW/HnZUbbT
   qb98L5rkP+iP4ESxw6ZkRYpaz9cDC/Wgk25uxS6w57B7quI5PtxVJ/p/P
   Q==;
X-CSE-ConnectionGUID: T7DQUbTxQq25utHwU72liA==
X-CSE-MsgGUID: i3dAOLxySM2PxsIDa0My+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41975317"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="41975317"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 16:37:21 -0800
X-CSE-ConnectionGUID: btPjcQqWQJ2tYL9jN3w3Kw==
X-CSE-MsgGUID: cOOac3sOQmam7EdnsqXjJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="141427138"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.46])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 16:37:20 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 1/5] ndctl/namespace: avoid integer overflow in namespace validation
Date: Mon,  3 Mar 2025 16:37:07 -0800
Message-ID: <9d4b1148babc3d6e43bd5beea807729940da2404.1741047738.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1741047738.git.alison.schofield@intel.com>
References: <cover.1741047738.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

A coverity scan highlighted an integer overflow issue when testing
if the size and align parameters make sense together.

Before performing the multiplication, check that the result will not
exceed the maximimum value that an unsigned long long can hold.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 ndctl/namespace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index aa8c23a50385..bb0c2f2e28c7 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -865,9 +865,15 @@ static int validate_namespace_options(struct ndctl_region *region,
 		 * option
 		 */
 		size_align = max(units, size_align) * ways;
-
 		p->size /= size_align;
 		p->size++;
+
+		if (p->size > ULLONG_MAX / size_align) {
+			err("size overflow: %llu * %llu exceeds ULLONG_MAX\n",
+			    p->size, size_align);
+			return -EINVAL;
+		}
+
 		p->size *= size_align;
 		p->size /= units;
 		err("'--size=' must align to interleave-width: %d and alignment: %ld\n"
-- 
2.37.3

