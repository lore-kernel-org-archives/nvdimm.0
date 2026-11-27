Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795797175;
	b=SPNC/vdp58MAG1XWxPfx9fwG5JnfPi3LUOlawOLaSI9JbXJ7hGXy3MENYvIoWl7r1IBu
	 J59p1r9A3lkUMDtztHig8GBSXL7DY2EyS0L5kQ22nc74uvf+pu6/tgI5BGDt5wchaV+R2
	 YGzxeRRTtoqKZEyT7uDfZW65SD8FgUcwLyd8UJyv2AbsNYYmUutdw/pYEQ29IDq5kbuYN
	 WI+5Hy9VfiArbPoxqQbPhvUGXFhiDInoli8aXE7E9+piF3QwCfIdcJ5Rebb0GsSogTl+m
	 3onQnVmrDxqSd4PAt2IEYiZQ28YA6ZLalgpYLohQQiV+XxPaBcQcw0NSeOnkp0wLMwA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797175;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Mailer:MIME-Version:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type;
	bh=BzVKtW5NHdb/sxlNHYFUIiHG+65dbsYhejickBFJVMk=;
	b=4Y7wvwZNQMOLFWfK0Uf1zP3jSXVaUqjpCbq6wl2mSpO45oC0UEQj823g6sp2a5CmpKQK
	 AlTJJq+rqcyF/71vbufs10m/t/SAywSUTG9SwT8vRBISs8hCTIG+LtFlBuGfuUkCCAjRQ
	 nFjMI7sv2L+YU8fJ1hGTODR2ro6Rh/7k+okw/Z8esNmMDsp4nVAC0lxQvp1NnkwmMg5JP
	 veNrSUDiCfOJVtcgwiF4rvDXmgkRzmEq+l7u7BeYLqMy79IEdzeEg7nRXTvipmnmRuWbh
	 Q941p5hu7Ptu85xEIBSKfALLtn/vGaLw0rTLA/ll/lix0AX8Av/NxUMZBaGCmzJY7kA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=echophase.com;
	spf=pass smtp.mailfrom=echophase.com;
	dkim=pass header.d=echophase.com header.i=@echophase.com header.a=rsa-sha256 header.s=google header.b=MH07rww3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.44
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE05606A321
	for <nvdimm@lists.linux.dev>; Fri, 27 Nov 2026 16:32:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFE05606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=echophase.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=echophase.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=echophase.com header.i=@echophase.com header.a=rsa-sha256 header.s=google header.b=MH07rww3
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-67db763cec7so8425496d50.1
        for <nvdimm@lists.linux.dev>; Fri, 27 Nov 2026 08:32:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795797173; cv=none;
        d=google.com; s=arc-20260327;
        b=sqcoY50jmFhB/ddwaqmnjpKoPMgaHUk7vvk9jMDsFwJWHcudSd7Ov9lofzDbKMGAm/
         wj9W53Z7k7O5L6V2MJJvEABv7n7xnduwYYyrwnziOCZ9Zycy45cDayemWwiFOEnHFEa/
         dRD+tnkdc0tMjE3lLthl/XJ51iH5iUrggD9eee+RN2VJO9yqcJNEVaWa3KSdovPx+u8t
         TVHNzxtPwVl121sGpCz69HvP/bC38vBfUSmZnm3lwGAvohn19tNTPYRDMn2s3FZDaeyT
         A5D/1aiqc4VsQLwQzkZQeT10c2P5KrROEkX3mZXiVOSoszUVyUxx/fYlLhFk9mbFkjb7
         14Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=BzVKtW5NHdb/sxlNHYFUIiHG+65dbsYhejickBFJVMk=;
        fh=Kfecv/AFegTqWAEsVRDljEjDYeSi06DZXjyXT9/sSc8=;
        b=Iiod7S5NsQNpQ1kA2WwtvepQHKkvlQzfxnUuNxryRlIto1RjBQn71TWtpmHSow/bn0
         GSYWGvHZHCqrUo1A6MCJs3Y3cZd+6rhEHQmCs2QttOe1RlTZ3ZpleEpMRtQ6U/p9NMiZ
         IYXfOAuc6YMbhYGbpRPZAeV4P5Pa/Q8KYv2kX+cPra1JA7lqdNdNp1lAW8sedmvn/kha
         9T9fo2OyoK9c/DsLWhaHX+asa6JN+dVg04XMk608AOUyxwaW34iNPl+etaa47n/Jf0Dd
         0ExR1HXUDYazqBV7kvLsMTUK8IZBWWYw5cJEwiFdsK8R8I8VHjwUwidjT81K4ZXtECwg
         A8Qw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=echophase.com; s=google; t=1795797173; x=1796401973; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BzVKtW5NHdb/sxlNHYFUIiHG+65dbsYhejickBFJVMk=;
        b=MH07rww3YKXpwWV2PkKLECu1Lw/Q1UIpHFGsyEZJpyOTbwM2kNW2B5ixaZ0TIQnwAz
         BbHp2BgISd2HT8pl8lYcFlPnEbVU0DdNlp4HDseYJMMcafOkwfVkcDA5PN5k3rF+CjYM
         yqm+4DCS9oQfFtx929pRAPdL4qFu5wrk4yKzqraLGmqhpEAnj7uLuksBMNUYtPXpo8mN
         L6RZmG+cpgKEoyOhPvEXYPY1k+WkGi5e5LAU7VbSX9pjnGvwNwXwJNLmQ/JKuLXaZTQW
         HuShJQYtSUeB8U0hvq3xbA2NEHq7GXLsb5KA6ZHJ4Da61+y7xxD01yMNTBgj9z633CSZ
         2vLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795797173; x=1796401973;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=BzVKtW5NHdb/sxlNHYFUIiHG+65dbsYhejickBFJVMk=;
        b=1gbVyd/i0KhZD/Paf20SNFCnsBNF4DLFVo6ACAYKk3Cn00gk3fOAorV6XUx9xv9ifZ
         hjJSESHi/PsazEx9QM7JtE6lCuznM9moc8P4g65w9KOHTICkbLHS1zgfZ9v7XBiXfWBn
         YrB2Ri6yrQIUs1afuqaDOrB5gLwdyRl0bEmHTBaGgKS0FWVxJBjkUuGxbfbTf8pPJA3Z
         cEowL0WyKcvAaT1J4iWHtKRzd7BMPk2V0Ms2Bn4EBQn9b9QYSHfJFz4FzUWkskncl9o5
         gQ92Yl1hCG56zYX59a755mRDfGEXIhgcgLGXt1YD7Z8k1o6V/nqAUMovxYgyIa74TvKL
         485g==
X-Forwarded-Encrypted: i=1; AL+hErG7yNTxS+GaJyCN5JDnNMkLe+BLxZ02DZGuM5CfzNqYv6P+Ke3MYdr119GrPKn4ThXXqZ3nSHk=@lists.linux.dev
X-Gm-Message-State: APuU4Z/2mzFWgE5SXPO/6HMGej1ODWlTS9CPz1yNosW83FtQGFwKtWA4
	YK6+frWQ59UFpSg0tkUA8qJN20Q9KHrHkHm+M1sqsefZnSc2KS+B7YnWGg2A9/QK4bwMWerQp47
	97QEXyZuAMQiKlGPq/2PHzzDIEIReS4Ko78v8IlSvDQ==
X-Gm-Gg: AZFdTZe9UHUFpzjphhfSqyi5GK2iMloStXdPS1XMq67Lx6jRKunXXpFgD6/dK9Q243u
	mPtgtNu+E4uQAHfvFms1DgTcKMoWh/gSzeyKha383juq7jkRHUxn7kMe4OyM2oD4x4EvY8Ktxwm
	YcFjz+pyyRGC89x0Rg72ZkSfplYq9/hbegiJhxPIXgLDWtT47rXfEPRF7eAgnJ40x8IxrMsnRvQ
	NvkVwPTsQ0LKvFF7/beUdJqkBtPoYZgOMhl+ZILFOj8XgI1sr7FXNTMXYl9k9Sta4ZtZR8jEuI9
	3sFukEnk1BIBfzkRs2UtrF9wYaLJatXs7itBojBc12DcG80ayoIqj3zkPMWI/J19YTFopGZDSg3
	fcVaZpfh5l8DgLNzSVLjUA5DYuHPDJY25aXVKXpevOmvZZ5VtwwYtbJ8r/yulVW9d+E5rbA==
X-Received: by 2002:a05:690e:47c7:20b0:679:ad63:6752 with SMTP id
 956f58d0204a3-67df4485df0mr6760668d50.88.1795797172525; Fri, 27 Nov 2026
 08:32:52 -0800 (PST)
Received: from 1009040482268 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 27 Nov 2026 08:32:51 -0800
From: Ramon Nogueira <ramon@echophase.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Fri, 27 Nov 2026 08:32:51 -0800
X-Gm-Features: Aa3M54rMQUzpO4yRAeN4raM6katXNjxW27MCpyzDDVBLsa2OU0HqYrWxnLZTdwk
Message-ID: <CAMM96J2Ma3gSwZAtF2S2XNWxP4wBtN5VxYRY_KQO3fqNGztrEA@mail.gmail.com>
Subject: [PATCH] fs/dax: do not replace existing shared DAX entry on read faults
To: Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Ramon Nogueira <ramon@echophase.com>
Content-Type: text/plain; charset="UTF-8"

Commit c6f0b395b211 ("fsdax,xfs: set the shared flag when file extent is
shared") replaced the write-only cow check in dax_insert_entry() with
shared = iter->iomap.flags & IOMAP_F_SHARED so that
dax_associate_entry() receives shared=true on read faults of shared
extents as well as CoW write faults.

However, unmap_mapping_pages() and XArray entry replacement were also
switched from cow to shared. As a result, whenever a filesystem sets
IOMAP_F_SHARED on DAX read faults (such as XFS on reflinked extents via
xfs_read_iomap_begin()), every read fault on an already-populated entry
zaps all mappings of this file for that range and replaces the XArray
entry with an identical one.

Two processes (or distinct VMAs) reading the same page of a reflinked
DAX file then ping-pong: each read fault unmaps the other VMA's PTE,
causing repeated page faults, XArray entry lock contention, and TLB
shootdowns. Furthermore, a PTE read fault hitting an existing shared PMD
entry unmaps and overwrites the PMD entry with a PTE-flagged entry.

Keep shared for dax_associate_entry(), and restore cow = write && shared
to gate unmap_mapping_pages(), entry replacement of existing real
entries, and PAGECACHE_TAG_TOWRITE. First read faults on empty or zero
entries still enter the insertion branch and pass shared=true to
dax_associate_entry(), while subsequent read faults leave the existing
PTE or PMD entry and other mappings intact.

Fixes: c6f0b395b211 ("fsdax,xfs: set the shared flag when file extent
is shared")
Cc: stable@vger.kernel.org # v6.2+
Signed-off-by: Ramon Nogueira <ramon@echophase.com>
---
 fs/dax.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9d161d7ef..de3931788 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1078,11 +1078,12 @@ static void *dax_insert_entry(struct xa_state
*xas, struct vm_fault *vmf,
 	bool write = iter->flags & IOMAP_WRITE;
 	bool dirty = write && !dax_fault_is_synchronous(iter, vmf->vma);
 	bool shared = iter->iomap.flags & IOMAP_F_SHARED;
+	bool cow = write && shared;

 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);

-	if (shared || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
+	if (cow || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
 		unsigned long index = xas->xa_index;
 		/* we are replacing a zero page with block mapping */
 		if (dax_is_pmd_entry(entry))
@@ -1094,7 +1095,7 @@ static void *dax_insert_entry(struct xa_state
*xas, struct vm_fault *vmf,

 	xas_reset(xas);
 	xas_lock_irq(xas);
-	if (shared || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		void *old;

 		dax_disassociate_entry(entry, mapping, false);
@@ -1102,12 +1103,13 @@ static void *dax_insert_entry(struct xa_state
*xas, struct vm_fault *vmf,
 					vmf->address, shared);

 		/*
-		 * Only swap our new entry into the page cache if the current
-		 * entry is a zero page or an empty entry.  If a normal PTE or
-		 * PMD entry is already in the cache, we leave it alone.  This
-		 * means that if we are trying to insert a PTE and the
-		 * existing entry is a PMD, we will just leave the PMD in the
-		 * tree and dirty it if necessary.
+		 * Only swap our new entry into the page cache on a CoW write
+		 * fault, or if the current entry is a zero page or an empty
+		 * entry.  If a normal PTE or PMD entry is already in the cache
+		 * on a read fault, we leave it alone.  This means that if we
+		 * are trying to insert a PTE and the existing entry is a PMD,
+		 * we will just leave the PMD in the tree and dirty it if
+		 * necessary.
 		 */
 		old = dax_lock_entry(xas, new_entry);
 		WARN_ON_ONCE(old != xa_mk_value(xa_to_value(entry) |
@@ -1120,7 +1122,7 @@ static void *dax_insert_entry(struct xa_state
*xas, struct vm_fault *vmf,
 	if (dirty)
 		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);

-	if (write && shared)
+	if (cow)
 		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);

 	xas_unlock_irq(xas);

base-commit: 9437ee8b6cf607e883b36e44bd755968daaebd48
-- 
2.54.0 (Apple Git-157)
