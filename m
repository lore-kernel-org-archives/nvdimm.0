Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA34B175A79
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 18:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745328; cv=none; b=AqGnmPd8WOW9uNlCFJvjNVSm/Ag+fvgcMiR13F2KQfpE172cQyFVf8zBhcspKpLC2q2e/bsNwODjq2q8GBIYrveprpGMzxdRaGpl/7m3LFCbee5WXDIepDa04Z3OSkBCcRRH0wohZKJGeEqL1Uw+0XFeIBSNqYpyOTzrDGbrPP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745328; c=relaxed/simple;
	bh=dWFSG8u7oJ1tS5+bgC+LuxGSEyW5U3yv31ndL8WfbZk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gXiNx0vtsgjSJIsgEo51W5DcRUZWhkDLbgSPLA6pSe1NuIq56E1JPdTHYbXHQR1/J92GjVETMMEY1gaY83AxGBH4vQtGtXTJpBdVmar5WDvNML5W/WJcOHQNlKjbV7BOSOtWVLC+dI9idrEIX+v1GEuMDHs+LfurX/KjQKWSe80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=THAUEXtP; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="THAUEXtP"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c0a81d286so58245811cf.1
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 11:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784745325; x=1785350125; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZE3yTmrW+H7J5TExci9q9j4rULKpaqgUmy/qSHf1N/c=;
        b=THAUEXtPfdcZPNab/grarnPK/iH/REov5SGcI/ISchAk0I0eoZ5MvNaYE2ijPp552L
         8EOm/jJjAJ+u1wpZuKBsNG343G6k6eDieq/MoeWn5WZVUEnhpcCBUmxI2MygIs1fKTcM
         aCh4IJFvhvs1o/93scDD4NKsftCC4uP8ZqdVBswUBXZuQRWL2HQyuIVsTNKi9DS0SB4E
         Yjz9lOLkfTJSrnyuDiO9iUNThc+smO2dCZCpWN5kJmzM+knJvfmgo7OgVwS2+lO3CxYh
         61ImT3oRJ2huSREPmg6l4DxAZz/6plk5xvnFLSMY3o45+IpvZk+H1b8ovHxnjg0taUrK
         uptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784745325; x=1785350125;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZE3yTmrW+H7J5TExci9q9j4rULKpaqgUmy/qSHf1N/c=;
        b=jVdoG68/XcDcPWeZ+InrHFat5/rpameagZwlLU8+WUP4WsGejqF50h7uQhNjM2f7v9
         lzIXMf0HHc5gwcJoSSjLGKdit3ESIHhS8TLxhFuLVLlUNSO+KO/k75YGag0Y2vMEdMqU
         bPw+bUcRvlTCdMrjCfZHZ36GFdliu0ApAb9Od7HNqkZT61MGyj+W3YiVUrXZaOv9c24F
         GRfajMRDfTkT4zMe+X7/f/N9upHt+37y8V6txIV5bFktBw+NdM5QjGrtYT7JakTyDdMu
         aFQO0S+hQzDbMJPMICWo9Jt99RB6VVirRBKBQ0ibfoVoRm6fWOb/2+Sf43iFSrQ876eZ
         y48Q==
X-Gm-Message-State: AOJu0Ywd/Nq3hfnNbCnxs+Zy9zqjJ3bR3g8rX98/uEotZDyScJShVK2j
	hVnddUoWGzjcc2dhSQ0dMdyE8pi71haS71G0w9Hm9VNCTCdPaMGayW5Yk8/hXnuUMr0=
X-Gm-Gg: AR+sD111RhZGfEpoKUPq3VAfuMzP4aubOzuy3/FxcwXko5TmbzSpa2XHSAaoHSXbN1t
	eq+mhRtlLh1WoAd39AWJxAu4pLYhxnFCMePcJ8iOfcUBI6IoOYXFTP74ZXzfsXoBm4R/ofXDNNo
	3fDLB3Njw7FGR5QEMW27ETTHQVSPmncZdDydmiODLw8Bu1XwLPG4A2EnqMooq+grRaUnMCXXVrL
	hm3w0q28/ADyHq0gW1RSIpITU7G+RCmnx5o1HR7QijOEu8Xr7pwLSi6ibgzbVbkdF0/neoR8IYB
	YkbIcgeZLUgbKcBjWEJFDakfTIdXgr3MqmADdNY7VCS/dpUtf1Pgo7hKK7dJt3KZdyMmvuI6AsJ
	VIBmTYe//q9z4QN1EZ6G9OkMZ/eceH9PgfjWbld0L1k1DMBBlwly2Tj+dyddBKWCDN5bstX1Crs
	0fzqDwhbyXFUTtA7En/T4hpw46fAPT6VizGPNYdPF/k6ZOgzrcOuNpy9OTiKiwZtA=
X-Received: by 2002:a05:622a:1b8e:b0:516:35fe:5524 with SMTP id d75a77b69052e-527a5c0f064mr51449541cf.5.1784745324692;
        Wed, 22 Jul 2026 11:35:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8b3e96sm27630216d6.1.2026.07.22.11.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:35:24 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com
Subject: [RFC PATCH 0/8] dax/kmem: support for private NUMA nodes
Date: Wed, 22 Jul 2026 14:35:11 -0400
Message-ID: <20260722183519.935213-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds uapi bits for private memory NUMA node [0] control.

It is not intended for merge - just discussion.

I have been using this to extensively test mm/ behaviors with private
nodes [1] and am wondering whether some of this is more generally
useful for coherent memory devices if private nodes lands.

For now, this is useful for testing, but locks in UAPI, so this RFC
is not intended as an intent to upstream - just sharing my testing api.
  
  Question 1: Do we want dax control of private node settings?
              1a) External? (uapi like this?)
	      1b) Internal-only? (plumbed through module apis)

  Question 2: If we do want this, do we want it in kmem or a
              separate dax driver? (dax/private_mem ?)

  Question 3: are dax_file and adistance useful regardless?

This adds 9 interfaces:

  dax0.0/dax_file
     this makes /dev/dax0.0 mmap-able when online as kmem
     it essentially attaches a default mempolicy to the vma
     that binds it to the dax device's node.

  dax0.0/private
     this switches whether hotplug sets N_MEMORY or N_MEMORY_PRIVATE

  dax0.0/adistance
     this allows overriding the default adistance to for the node
     into a specific tier.  That allows for testing tiering in both
     directions (demotion from/to the node)

  dax0.0/reclaim
  dax0.0/user_numa
  dax0.0/hotunplug
  dax0.0/demotion
  dax0.0/numa_balancing
  dax0.0/ltpin
     these bits all enable their respective NODE_PRIVATE_CAP_ bit

     reclaim   - enables reclaim on the node
     user_numa - enables mbind/mempolicy/move_pages/migrate_pages
     hotunplug - enables hotunplug to migrate memory
     demotion  - enables reclaim to demote from or to the node
     numa_balancing - allows prot_none injection on the node's folios
     ltpin     - allows longterm pin on node's folios to work

[0] private node series
https://lore.kernel.org/linux-mm/20260720193431.3841992-1-gourry@gourry.net/

[1] selftests/dax extensions for all of this that show use cases and
    testing for the private node series - including all user api's
    like mbind, set_mempolicy, move_pages, migrate_privates - as well
    as reclaim behaviors.
https://github.com/gourryinverse/linux/commits/scratch/gourry/managed_nodes/dax_private-mm-new/

Gregory Price (8):
  dax/kmem: add dax_file= to expose an anonymous-fault char device
  dax/kmem: add private= to online memory as an N_MEMORY_PRIVATE node
  dax/kmem: add the reclaim opt-in (CAP_RECLAIM) for private nodes
  dax/kmem: add the user_numa opt-in (CAP_USER_NUMA) for private nodes
  dax/kmem: add the hotunplug opt-in (CAP_HOTUNPLUG) for private nodes
  dax/kmem: add the demotion and numa_balancing opt-ins for private
    nodes
  dax/kmem: add the ltpin opt-in (CAP_LTPIN) for private nodes
  dax/kmem: add dax/adistance to make private node adistance
    configurable

 drivers/dax/kmem.c | 368 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 366 insertions(+), 2 deletions(-)

-- 
2.53.0-Meta

