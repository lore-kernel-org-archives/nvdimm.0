Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFE8429E
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 23:47:28 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id 195so6043800pgc.6
        for <nvdimm@lists.linux.dev>; Thu, 03 Mar 2022 15:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BSvJ8k4SGcUg5weFNGj91FwzgYN4szFG8nOArgV3ZW0=;
        b=FI9b9Ea1FiI1RcWV0Z0A++sv6dLXsqkwbWGI4TM4T3sOWIcdye93LsCMpvl86ZJX79
         8E8QTPZZ7Z3wT/wwaByeFh7jE91pCoQJwBVNQBRcg1NS5a7zk+yVFBA33Bi+0AqDLcY+
         JvGHmRPZh2Tjr3/jthyph5sQAOaJdZoxzJQdvfU7HyUdW1WKlvRJGckRzHFY5p2Jq1+t
         vRMr+bGQrRVL+KAx+GtrfRbmCIroWJQnMpAAH7FobCr1keWe2VaMj+4MfIY/QaSAqOyR
         Yjn8EAH1g0MpRU6jBvcIEt4bpnf7sZxtbJXwbo0/fOdCmsIRpLdFw+8lyELRVx7YVKw/
         cBXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BSvJ8k4SGcUg5weFNGj91FwzgYN4szFG8nOArgV3ZW0=;
        b=HISgFNmkFzMctkuf85QZCLKIgAXIFsRYkq8HezOIK9cKliyCdF6v0SG4s2MCWEabGh
         oE/i2ot0VkpOnaTXeLNW1ZKMPrmk/pa3ZHgjw8T01dKvgYRhg42Vu9AHd5S91M4l5+7+
         kYs9OS/l4QefVkXYVRJQcGn4tbVKo4biX/bPfp5WUQnlomJF8pyTvJMocT5gpSsaWPfA
         DysL49o+xlNLW9rRHQWYD9Ai/bw0h+Z+VXAldgU62EzCAghCnyfWYsDmLOrYvQfQ8D4h
         vbuLD3Yzkxzpo97zGi1hqqMSN7lsergaBXev+EhJhcJAtDOwvEhqbZEUeFvsGD92bggb
         7jQw==
X-Gm-Message-State: AOAM530h4fgfGAyPhG/tPYCQn0uSagoJCclVdVkRsEOZXI4HeTwlISDm
	xe7Sn8UIY1qQSRlqlc0YxBvKi25cppyeECIRGEUJTA==
X-Google-Smtp-Source: ABdhPJz7n9nkrLlO//30Tg9zFXzXSAsfZE/u6pk24MSxbCOgTrbP+0ZPJrxJ0A/qEKVmhkx0NeqUYBxJYOjQrzhKmvU=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr32698434pgb.74.1646351247562; Thu, 03
 Mar 2022 15:47:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220303231657.1053594-1-alison.schofield@intel.com>
In-Reply-To: <20220303231657.1053594-1-alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Mar 2022 15:47:14 -0800
Message-ID: <CAPcyv4jMasdT84-DSPFO3opRitQBPemb8WkcPaY1DFr1og94pg@mail.gmail.com>
Subject: Re: [ndctl PATCH] libcxl: Remove extraneous NULL checks when
 validating cmd status
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 3, 2022 at 3:13 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> When a cxl_cmd_new_*() function is executed the returned command
> pointer is always checked for NULL. Remove extraneous NULL checks
> later in the command validation path.
>
> Coverity pointed these out as 'check_after_deref' issues.
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

LGTM:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
