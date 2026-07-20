Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2320481AA0
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576130; cv=none; b=Ovt3AQUxpOSdPXGX4Xs3idNYbqASEVq5OoH708+kEVcm/7+CZWd/Ca+dx2hSYhmwvnfKPq4Bv1NCv+yFuUTqcapR8Oi2/U/ktlFxQlc9Gcsr8fv15Z8qckAQvcopLuA0yBe9as1oCYeQ9e90aqOpUnPn9Hv44aSpHJf60RQT88g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576130; c=relaxed/simple;
	bh=di7fIfxF7ozb/zDn5Ysl3z+j036+4RO+ucFlAFRHfuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUajEhwSvzjNhsIFOIqJHp+J3IV1kZbWSOe1VIH30JXd9p5aP6xePLgsqS7jC/FU+jZwOxzkTErnRmk4x4h+iQVLeTgOQVRve8wVRJvEkWTnUCEgr7Ucq76gAN8fymUdREYCVC3WlvWtKosO85dAarbsIkb4mdCd6VLtaNZbreQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=mgv9lF8Y; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="mgv9lF8Y"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e602d2c0fso380134085a.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576125; x=1785180925; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wWSndD15nfA3ulYoFeibVziNkAccxURrSPvFkTAURcI=;
        b=mgv9lF8YrdYa7V+fFbzXjCGUw7kfiQ+I0GJP+9yJp8btQxZWPdMeddOECMua8/sK/I
         xBvlpTKSGQwEHaKZ2KArZFMZdfUyfx7DAl7sIyD2vSK3G8CwJF44udu0hn+hb0P8LMoM
         jJTkT9rPOUAQNQfFS4Uk4DYC6Zvv9MW1heFFzP7wTwD7dwLYGbdpyVqPXs+jjsIX5jn8
         xZUh8qts+1NFYIab3k+utuCDB3nY4H2TwwaKfBjZX6cb00YMSEzkJv96x9WtiCHzJ3p8
         5K0rFTVHseVMgvEzrozNE48Ba5hVgylpnyU41Gzd8Lbu5bqZE04RtQJmofkzExmcx416
         r60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576125; x=1785180925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wWSndD15nfA3ulYoFeibVziNkAccxURrSPvFkTAURcI=;
        b=ByBeuPiarRluSiF+sbXr6P550Em/RY36M8w7WVFGJ4qXEad0zBA2raTlMylwzeuYDr
         FEwae6StC/vvQf/B4/nopNXg268x5C9J7jPal+AoKOeRaNLNp0p6osfXXSE2Q8X3idkj
         pr/JtQxnhacz/j4Utj2HrS3Fvbyi6TzG3BQLJaxv07E6uH6QRWrsedzBLDrNRuXtJH6n
         u2VUcIVmGeH061Rhr/Do4dxzK/x7sqVeMvV7VCf6jA7O0h/PL9qImeWjkckDpN/rB29t
         heW6sqeVq/cvbOgt0pEnyKIvSnZ8FLoNcUk7Hv3ebsMfz42jkcuqrENICzfIeWcnoghj
         qQAQ==
X-Forwarded-Encrypted: i=1; AHgh+RradsRlJefWlCQ2/axk8VH9rf55GmwKKPwILepmDNAXP9mNwCg2EKTSCnBiN55QZwsjEua3De0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDSa3zLwMtYhrqvpek4AFHQMzSXCSy3U0sNwM2zwGKtPcRyvnU
	UCthb/UTPP8rSSlsbVIoAzZsPYZ6j9ZUAaEeo831MqYOV9JsaT4h3h723QAuYTmAAvo=
X-Gm-Gg: AfdE7ckEx/MmlMaR3zsvDotPieyW/SrbROu6JAjqOSrN+axLvMEy7kgrXRSaT6/PTSU
	d9NbXvuV5eEQ2z/WNM8mp4oavJnU1EyQxjssGgOsYwjMy9nAjD64DSDYfSjjYJX/uJgz94Yf+jo
	8O+NTvKzSzj9FfOHI+ZpaYoGYx2/hzXAssRPD0IaRrOz1UqgAnCOZRW6wEetBUW5m5O+7AHEiJV
	y5BXCG4/a/J8Plslz6voPm4UERcj50BtmM9LNxvp6OTO2aIfdFv6JDjfw0W8CjPeUcobqPpTR5r
	X30jYDZWOfsLUdEuU6rSTUKYI90NWRjp37+JZqavABDWDkpZAsrQO9aeK8u8MFEuUY8tp9H86Jb
	qDrfaTrXbvAWx/cEibrw25Mt1cOHaRmMBjiRQVdrAOKUkxEjialX5mKZPSqYFREnzgk9ODQtXBR
	51wJyNKpNHKb8JZONnh6ralbSqf9KyhIdCj8E7eRB9O0zV/08bwjLXGTM77dCTnRI=
X-Received: by 2002:a05:620a:2913:b0:92e:f2cf:56f9 with SMTP id af79cd13be357-930b4830467mr1569223785a.9.1784576125333;
        Mon, 20 Jul 2026 12:35:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:24 -0700 (PDT)
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
Subject: [PATCH v5 18/36] mm/gup: disallow longterm pin of private node folios
Date: Mon, 20 Jul 2026 15:34:12 -0400
Message-ID: <20260720193431.3841992-19-gourry@gourry.net>
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

FOLL_LONGTERM on a N_MEMORY_PRIVATE node folio is wrong both ways the
GUP longterm path resolves it:

   a ZONE_NORMAL folio would be pinned in place
   a ZONE_MOVABLE folio would be migrated off first

A private node folio should do neither - the pin should fail in place.

Add folio_longterm_pin_forbidden() (true for any private node folio) and
reject such a pin in check_and_migrate_movable_pages_or_folios() before
any isolation, so nothing is migrated.

The gup-fast path defers a private folio to the slow path via
folio_allows_longterm_pin().

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/gup.c      | 27 +++++++++++++++++++++++++--
 mm/internal.h | 25 +++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 1d32e9a3dc79c..a7d4de223785c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -547,10 +547,10 @@ static struct folio *try_grab_folio_fast(struct page *page, int refs,
 	/*
 	 * Can't do FOLL_LONGTERM + FOLL_PIN gup fast path if not in a
 	 * right zone, so fail and let the caller fall back to the slow
-	 * path.
+	 * path.  Fail for private-node folios here so slow path rejects.
 	 */
 	if (unlikely((flags & FOLL_LONGTERM) &&
-		     !folio_is_longterm_pinnable(folio))) {
+		     !folio_allows_longterm_pin(folio))) {
 		folio_put_refs(folio, refs);
 		return NULL;
 	}
@@ -2389,12 +2389,35 @@ migrate_longterm_unpinnable_folios(struct list_head *movable_folio_list,
 	return ret;
 }
 
+/*
+ * True if any folio sits on a private node whose folios may not be longterm
+ * pinned.  Such folios can neither be pinned nor migrated, so the whole pin
+ * must fail before migration.  Checked before any isolation occurs.
+ */
+static bool pofs_has_ltpin_forbidden(struct pages_or_folios *pofs)
+{
+	struct folio *folio;
+	long i = 0;
+
+	for (folio = pofs_get_folio(pofs, i); folio;
+	     folio = pofs_next_folio(folio, pofs, &i)) {
+		if (folio_longterm_pin_forbidden(folio))
+			return true;
+	}
+	return false;
+}
+
 static long
 check_and_migrate_movable_pages_or_folios(struct pages_or_folios *pofs)
 {
 	LIST_HEAD(movable_folio_list);
 	unsigned long collected;
 
+	if (pofs_has_ltpin_forbidden(pofs)) {
+		pofs_unpin(pofs);
+		return -EFAULT;
+	}
+
 	collected = collect_longterm_unpinnable_folios(&movable_folio_list,
 						       pofs);
 	if (!collected)
diff --git a/mm/internal.h b/mm/internal.h
index cb9f4a8342e32..85c460296cea1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -110,6 +110,31 @@ static inline bool page_is_private_managed(struct page *page)
 	return folio_is_private_managed(page_folio(page));
 }
 
+/*
+ * folio_allows_longterm_pin() - may this folio be long-term GUP-pinned?
+ *
+ * checks folio_is_longterm_pinnable() rules plus private node permissions.
+ * private node permission is checked here to resolve circular header
+ * dependencies in folio_is_longterm_pinnable.
+ */
+static inline bool folio_allows_longterm_pin(struct folio *folio)
+{
+	return folio_is_longterm_pinnable(folio) &&
+	       !folio_is_private_node(folio);
+}
+
+/*
+ * folio_longterm_pin_forbidden() - must a longterm pin of this folio fail
+ * outright (neither pinned in place nor migrated off the node)?
+ *
+ * True for any folio on a private node: such memory can be neither pinned
+ * nor migrated, so the pin must be rejected with the folio left in place.
+ */
+static inline bool folio_longterm_pin_forbidden(struct folio *folio)
+{
+	return folio_is_private_node(folio);
+}
+
 /*
  * Maintains state across a page table move. The operation assumes both source
  * and destination VMAs already exist and are specified by the user.
-- 
2.53.0-Meta

