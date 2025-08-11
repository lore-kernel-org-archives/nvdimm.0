Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340E02D46B2
	for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 11:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754911614; cv=none; b=YIQYlowskm8G0En3W7ARDOb6JJkScMIrZUBFJ6fV6H2WYUVXu4bFIE7kbxwxEPIwUQmk345L4lKUC3yOOTqK2Gg9GWxjAVi3FXe/q6bHoFc7GphvOwUWbqc9+Jlx8jhMLb/qiHssKmaIzh/RtnFEjkRMBXkBvHbHbuRwk8hurs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754911614; c=relaxed/simple;
	bh=5bTAXo4Wnbsgm2C4LriAvbtI/44w1uQqyTmK51I8pv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=n+LnqeU4NFG7Rn/kHpPSHIZv09qW5sFmAeZggCoK3hwb0LinahxlILC1hzzWmNB9avJaMb5qI/d2KfU9HUcBqDy5dndW1GufPhJs2u2DPiUhxUBwRgzuu0S7NnWXsl/JTzP8bxG///AQEcjrKC54cpQr9HkvaipOu0mFVsG09eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dw7hYDSn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dw7hYDSn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UJDg4sW92zbLWKqBjb1tVZssT9gBBixv5gdvUlii8Zs=;
	b=Dw7hYDSn4ECdNdnpa6TzGzoX5SH1fo2SKgFssJItHmYvklx91CAYj5o+2ABXjcY/u4gWDD
	d6CQLcHShyJgVUl9k0eMRfsfMmliaFqWdYBFuyf75U07P62r875NBLQI2a1KovrvpTdNHg
	zexyAy+1g/yo9F4j1QYoIm34b+RnVVE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-srwvhxR3OIq_L7AxHfjX5w-1; Mon, 11 Aug 2025 07:26:51 -0400
X-MC-Unique: srwvhxR3OIq_L7AxHfjX5w-1
X-Mimecast-MFC-AGG-ID: srwvhxR3OIq_L7AxHfjX5w_1754911610
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459d7da3647so36284085e9.0
        for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 04:26:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911610; x=1755516410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UJDg4sW92zbLWKqBjb1tVZssT9gBBixv5gdvUlii8Zs=;
        b=jBFjGQHH0UpK91YS6F1atT3WLpCBIDChbksxLJ5WI991pSpLvc+Sga5YrOh/ikfpSZ
         pO64xRKk+wY9d6NYajjvZwpNE1B8tsUicZbc6MaAVkCd8Nldj0qGEpURin6KPerZdrwk
         ToooMS+UY3B3qhCneWRZGwHnlyIRaEb9Ul8MFr8j3/KrMKS/05oTy+IGp2DG0L5RnpYA
         AjmC6iOgCF+b1EpdA/LtUkF1aAzPHfTw8EoRMiX6AxeKZ92EbN6AUHvn4V6L/xAG7EAF
         JctJjvtDX6XvRz90mw8LuUxv8tOqlpsuy6KUb9X1ZzuyJOm6/00xAWDgmDZ6gUP300sL
         QXvg==
X-Forwarded-Encrypted: i=1; AJvYcCUimNZITwaZ1Y+OMWj4dK6F+BSO2pwEs+XY/C+5ibcd7EmqiH58Y4qJIopafirt3uxYs74VqsA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2QcbSYqYqARHwezbE3cB5aVUjUA3AGpoRbJWPq8MEI0P43e+g
	qj0r6veLd+/5KdKIb6vsmtuinD1djcstkRogu59sDOcojFqLmJMTpnmCaYd39QBb1G6B2Psnce/
	05sVMjy2/x6CwCjBribRppQcwsOA+HDytqJVqRshbPsUHMcmJ5XXTJcGs6w==
X-Gm-Gg: ASbGncsGBRuhI4d0JlEtnW0WKgMkyQN9uRdtDEzNoZx5q7gcd1vZvQxuns/ey7UfWzP
	hg2ZazxZZBLz97a4MDAObuBLPV8u46l9X02d42XSlbItmvvJRNv8PNZkIz1/9QqezRkfVIxUHis
	+F1UJx/wFgTJk6LuTxCsmfpYP1Cgx++hlEOoEEsg1gjhcLYC815wm/aiBllU1dcEGbsubE6hMkW
	uGOvB+jriytlH5QXe9CUq9zCzB+wdRAad8FB62HdBB6zizSFdgTss93CG+UZaIUzeh7G/dquRmy
	HRp/Up4uV2/wvfw4iwyVPwE6Sk5tSOeTKunvg2afUTNgwnEnQ/nKuaqLdpx4aDk9fT6OCAqTQTY
	4ui1+TqYNQBjojfPjbA9ZWJoF
X-Received: by 2002:a05:6000:2010:b0:3b7:9d83:5104 with SMTP id ffacd0b85a97d-3b900b83ce4mr10356639f8f.51.1754911610084;
        Mon, 11 Aug 2025 04:26:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH28XXBuV6P4eMmACbygagN9E2w90dcNlvtCQwFebmNkdYsSnJof6QrfGHsOh8VfCIdvok2gg==
X-Received: by 2002:a05:6000:2010:b0:3b7:9d83:5104 with SMTP id ffacd0b85a97d-3b900b83ce4mr10356583f8f.51.1754911609552;
        Mon, 11 Aug 2025 04:26:49 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3bf93dsm40408983f8f.27.2025.08.11.04.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:48 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 06/11] powerpc/ptdump: rename "struct pgtable_level" to "struct ptdump_pglevel"
Date: Mon, 11 Aug 2025 13:26:26 +0200
Message-ID: <20250811112631.759341-7-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WYjkc4Uh6wEbf2lTonhMPp6rHYRTQ4fmFVe6DLnyeZc_1754911610
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

We want to make use of "pgtable_level" for an enum in core-mm. Other
architectures seem to call "struct pgtable_level" either:
* "struct pg_level" when not exposed in a header (riscv, arm)
* "struct ptdump_pg_level" when expose in a header (arm64)

So let's follow what arm64 does.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/powerpc/mm/ptdump/8xx.c      | 2 +-
 arch/powerpc/mm/ptdump/book3s64.c | 2 +-
 arch/powerpc/mm/ptdump/ptdump.h   | 4 ++--
 arch/powerpc/mm/ptdump/shared.c   | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/mm/ptdump/8xx.c b/arch/powerpc/mm/ptdump/8xx.c
index b5c79b11ea3c2..4ca9cf7a90c9e 100644
--- a/arch/powerpc/mm/ptdump/8xx.c
+++ b/arch/powerpc/mm/ptdump/8xx.c
@@ -69,7 +69,7 @@ static const struct flag_info flag_array[] = {
 	}
 };
 
-struct pgtable_level pg_level[5] = {
+struct ptdump_pg_level pg_level[5] = {
 	{ /* pgd */
 		.flag	= flag_array,
 		.num	= ARRAY_SIZE(flag_array),
diff --git a/arch/powerpc/mm/ptdump/book3s64.c b/arch/powerpc/mm/ptdump/book3s64.c
index 5ad92d9dc5d10..6b2da9241d4c4 100644
--- a/arch/powerpc/mm/ptdump/book3s64.c
+++ b/arch/powerpc/mm/ptdump/book3s64.c
@@ -102,7 +102,7 @@ static const struct flag_info flag_array[] = {
 	}
 };
 
-struct pgtable_level pg_level[5] = {
+struct ptdump_pg_level pg_level[5] = {
 	{ /* pgd */
 		.flag	= flag_array,
 		.num	= ARRAY_SIZE(flag_array),
diff --git a/arch/powerpc/mm/ptdump/ptdump.h b/arch/powerpc/mm/ptdump/ptdump.h
index 154efae96ae09..4232aa4b57eae 100644
--- a/arch/powerpc/mm/ptdump/ptdump.h
+++ b/arch/powerpc/mm/ptdump/ptdump.h
@@ -11,12 +11,12 @@ struct flag_info {
 	int		shift;
 };
 
-struct pgtable_level {
+struct ptdump_pg_level {
 	const struct flag_info *flag;
 	size_t num;
 	u64 mask;
 };
 
-extern struct pgtable_level pg_level[5];
+extern struct ptdump_pg_level pg_level[5];
 
 void pt_dump_size(struct seq_file *m, unsigned long delta);
diff --git a/arch/powerpc/mm/ptdump/shared.c b/arch/powerpc/mm/ptdump/shared.c
index 39c30c62b7ea7..58998960eb9a4 100644
--- a/arch/powerpc/mm/ptdump/shared.c
+++ b/arch/powerpc/mm/ptdump/shared.c
@@ -67,7 +67,7 @@ static const struct flag_info flag_array[] = {
 	}
 };
 
-struct pgtable_level pg_level[5] = {
+struct ptdump_pg_level pg_level[5] = {
 	{ /* pgd */
 		.flag	= flag_array,
 		.num	= ARRAY_SIZE(flag_array),
-- 
2.50.1

