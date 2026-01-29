Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com [209.85.222.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D60B35C1AB
	for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 21:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769720697; cv=none; b=ZPIw3ZGxcDQqbDyjrE6dV6ii/l/cpIUDxuNg3pZwKHgDx8bx9w/PF9g2lwleMXSXWXwHt5mb9o8B2EWMcdiHo/9CZJbtED/wI895eFGnbVJG6bSOO8suA1pMZfQ+VBVzNG/Q+MzfhO90vu08wXZPw1/eXHCqNfohpe1eZPWg9J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769720697; c=relaxed/simple;
	bh=V3jcetw4D8mN0UQEcroE5IaVeGXsJTloPdOskFdLl70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBGyi6gXGK64JLTwD8audd8xtzy9yogL5VFrkg7VIsGMLzloORLsWAzoDUDQH0f0aw+aRyMg92vvOFaqL58mqTkC2vXPMnk3ntr5S8wvHMKrbfkEjLAGOj5LyTj1y4+I8gAeeFWI5CW9+5+ZJrHtE6JlXDvraZFyAdunBPEoLAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=KRy6MFV3; arc=none smtp.client-ip=209.85.222.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="KRy6MFV3"
Received: by mail-qk1-f194.google.com with SMTP id af79cd13be357-8c52c67f64cso136995385a.0
        for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 13:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720691; x=1770325491; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFORCx/4rWXlwM5MWzZ4y2ZhtVTmicaaxzmL4W2ym48=;
        b=KRy6MFV3NDioMqWJCxQURAA3jNXkhMKXVBMh/FXdBNlmMeShgZ7h+LJNAzu5DlgYek
         SVAjuzDVhzgNayc2H4thDrK4HQa78LGJnVUOgf0ArsZuqff8MYIqXdBtvxvY0i/suoW6
         cMjBNdIwjed+g3Z53PH5ca+jnzez3FRg2CVA7JgYhSa2wOkLpjFsXV3BDme6ylfhENn4
         CQPbyHtcgRzjwaK7/icu113CqIuSZsrSJXBk6w0mVXGGRfXtB8LGRIbi9tttOUDPXa0M
         lt+mz067nkjJ10M2iDXpr2Phndq5DoxyUj0JmeplAKznwT1/i/qCIr/e1GTz8S0ssdMb
         gtfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720691; x=1770325491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jFORCx/4rWXlwM5MWzZ4y2ZhtVTmicaaxzmL4W2ym48=;
        b=ifwxeoGOFPa7lHjc9Txk27iJsRSyA8TjCWCZ4NbtotAhAmTrJby4G3rcRvekE0mDez
         gtyrnDkhMI+23+XarX9bO5qnnziwUy2JHGYek3akSAPiBiD78Pa0tgJgokQPHIWY6Ub7
         3iGcmvoKVdGARpaesrB2NIKlnEPAnVABTEwT4qKDrkCjqb4sKV/I01rx4AjPuk7H3MYt
         kLJFgv8ktKIl0H7P3AegFSw4cF7pzCV/CZ/lTAIXtiIrPBsYZTqgXcYxP1hzab3iOo0V
         yjtGP+UV6q+rOk1vOHLqPIEbzN1GsQ1A2gLDaXY9rKnMr7zu8HSk1pSwnMR63QbFJFSc
         VKcg==
X-Forwarded-Encrypted: i=1; AJvYcCWbTdMlOvDxP6wb9LIj99ZGKNUUfC45z9j8Vcr5TkWNn8oiS6lC1cD4TFMjb/+o1vAuWz03fAg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJvv0gexaqpMW8lFoC9DqnXDb/ZIrTDF7u+DCCixtpGrRNarZv
	Ws2Z2WLjJUN4Rt1X254p3b+MHmloOoYnQUIPVDUHMuVwcM2oyOC9OVxytQd+eZFxwsQQ9vsVS4m
	dXcebklvpPQ==
X-Gm-Gg: AZuq6aKmVkmKkd0Ct0fRK8vJOPv3RPABtG4kZdcG83mddEg/fm2HvVMnLMPV52UK0aH
	rcnclSy6ZSSgmtXS3mF0FvprrKg705Ik2zLxdlib/DaaxxoRTNFgaEdr4fnEM7ZGKtqgFdBWg99
	RnIEC1FL9qzqy4JOAvDSefv5l5sb5x7NrG7BwxDntV9H8XOeJDBhWqdiY7chCcajf3pzQ4mhvlR
	88lnwawOCg9Zn2xwQoX+v/dN49fEv1SX4KKqEN0/4zU7tXs+KRvObDx9kSQ6Rd7g53JydCHl/K5
	19yOGPnGkBijnfvw3rrJC1R6fNH90KzI3zzgKWX2vtdsgOn8QqrtW/xpZwjI2yQrWJnPO1lvsQF
	4mowd2tPZ9kb0FffS9BWWcMON0khWHcIT2AiJhlHPIh5uSP7mzcioNawY9ExDuUvnGhjjN0a+bt
	keCBO+I5FaEY8WDWug+f5xaZuOTWYDiSQACz3ofvLjNTR2koYWnpkJy3aB2piDH4PIQFxcMVvBv
	5U=
X-Received: by 2002:a05:620a:298d:b0:8c5:391f:1db7 with SMTP id af79cd13be357-8c9eb3119c3mr144724885a.64.1769720690713;
        Thu, 29 Jan 2026 13:04:50 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:04:50 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH 1/9] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Thu, 29 Jan 2026 16:04:34 -0500
Message-ID: <20260129210442.3951412-2-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.
This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable.

No functional change.

Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bc805029da51..87796b617d9e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	int *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1578,8 +1580,12 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+	if (mhp_get_default_online_type() != MMOP_OFFLINE) {
+		int online_type = mhp_get_default_online_type();
+
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
+	}
 
 	return ret;
 error:
-- 
2.52.0

