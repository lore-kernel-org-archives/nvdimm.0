Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E73B4DA547
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576172; cv=none; b=R+fU9sS/5JwaYtcYjPTj5ldVYaDZjrJm0flV1/CJKRAdx1U0n0zSuSJHYP3CXaNLFXGNWawbGH+g7kBp/r1e5cc7Px7F8Hib1onIBiQC9fvGSdONTqauwE3VFogqlFkhz/j5aemdu7zx3vwNyt6Zzbp1omk9sWuWnDwawGIPYos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576172; c=relaxed/simple;
	bh=OgLS5lz8LcFlUwT/mS8KgOm9wsHn4lmIq/hL83K2TIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIE48w5ZpRU3asUsanofkvfHvK1dBS0i03yqoKYQXAggFxvy17eu0qlzh5qiTvSw/GouUTf01seOfcwa5raHXrNHVsUXlaSiFXIpJa/E/8hO/otd/IMPajipGrM6fXvJF4nwHbVptfIEtWCHjV2UDGuBihM3X8EsNXpUihe1Uzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=GEec4Dwn; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="GEec4Dwn"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e5c9211d2so926848385a.1
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576168; x=1785180968; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BDe0EIY/cD+bqy5JmFZ8sdGZo0VCgkgte/Ch1WssJBA=;
        b=GEec4Dwn1g5sjOdkRglDF5bdnzK8SNAqhnbwU/Cm5wzOhC91TsNZMzNf+9gfFbl2pp
         60Jjxgg2S3Cikt/P8hqpl5KJXBwFWdsyQkkYvesAc5ZDyeF06fB2d/teIt6awJ24WSeP
         SgvDItpUlw5g88JmremthP0E4RyNZm5dn/yjqLu2kefbcVjqhujJXUQeQs89f9haloBn
         Gx9I3J5lkTs5Y9Ni4OG3da7r3g+mRFkJz/C/c3vY28AuQ9CsGpwzk4rB5rOX54oj8Eve
         WKU4CTd6hkbwl3FTfzLLWXkN20ZlmsdIbzahEz9ucKuvk6Wn7WzgF0A+69JgofbJIeT9
         p31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576168; x=1785180968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BDe0EIY/cD+bqy5JmFZ8sdGZo0VCgkgte/Ch1WssJBA=;
        b=lG988MKxHyCDqRkv3NB6M4YZy3I09RP0NfSJLMLcZ9Ybar3oUzT8UnWJQZFRunemyr
         B0jCJIlaixoeJ+tZWnQegiX2x6moBHYUg0XrHtlyZlYyf0BOzw0KjpMh6FBnTOY43B47
         +4FfqP33Ryh8XJmEz8m6rM6iG1Eui+Ou9SGuyyJvK3SXppNVqENHYHyBvX5NQq34Lv1H
         J9FcqXkDpk6vdU0yagyrEJA4FBq+HkV/Czo+WpdhIJZzkqaQEduclFcrc+Rv0tFQEMpz
         rq6VS6Jt1Cx4POKv83+7/BCftKyK7jDOt2XDZrZsAoemw/b83UgCVMryFKgYrmzZZaz7
         hB9A==
X-Forwarded-Encrypted: i=1; AHgh+RrwzgZeXSQGfxwPVmBP9eVvs/SUtDz7Y5E5vopL0CLSq0MMuMnjL0ML5DRdxDW/CoK0ScZsnSw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMoD6wEpEd/QmY8qJPzzGVmmZcMPek7BDr3wmOsqDpVZ+KuBvO
	v2BAhgWoRlQIocHcrGP36MpLTl9DAf1j14SyF23Aa0aQd5UzD+7KBLprzFu/zPWfi9I=
X-Gm-Gg: AfdE7ck69ZBdbUJKALXTLock89kFbCfly6yehWB72MCBwAfWWVVW9ylCLGafQqID05v
	RWO16IlaGvCzXPmwvM0w0J+Lalk0ayv+HjFwGcdSH4SKJok+Lft4+W+gYIuBUFvDuXsakD9ue6D
	02aRs7ggqUXmTGK06NN1iFW4t0Y+9Rw85EFNZFMy2WEfs80ts8Du+7w5SSqIvkTfubeTL5on5t/
	oaL6j5ARaiWSIZA331N6D2GI9vY0SEv7FLCjGUygYZ0UEcpKy99l/5JnRqXdzHyAGsdSOD/XlrT
	VP8V1CH630sODXm1Q0kAuUuwkDaleHk0ajn5W2sqz3FqAHva0A7z5Ih0wMLId4EsptmcEYRPKaR
	kEnMl3EvN1m02xT465if37au9eLYAi69stMCDzeBDQUvuvZeASVAMqHQ/NxdP/+IQibBkIiTGaA
	28pYWamDxFNiCvzYzNHImjYs68pnuQr6uLGkstM0oUPqSGf50AYifVkM4EQOo65SU=
X-Received: by 2002:a05:620a:28c7:b0:92e:c118:18b7 with SMTP id af79cd13be357-930b43c37e0mr1448114585a.86.1784576168124;
        Mon, 20 Jul 2026 12:36:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:36:07 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 34/36] mm/mempolicy: add mpol_set_shared_policy_range()
Date: Mon, 20 Jul 2026 15:34:28 -0400
Message-ID: <20260720193431.3841992-35-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mpol_set_shared_policy() installs a policy over a VMA's page-offset
range, which is the only programmatic way to populate an inode's
shared policy after init.

Two limitations make it unusable for binding an entire backing inode
from in-kernel code:

  - It requires a VMA, so it cannot cover unmapped offsets.
    (e.g. unmapped file folios faulted by pagecache)

  - mpol_shared_policy_init(), the only no-VMA installer, reconstructs
    the policy from mpol->w.user_nodemask.  That field is only populated
    for static/relative or mount-string policies.

    a policy built programmatically (e.g. by mpol_bind_node()) leaves it
    empty and stores w.cpuset_mems_allowed instead, so _init mangles it.

Add mpol_set_shared_policy_range(), which installs an already-built,
fully contextualised policy verbatim over an arbitrary [start, end)
page range with no VMA.

Reimplement mpol_set_shared_policy() as a thin wrapper that derives
the range from the VMA, so both share a single underlying path.

Suggested-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-8
---
 include/linux/mempolicy.h |  2 ++
 mm/mempolicy.c            | 35 +++++++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 715951a5b03c1..1348e9f5f2cf9 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -125,6 +125,8 @@ int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst);
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol);
 int mpol_set_shared_policy(struct shared_policy *sp,
 			   struct vm_area_struct *vma, struct mempolicy *mpol);
+int mpol_set_shared_policy_range(struct shared_policy *sp, pgoff_t start,
+				 pgoff_t end, struct mempolicy *mpol);
 void mpol_free_shared_policy(struct shared_policy *sp);
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 					    pgoff_t idx);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4daba81fff7c7..23c4c25097450 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3424,24 +3424,47 @@ void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 }
 EXPORT_SYMBOL_FOR_MODULES(mpol_shared_policy_init, "kvm");
 
-int mpol_set_shared_policy(struct shared_policy *sp,
-			struct vm_area_struct *vma, struct mempolicy *pol)
+/**
+ * mpol_set_shared_policy_range - install @pol over [@start, @end) of @sp
+ * @sp:    the shared policy tree
+ * @start: first page offset (inclusive)
+ * @end:   last page offset (exclusive)
+ * @pol:   a fully-built, validated policy, or NULL to clear the range
+ *
+ * Installs @pol over the given range, replacing any overlapping policy.
+ * @sp takes its own reference, the caller retains its reference on @pol.
+ *
+ * The policy is not reconstructed, so the policy is preserved exactly.
+ *
+ * Unlike mpol_set_shared_policy(), no VMA is required, so a range that
+ * is never mapped into a VMA can be covered, including the whole file.
+ *
+ * Return: 0 on success, -ENOMEM on allocation failure.
+ */
+int mpol_set_shared_policy_range(struct shared_policy *sp, pgoff_t start,
+				 pgoff_t end, struct mempolicy *pol)
 {
-	const pgoff_t pgoff = vma_start_pgoff(vma);
-	const pgoff_t pgoff_end = vma_end_pgoff(vma);
 	struct sp_node *new = NULL;
 	int err;
 
 	if (pol) {
-		new = sp_alloc(pgoff, pgoff_end, pol);
+		new = sp_alloc(start, end, pol);
 		if (!new)
 			return -ENOMEM;
 	}
-	err = shared_policy_replace(sp, pgoff, pgoff_end, new);
+	err = shared_policy_replace(sp, start, end, new);
 	if (err && new)
 		sp_free(new);
 	return err;
 }
+EXPORT_SYMBOL_FOR_MODULES(mpol_set_shared_policy_range, "kvm");
+
+int mpol_set_shared_policy(struct shared_policy *sp,
+			struct vm_area_struct *vma, struct mempolicy *pol)
+{
+	return mpol_set_shared_policy_range(sp, vma->vm_pgoff,
+					   vma->vm_pgoff + vma_pages(vma), pol);
+}
 EXPORT_SYMBOL_FOR_MODULES(mpol_set_shared_policy, "kvm");
 
 /* Free a backing policy store on inode delete. */
-- 
2.53.0-Meta

