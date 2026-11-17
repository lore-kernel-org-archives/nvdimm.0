Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931119;
	b=D4LDrQRspVIh5QxF7L/TAcn7YIb7PJyfCcUxDFvigau7QZfzo1YtwwVyNA9znmeRwu5G
	 Eivuy/qqdp9KQpmMO8TYRBXvu5VMB59UZHURUTHcOe4cxZ/MLKEETPiqZ+DbUOru1PgUr
	 UMZdOIx/OjcXUxHCeb5obRtwz4ERTI3mDvY+uR/9EPdIXWiqEELNOeAGz0dM6XeVmLvuj
	 VzaLM3ciN1vsIN69KSI2bmfoQAz2ZVL5QStWtnTHUh+YQ4K2mhbJB1JO+8qSVVEffJ9sx
	 rXMt76O2WBpL5TLKLnnNSlzRHu63GcMoE2TiPHaUa6GqW8WjzPukG3d/aSjm7502xYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931119;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer;
	bh=cS72ij2d9ni29XRJBjpUF55VVESM9MZfzucjV2dsBEU=;
	b=2zgv9MFIISYwy61KWmEYwozI+oJ8RdNOjg/U0XFDGN12UFPgnb7S/tpjv+JPmidF/Vei
	 797rYookILmghRMtte7itg7LPgfbNAm9s3oYKQBLqKkBdUHYqsPVwnWquaysiilnXjbVt
	 8TRA4EkeqOWpHCSrr2JUtkKHcenXo+ZYfm6w3s45cKnVHozb6Ye7SPGj18B5D+vHhr5/Z
	 JEVClnmbpGgLgaGMrPTyXbaRkuPj7FMLxsvGMmoDLS1zFEZ1z1MuZ1/FOqQtkuchfe7n6
	 1t1KxlPxdPkZFOQiFHN4A7Y9lMo/6ToFd/Hs7oPEEC/TDNYmOGFkk3jH/ZDIu3mDhLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YrRAPDeL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01B3606A32F;
	Tue, 17 Nov 2026 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YrRAPDeL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2030C1F000C7;
	Tue, 17 Nov 2026 15:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931119;
	bh=cS72ij2d9ni29XRJBjpUF55VVESM9MZfzucjV2dsBEU=;
	h=From:Subject:Date:To:Cc;
	b=YrRAPDeLFHufyNicmII5GYATuKsD/SPRYLYHTeXp3o6xEXHIz+mmEK+LatGEsgBWw
	 hvx+/QMwz/AcIKp8qKIN53vGa4AjPEzf/3Pr6sGe23UyRDlOIQNXAsoFCEGCoEiBug
	 5G5Dv5Dmm/m8VWPQGPuzuu8KgtI0EJ4AKquNyyzEqglCrl/rvrEmZZwA6jeChZsPjV
	 S85MPiwldb2xOZnkUGQHJcJtli7FYEAwSwwwrhFNsRvxsEoc5P5h656QI6AxoJAAAN
	 jNdY644iCqf7+Abe8BsGMdKrwLQ0Kb7JFJUYx7a+y72JHQ+54shoiVh+DoeZR/Hb3R
	 mgwGo00kRlJAA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/3] mm/memory: fix handling of PTE markers in
 insert_page_into_pte_locked()
Date: Tue, 17 Nov 2026 17:58:31 +0200
Message-Id: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ6CMBBFr0Jm7UTLAohXMS6m06nU2EI6gBjC3
 S26fC//vw1UchCFa7VBliVoGFIBc6qAe0oPweAKQ32pG2NMi7P3Dh2tSPpJjO8RfVixa1pi7hy
 3nYfyHbMU/eve7n/W2T6FpyN2LCypoM2UuD9UjMMUzzHinHQi+xLY9y/bS+rxnQAAAA==
X-Change-ID: 20261117-uffd-dax-async-wp-fix-867acc8dc78f
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, nvdimm@lists.linux.dev
X-Mailer: b4 0.16.1-dev

Jingyi reported that a uffd-wp marker in a DAX mapping causes endless
refaults on reads and SIGBUS on writes [1].

The root cause is that insert_page_into_pte_locked() treats every PTE that
is not none as a present mapping. Besides uffd-wp markers, this also
affects guard markers that MADV_GUARD_INSTALL can put into a DAX mapping
concurrently with a write fault.

The first patch restructures insert_page_into_pte_locked() to make room
for the fixes, the second patch fixes the reported issue and the third
makes write faults back off on non-present PTEs.

Both issues were reproduced on ext4 with dax=always on emulated pmem, and
the fixes were verified with these reproducers.
selftests.

[1] https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com

---
Mike Rapoport (Microsoft) (3):
      mm/memory: install new PTEs first in insert_page_into_pte_locked()
      mm/memory: replace uffd-wp markers in insert_page_into_pte_locked()
      mm/memory: don't upgrade non-present PTEs in insert_page_into_pte_locked()

 mm/memory.c | 68 +++++++++++++++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 33 deletions(-)
---
base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c
change-id: 20261117-uffd-dax-async-wp-fix-867acc8dc78f

--
Sincerely yours,
Mike.

