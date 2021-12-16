Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB8C29CA
	for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 22:37:28 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so782814pjw.2
        for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 14:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nd3FPcpscBUa+ixszVwzQhFJjxVxW1EhW+dsi5kR6FQ=;
        b=HQaOP5AuZVZ1ZSEomyfh1haFOjdiDuxrri6fN182bKqvXbkeyNNQxCFbT4o2Fud5zg
         agdLJynGiiwzpLNm0LuiA62O09ECCl3ev8vAkPt2eb486x13lyCXRWX5C3dRvoPynZxP
         Fq20Fe3DIvSpwmoeGwN/02yOGYWPQFUHDHj2zwUO8+M1ZaP7zqKuqY1vXhvcFYOIZrJp
         c97mPZTZdJkkERc+BP7RAxu+IT4Xi+1HpafcGWJDGdpZZLPwxR2Gudu6GjDmL4c9aFA+
         ycUtbZOJyTltgm+lpXe54EzeY77pXi04VE0R2xs7E0NgumJcnwZXcMjXiaPuxADJPxiP
         jxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nd3FPcpscBUa+ixszVwzQhFJjxVxW1EhW+dsi5kR6FQ=;
        b=wt4wSdGD+R4dQYn6EVcYHC+9O0Hu3fLZ1AA2BnmVSHxPhx8uVJhfFqMW5A7DBAj/lX
         HOnKzZZ7g8AbvgNB/saU7815TtDVTt1QP/zWtZWTeIecJYYXtzRaeXGZEbLwBifcDFio
         OFmfrHWmJjACbg3jlVCZIvmN0agTfskUhJCfJvxwOZpzASt7BrWFE8Uy+sWDY485ksqn
         IPiPwiN8IDadvnR+k3qInZfVypH2iTKuiSwGH30+qrVsqRICz5EgfXpNdHpkPqa3cyDx
         PYrNfkIl8uttNDRqllmWmHGmi3YWLtKBQAJRCZRA5gq8d2ztu6CqHSTpeap8vbCcmiLR
         5gcg==
X-Gm-Message-State: AOAM532/FlyWUhUSFvLyUsfP1kNFGN5HL8isFTjozzPJTEVHoKOOAStM
	BYSgYG50SITX4Bto/HU6jOsi3xbl/XFhAdWU14APPA==
X-Google-Smtp-Source: ABdhPJzKp0BPeJSzhI4Jl/h3FT0Zy3py25nsFzvz1/9Ik1KM8cAgT0fsnwSRZzEAKFDBvtwEU+kZjnkx9qcs4eKd5Zc=
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr281723pjb.220.1639694248359;
 Thu, 16 Dec 2021 14:37:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211210223440.3946603-1-vishal.l.verma@intel.com> <20211210223440.3946603-8-vishal.l.verma@intel.com>
In-Reply-To: <20211210223440.3946603-8-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Dec 2021 14:37:18 -0800
Message-ID: <CAPcyv4hK2OdUxR5LPXe3WP_DQ5JS1V+=Y98tRF4Gh3aBjiFEvg@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 07/11] daxctl: add basic config parsing support
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 10, 2021 at 2:34 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add support similar to ndctl and libndctl for parsing config files. This
> allows storing a config file path/list in the daxctl_ctx, and adds APIs
> for setting and retrieving it.
>
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Reviewed-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

LGTM

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
