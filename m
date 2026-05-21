Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C7E306767
	for <nvdimm@lists.linux.dev>; Thu, 21 May 2026 07:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779347903; cv=none; b=BwqCxDoOFcjfMHJCHTAYwMpIlhixIFc0etfuec9PHFZs+4hwC85Dgf4iJk7OOSNYEcJbgEUPfODg3GFJBwtnmJIIn1CJjEdgV2RAXnqlmWLw3mK7tc2QBn6n9tVImflanOc/0Vpjo50cQAeFU5yBNckZw4qS7b7fl2QZ1/exyG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779347903; c=relaxed/simple;
	bh=yd6KVH6vUWWUGg3sDMJlbIEWN9cPpXA4s/gaVmF7Auo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idQTX30BtOpj9ogD/qhfDOByNJYEqTGdfHoRwjFQ846Kj+VVfYstIIkwzVUbveQ/lY4sj/xPNrthtxWVPYpXliUwSyjCbHEH19dYAoqIOfgt6lCInqZB3UJT8s9VKIZeG3YjbD5UqhijMngfjOP50d3gbd/KZpCug3zDbaX91yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=nfCJgFXK; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="nfCJgFXK"
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id AB5FFD0926;
	Thu, 21 May 2026 07:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779347900;
	bh=AUiMwLPfpXogrlps4hAMsldk7b0PjeII3oCxeSA5XjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfCJgFXKThvMlVfobGHCKnep/wprKEp3k0Djg2QHgMi8kJQMDGP9pAQ+kTrjAqEd4
	 R8O927B73xTHAZyykoiViMyRIYkdEDodj5XzUW1cv/zADJSvhBU/EzajYdrrk6lYQf
	 mexHnZt3e1t807eH/ceFSr7vod7GS4ZfH244GmCU=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 1/4] nvdimm: Convert nvdimm_bus guard to class
Date: Thu, 21 May 2026 07:18:01 +0000
Message-ID: <d217365f59560ba0dde4291d655355c357d463c2.1779286416.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779286416.git.d@ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nvdimm_bus guard accepts NULL and skips locking when NULL is passed.
Convert from DEFINE_GUARD() to DEFINE_CLASS() + DEFINE_CLASS_IS_GUARD().

This is a preparatory change for making DEFINE_GUARD() constructors
__nonnull(). nvdimm_bus legitimately passes NULL, so it must be adjusted
to avoid a compile error.

No functional change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/nd.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b199eea3260e..18b64559664b 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -632,8 +632,11 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
 u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region);
 void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
-DEFINE_GUARD(nvdimm_bus, struct device *,
-	     if (_T) nvdimm_bus_lock(_T), if (_T) nvdimm_bus_unlock(_T));
+DEFINE_CLASS(nvdimm_bus, struct device *,
+	     if (_T) nvdimm_bus_unlock(_T),
+	     ({ if (_T) nvdimm_bus_lock(_T); _T; }),
+	     struct device *_T);
+DEFINE_CLASS_IS_GUARD(nvdimm_bus);
 
 bool is_nvdimm_bus_locked(struct device *dev);
 void nvdimm_check_and_set_ro(struct gendisk *disk);
-- 
2.53.0-Meta

