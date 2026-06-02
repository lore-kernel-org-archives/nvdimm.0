Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DF3360EFA
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 07:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780384919; cv=none; b=ThWjkC/GN4O75sWNkqpMykIwpLwODIqa+eBVd9p6ov3PnEL5KiHuISakd/ghdN7VQA7jUBxB7HQuY8m/iTqsWRhmNmRLAhso3cEd4/His+GAnfNJ6V6XUgtXotRUva4PGv3CYwXhZ1MoCNLSvCvyQR8TookVnEdXRWiGwRzl4Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780384919; c=relaxed/simple;
	bh=rDf3nABXNo8vMeXp5HldaYDR5skbzeT8SXMZO6GsOxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErAONTOuNrwE7Cdqe34xzkJfo57/RSHe2VD5aefFj5Nf+jg+4NRGezi6qPoK9OT4rMVIF6bCC7k05yT6OO2V3ektra3f2/P65NE/ItOsvQyg7bKj9qSg/6zyRXK/dKLhj4Lw/160eGzU6J32LDr4QiMCR687TaJzFjOEr0czMtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=T7xBVUUF; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="T7xBVUUF"
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 885BBD0F64;
	Tue, 02 Jun 2026 07:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780384410;
	bh=lDIPRhu4eC69IHX//CJMd4ihavt8RgvIqQIf1iXGap8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7xBVUUFAUZ1XGP2Kw6qlEA5/9HEkKGDkpi3ueWDkrUHbugbWP+f5+jASUCpDetB3
	 4VhZqrAwpI1CpEaFkNI6YNWgQbT3VEsrLpJWa6QTYtlfzm0R7SkfeEpjPD4kl/4SeI
	 4lhx15kW9dsRc2+66dNtTMKze+UJipjJ5sF4pcLs=
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
Subject: [PATCH v5 2/4] genirq: Move NULL check into irqdesc_lock guard unlock expression
Date: Tue,  2 Jun 2026 07:12:51 +0000
Message-ID: <ab457810653e4356e29b2d74ba616478bd9328ad.1780064327.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780064327.git.d@ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

irqdesc_lock uses __DEFINE_UNLOCK_GUARD() directly with a custom
constructor that can set .lock to NULL.

In preparation for removing the NULL check from __DEFINE_UNLOCK_GUARD(),
move the NULL check into the irqdesc_lock unlock expression, making the
NULL handling explicit at the call site.

No functional change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 kernel/irq/internals.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 9412e57056f5..347cb333b9fe 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -171,7 +171,7 @@ void __irq_put_desc_unlock(struct irq_desc *desc, unsigned long flags, bool bus)
 
 __DEFINE_CLASS_IS_CONDITIONAL(irqdesc_lock, true);
 __DEFINE_UNLOCK_GUARD(irqdesc_lock, struct irq_desc,
-		      __irq_put_desc_unlock(_T->lock, _T->flags, _T->bus),
+		      if (_T->lock) __irq_put_desc_unlock(_T->lock, _T->flags, _T->bus),
 		      unsigned long flags; bool bus);
 
 static inline class_irqdesc_lock_t class_irqdesc_lock_constructor(unsigned int irq, bool bus,
-- 
2.53.0-Meta

