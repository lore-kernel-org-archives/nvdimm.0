Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793222561;
	b=wbGosH9ie4VkjebkITj+AMeW6AuUQU38KtWRSEVtmhj3rpdbV7Ih39iWCxu+kATgT6zk
	 /4fbYLeDDi1Tvd19C9YdwSVeYTLdRwEBGZlio3T2NwQvBlXU3ShzLjLIuJCsU8SBtEWaS
	 JStrSllFoegfOZNcuDetoBvgZjDHgu1xfsMi8gi+7r9p7G689i7nlXxfQuNHbiJQihvrH
	 gBLzCuTHcVzNtCH8gvncPGiilj5Zv0LCzTxf10decZUjn0uEKJusNzKAYXGB64Ou64T/n
	 316ypC4om2kyR3+e8Rg7WrqBR53GhFpp8DAHYlvkeVtsG/QMNdmH50UxJrt7whskI3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793222561;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:Content-Type:Content-Transfer-Encoding:MIME-Version:
	 X-Mailer;
	bh=WMki2iGDcWIUAFS2COZpWEg7kj0OK6Yz3Faiyp7P30s=;
	b=E+v1Ffo6Vof7FtXGPnROGfT2MnwA/kVEOcn/ZN+yhgMhKaS4E1Q7WBNxLVKp0ese8kVm
	 e37Y15knlZn4H/mXjmzxoBwB0cWT4pTenwyAldj9Byt4jawVriFx38hPy/BGJEipOKSs4
	 c0oVEHdB+1iYkOc2GLdBivBWs3IPK1ruy3xI9B/7b+k0NXUAvs7rc8Mh6j9IC8biND104
	 f0VC85HjB67VsvwQ9pmyUfzbZW3ZXDldJv2pqlQpXSqeZj2W/HhEW5e6f7obXXT01uUfV
	 0b4Xwp+CuZWhxpIJDZNsX4A5bN3zfRZvvuwn5m12nApJhWz9by9IDGlWyU/czbdpFcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=DiTvBM4q;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB45606A31E
	for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 21:22:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EB45606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=DiTvBM4q
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b4a13789b0so166294a12.0
        for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 14:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793222560; x=1793827360; darn=lists.linux.dev;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WMki2iGDcWIUAFS2COZpWEg7kj0OK6Yz3Faiyp7P30s=;
        b=DiTvBM4qOtcQEHTP1xA5VwiA9kg27YCP1fekB3KR+4mW+hGZAv+324ih+ib0gT8cfT
         gWbneJZhRMCfCvxoR3dzWP2AsMECHcoWlUx4zedXVeX1cczeaAFjMxqi6nRhMN+B0Oeo
         W/HZmn6UTWfIGmzC5/P0Bs8jl520PhjDcUkOV/+e2e0ISQ806JGv5tTSf/mFo26C+WV4
         npY7awv+FoHZLBaThsokI1eIJcdC6wZlhjT/bqUWJMJY65OvmwvMfuiipu+VjeWfkuc7
         UdQgQYvGtel5fgp+s0gSDo88jTb13yuNtwQeCSWc2WgKSCWySRKDLdlfOX3H9A2Obh5v
         12dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222560; x=1793827360;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WMki2iGDcWIUAFS2COZpWEg7kj0OK6Yz3Faiyp7P30s=;
        b=Fr+vhjrzmMzuBls486UaExXyvqyAlrruin2C/lMUkXGFVICuIsQb3eg5vd8p74USdI
         LaumBZuJJMVIJgsDv1pOQWMujS8qe50TcZDzH/GsWfOvnGx6sXG1tX//xr7KODCIZqoE
         WJqZbzDEqHqMWZzTOctbxZvTiAsLLJ71JsSt5nfwTfY9BrQXVQlV2dkgB5oqHD6QX+lC
         rVR4do3THFghT4FEEQ2UILVNIBIcMr9XAo76g6hmKgHPKdM+DxZkhuOAL+ZdVPbDW1Zu
         T6CAm2gkmhRU8GTAc4KU6D3y738kST7haQxkzcY3yIVQwG/ZCMvvvC6PelO+GP6w/W9w
         cStA==
X-Gm-Message-State: AFq9FYIHK7PZISdB0QK+XeF4ldPselASX9SwDiOC8p3kFtvU1am4s55z
	Ll/M7/zu80e7W5/KPjc7BGpSkizdN+ceDJw7xowkYAJPTwsMgJVitmlml/50HgsJtDI=
X-Gm-Gg: AYBFou1Agoii64wlfXQQx68jL+FH+zY+rEgbGvAORcitEsML0Z5nUWbabZPCZxdFb53
	ixOligk5RA7vMopvI7jbV/tfXY8fPDFs7kQ3hLmfHLpFxuU1WJhghTcqom2EJYHJuGlwpv/QAYf
	4S+XDAZn2iRCy+ZDChPAk6ezeiFhh60aCWgDNBSn9pTCooqJzSFfiYRv/15fQxo1akPUyu3I6f8
	/SoAuf79KLaX0a08wm6TMkQYtUbPVKj4B9GT9fUPKJS1cmfrxmzNBCPdrQsXyKQn0TOBtO/Bcvk
	+G5X3eMOqOOXBJ+Sh6zDahKRKzwnbN3Wadqsh0Bbqv0rTFekyCnTVPLwOzJPwzjx6XuafBLo9/T
	4cSvDkH3VKHsLrxsS0W/+RJGwrOD15ov6cgYQTW2p7wrhhGyMaR5kaqaIzbnvqU2e5wtQX4WbvV
	zp3xW40XZL3gBrq++kuF4xeXiUUopP2jXdMEF3OSzGnVuTlZIv+o5OHheg8oS1a3TbU+m0YZGhw
	YjF2NcUALuMyaVvjbTzDHEMHVg+K3Tk2EjFQ99p12wUZjVtPO0CFNNil8TjoEBeXaOnpoOdRPfW
	lex7Ac9Jt5yopNYDTQLv
X-Received: by 2002:aa7:c789:0:b0:6b3:e4e8:74ba with SMTP id 4fb4d7f45d1cf-6b4b0be034fmr390383a12.13.1793222559800;
        Wed, 28 Oct 2026 14:22:39 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:44::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4964488e8sm1911850a12.31.2026.10.28.14.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:22:37 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: nvdimm@lists.linux.dev, alison.schofield@intel.com
Cc: linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] libdaxctl: check the zone of onlined memory blocks
Date: Wed, 28 Oct 2026 14:21:23 -0700
Message-ID: <179322248318.3398847.13424413341337264007@gourry.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Mailer: b4 0.17-dev

daxctl_memory_online_with_zone() is meant to scan the device's blocks
after onlining them and fail with -EBUSY if any block is not in the
requested zone: an agent such as an auto-online policy or a udev rule
may have onlined some blocks first, into a zone daxctl did not ask for.
online_one_memblock() relies on that scan, it ignores a failed write
for a block that someone else onlined ("There will be a full scan for
zone correctness later").

But daxctl_memory_op() returns the number of blocks it onlined, and the
function returns early on any non-zero value, so the scan only ever
runs when no block was onlined at all.  Whenever daxctl does online
memory, a zone mismatch goes unreported.

Example: 
  memory_hotplug.online_policy=auto-movable
  reconfigure-device --no-movable -m system-ram

  => reports success with the memory in ZONE_MOVABLE.

Return early only on errors, and return the number of onlined blocks
after the scan.

Fixes: 0542201b5902 ("daxctl: detect races when onlining memory blocks")
Signed-off-by: "Gregory Price (Meta)" <gourry@gourry.net>

---
 daxctl/lib/libdaxctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 01b1915..f4b2fda 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -1691,7 +1691,7 @@ static int daxctl_memory_online_with_zone(struct daxctl_memory *mem,
 	struct daxctl_dev *dev = daxctl_memory_get_dev(mem);
 	const char *devname = daxctl_dev_get_devname(dev);
 	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
-	int rc;
+	int rc, count;
 
 	switch (zone) {
 	case MEM_ZONE_MOVABLE:
@@ -1704,8 +1704,9 @@ static int daxctl_memory_online_with_zone(struct daxctl_memory *mem,
 		err(ctx, "%s: BUG: invalid zone for onlining\n", devname);
 		rc = -EINVAL;
 	}
-	if (rc)
+	if (rc < 0)
 		return rc;
+	count = rc;
 
 	/*
 	 * Detect any potential races when blocks were being brought online by
@@ -1724,7 +1725,7 @@ static int daxctl_memory_online_with_zone(struct daxctl_memory *mem,
 		return -EBUSY;
 	}
 
-	return rc;
+	return count;
 }
 
 DAXCTL_EXPORT int daxctl_memory_online(struct daxctl_memory *mem)

