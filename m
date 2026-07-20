Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7969847DF91
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576118; cv=none; b=D7agKnvyMI3QOewY69bRUPLmaCxuCUITRr0ZGs42TpT/sDoMrnSjFFQWUtpJpytpWrU9lmh7CbN+4k/YUo0Xn6Qm20d0FE8x0PVR2xO5fueyhg281tOJKQHHJl6y4HiXcDlVLHzjj5C0i8TTKigrPy9nhbbg4bARyclOMZLBx1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576118; c=relaxed/simple;
	bh=rQ3ZLRwttPY5U7qx79TyOlCHcsHd1SWTIks/cm1EO0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLpbaZEY9CTlsIevuSCIlt5lQNzJZSCMUZju3JvQkpSBiPlF/DX8R1KYl53vfwR271KPihycXy7uS/EyKx2I3nNuYkUewmyq+yD2tJTkYTgUY4BiUMYQzI6mlmIeYYQL8+srRP3AqfDPGoVNArqEgkg6jNXQA9eyTx2RziG+9Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=mhirHceG; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="mhirHceG"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92eafc94c9cso824373285a.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576113; x=1785180913; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dXwJlI/llosQi30lLS1O2+gV7rtKvgDC66cTY4z3y4o=;
        b=mhirHceGDm8cngo62rI0fvr5camhq+mfCWDi3kYtN8gwv0GmXuXMwQQHHDo64wWecm
         JZPXySomncMpJ/sbKB0lRITX0kX5m4JrzYwBdHlfkSJT3ujS86/6+eiyebla6DSLz9gt
         tE/IxR1eypHiGjVrEgJh3ob4hEHzvSL9B6V3KtsjH1kpmQhtaJnYFXzkL8TAbnHvhfvP
         1YDJB9am6qAhDBwzDC2H8dlChxZg3DTuFonICjoq/sKxq+Tfgq/6Ajo4xdjOA3MywQDN
         fv+DSV64QInshIrzYK6RqbD06TC45BH+6R0LaL2lSOPPysfLl3wa7a+NyxIl2XAmeaDi
         /ujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576113; x=1785180913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dXwJlI/llosQi30lLS1O2+gV7rtKvgDC66cTY4z3y4o=;
        b=eAvP66QGSpLofh1NMsEQI9iAwamW7pG/ClwiUrYxIaoCAWCiOvROcSccb1cIuoPGdB
         Z+3WNccq+2VhK5/z5pr/MfUoYdNRMOL923cyjHGDpaQLhTY+CQ3c7TRogwdK+otoKuHS
         rrHfDr7SssUcrhuY8LVkehpsCmTDCMVf+YBlqzdARY28pxrnosiNJygOQRPa0Ge1CKVa
         W3S7jkHqxzT4y94K58fMX5Kml1SRvQvH9Z8H13Q+/L77BkIDxMXChqacfc/ohHFT4Tbo
         rAF62S1o4aoF5WneTZ/EAnHQMZSz02AwfBdDgtm6CQsO9WtI9kppTCi4Z+sVCCxZPU2Z
         SoRg==
X-Forwarded-Encrypted: i=1; AHgh+Rodd9RdTomLaaa4iE1q8qoQHeB5y4LFZ0WBEL5feztcodPFwsMr4wK4iOwfWRDDqqrfXx1M8mI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwidJ49Kk8+hZAxKQeeAHdhzSHXXb65UbzK9g6/BcUkOuV6qD7d
	yosH7X/Gdb4bg6ttmT0hgeKAhHsHVFZVPS7nYEOZQD7RfbyKN3L9rjWv2NhTGxFAq3M=
X-Gm-Gg: AfdE7cmTPqvJM9ugYAGQ77VSuWHC+YZ+gyNwO7eeLBETbp7tvzlfDcSh2GbziOmYphv
	XX0QrJFtsx+afH7wcX81oaoAbvBuLSYyILwi2JdGmJ8WfabcLayrRAzFehFUy3D4glK76fUJg0x
	ggdNaoWwDhi/8jJOUwfVNTG6w5jJnzKFv5/V4w8QL+t7anN0S2EwoTDWcutVyCT5/H6UwYvWbpm
	6DrdOI9SJwxvtqvT6+1lh13U4MvQK9mC2W2THDLZvzCMAmdmMGtVtqw9u+N29OPCJuXvRCXNPkd
	lbsYdGQKQWJr6xa41C2xGb0oU6A44eGfoJJPC3LUforhcbYnyaH2iEi4mws030XGvjwElZJvUoC
	R2S+4919R98cm0hlZ7SDCWEEx7Qv4a2OLc8vGOludypNuFQoyN4FUz7hJoAeyHl+esS1mH5zYS5
	Jj/a6FZT20jxOiANs5oxwT0FXdH1+BAtjvv7b6drZM1x2HSE69zxkzJG+1+XhR+Hs=
X-Received: by 2002:a05:620a:45a4:b0:930:af44:c3f6 with SMTP id af79cd13be357-930b416db87mr1543521885a.43.1784576112837;
        Mon, 20 Jul 2026 12:35:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:12 -0700 (PDT)
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
Subject: [PATCH v5 13/36] mm/mempolicy: disallow NUMA Balancing prot_none on private nodes
Date: Mon, 20 Jul 2026 15:34:07 -0400
Message-ID: <20260720193431.3841992-14-gourry@gourry.net>
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

Skip private node memory the same way zone device memory is
skipped, since private nodes do not presently support migration.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 8e8763f6e5f5b..2b76c57a460c9 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -845,7 +845,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 {
 	int nid;
 
-	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
+	if (!folio || folio_is_private_managed(folio) || folio_test_ksm(folio))
 		return false;
 
 	/* Also skip shared copy-on-write folios */
-- 
2.53.0-Meta

