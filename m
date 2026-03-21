Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B23392815
	for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774105461; cv=none; b=se5dXIeK72rJWvNCNf4EQ3SFFxyXkA7a7J2tnUCPr+SBRAuLLNGG50+JTNjCnQarbTtruQkNFbFh16D6yB95eOIN23IbKD+5cFFmXhbeKdSBciAU8mZcuNB7YMKDKbsHZCOT788TnlFlTsCjx7x5kOFdZR6sc5M3TAYmICrfWdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774105461; c=relaxed/simple;
	bh=cwLq4fYvCtZxySyHqWgZl6tJPwolVZsJKYMQbZ2gyMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJyk8u48u+sss85iffjAvpsZldZC1cgPCGJGC6sqXAELb5oYu2DBHUpeKgZTvjXGaSpp/YMRaqLQ3CWVm8KG8BJ1/0lLYhxJEersAtg6p36GWk5XXA8b9/bj9hBSgmL2/t0TgYKHmSoFXMZuu8zMwU609i6jAOrQmFMtsStAUpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=riH3+KGW; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="riH3+KGW"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5ffabb1dfbaso1684849137.3
        for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 08:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105456; x=1774710256; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8aQsutcLH43Y9NxwFlNMe1GVmyWLzH9mSMGyjSQ6t5E=;
        b=riH3+KGWeO7zQM2koNxapaC1Xqgg9Bm1xmZVVjN0OVVfCxuyQeu0yBvQZpsdlhdARx
         YgTihEWqllr8g1K/FZ4v6AouGYFu1B17qb7f6bWpK+Y+B5moN7vEfcFL6Tfv71BC8TOF
         diJkUvUAaAT/4uw66dpR58v6O3zYHvVN7kgeMS4c67U15sNQumR0fTEVKnw1jEkE/rJN
         wXilIXmBDI2mJpiASItzfDr2LNLWRjEH5TpP+dg63vq5PkN08Me1kzI3oUqFEJwx8gAi
         AxIAhWrjg3nN/b+KdUYpZGiioSqhkweWsw14wmVoLdwiGqW1aIT+3H8qrLIlysjTL5pm
         B5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105456; x=1774710256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8aQsutcLH43Y9NxwFlNMe1GVmyWLzH9mSMGyjSQ6t5E=;
        b=kMuOvYXloGpLTUdFxH7JH+KEC8CsXd2dwrb6gGCFwrTpPk5Osl8Pt5KBm650E+gcfT
         eqPXDefj5naqDVU3Wma0CgKirp/AqGBO/onJ5xD4NA1QaaHkeg+/kGai03ThB4ybSy5C
         L+3Nb+7G9HCbz1bCfAVPJsOReipRvvqnVces9qwAylsf5BWLCLAlWbWaqvzt6OFOQYik
         WgBU7ugcfphuUd88o/Stfz9NBP4Kuu6sTxzcLyKVoUSFuHNgEHwS+CpnUcMh5xNFxWN+
         vR6KxWlR+bbwr64m9m6HL7LVw+hUJhXnkI2iJJZ91ZyQkBkEf0KnMSy+T7RqvkawLTFr
         x8yQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnY5AReYytHnIuKNh7lKFDEW8WQA3ZbgCDyzE34Wsp2VOYla0999TRpdiXkFzEBBHjPV1TZjg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy13zU0Y7EpbZ6mPNXGtc5sw/swfzcVVN/JbEp+tFxhBrn0qlGI
	9iyEcuRkkgMZgzbC1FirndyuA2rcnFp2SSlhQ9IqsbAtu5rGKROYyZjOMiLek/BPKNI=
X-Gm-Gg: ATEYQzxgPTepRbJf/4Ptf6GYt4x3B62iYquM8uDFNeFu3RdcZfTkTssY72/xc2DEFXK
	H3cQ+c9kjlDPrOlQ46ZgsrFnymyD9fQAKBozTGC49CSymULCd7Z15o8+Sd6axnLNFqBeupTMROJ
	CfWYrUklIjrv448w1jihISCkT/PVnke5UahoxXlBOHsQNsxOPmb29aeiUHOOLPTwnvDmfwlcPsd
	o54HgJD8ho6gP+VXeP24097TrInF5NECcAKjRiv+jI2jCygJwjCjV72OK2UleIKAvV3RJwPqVgE
	9uxzQbGHNWKQjgFI/EBK1FGuKWBGRVWQKiH6YU1pQX4RbLBzVmUwRpAJf5wQLiYr5thinh8bpR4
	6k1ZIyLkh3GitN3r728D5zoSxr6FeXQ94k3ImXAjX3iJB2ABVLboXAlqDSRuXDP6m75/FH4ceE2
	7SjMnTj6FqMDP6BlGsn2z2/qDGlnOpzYI5XxnEF6gYdijC1m722+EzHUtulEwQelYjLKUh6Jjz4
	r0iOKE2s8TLvTQcot2fUekLDQ==
X-Received: by 2002:a05:6102:5a94:b0:5ff:fbe4:89c with SMTP id ada2fe7eead31-602aed31766mr3273670137.26.1774105456040;
        Sat, 21 Mar 2026 08:04:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:15 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 4/8] mm/memory_hotplug: export mhp_get_default_online_type
Date: Sat, 21 Mar 2026 11:04:00 -0400
Message-ID: <20260321150404.3288786-5-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
and the mhp_get_default_online_type function for hotplug use cases.

Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
the same driver code, and chose the dax_kmem path as the default driver
path - making it difficult to require hotplug as a predicate to building
the overall driver (it may break other non-hotplug use-cases).

Export mhp_get_default_online_type function to allow these drivers to
build when hotplug is disabled and still use the DAX use case.

In the built-out case we simply return MMOP_OFFLINE as it's
non-destructive.  The internal function can never return -1 either,
so we choose this to allow for defining the function with 'enum mmop'.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h | 29 +++++++++++++++++++++++++++++
 mm/memory_hotplug.c            |  1 +
 2 files changed, 30 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index e77ef3d7ff73..a8bcb36f93b8 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -6,6 +6,7 @@
 #include <linux/spinlock.h>
 #include <linux/notifier.h>
 #include <linux/bug.h>
+#include <linux/errno.h>
 
 struct page;
 struct zone;
@@ -28,6 +29,27 @@ enum mmop {
 	MMOP_ONLINE_MOVABLE,
 };
 
+/**
+ * mmop_to_str - convert memory online type to string
+ * @online_type: the MMOP_* value to convert
+ *
+ * Returns a string representation of the memory online type,
+ * suitable for sysfs output (includes trailing newline).
+ */
+static inline const char *mmop_to_str(enum mmop online_type)
+{
+	switch (online_type) {
+	case MMOP_ONLINE:
+		return "online\n";
+	case MMOP_ONLINE_KERNEL:
+		return "online_kernel\n";
+	case MMOP_ONLINE_MOVABLE:
+		return "online_movable\n";
+	default:
+		return "offline\n";
+	}
+}
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 struct page *pfn_to_online_page(unsigned long pfn);
 
@@ -221,6 +243,11 @@ static inline bool mhp_supports_memmap_on_memory(void)
 static inline void pgdat_kswapd_lock(pg_data_t *pgdat) {}
 static inline void pgdat_kswapd_unlock(pg_data_t *pgdat) {}
 static inline void pgdat_kswapd_lock_init(pg_data_t *pgdat) {}
+
+static inline int mhp_online_type_from_str(const char *str)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
 /*
@@ -316,6 +343,8 @@ extern struct zone *zone_for_pfn_range(enum mmop online_type,
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
+#else
+static inline enum mmop mhp_get_default_online_type(void) { return MMOP_OFFLINE; }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 282bf3d89613..af9a6cb5a2f9 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -240,6 +240,7 @@ enum mmop mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(enum mmop online_type)
 {
-- 
2.53.0

