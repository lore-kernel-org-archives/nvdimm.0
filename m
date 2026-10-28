Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793195748;
	b=nR+1X9Le1WjyY1uJGXEC5nKvjLZpBesAF3dLLAT40+NCbDC3o3SBdYOV5wj4e3etQYek
	 fv58KuM/5yJiVu1OeP2hygZgSB2f3vjXHm1pXprEf8BkQEdp2w52SFJyOP5ZyhT0vGu1Y
	 pPU7UkRrGXzwxnO0fzZh/QSo68dhMS6AfDfB6WCpqJi3mT4dT9N7VlvEDG5MwKn7qH9mA
	 E/utpXSChbUpEQfY3fatSyzLVh6TXseg5a+HDAFHTCsfY/o6qYjHjg0tWCZyijoSY9DbF
	 FG4lYrpEfbUc5f0IUE8y8nyzEOLSmLLypZiP8MjSNVJfQfrAL1bvxV8mguEsjRxcIOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793195748;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer;
	bh=FTua7rg4GDko5qmXH3XgkgEw8Vao7QVw3C0DynZlLyQ=;
	b=yQNrCikR30tcuKkG2ffSxgbelnMml+rXWQ4PY8LV7GBGELwTO0IAsyGTE8RXUhH4Hl7W
	 JHcDw/1D5VwhlObQI4BWXtwWX7fi0MbtgKy/Agfd3qYBp7kkmumZKbuDVh4sOJGU2ZZvk
	 bL5FnSu9sRO8sOwrTQkZA1DvhZe0uZVdVdVi0aCvClC3DqbvBaXHCMPCITLJ7oREyP+F+
	 6JnygTsC+1UKh6EKk0VCNvpX4vPYHCtaVJpUDGJxnmKDrWp7/ARUGeAFpTo8vgKehVh1O
	 JoAuCBJLTv1Jmj0VEVoPKnjye3JHQedNfmUoaW514/T5l2jvyducYax5Z0qYutCksTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Dq3rN9ww;
	arc=none smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418F4606A31D
	for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 13:55:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 418F4606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Dq3rN9ww
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b1ab2ad719so1222738a12.3
        for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 06:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793195746; x=1793800546; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FTua7rg4GDko5qmXH3XgkgEw8Vao7QVw3C0DynZlLyQ=;
        b=Dq3rN9wwhhO6ozLBU2VV2xTURIoNXXj13Pf5UUTlZN6MPqWDZ3FI3C0VG7U1CIX8NF
         rv2zAtA5N0dpFX2X0+lWfQxTUqEGuNh2X2D+rBw3BlX72wu3njpwC3U4oEPIgwsUfdhh
         TCYJPQJMj/4YztRfRncneUTY0SSkXKn8RbAcVo1KmEw5i9rd5GZJQ0AXbT1dNWbsoMbZ
         5Gv5XcPKMHH4tWEu1sTPi5xYtW24fhZrD8QApeUlwQPQfzHPzO4O+CoWERbKzFkWOhIr
         XBNRIPevkG6E3ryQpEuJ267T3y+6cDn2YWCLXI3mD+b9FkbJbFrvLaBRAVQl9AcHdmyg
         do9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793195746; x=1793800546;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FTua7rg4GDko5qmXH3XgkgEw8Vao7QVw3C0DynZlLyQ=;
        b=tSChdhq7mwmKRZBxWqDPXCOBR9/HTwBIGDCvnJN9DgAWUw6h8AsNRJ38DxCyDZKAin
         vhG3siPgjKSyn30C8Z/OwzQnZGeG2ZZoDDcqc96sWx6b6C3qedc7LvOPZN7VLhg2KrXw
         IDI6XE/2fzY3cnUblZZe4Wjq92U9NhRUMF2hcTfkl1rdH83aRHh2kaGKhJ8HO9QGC5Vk
         mKd6K3TSfWhof/woKoPXSKktmCWyphfeAJIVJvxGY8iRvwtRgMP5TTRrTPyabQnpj2nF
         Pyrlp/NR/J5LvwS4GQLYdWWiyFZ3LxcRF4dLti3Bg/Plc27wlj2a4Pl//Q0bMWsycy1y
         H4lQ==
X-Gm-Message-State: AFq9FYJE0SXQrhG70mddPrnEPBAMa34npdWcLUKtRrqWpR/QM5TzBP+0
	mbDEWFr2GsNDFXKrE8XJir2sXKEINo62nz9N3BcU/88ww6/UAGC9bb5mNqslKqi71MpoG1HyGi+
	n22iRe4o=
X-Gm-Gg: AYBFou1lrT2dr/0P3ojJWcaoBSMp/0bAC9Kkd0SVf9jNTYQ9DLKiS5NGknoT/TF6Hus
	ioywxB77YP8BC1XxF8NCMqeqCP03bpHN0dewCkwjMfbe9lGDfT6l1S11uXVa1CVjNAp1UuwmZlV
	41cddAtVi/bLJcNus9nlqcHqHVBORTSgLJCbYBfzgRfi4ZlR1DC97y+l1So4O59YEgsRzTIBm9N
	4X8aRtTMA2OifXIYZIKGnfkTknfA1vX3BgHpmBvJB3/CaAbtyITp/SZLilsue51G2HnZtFZtyC/
	GNdd0Bqp4ms8mmM0yJrtNRUSmuFgSVMu6LbW8fYCSOehJ7kEogrBj5YL00I4IfFvZtecMW5ihQL
	6ICYhWa4xL2eaD+LKwPsPs3YCMdP+Foz2A5WCFubhzs6oRts35UO8gNJX8HrWI9t8c3GzvN4vec
	GlJI+pLTj8tXtK3K/E/k53fKxfLTVCk6b7XbQ9xVUClsA6nyhDdAvnRY/tM50g5e1I+wk/B1nZA
	pkrMi5V3oIQLjzOv1ZKrq4UP0JrJGN3u56tCXLKQwxAiRVSOQiSSavnx8OWamHfAHNzlSyD4xfX
	weAUYeOPcFttOv0dT50=
X-Received: by 2002:a05:6402:518f:b0:6b3:8018:7643 with SMTP id 4fb4d7f45d1cf-6b49cc2222amr1744746a12.45.1793195746374;
        Wed, 28 Oct 2026 06:55:46 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:4::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4952e380csm1585500a12.0.2026.10.28.06.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 06:55:45 -0700 (PDT)
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
Subject: Re: [ndctl PATCH 3/4] libdaxctl: match memory blocks against each
 dax device mapping
From: Gregory Price <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, Gregory Price <gourry@gourry.net>, 
 linux-cxl@vger.kernel.org
In-Reply-To: <45bcae14b4f665af8427ebe38afdb9eff282bacd.1792695259.git.alison.schofield@intel.com>
References: <cover.1792695259.git.alison.schofield@intel.com>
 <45bcae14b4f665af8427ebe38afdb9eff282bacd.1792695259.git.alison.schofield@intel.com>
Date: Wed, 28 Oct 2026 06:55:44 -0700
Message-Id: <179319574485.768545.678014460424399236.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-22 12:56 -0700, Alison Schofield wrote:
> memblock_in_dev() treats a DAX device as one contiguous physical address
> range, even when the device has multiple ranges separated by gaps. This
> misses blocks in later ranges and may incorrectly include blocks belonging
> to another device.
> 
> Memory block counts and per-block online/offline operations use this
> lookup, so daxctl may operate on memory outside the requested device.
> 
> Match blocks against each individual mapping, retaining the single-range
> fallback for older kernels.
> 
> Fixes: e8bf803e359b ("libdaxctl: add a 'daxctl_memory' object for memory based operations")
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  daxctl/lib/libdaxctl.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>

Ran through an analysis and testing round with my clanker, seems to want
this fixup.  Looked reasonable, just passing it along.

Will get proper tags for you this week.

-- >8 --

Counting an unplugged device's blocks can return -ENOENT when its node
still has unrelated RAM. mappings_init() leaves ENOENT after probing
past the final mapping, and unrelated blocks take continue before the
scan resets errno. End-of-directory can preserve that stale error.

Clear errno immediately before each readdir() call so the final errno
check describes that read alone. Errors from block operations still
exit through out_dir with their saved return value.

This corrects "libdaxctl: match memory blocks against each dax device
mapping". Returning real node-directory entries with memory entries
last reproduces the error in the posted series and verifies the fix.

---
 daxctl/lib/libdaxctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index e106fff..c154db9 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -1716,8 +1716,8 @@ static int daxctl_memory_op(struct daxctl_memory *mem, enum memory_op op)
 		return rc;
 	}
 
-	errno = 0;
-	while ((de = readdir(node_dir)) != NULL) {
+	/* Helpers may leave errno set even when a block is skipped. */
+	for (errno = 0; (de = readdir(node_dir)) != NULL; errno = 0) {
 		if (strncmp(de->d_name, "memory", 6) == 0) {
 			if (strncmp(de->d_name, "memory_", 7) == 0)
 				continue;
@@ -1734,7 +1734,6 @@ static int daxctl_memory_op(struct daxctl_memory *mem, enum memory_op op)
 			if (rc == 0)
 				count++;
 		}
-		errno = 0;
 	}
 
 	if (status_flags & MEM_ST_ZONE_INCONSISTENT)

-- 
Gregory Price (Meta) <gourry@gourry.net>
