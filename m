Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D3938A71E
	for <nvdimm@lists.linux.dev>; Mon, 31 Aug 2026 04:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788150910; cv=none; b=XzdzmzHjLbm07Gp7IYp4UFLpX5Exx3mTq6a7DfxD8UQ2p3G04fbg5zURirrJENJOuUIhXDL2f5D9gnuHL7AQ+EYpUHzArD674FVph3/oua3zsYnTlZUKfYmJH1ayn0h7AQbVL3bRpSwVWWyksepzVjyw39Irpjy3t8WGWqsBfqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788150910; c=relaxed/simple;
	bh=2K4OYdBn6JH6BbUMe3S8iRa7QaUbz2dz7Xs9yiDufBs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KxsGzrFhi8vSt8XrfCNirw/Nj0L69XpEi9QPVwGitspsCmx/jWX2+a5BVYJQO7IbhGyimfKRZW64HTlvJvhrQRd0o1ks97YABgzd0/oBhoAR6dVsldoZfwYa5PgbrhoekyezZTK1F6a1t6wBgAsVvsMwcW9navvtcFeV6hx5zfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lv4x2VaY; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lv4x2VaY"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2caced6038eso29812705ad.0
        for <nvdimm@lists.linux.dev>; Sun, 30 Aug 2026 21:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788150908; x=1788755708; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7eDTIpv2tuo9c5hFEI1wY3H5RV5KUp/pbjznvsnrm28=;
        b=Lv4x2VaYuCPQw0rUOUo089eeq3+9nToCUecaRk4X73PcAi9kV/kxvVd//6kcPNFBlW
         24AhvP7bEuw9jk5VI1SACf8C8JWiA98PRi49mIboA5aLhAFVZcqrMqQLV8aMqMehDIWg
         wUQOnqV4Yws+fSx3nYuHIOv7PR/k2MpLukZy2tgHN7M3MQd4NCrLffXc/8JFUM4N2jkz
         rZo5iJ5jAuEztsuxKAWs8e/wUmHnbJUE8jYw1sMYD7OimV2JxV3C7UUfiJLY/FmOq7V3
         KAFLBUqbYdSG1tDuj1hvIRNkUSAHh6QCDf+lxYDyTwEdtz/o4Z5oIJw7lGsaa35Pn7qX
         fcSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788150908; x=1788755708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7eDTIpv2tuo9c5hFEI1wY3H5RV5KUp/pbjznvsnrm28=;
        b=jmKA0fd3sn3Rwhjwnvjfpfl6nyMyEg5GpYM/YlX0q+qBpQciSmaP2y/k36MR2ZWuJz
         UlNBfX5S0eYYODLQWgbKwQtmcfYOAF0PscIUNYxthQMtM3WXazVQYHNUsnvhpbTKeoxY
         8Zc2Hdp+dlJ5hDgK41d6E+0alaeUGajvB2WMH/OTEARA/SnaArdWQTnQv9hRF1kNDADK
         bNCa2Mkj5rzJNjZAL0aR2k6frKupgmbgAGdfmDib9kd90GUXzYbLHjf/AaKNte0p2Zki
         dWxHfPXPMeuUEWwfjGPCdFsHWC2Gc+ZQVpuHDFjZkDNzR/NpxyFb+gfWAI2FFay11EUF
         ZHyQ==
X-Forwarded-Encrypted: i=1; AKwUvBz4TY4e4/9oXBxEd+uPCwJidukvpAwFjnc0k30KIQlwh28u7UMaL6AZtGqA7h2jUQ9p6b6wpcI=@lists.linux.dev
X-Gm-Message-State: AFuF++l9H4C6bG8xvagIRbgmbzTvjC0LBIBLzUrb5ShzGtGVPTDT3G3q
	RouT9Mj1WfFOnIIZtNxONmA8Wnxy5gNSdagk9eem+K1DYiTEdiF6slD2
X-Gm-Gg: AYBFou1QNRLYvUqAYNeyC3EN7B0ayhDbW6T48oHw4QnlQdc7Cyt4vMJvFyVmQ7LUj37
	lpZSs5Qvy7s3azTMe70x2uduHh2eDyHJe7RCaA7uW7d9mb2Duh7fGNVGVhEXfG6QjmZKZUDtyDv
	YIZxY8wRApimOn5oNV7Hol+oLnaOPxfDTpTNmnND4yjUHEiHoLz0UwQtCvGnNf1f5BnY1Gga4KU
	wQPBT4VxvWVimR9SzTD6q4pvOWjk3BJ5IdpAF4JuhgrFWlOIP5qT+hcTomiLmkJiwyD3Y3EwMYc
	b9uddwzKdEFpfgNI9wIOhaVV2z6/fJgrdhJIEACsd1ZFuzNxOnOLlHTy5++I6uVrryEOcH6o/Ay
	CxABgX7o7CgIOGAQvMi3Sr0in4IcdLS+DBraLFIEsP+HyDSkG3UkxaxJNYF/ZA+zHow0E2z9Hpn
	fPbYN9ZTsAKqEp3elAz3RmNUUMKQKSV0I7OqQbVsn7V7Hi1ZKt42ZOwC5sYBB95JPjLp7pqg/9d
	rsLi6b2IMI=
X-Received: by 2002:a17:902:e809:b0:2d8:d4d2:d134 with SMTP id d9443c01a7336-2d91b239e87mr37083215ad.16.1788150908168;
        Sun, 30 Aug 2026 21:35:08 -0700 (PDT)
Received: from volcano9f8e-host.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-328713b944bsm26991328eec.27.2026.08.30.21.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 21:35:07 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com
Cc: iweiny@kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] nvdimm/pmem: Release gendisk on probe failure
Date: Mon, 31 Aug 2026 10:04:59 +0530
Message-ID: <20260831043459.1298059-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pmem namespace probe allocates a gendisk early, fills it in, and only hands
it to devres once device_add_disk() has succeeded.  Until that handover the
probe itself owns the disk, and the error paths in between release it
through a common label.

Initializing the namespace's badblocks state sits between those two points
but returns directly on failure, so the gendisk, its queue and its bdev
inode are left allocated with nothing to free them.  The devres release
action has not been registered at that point, so unbinding or destroying
the namespace does not reclaim them either, and they stay allocated for the
rest of the boot.  Nothing is user visible, as the disk was never added, so
the only effect is the memory.

devm_init_badblocks() fails only if a one page GFP_KERNEL allocation fails,
which needs memory exhaustion, so the path is hard to reach in practice.

Release the gendisk through the existing cleanup path on this failure.

Fixes: 0caeef63e6d2 ("libnvdimm: Add a poison list and export badblocks")
Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
Changes in v2, all from Alison's review of v1:
 - Retitled, and the changelog rewritten as background, problem, impact and
   resolution rather than a walk through the error labels.
 - Fixes: re-derived.  b95f5f4391fa only replaced one failing call with
   another; the early return that leaks the disk was added a week earlier by
   0caeef63e6d2, when the disk was already allocated by alloc_disk_node()
   and the only put_disk() was in the detach path.
 - Says what the leak's fate is: the devres release action is registered
   only after device_add_disk(), so nothing reclaims the disk on unbind.
 - The object counts are gone, see below for why.

How this was found: reviewing pmem's probe error paths with an AI assistant,
hence the Assisted-by tag.  The finding was then confirmed against the code
and measured as follows.

How it was tested: this is a unit test of an error path that needs memory
exhaustion to reach, not a user visible scenario.  The badblocks init in
pmem_attach_disk() was forced to fail with a throwaway kernel change, a
namespace was bound 32 times in a guest with memmap=256M!1G, and
disk_release() calls were counted with ftrace's function profiler:

                          without the patch   with the patch
  disk_release() calls          0 of 32          32 of 32
  bdev_cache active         48 -> 72 (+24)     48 -> 48 (+0)

v1 quoted the bdev_cache delta, which is what drew the question about 64
attempts and 60 objects: slab accounting does not track this one for one,
as the +24 above shows for 32 probes.  disk_release() does, so that is the
number reported here and the slab figure is only context.

 drivers/nvdimm/pmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 30a51c365ce8..648fc7d66063 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -563,8 +563,10 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
-	if (devm_init_badblocks(dev, &pmem->bb))
-		return -ENOMEM;
+	if (devm_init_badblocks(dev, &pmem->bb)) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb = &pmem->bb;
 
-- 
2.43.7

