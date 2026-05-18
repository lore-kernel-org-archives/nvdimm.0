Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391F2372696
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 15:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779117717; cv=none; b=kyg4QalRhZ4WQVVaun/O9StYwHUaJWt9kFwENpcSbpfJ2WEtEjzqtNAJCyEFxPBDKEoxX5dtvDvpIh1rQnBCB3WQzfH2WLjLSjefLxMwywuR6AuSuuiWUzMVFEwhNizbzbCpyPOMzaMGTXDsV1nZZQRPz8Pls/bBACjj7NK1MCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779117717; c=relaxed/simple;
	bh=zcHp3n63a3QsoIUutd2eye1a+SLKUE2Vcpi8JETNKyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrUNxPJUx19+fnw+4ZKIajBgpxbIRAVxzBztRChWmvsBpSu28RCJB/bPA9YYQNdo9bgMRoxQga4k44uoWvPOYJ1iUIQfVFt4GB5PhnaRN37vZe18UypZZ9TL4qLTMqvNQNP0/5Y31Kx3aRnnuzkNqBCw+/7ALmoWC7TKTSlQ4qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=zPA0jU0R; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="zPA0jU0R"
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 19B50D073D;
	Mon, 18 May 2026 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779117709;
	bh=tmv/EHoh0GLlM8m0HYlN08j4c0ckx3H1OLOI21Bitic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPA0jU0R/m+ol8oLMrRer/bHnOl9a2bstPnmlU+1e0MAPDzqw/JxKdoHjc36juMHE
	 kf9RwbsFiX5QzNE4ZSSnsRgDCJpTfiTtRSHN0zh5aJeH0OdMjVlIWemixl1BMLSR7h
	 dTIChYA8rng8OBhmSaRffT3gMzKBp0q5Y00eFCe8=
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
Subject: [PATCH v3 1/4] nvdimm: Convert nvdimm_bus guard to class
Date: Mon, 18 May 2026 15:21:27 +0000
Message-ID: <9857a934214db3460bf55a56e152dedfa1d8bd01.1779116497.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779116497.git.d@ilvokhin.com>
References: <cover.1779116497.git.d@ilvokhin.com>
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

