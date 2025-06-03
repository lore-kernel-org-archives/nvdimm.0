Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807A82288F9
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 21:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748985404; cv=none; b=OcG35etEAq7qf0AKQ4vRGjo7WPl0sDaf/d6aBtWwGz/t+cO03SLYVENnnTH3fPHXNQah+bHzSKNDdiXKKoKKsvYaLI8SSiOkjL4mRx8l0JYQe5DosH/MhCxdggxHq6q3X95tp7mNlogdC0oqWe1H97h1xuS01Bvx4ZYgPassp4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748985404; c=relaxed/simple;
	bh=XoGH0h2IJWjwbQWxYS/rtN7yH92g+3vhD4JjuLqqPnw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=a4vUp3RJEIxf9oksiM2sVTWKgvS6wiMZQFXoOAPgCQ1yquMExedL1rxTyUDAUjafMzn4DFwZA85uGqS579v0IuvecwzGtXrFLl4yis7vfbk+/8rCQFAyE0ToZxxXix+oQJZQya3fVlKGwMsDqkRPQoSi/i6hbnnebd+T9m9elVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hyClcddk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hyClcddk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748985401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=314MrEBwr4k+CUpKTmx4sCu/ScFWOUTeM6rdnwbV6hM=;
	b=hyClcddkVtGzi6PSC4yUzM3n9yn0Ey/DkNK/KEhmlNRUPMX/e+HabHHj2e45v2k2czAzhR
	kQApH0smjztfJ3OB1NAsMg6TFwC5kfwPqwRo2aR9e90IGuXER5MVRIDgacNYAkZqjqefUw
	EvG1JS6Og+k/Z4viAsWUM/2T5QMmzdk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-m4PYLs46Mb-iMbGwM5MVeg-1; Tue, 03 Jun 2025 17:16:38 -0400
X-MC-Unique: m4PYLs46Mb-iMbGwM5MVeg-1
X-Mimecast-MFC-AGG-ID: m4PYLs46Mb-iMbGwM5MVeg_1748985397
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451e24dfe1dso13478255e9.0
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 14:16:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748985397; x=1749590197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=314MrEBwr4k+CUpKTmx4sCu/ScFWOUTeM6rdnwbV6hM=;
        b=Who6zgeV4pe1XXtuu3IlAoabIYb7Y3dYzfMeregMTgxm9lqs1RZTxgvjYP+wwPoyTk
         DCdDCTlfd1KkuPhzT9ZjM0cm2mz7akvdDGZI3HgCOlYPurhZ1tuLIIAg/UNNBF+INXcA
         JcVoWCc3K0be5NsKkw9XCOqbol8Gz2Wg9YnmviF8Nyk8Y+kT1ueo6KnO9CYarfqjqn6L
         CKKeLyG+0oPT2yqLqZWy8IQz2+Au9QbLtujwPrrB3gyZlQ+py0hC1/yGjVuYFGlVyuYQ
         tbYYb80I6uhXdjeDR5TKvn3ku+jCRLj04wZykMY4YrwRV6+zk/QYHrjoump+yABkIbpa
         SXnw==
X-Forwarded-Encrypted: i=1; AJvYcCXwVihUMlAdbtwJZkx9YSYMn0X3zkKmzFa/iFRK1hpIJrKPLHfUdyCazdochv7NKPL1aijPdSU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdyZH2Ckjeu33kxQZcM4xF0AUWk3bQLcqTPYPVcfe9qAAegjsK
	thjYhMtVck9txVeNFpm+YchLqBxJWuxJ9gsqDXbZtGtNobf7ehbW5yjN/2nU2Au3j/pcgFh52k9
	WnggZxKH2ShqKf3YHRG703e+rdAgSegZxaank+BZ9Lo9ON9m4C0WXnYzTfQ==
X-Gm-Gg: ASbGncu0jREWTnz5QogXcNWMsCbl3qOuqtMBVxmtAOFtxvkEXucnbERbtr5uRs4KL8K
	R3831XWP2EcmVRD6PJIKAmW4TJVs1L0mhrO14Lr++8mY0O8wkQZ25RQuIPn/TJWQM2fhavinpxt
	/qRettXwADKkK3o6Mby8ZS08WHOGtPnWXKANWbMi7+T6JgzDsG25J1FOq7I0eb8Fm4H2cJECj9c
	xDb3rYCUpVehwv8551O9pdZXFZ0eL7vx5BRQ1GH70SHjZ11JSUSrEIxenKysqfnKeQTuXalLT06
	HBB1+pf13yf8TsNd4l49HLasUyHcjyIzkY9ULWEL2/uF8cmbDBarFhCPDDppgcUotHGE/k8y1Sl
	we8q8KpA=
X-Received: by 2002:a05:6000:1a8a:b0:3a4:f379:65c4 with SMTP id ffacd0b85a97d-3a51d96b480mr197096f8f.45.1748985397106;
        Tue, 03 Jun 2025 14:16:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8kkzJnQJD0YMtEENpld5wUwUCJ3Dmqv/cCnKp6Z6c5loiuHX+OBpCRrySLipJK13BBXeN7A==
X-Received: by 2002:a05:6000:1a8a:b0:3a4:f379:65c4 with SMTP id ffacd0b85a97d-3a51d96b480mr197074f8f.45.1748985396684;
        Tue, 03 Jun 2025 14:16:36 -0700 (PDT)
Received: from localhost (p200300d82f0df000eec92b8d4913f32a.dip0.t-ipconnect.de. [2003:d8:2f0d:f000:eec9:2b8d:4913:f32a])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a4f009fd7csm19308738f8f.88.2025.06.03.14.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 14:16:36 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
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
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v1 0/2] mm/huge_memory: don't mark refcounted pages special in vmf_insert_folio_*()
Date: Tue,  3 Jun 2025 23:16:32 +0200
Message-ID: <20250603211634.2925015-1-david@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D6upb7HFh0KfLWYHCCyHZjjFZcQE8h-Z-yapMX3XTrk_1748985397
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Based on Linus' master.

While working on improving vm_normal_page() and friends, I stumbled
over this issues: refcounted "normal" pages must not be marked
using pmd_special() / pud_special().

Fortunately, so far there doesn't seem to be serious damage.

This is only compile-tested so far. Still looking for an easy way to test
PMD/PUD mappings with DAX. Any tests I can easily run?

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>

David Hildenbrand (2):
  mm/huge_memory: don't mark refcounted pages special in
    vmf_insert_folio_pmd()
  mm/huge_memory: don't mark refcounted pages special in
    vmf_insert_folio_pud()

 include/linux/mm.h | 15 ++++++++++
 mm/huge_memory.c   | 72 +++++++++++++++++++++++++++++++++++-----------
 2 files changed, 70 insertions(+), 17 deletions(-)


base-commit: a9dfb7db96f7bc1f30feae673aab7fdbfbc94e9c
-- 
2.49.0

