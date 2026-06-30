Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC592FB965
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 21:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782854336; cv=none; b=dXig4CU8f+7RnvoUdV9bkyirNaa0u6Js2+WTyKw3zkVIn14HrOPNj7zULTkXNi24qaR0/prXVAk3WUwmDLkmEzRAn+PtW2OPQUxquwMtziWs6Kt/xq1IoNiMzimd2QE2w4rgUPIL3Q3SIGgwgkvSji5Rm+RpfqY1wtm16Fgy+DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782854336; c=relaxed/simple;
	bh=8FG7ZFmw3F40yTw3byN4Wrjifv1WRBP6iWaBrd7AOJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElyA/OplS1wJH8xVPTBOh6Mq9clae2o7tlwt/yxDJGQcn7SBAQBlc5LxDiEc7BgklcSkbr7esRweRpkc0np/y/bFboFpGAtFrTMftNQlzOp33JRyTdRHcVXEmc9ZZ01CLQQgu6Tnt73uMJqTQhpgwmDEJ6lPBUbadh2ceakml8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=YRu5dW5s; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="YRu5dW5s"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e5c92c389so167799185a.3
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 14:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854332; x=1783459132; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lel2Y3CZmRG0qaIuB9j1lDgS4wpuSucao3lSJ/Gln9c=;
        b=YRu5dW5sX5zC6vsQ3vSreLOK6C7wFhNt+d2kCX0R2r2gwFMAaV3NNjXssazcwoWyPH
         cWHIiYaZFLfcskXNKPvmFbKUWi6eEdmucyzr2fdYEOlKpQTyJQqSACYdHFjSdVuA7ecu
         oJ4aJsvkXhxzYTvDChyMg140htVCblD0nKNtZ+Of74a6tSwJgFz5usE918yGbshKch+d
         H80OYsvbqLkmOR/0TT4U7cF+qM+a0pHsODxeWnSsepH5rr2gIBV6UvdeB9ukpDOYLVW6
         AIXwnOLBUZUPVDUEJd+avxSq3LYm1eYKywM3r4xEQUMy3y78oDuYahdDM2PKQ1wV8D1G
         f0uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854332; x=1783459132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lel2Y3CZmRG0qaIuB9j1lDgS4wpuSucao3lSJ/Gln9c=;
        b=bypxLqZmRGc80yW6IhX4ArporftYV6KMcAYbWrZT3BqpyyETKgsnf2yI9Zszp+6v5U
         2xjwtRNxS7Agj9uBZZtbhmUYlEZbseWUo2TK+dKHvWkfIQEO3T7wltG9RYZaEirbOu6F
         e7yyGD8Rx1gixgAWHP+0FYr0PSXU6NuqdCTTzVsf72EjS5MfPbkyIxA3rPsP7L0nAz1E
         PsRmUSaAL2hgEL4lVYaOxDQjOwwd6VZfzRxuUeZY2js1uHw5K+oBE7s4DvA0yR2oI2y2
         p+kpdrIQX3lqQTKXgv+YL4U9NgIlSNFIQrG99bDZhguVW6Ib86N+GieOvLnwx5ETPgoe
         y3rg==
X-Gm-Message-State: AOJu0YxCnLx6la/YzStYyrQzgt51GPK9qPrOD1wECuuudLdYNLf1AGiw
	folaWIvqV8sV1D7cBIvZ9/MCgadOhHpv7vEzbEnnhuDGQDWgH39jCZE6ZjtiYmruQHs=
X-Gm-Gg: AfdE7clDdbBVwIM8Ls39eA9Xl6iUJdoBg1lnCkHxpNEONqK1jRCLge1A9CbuvNb7N+i
	RPX14lUpqTqdFlpg4BeYtARmLuR+roUVbQOHKplHXZ9569GWuqUbd3KTLFyZ4EH6NlP4h2TUAW9
	dZZuKDR16l1UCZCyUhNBRc6T7T0asuIGsSB/Cz5CdLab1hDD0IhaHItlH4M6wF9wRgAdQYLu7K9
	H5u1po8AOLWwQg4oBMzwuJHOMvFGHWYYMrSdYpJ3hYacjXcqWovketbzdA9y88x8dI0AMCqOVKl
	LfnidMYSMmGlAzAdV2ZagTVDulsHoZCLyV4Ymk4XYxsc2jz/E1tvwNhijJrqeEVxvHAvzg5wGAU
	5xZE2nM8Gllp9032QWzK7Q77j0Xd6qw7mfwd/0FEGi0fBzpX9+69D2wYRiCLjdmuNUx2aGYsMgf
	X3NuCd8elRinHFhKvzAk2iNFh4rrpynV6Bwxz6DmkuZIoOYGTSuxzS7qmKPokWCGQHJz+ODWvMY
	g==
X-Received: by 2002:a05:620a:a190:20b0:92e:6e55:cc66 with SMTP id af79cd13be357-92e6e55e500mr269113785a.47.1782854331991;
        Tue, 30 Jun 2026 14:18:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:51 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
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
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com
Subject: [PATCH v6 02/10] mm/memory_hotplug: add mhp_online_type_to_str() and export string helpers
Date: Tue, 30 Jun 2026 17:18:34 -0400
Message-ID: <20260630211842.2252800-3-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add mhp_online_type_to_str() as the inverse of mhp_online_type_from_str(),
and export both so a driver can render and parse the memory online type
through its own sysfs interface.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/memory.c          | 9 +++++++++
 include/linux/memory_hotplug.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index b318344426fa..3a2f69d3af7b 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -46,6 +46,15 @@ int mhp_online_type_from_str(const char *str)
 	}
 	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(mhp_online_type_from_str);
+
+const char *mhp_online_type_to_str(int online_type)
+{
+	if (online_type < 0 || online_type >= (int)ARRAY_SIZE(online_type_to_str))
+		return NULL;
+	return online_type_to_str[online_type];
+}
+EXPORT_SYMBOL_GPL(mhp_online_type_to_str);
 
 #define to_memory_block(dev) container_of(dev, struct memory_block, dev)
 
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 7c9d66729c60..5d4b628c4a1f 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -127,6 +127,7 @@ extern int arch_add_memory(int nid, u64 start, u64 size,
 extern u64 max_mem_size;
 
 extern int mhp_online_type_from_str(const char *str);
+const char *mhp_online_type_to_str(int online_type);
 
 /* If movable_node boot option specified */
 extern bool movable_node_enabled;
-- 
2.53.0-Meta

