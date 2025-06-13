Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CCD256C73
	for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 09:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749806831; cv=none; b=cYnU95CU7KrojYbzorx0VOvBJJ2M1nLupfCxBWHyqoN7qxh7buncHTFicPX7Q7byLg18G5JsgOc2aPhJQbqZb77YO/BFSnSSGMteIaAHutmhs6+BZSyCKGm76thNZttCBNmMSNUr5pT6SCzEMQroFdgBY31WlFZql9SrDzF83Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749806831; c=relaxed/simple;
	bh=mhgTTIZZsefj8mnYxT3QFETIlhACxk/HMINCBYR2EQM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=moATmSAIeDPMV7JmsJs1Wgmq6YrU6oyEza4In/9pna0y4PveG7wST2jQecJo/DxgsUv9/W1z5Ly1l4NVE8KkFuaLnXc+ORCOHJ50P8+W9GT2yRE4oLeW6mHLrijaupQI9Iwg4kfOC1tUu+qBJh3sWfE6PFx9pAbQGfou/8lVfoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TTK3/mGl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TTK3/mGl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749806827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eA9hGBugFKNk6aXi/MtXxZpnAai7SGsOuKl0QrS3BOQ=;
	b=TTK3/mGlbVCeU3/15kRdXgSGvmQy9uI8+60R7Y0J24FLVkCkfrKrSoiDs/hz0vNysLL221
	fvOjl5T+2MjQJgOXvSO11asX12aGzhBIIxaJ88GJWidB3+/s4T9BpkBIkl79TWgW27VAzP
	7/n6zcRmyKkzMPFWoRXCm2GsrKyq700=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-OAKeGZ8TO2eo4K7QIvsmZw-1; Fri, 13 Jun 2025 05:27:05 -0400
X-MC-Unique: OAKeGZ8TO2eo4K7QIvsmZw-1
X-Mimecast-MFC-AGG-ID: OAKeGZ8TO2eo4K7QIvsmZw_1749806824
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4532514dee8so18463845e9.0
        for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 02:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749806824; x=1750411624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eA9hGBugFKNk6aXi/MtXxZpnAai7SGsOuKl0QrS3BOQ=;
        b=LKLKDxW6bR7zxZ4zVatzrxhIR9c/aWVDHy6kh8pPsx5Lzo/NRFgobcR1ioAkmUip97
         KwdU/0sWGLn/6kbljKOcX6+CFHHaZBaLL4vyV8gjjoMEur+RRynmcjS2bCmzSyfAJbgX
         JZEqia712CbDjbdJvHuugvd9ES20ikxWNY8bgaKBCt00z/ardNj0VXKZH80mj0NaqEqW
         fpzVHx0bYkpBVuIol2lGjLziPYElO82nYDuC+9FuXHnT3IPt7A0XB2EoOJ0c00X0lRUe
         LqN/q6KNo2Ih3JF3fi0ONEwQLP5l68RoiC5zPK/HNmEAntKfxUS8vyvh3hmnVA5ub8el
         YrGw==
X-Forwarded-Encrypted: i=1; AJvYcCX9ibi4U0pUYnKpWyPkyZEKgfHBDVmTihtHUxX+zKFOSHhdovQQE1CarCTThUhv3wldxCUMUUY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZjmYpfDLMNRIyq6+DmnJf0SpEc5MxWMeO5G7lg3Ou/m5FqGD+
	/R544o1wfKYgGru5MoRd2cmikiugNO+y6/ZMx8w2TbShEUwtsNHe/FHOMKGQmwiw+3LSioXfw/c
	vJuLEiQTZ8LjLzCX2Tlqm1zS+jOyfjV0g09svSL82C+J0R8snHWdqxcidbQ==
X-Gm-Gg: ASbGncs0ezVZFkWkm2MY7rsyrTDezRBdiPU3vEv4Ej0GBQNXh2qqP1DFjkkOVtPesPz
	Yg+c+jBre2SNiKN5jfoVsP8U/jE/+5jVkUNjoQLN+qBItD/Z1aZzbGD5g3wI7/5xwAov5p5PC1c
	BxQMI3OxMP4nsfI5J9EuKoCGsBNT19pLGgWDZsS4qCltU6ed3k8L6Rc3PQbLq2aigzYVZoxVdyw
	E2mvQSNmx6uFjK8B+JP7PXZB8hnlS8vPRpVkYABCpzWtrijXodn12GR1zVq4CHLSaUCW8+9XENe
	eQ1I3AUFycy1m11HnADXKW+0vFwBfGac3G32kh10PoEsPq3k2o/ATbDKx9eBGPf0nEb1zWs00w/
	774V3Bfo=
X-Received: by 2002:a05:600c:1c19:b0:442:e9eb:cba2 with SMTP id 5b1f17b1804b1-4533499edc7mr24668055e9.0.1749806824361;
        Fri, 13 Jun 2025 02:27:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGERaE8MR+6/dmyK3cZQ7xtwJhWFU3zCcnVAfTUdbkGjRrz6rE1iR9ahL+Nyc7gnKqK2+FRCw==
X-Received: by 2002:a05:600c:1c19:b0:442:e9eb:cba2 with SMTP id 5b1f17b1804b1-4533499edc7mr24667655e9.0.1749806823907;
        Fri, 13 Jun 2025 02:27:03 -0700 (PDT)
Received: from localhost (p200300d82f1a37002982b5f7a04e4cb4.dip0.t-ipconnect.de. [2003:d8:2f1a:3700:2982:b5f7:a04e:4cb4])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a568a73a7bsm1822993f8f.36.2025.06.13.02.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 02:27:03 -0700 (PDT)
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
	Dan Williams <dan.j.williams@intel.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH v3 0/3] mm/huge_memory: vmf_insert_folio_*() and vmf_insert_pfn_pud() fixes
Date: Fri, 13 Jun 2025 11:26:59 +0200
Message-ID: <20250613092702.1943533-1-david@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uXdHw6O-X_gcoMxWulLWgyZ-vbhsykJ_uEzr7frSNIo_1749806824
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Based on mm/mm-unstable.

While working on improving vm_normal_page() and friends, I stumbled
over this issues: refcounted "normal" folios must not be marked
using pmd_special() / pud_special(). Otherwise, we're effectively telling
the system that these folios are no "normal", violating the rules we
documented for vm_normal_page().

Fortunately, there are not many pmd_special()/pud_special() users yet.
So far there doesn't seem to be serious damage.

Tested using the ndctl tests ("ndctl:dax" suite).

v2 -> v3:
* Added tags (thanks for all the review!)
* Smaller fixups (add empty lines) and patch description improvements

v1 -> v2:
* "mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()"
 -> Added after stumbling over that
* Modified the other tests to reuse the existing function by passing a
  new struct
* Renamed the patches to talk about "folios" instead of pages and adjusted
  the patch descriptions
* Dropped RB/TB from Dan and Oscar due to the changes

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
Cc: Oscar Salvador <osalvador@suse.de>

David Hildenbrand (3):
  mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()
  mm/huge_memory: don't mark refcounted folios special in
    vmf_insert_folio_pmd()
  mm/huge_memory: don't mark refcounted folios special in
    vmf_insert_folio_pud()

 include/linux/mm.h |  19 +++++++-
 mm/huge_memory.c   | 112 ++++++++++++++++++++++++++++-----------------
 2 files changed, 87 insertions(+), 44 deletions(-)

-- 
2.49.0

