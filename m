Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202504;
	b=W13UV0KcYzfU+RRRj1REpQV5Tt8cCnJAylNFrNTfFObIopMZ60CUYw9SAW+nPGEFPFig
	 r4orq8InapfF8Csqa0kdYTiesL+X7eZrXhxZuuzQ3ef3eOfbvmzFp5T+k9Wu/Yqw2QlES
	 U4ba6UwdDVmoRp4ykzi4mRys5MN8USoI/Y5DHk6WGmlUz2ouhQ3kR1t5cQmgXtIhHo27Q
	 lWSMFv4RXtwFRW6fsHrqSe71sK1qLaYnKVtAsWiP6zhSWR6ON3JjdzC0wac3fQP+CNkGQ
	 kapomZ35XvvdaE5iQhBDD6nsRAU2OgO6CD8H7ji+Ux/JWRscnTSARBu9KiF+6UqWc/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202504;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer;
	bh=195IjFRuPfqTqT/b0yTQoHpHUjVdw6NRNCX9zfuEHAk=;
	b=nb2iqKELcDu5aeLrWiOsQsIIkNPJ5leGh9xgJOfnL2vK4oo4pwnZa0Q1fz5CCQtWaX0g
	 1qRBfaa3vNMxKtGGZ8VMlMcSbwcEZneILamYSWJI2SW88HceOHn2Pb9+35hsKvpZ0Z5NQ
	 SYMwvEPLLK/qsz2u0J7kUb1wMJoMd2W43t+KiUKlzzYlZhjUk1kfkTmKa8am2GjbxwC52
	 9Wh04pqGoLS+L0CnhL/CPrZvDXeEGdeul448fAq1m3iDiLmVYScYdMvE4LPvse6clRAf3
	 gRsHGln1qMlNa/s13nq/3kgK6qRb/TACB1DCMJcNQwuqay3yKV/Uz4iFEF9NtdNl/ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b="d/aHatwP";
	arc=none smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C066606A33A
	for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 15:48:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C066606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=d/aHatwP
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b167ffd132so1980363a12.1
        for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 08:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793202502; x=1793807302; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=195IjFRuPfqTqT/b0yTQoHpHUjVdw6NRNCX9zfuEHAk=;
        b=d/aHatwPzozx4GZ/bQRgfGMTrMOeLQXTnthJOkRSP9UFBt7yhb8wu4GdQMQmWqLqa7
         dOKOOwMm4C3YCnU9Fj7KL5PUWkuZyEb3QMKbRypuOg9V/HHwvDlC//6ml3JveNBFvZCE
         5psakh3nsDdVAt8f1t2fnZ78nzWJ/ZYfktqTCC5jJxjmZLTCfLw3nOgx7XzMZ42PWWrf
         +cJeKAsrdKOYpDj83yUqe+NfThYSVbkMppojxP03CURwegewxtZ46ews7DiYJQzwOhLI
         AUwz4dqbKh7S7swObhd/NSMwinT7tZNhih1iwpd+a0M4wdHC+4/51B83IDw9ABWfDtrr
         VgQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793202502; x=1793807302;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=195IjFRuPfqTqT/b0yTQoHpHUjVdw6NRNCX9zfuEHAk=;
        b=FHjJSmAaI3ao3DfhotPG58BuFOEDrhmT9hson3uIUu2dPtfz3rShTiIif9djx55Xos
         aaY/aXOqku6djpmrXvlgD5S97TnkhiN8jRzlPLWlXkzwdsB4N9ewf9gmh5PzRX6jjZ0c
         SIqWNQzqbaVi0CG1549iGVOwKjn6eLM+fxWCGLAorMOV0zmkRIbMadOPdjNTJ5bn+p3u
         3S1hkblrE3625Aie0adEPpPmOZa5w7s5FYeZ6TlcS6s1jgA+AY4W/8zFq0K3P0cuQmBd
         l0qh3Sv+FXI6l4Y0bA071tZZ7FzeGvlxXZuy5U8oSNcLA/zOaXZ726qVui/HTHAt1ua6
         LxDQ==
X-Gm-Message-State: AFq9FYKH73+/r09Pm76cR/EKJitoCeeaeYTMA6r2tUPCP0+V9bfzxk0B
	4n/Gn62MpDK/GGSfLdyHmu78IwVIlY8yx8Y6guIynGfj1UP/Vs9UArMlItfaXPrZNoyNmJliiEu
	1Z7he8UQ=
X-Gm-Gg: AYBFou1hDYsThnnbNVHrsSMmNKRq1tOPHRFThLFKpVnNdskoBOitY5duu8vfRHGAU+p
	fXblpizFP9LzfHrPswOhuludeFkKTaUUGxWIBV3Krl9RL3WnkoYZe6PGTMAn3SIRn7wUpLDXFS0
	nS5ht+4ELudMWd5DznqX+aCSXJ2ssQ73JbuFI8+5DPKak9kWST6vtgU2aJOPSAOxK6Fx24Knb/0
	E3wPoRQhnCGKePbj+OX6mWEGiXR1KkYtNrjEn9zyJI8FlpwroH/FHVyJ8x86ZQyyAjVvk/s5AZA
	rV+Xsbr/TpfLAQkMlcSGcWVTcndp9pEj4QtVoBXU9kFP/EbkYF5oQov3c368GfPqEBWAQNAYVIg
	j9PkdjLoHIhqPZUJPrJ0WhrKF8dmTX8x+CbB9AhVr4U6sn56aEtu1rPahbqRJF82+Z9nPiP+w6l
	SsxlhfPhtaSfdhWHOzjRsCzSXKQVio2BLoFsD/SpThVBHdToRj2ClGzSOM7LsIAXwGMOmc+3W3H
	MMhAPIlW58zWpZR8JjSr7gqCT9FC7aHpDr0OgT0a26Gtj/X88ot5pJYDCU2CDjvbQkpgzIzsoEU
	RiD/IElFd7eV9Qyd+zWOKw==
X-Received: by 2002:a05:6402:2753:b0:6a5:fbc6:cad1 with SMTP id 4fb4d7f45d1cf-6b49cbcebc1mr1982963a12.7.1793202501767;
        Wed, 28 Oct 2026 08:48:21 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:4e::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4964203bcsm1672508a12.23.2026.10.28.08.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:48:21 -0700 (PDT)
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
Subject: Re: [ndctl PATCH 1/4] libdaxctl: handle mapping initialization
 failures
From: Gregory Price <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, Gregory Price <gourry@gourry.net>, 
 linux-cxl@vger.kernel.org
In-Reply-To: <7737e1406eb60677979d3b6b090d52ee124ebaa7.1792695259.git.alison.schofield@intel.com>
References: <cover.1792695259.git.alison.schofield@intel.com>
 <7737e1406eb60677979d3b6b090d52ee124ebaa7.1792695259.git.alison.schofield@intel.com>
Date: Wed, 28 Oct 2026 08:48:19 -0700
Message-Id: <179320249973.768545.15663374040316123591.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-22 12:56 -0700, Alison Schofield wrote:
> A failed sysfs read can silently truncate a device's mapping list, leaving
> callers with incomplete range information and potentially incorrect memory
> block accounting. An allocation failure also causes an infinite loop,
> hanging the caller.
> 
> Distinguish the end of the mapping list from read failures, reject
> incomplete lists, and discard partial results on error. The mappings
> describe the device's constituent ranges, so validate that their combined
> size matches the device size. Return -ENOMEM on allocation failure.
> 
> Fixes: 5a31bf710399 ("libdaxctl: add mapping iterator APIs")
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Nothing stands out to me, this lgtm. Did a bit of testing as well.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>
