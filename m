Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F47340A6F
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 15:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871128; cv=none; b=qbDMasTh438ucudHSgA+QD+jjd3/Eh7ygkz5pfsITbA/EAjOS2iitpYZ6foneOxHV5rOzLYeyJ6bcx1DBkVHD1c0G65NpcZM0UxQPWYjvynP989OyCm8l2E317BbqBFFMFQ0VPK3jRwUFbafEg9RQ3DhWL0+cMGUrEQwinbReDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871128; c=relaxed/simple;
	bh=PA4Bqt4ZM/5eU9t/Xv2IagzZnnLp2iO/pQZpXfi9d2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNjuwlrCnww4JkCrWg9+592UKCtej0JWFmIm3B5Kz09DcARYtiIw4EhX2z8M1zD45u9lfryb0+7/n5Yk3ENuHfCYBaEb3+xQX97CA1a7ubVAGy4ygiAqd3L5itz7IVS1TNFx8RjNGe+aQGUjoHvL5zSFFcL7wgT3QCyrzd7bfdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Nl3hvZlF; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Nl3hvZlF"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e67555e24so131163985a.3
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 08:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871121; x=1784475921; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qpaKnc1e95Tg7VSs2UGrLw6c/qizit0d3ArQLheYoTo=;
        b=Nl3hvZlFIAK7zFjufg9IY8vMHRfOIKaQnMADQeJNUNu3EN21Nqpz0t5KHVLhwSWN3L
         7RcvhPV1QuzkHccEZh1X+lkud2OAQJTDy/X8qg6b2Yyka5DixI8U3xrCN8SiApabg12y
         gOnPw3q2aWDIKi96TuQRgqNeyUrYZ0EtCKNtVKpCiZ6v8G9Hok13M++y4kXQUZR73kRM
         E8T+ilGTMma/99mn/kMHAM45dgK4VeEAoieSugn5hYHL7ADTc+TTCZz9Nk/lxH0XZywB
         YZmBcj4pSAQEp5fJQtLX+rHPMdcMaK0nQZWuKPWykmBdIS7lp8rLhx+BBQCQ9s5MZx1V
         e3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871121; x=1784475921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qpaKnc1e95Tg7VSs2UGrLw6c/qizit0d3ArQLheYoTo=;
        b=HKcAzFHaQwVVB0s1VnAQu0tZeDT5FxPFLobtJs5ryx7QEs2FUp3cnEOmFoGicSSZHg
         wTJhEVufCmU0C0rMpprjMDQyE6/sYKsbqHqDfyTokcMdePm51qdaAqnbmHFQFC9LpkgX
         m2KH6xnSSOap1EFMIrBI+PrLZHOBEkLxcwjQwqAAljOPNw63/nQ7uJM6ZOAmSKzagrta
         UDsfQJlECOJcS+4f6wCE0PpahL8DPB+z38tlEVo7zTCcBFIcMcbyqik5q1/HigpmcXNa
         9JnAcGmjpD/DYBi49bDHQWA+AjnWRdpdkXHh6JQHccvpS7YzV6t/hPNHe30qdj5RcBx0
         PtkQ==
X-Forwarded-Encrypted: i=1; AHgh+RozmwmjzB6mz04QbakgeWxQS43/zqDW1MLXi8y5CxYf/Jamp2Eap7FwbVUnHCDxoSGGk0WXZgQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPCNhMot8svJJwIAwDdzO8YVyijAUGoBUpiztgDAieHrl+xEvK
	8m90dRjBAPWqk8FPlXe4zQuv893OPBgxm0bTEEzeHR9YQSXI+xf8hkKQ4iEQHvv4HB4=
X-Gm-Gg: AfdE7cmxQE/8HkeCxBBHjI40EYB0OR5XSgj7Nmv5DX5YhG5fU/3bAYbKir1NiWcAADe
	9WtwCE+Ac0TVGqx0gPV7qN5/o1vV1AhkIUeuVD9LxuU6BRNJNHrd0ukJEMG7qHcxW3PI39n3foz
	b/nfRIG1QQpFN4NZi0tLX5SZBkInFUBWKokidvLJVRgtYdtxj8SsCfd5IoMxXPyHJEvuiH+8GTb
	vBQu3ivzlAgHAh+GugfdzoKNEWhb69eMRA3+SAUAMWtIr76cOLdyb/AD75lU/uRZjy6gYHuS69s
	cH4Z5/dqe5ybJ+DGlZxP4/4LOwJUppTMy+V19JOVADlN+vkWCx1lAnMN1TaFMVosOPL1SzE7tj6
	noiwS/Y3iTIgg96zTbWHvzFVH+aK72yOUYdnjhrbTVW5+IT7vqhQSqiWncU0Sa4/AAF8D8lu1jD
	LmvtyfG3aqs83KFy7/hU7vvUIAdKYQNyG7DHwGQ3XAgSWymRJULnNWIANBmif2NSne1UWqmjI+0
	A==
X-Received: by 2002:a05:620a:2913:b0:915:e9c3:f1a0 with SMTP id af79cd13be357-92ef2b35bfemr677144185a.12.1783871120928;
        Sun, 12 Jul 2026 08:45:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:20 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v7 03/10] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Sun, 12 Jul 2026 11:44:57 -0400
Message-ID: <20260712154505.3564379-4-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
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

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8b137328dcf01..e625529baf996 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1338,7 +1338,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	enum mmop *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1495,6 +1497,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	enum mmop online_type = mhp_get_default_online_type();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1583,7 +1586,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	/* online pages if requested */
 	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
 
 	return ret;
 error:
-- 
2.53.0-Meta

