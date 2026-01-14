Received: from mail-qt1-f196.google.com (mail-qt1-f196.google.com [209.85.160.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E732137B3EC
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 23:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768434662; cv=none; b=V2KxUukBFx2yJAhLIojBlPTk+x/JMoXSZswbwr2wU8b467gU8eVvOTo/ug6auw+Mlqhtpps0QDgcm4qgyGxLv3VWpfeX0TdR1gINu8SMdQCb0nT5c13Nu/cCTdDxY+CoVBHgqKe95gKkqWlXF8lp+p9KVfSw8aVtt4SbJPeskVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768434662; c=relaxed/simple;
	bh=flZoV7rTu0HoLnYzDWHCPkEv69kRnAJvNaCvCfg2dPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfEtqkrlnmWBJ8CrEO1llmuTHsJF5M7/U8bPhi5wGaBpm3gKqKN36zRNIaPjG2EZQYyLGmzdy+yP3wNrrkGwZUSL0cBZco4A3oC9x8sr7Z51EX/OArLJhu7O58YjWh2n9bQ+eAS2OduauKJn4QpXkmlA8I4G9Rk9ut8SdDJxgmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=TX0Frthd; arc=none smtp.client-ip=209.85.160.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="TX0Frthd"
Received: by mail-qt1-f196.google.com with SMTP id d75a77b69052e-4ee1939e70bso3772661cf.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 15:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768434660; x=1769039460; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TeEc8tQJdZv6wSmBwJwNJ7eg8WiARnEu4gZS0Yp4t4I=;
        b=TX0Frthde9bakbZWa0n74tS5K1+/mxmk7qR0y47Iqraq64u7EpycCT2RLScURdcYBR
         WhS80YHFPa6dL68m0yj3aGSJGg7lcS3avxpkepk9WLv7zIxMRPorB4tv7m8pV9q8RYr7
         HIBuQzA7Vi9UIIeafqypWSKGvWunAQM1wF9y3/OPQZh66x6XoJTGePkfc7FMq7SSQACQ
         p0rWUj96FV1lUcqqtYKMB+2nRl5pAWotReSswNYwTcI6c/1J2RRHL6jLv/j0xNeiZhDz
         LoIyeSW1BOoSk0Ks0ulQDLsdHhMe0yb697Vc3WnmkMNBWVqu3YFNZYs+I2HbOAhBsUVS
         ZvLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768434660; x=1769039460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TeEc8tQJdZv6wSmBwJwNJ7eg8WiARnEu4gZS0Yp4t4I=;
        b=oDurzM7VyhIT1e0bxnoYUmm6Oaw/t1uRp9DQMidlRBjO3ha7/9OuznAJYqagLPlx49
         aAsPdz+22niIz8O/JrMqYHQ8VuRFWKnfQqsaYJ2SIuVQTgCOk2n43NserOOWqqumunzX
         f9kTIhLrCwc3s0wjTZBf9ll/VLFXxZXYg0t7vElKr3kQomtcNoQk5namaOdLRzyg4i9g
         SGXh3cn9Y6476FPvStG6/1eAVTe7EwrguG6mEr2iKW+EEzWZdnhkDJTRtrguBLu8Qs6U
         DAgBl+vrDZJroqvo+woGSoYkE9q4y4dlAH6eby1sgUTn8wOGtesynKnUmTMilQ30Iqtk
         I3nQ==
X-Forwarded-Encrypted: i=1; AJvYcCWH8YmT7K67dtk4EU1c89oXaRSSNjxu/U7My9TPocImwoW9CQbYOn7+rFAfa96rLLzJuw+Mr/Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrK03iPoHAf/22MdH6rV5bwjAJREewYNP8LnSTxIIhZAwepIUb
	XbsNr8GscxlT897CILrwWW3m5qq/eo623+Zso3tTaPbaiF5i75sR1AdFp2hBSbG8NmA=
X-Gm-Gg: AY/fxX68U+oSIrTbScjRs6EQQ19TQZYH8U+hu7Iwj9IWRTcoHfg5XeiwGPIMS2Hk6Bt
	OTSknjOKvAzXrHEacLz7PSWmHlUq4S9jLtzqpLkQP5fj+n2LgTsuXGhsRFy5Mh1Ql0Js190A6aP
	canXYR7A8T5QJg9ZQ0b5FlRhfSt46M+hlsg18ER72CvnpA7mkTlqEQDjXK2oE10WGh7akRdDMxa
	af6AgjKm/Mriyxu16ssMMq7eQVbNlUZkXXD7G0QO3IccrEfAEDIlBeGKCJenFVuaA6YBZs15sl5
	WHuxVu1ouJmRmjrFHRyy6quaidAjthYrDA6TDZMEZEiJj32ai2Ue+Ze7y+R9VyKAkYCi4WB6Dac
	FuJOYiuU2FyqslU7LdBHSwJQQR+YqWWtbuHgUoSnmopd5Jd9/tREsas71IHSxZGW/850PT9mAU1
	o54ACtrXBTkc7uIiJPBcmZfw+TrZb0+dp1ghIhMH2syqsElHJMoQhKzHDHgyoNq+hsB3DfKNYfg
	ijBv9SIVKdt3g==
X-Received: by 2002:a05:622a:181d:b0:4ee:1d0c:15e8 with SMTP id d75a77b69052e-5014a99becfmr55478081cf.74.1768434659885;
        Wed, 14 Jan 2026 15:50:59 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772346f8sm188449106d6.35.2026.01.14.15.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 15:50:59 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: [PATCH v2 1/5] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Wed, 14 Jan 2026 18:50:17 -0500
Message-ID: <20260114235022.3437787-2-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114235022.3437787-1-gourry@gourry.net>
References: <20260114235022.3437787-1-gourry@gourry.net>
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
type via a local variable. No functional change.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 389989a28abe..5718556121f0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	int *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1578,8 +1580,12 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+	if (mhp_get_default_online_type() != MMOP_OFFLINE) {
+		int online_type = mhp_get_default_online_type();
+
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
+	}
 
 	return ret;
 error:
-- 
2.52.0

