Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66BD343884
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 15:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871131; cv=none; b=ADYwf9ZZzRTnNZQfaVQv/3Jii/SoSQFlO8OsJsQGP8t33PsRDmTUTa3uI7iW2CzgmHL5lEWZ0c0wRneaMHbWwUlf3fVKrUyvnGf8Uppne9QEXTOcHQEKVJGo32g7N/a0DedLsa0DPxgtk+3REZZK7vDMySZRmhNH+n4n3trAVsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871131; c=relaxed/simple;
	bh=JQAGfqE0PffesD9sKQCzYKMipVFSPTwh6dBNXQMkTdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0Ah2FBLKP9jlNC2HzyV1R9fk+IPrhPpo5TxWwVgt9aHDufMR/TKZUEFCgwWSFucvJmmBg47q5/XwB9IUMyzwqeOd1gXc3NFopzWkoyHZ4/4TTQpO/nULgIjh34HwYrLLimD54NIG7pZpFcmH5UnLxdMt+AmiNseARtK1NrgNQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=VBkLZpyS; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="VBkLZpyS"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e7c6ec9dbso93920985a.0
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 08:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871128; x=1784475928; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BguinuoorksxpsezVhTMBAsbvTRcZT92EAAvPgOWJAM=;
        b=VBkLZpySWyNCGayR2O6PgN9pfK2MwXHk/IBnE5kmGyzhJtl+zIfOTwghFdxigDSpS9
         2DmPb9MMEJZbXlJsCgTVwqNpM6aXwSGmd/pJZHA8ngacI8Vpo/CsFpB3bKE6H/Qtu/35
         Q/yrLuTnsrHHr6hymW4mb8qHkjQ1noxHwS6XfgyxLoizxdtcMiUrU84OdtkblYxWWRu9
         dZ7u0mmtuy5asRO+muiCoogEANX/eNa5V5ZZK4tABq6nO9JKJX8KdtYZJNIG8ZtXNw0J
         x3cAjex4WPz8w6RrzhoHEmmo+e5AdbqimqhhyVIPfAq1m8RkxvaSJ+LqsErcKagPcvJW
         N95Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871128; x=1784475928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BguinuoorksxpsezVhTMBAsbvTRcZT92EAAvPgOWJAM=;
        b=kaq3oZNMcQChJMy7poIM8eYg1zR8DVbaDiSzV1kfzR3uzUrv655Q6z5YhCGWSRFnvN
         FTqr1FAUlPYYbDcKrvmv3ZE9nnEVNv6gFJvbEIpkwLtXQgxq8H/CtGryFL9fAw0boNSD
         ry+qHzBwb25Nuqm8h179U4B0oHy10f7tJ5mQyzLfDlGWXmiFZnCmRpdQagbfBLDxO2XC
         Vh4YE5QftK9dZHHZVA6DhEZv4rK1jeXEnTaSsA89IUvCiUfYmEnWJlrWMmJeD5fTy33m
         Mcymc1jGyIix5XjLp15Ej96qAByzDITt6xM5BPoRLYFnkHNs2pmqkb0GZjp3a2FimTpm
         32ww==
X-Forwarded-Encrypted: i=1; AHgh+Rr+UzrzPYKiDCdA5kKKvslc8bNsKSj2Xbq3uwqJdaEJtpD308v1QceCZuGAK0OBJQPUNlA0FF4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzriBhxL0QqpQeuj32GiSQs3o8zbTMgh4xwSNO/Gnc8orb2adLt
	2f1cHM0To4CMd9PSyzYQTSicVl4jNCO+pp2VnY9+5uSMbh1RpCHinemmm2My6iH5oaw=
X-Gm-Gg: AfdE7cmjrGI0bIXDT3ZYIeJO9Hp5sRTUz+OpsW9xL/AU+hEzaB3Dl3Fw+IT0WjQsQq4
	nbP7eWZJObw3nSfIVBnp0zgGPGYMWdFgQ39oEOgSFVmJ0FhdnDYF1HTGfTcwEUBhu67+fuyIQnM
	Q7hX2tav/JtOB1z6e7SeC2R1392iLaW6NY+PgP9+D8+pReN4rKHDxjJ0+7Zvin5/6a4Gn4Im5s6
	W4E8ynM+vYOpzloh1XPINoNbIxrnpog1/O6qdEQWyqZzgTSQygTPiKL/g7UtO0/c2aTIWvu4/rg
	8LfqVB68XhEbAFgWHyqTa9ZfxGIrDLuuzYtIoU1ysyvtBVI8zcIk0ziTDUoRs5R27Lz8DNhvDXX
	+JHp/iZAIug01tNNZD3X2xG9F0hjWfzyU8wSIyO4X40XkMgUnPh+uwci7LmiS1RpAQHwc6bjIfG
	PFEUx+zBGgs5A+0Ns6empR3SZRaDmaL23w6y50kTgfmJozVt6sCgHeJsHRRHuaIEnu6oGASj52a
	DjfgrlERRAh
X-Received: by 2002:a05:620a:400b:b0:92e:c117:5ed3 with SMTP id af79cd13be357-92ef2e222a1mr610227085a.83.1783871127659;
        Sun, 12 Jul 2026 08:45:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:27 -0700 (PDT)
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
	gourry@gourry.net
Subject: [PATCH v7 07/10] dax/kmem: resolve default online type at probe time
Date: Sun, 12 Jul 2026 11:45:01 -0400
Message-ID: <20260712154505.3564379-8-gourry@gourry.net>
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

Resolve the default online type in kmem at probe time explicitly
instead of implicitly inheriting the system default by calling
add_memory_driver_managed().

No behavioral change at this point (still system default).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 592171ec10f49..38ed5c4e9c83d 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -73,6 +73,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	mhp_t mhp_flags;
 	int numa_node;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
+	int online_type = mhp_get_default_online_type();
 
 	/*
 	 * Ensure good NUMA information for the persistent memory.
@@ -172,8 +173,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
 		 */
-		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags);
+		rc = __add_memory_driver_managed(data->mgid, range.start,
+				range_len(&range), kmem_name, mhp_flags,
+				online_type);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
-- 
2.53.0-Meta

