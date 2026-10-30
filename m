Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793323050;
	b=jAg+FP3t+VCzE4sc8AyHytkpfr3Ac2Q4hyC7HT5Jnz449vF/OoGELDkLH9sPeJxvyLgH
	 +MM9lmzK/ELw19bsGIvlpt0Gne+oO1dL55DKwJagCFyHiEaC+udbhDzXVpK1VRmiT53r8
	 E6a0PDTYGgZ3NZ9n+dgJ+tq7jy895tMr9GXMQ+DZxR212t93xVK1xXrJt2u1Pet/zzoyT
	 7EK+QjbhTxyPshG7rp8qe+Sctd3r89/XEJmiLZGJToN0d4PXoNohEIxc+ehildOe96QSj
	 nXiTMjXgG31UpN3UVJTbP5pygjhM5BlVph8dzQuTw4B6X2DrwB/zQpJeRTgyKCNv9IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793323050;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer;
	bh=WJ4DVaiAmp5krpfxroberXtVy1jbtY3DUs/Jn0ssYiQ=;
	b=o49kW3YOIEcR7zZA3UmrhEOKg19o8hJa92PRgqjfDUpxnqyYZMneOYaMyAvg62eABoX3
	 7Sc8r0eUhEBd6W/vNysDP9/3a7mcz0ceSv4WqrPYyviKnF6q91yckCSRG460pOu2z99Dl
	 M8uzljPl+HtG8SGnImI4oiDIYev2haujmakZO9K2KRt2lpVW619RtAzJifSb04LBSNQVn
	 mBm+u9hFwG0sTIaCIzbNLX8liNjqhZL1h5kNNmvWOp2TbZ1x1opR/aJKbckfNoiXOTh+Y
	 NbevWkuzNhDc0OIRjY59I/2DGCDcE+PYl1ugv0Qtr1Euzcs2NGC/wYRCwjaivBfKdCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=qN+auRK4;
	arc=none smtp.remote-ip=209.85.222.182
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5733F606A31A
	for <nvdimm@lists.linux.dev>; Fri, 30 Oct 2026 01:17:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5733F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=qN+auRK4
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-943e8d35f74so13095985a.0
        for <nvdimm@lists.linux.dev>; Thu, 29 Oct 2026 18:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793323048; x=1793927848; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WJ4DVaiAmp5krpfxroberXtVy1jbtY3DUs/Jn0ssYiQ=;
        b=qN+auRK4qzHPHwsTXt7SRycRlQpEBWoUeT4xYGVL0kFMv5v0b5GEwn0T0wk7VFWpN9
         OjFONz/v7Vv5ZD/kRsWLB0+N8Yurc/DVSL0IjE9HW2h+azlyBhUbI6VSaOKEDG8hId+P
         WQX4YsUD2yhOnWTv6/ZRVJUWPsuiQM48ymhiaH7NLKC2/rad8iBadXTmmPl4huyhqBfc
         hxhCtInSmRKegbmxJMrphJu1hDxe2q521utpZWIZLViEEhHF6KWHPmdDRZA29J2iFtNG
         JQVi6SfdSxAM5xbKora3Ld6k/sK/JFjy3dKwu01b1NPC03vR/SG4vA2NZJ2ISLjFAtYn
         qnaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793323048; x=1793927848;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WJ4DVaiAmp5krpfxroberXtVy1jbtY3DUs/Jn0ssYiQ=;
        b=QtLj14dCMrF+7ZcbucyIiV+FYALBWj/zIi0FXNghtfBXkfSZNTHCf5RwooSX6AkxUT
         T2rc3z61jdWe0dN12Rblqs8SduK6pOB/9ljKxa1J9BBf2GkaJ6RL7uYdy5T8UEgo1vkU
         DT5mAcdXDsBfYD3pr3asQmW8ljPJPlbc7pdetsmDR/cSYEMQd6M54DLhdL/tArI8ARUS
         s/91661vDCz0H0OsnHhAtH7OeAhMf5Z5klYnWug6xWk8hWSXhn8BpSK3Vh9XEiGFZtSP
         vA6cgM3wxDn5DbId9VeGDjFX5uM0mMaVkMLAjF1wTYf3eCKQeNXPGNuQeje0C6VSAMfW
         kQoQ==
X-Gm-Message-State: AFq9FYIRknq8CnOY+wf4jim+1avhxbqyZTsyV/I5hQzXcrI2g4KFUvzU
	TYo5QpHMbJo/zswDnfRNvZOvr6qpu8K+MH42fkmifxW/YJDos1AKUvIBxc0um/awpP4=
X-Gm-Gg: AYBFou2om8h5yJjeFAHyyzF529JRVLnd/uTeKNQE/+0xCWfEUM6235dUrFmwfPAqjgg
	Drf1R348orOYA2VnaMLgUz9oHwiWBpwlTVFeYTOwugvulYghwteNudeU79W5iuHFobCJMA+ktjT
	GwqcxQ2gFFpGmdabAsyGXixPQ1hrqt5y4u6phrEeuZe4xTrKLF5WYYwyzJ+5a+nrEGCqI4r4GgB
	f1C84JuNXkHuMB2F1O+6K9JJGcZBqDo0aCP/xGH/NdmA4oAZBOFf4q3F4QxwkjBkM+3wmtkpzUg
	95GVmkpkIpanJhWnvKA7zahAVtXXxwbUCWNLYpb6YkKiRmxqPhxFUvj1sVVtScxz6VESDS5FJMs
	hqE5JnYliorwWOXqxTFtumG7hN9MK32NIbngcs/yKbLizaqbtzOZQB951nISIXoCC+Z9sM0QUwq
	d01FYghhGFFU3fcroE1VImHfjqBdShjitQf5Rl0fL6Pq5QMHaM38MGGAbi4HGyQHg9NhwTP0sV7
	U6RnQE/ew96UVXxyvxF6vsxYjzweoHVBQ4G6lA/1KYJKrvR0u2fuVisianfu/t9SDfZslEoJF9i
	Bz0XuvIIpl+5moygN1R8B9/TgMcweUjHH1XTglDA1aI11xtFu7CigIjFdEUk6CPNNKdGY4gaa7i
	o
X-Received: by 2002:a05:620a:45ac:b0:93e:c12c:f121 with SMTP id af79cd13be357-944218577eemr157290085a.77.1793323048156;
        Thu, 29 Oct 2026 18:17:28 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca805be18sm1291836d6.31.2026.10.29.18.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 18:17:27 -0700 (PDT)
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
Subject: Re: [ndctl PATCH v2 3/4] libdaxctl: match memory blocks against
 each dax device mapping
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, Gregory Price <gourry@gourry.net>, 
 linux-cxl@vger.kernel.org
In-Reply-To: <730b33a1a2d7b4e6b3f319f459bf36f5fd901906.1793315621.git.alison.schofield@intel.com>
References: <cover.1793315621.git.alison.schofield@intel.com>
 <730b33a1a2d7b4e6b3f319f459bf36f5fd901906.1793315621.git.alison.schofield@intel.com>
Date: Thu, 29 Oct 2026 21:17:27 -0400
Message-Id: <179332304704.1311000.8174376858031226516.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-29 16:44 -0700, Alison Schofield wrote:
> memblock_in_dev() treats a DAX device as one contiguous physical address
> range, even when the device has multiple ranges separated by gaps. This
> misses blocks in later ranges and may incorrectly include blocks belonging
> to another device.
> 
> Memory block counts and per-block online/offline operations use this
> lookup, so daxctl may operate on memory outside the requested device.
> 
> Match blocks against each individual mapping, retaining the single-range
> fallback for older kernels. Reset errno before each readdir() so a stale
> ENOENT from the mapping lookup is not reported as a directory read error.
> 
> Fixes: e8bf803e359b ("libdaxctl: add a 'daxctl_memory' object for memory based operations")
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory

