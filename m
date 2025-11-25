Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25A02459EA
	for <nvdimm@lists.linux.dev>; Tue, 25 Nov 2025 13:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764078850; cv=none; b=btMrfGpZdzyOZ7wg/fJHVE41zv8WZt+HvpF9AZhK+nYRG09kG6WaOEuHGrlhN0udkgGaOwPwuBn4W6LyG1I9PK2dWP2U/zm6zR4IBlDCPYNBm7eQhRq2z8WOUzf74ZLEgGA71bwyDZPg5+j7WAaISIFpREYjxkEKmALdZMl0mVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764078850; c=relaxed/simple;
	bh=l6KJEbEVM5y7rexEcKSpqScYa9AjmZUzszGRaxbfMbw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oNCXp3DI/T53EDoVtv7PkxgEyzw8lDY0x/WPnBroU8uhZE2fdsA0JwpAMMOg1bcGg4HW+qI+Hh8IEeOL5nxFMamZIIJ9vJQpm3JtaHf/rdsEQFHUl1t4UT4KLNS+2qa/2lMIxal5kFoNQDbdOIWQAlq9EnONMBuYoC1DK7wox5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lRCpbtVA; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lRCpbtVA"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477b1cc8fb4so31678205e9.1
        for <nvdimm@lists.linux.dev>; Tue, 25 Nov 2025 05:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764078847; x=1764683647; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PfZmCnQkSgXm6bGG1U92mqMyyCoId2oi/fIXBdd/gDE=;
        b=lRCpbtVA30DXLRQoqJ3XUkrac4LSbPVtyisaDpihMroW+Tbyd6XAeOpQrmTXRYsbLR
         A7P/QQlWoMTTmNEqm84tI7eTJmcJ0acF5/lOXCvtuLg2nJHuWcjcXdZmkjgk5Sy3o8+I
         ZatxEFY8mrvlIb7uM+fc6iAkXayKd4nIO44cLKOMVcb2BrxT3vF1AFsynaw7+Sn8VHGW
         us9gyPaIVfbrZ9vadLt6Uvt1GtDLGEtKkQjEK9WmXew3zjDhTWQB4YwnGNhBXrq7qDDQ
         yJVC6VpR9fEKGWqpxgIRTvof7Gz3SN/R3+m9kBwrKDbt9i+Vrkp2cwTOwtsJegsZjwpb
         ynBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764078847; x=1764683647;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PfZmCnQkSgXm6bGG1U92mqMyyCoId2oi/fIXBdd/gDE=;
        b=D8ei5lwzwXIvElWWRhucRo4r8HsSKgSVT2j0NqdFRudoD2z5KsBxBzLcWWAUP1SfJK
         DgwGtF/Xsda/2EvM7JLd7gpA3vk5j1TmcIeX/+GkcXoL2qm7CgfNqAYgs3S0vNtDoihF
         2nkOi9jO1cP4GI3jUPBgpyNaAaJgqp60InCnTaye3vbqR7hEOfFkAE41eETzx3TR7/fy
         q4FZ3M4BGf75k+3p0e8zfFu4f7KJV/skPCkMGmLgk+/soA5sbitf94FRNPzsiALK053g
         qUvffbrSrsFEgP3UsiBEfRJdRXzQxxcP0+bEL8dQQWc/GoeLoCZz/zAE6S1NFdMkXGfV
         GU5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUnH9InoqKoBaOVqNbu13iAvUc3LhMtSOIQqmNiHQcuK9U5qBUzBAN2pGWOjqkFHZXMWCAgY5w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzo3RYonulwYPWyMf6NGYZy7UxZskBqh3ZX4w6YEDu1Y+selLKu
	kfXc9sdN0Aa65lYR+ogqRKdIKs81i/St+Qb5TGkjTqWZ+slwhLkHbMKBcubrX/kweu4=
X-Gm-Gg: ASbGnctg8f2aMIVdjjNJMJ00DPMsQ0G05aqBbDGePT/bGFuBd/+Am6JTDcJbitAIF2f
	+zMtz8IcPxbQVELEiew5zvtwy+ELbNHetpXIh7UQ7x6a0zUBjXwmTMCifc2UJvXuDaXSiGJ1QFO
	qXovXa56yejTMYYfKM8ok4YKBG9xFmEwAWWGcGRcTECt/lCx1QqeySPNosY2YWDGt+iOB0uSDQz
	3KOMS+rwg7vDTOsvhGr/GWZMOMIwnECoyjY95IVU9CwgRoClWtStd7Hc1P2J7nuzri7OKpFWNDO
	eFc78VDD5wfkUX1FquhuoV2qu11Im1vFnbXtY/wMlNimUGBEZftbrrelasOQPUB11H+oV61fdsJ
	EF+3WxBUzsghKDOaAdu5dJGWsupHm7zqzKAhCt+OA/fgx5wQ6b0wOL4CKQXq889MP+5oTTBvQ78
	WvjqNwpN6j3HjD3heZ
X-Google-Smtp-Source: AGHT+IE6Z/i4LBBFZymostPyZofb9RWGBQcEhAavUgAtLmc+CAwBQkdpZHZEouVOs2i7Ai+1mMZV8A==
X-Received: by 2002:a05:600c:3b9c:b0:477:af07:dd22 with SMTP id 5b1f17b1804b1-47904b24243mr26387045e9.28.1764078847095;
        Tue, 25 Nov 2025 05:54:07 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-477bf22dfc1sm250227535e9.12.2025.11.25.05.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 05:54:06 -0800 (PST)
Date: Tue, 25 Nov 2025 16:54:03 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH next] nvdimm: Prevent integer overflow in
 ramdax_get_config_data()
Message-ID: <aSW0-9cJcTMTynTj@stanley.mountain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The "cmd->in_offset" variable comes from the user via the __nd_ioctl()
function.  The problem is that the "cmd->in_offset + cmd->in_length"
addition could have an integer wrapping issue if cmd->in_offset is close
to UINT_MAX .  The "cmd->in_length" variable has been capped, but the
"cmd->in_offset" variable has not.  Both of these variables are type u32.

Fixes: 43bc0aa19a21 ("nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/nvdimm/ramdax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/ramdax.c b/drivers/nvdimm/ramdax.c
index 63cf05791829..faa6f3101972 100644
--- a/drivers/nvdimm/ramdax.c
+++ b/drivers/nvdimm/ramdax.c
@@ -143,7 +143,7 @@ static int ramdax_get_config_data(struct nvdimm *nvdimm, int buf_len,
 		return -EINVAL;
 	if (struct_size(cmd, out_buf, cmd->in_length) > buf_len)
 		return -EINVAL;
-	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
+	if (size_add(cmd->in_offset, cmd->in_length) > LABEL_AREA_SIZE)
 		return -EINVAL;
 
 	memcpy(cmd->out_buf, dimm->label_area + cmd->in_offset, cmd->in_length);
-- 
2.51.0

