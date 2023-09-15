Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0C523DB
	for <nvdimm@lists.linux.dev>; Fri, 15 Sep 2023 03:40:52 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-68fb6fd2836so1537785b3a.0
        for <nvdimm@lists.linux.dev>; Thu, 14 Sep 2023 20:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694749252; x=1695354052; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wc99nGQEALaOKSDIv77AhBK5hwBb20YJz7YOm9x4L4E=;
        b=lZqbP0Kxm9fUq2iQ+MwWItINSjL3QC84/f4Am8GVVtY1QlBt8N+EZDY6V2SDnpJEzm
         jAjzsBLqP81vS8ePBDBo7cDf8V81+8XkkpVuy/cIrI3dj1zjDf7mMA+BqdEmBMbWDZ07
         z9rh6vvAvkMpDi+8K/S3fy0trxammLbY3yO/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694749252; x=1695354052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wc99nGQEALaOKSDIv77AhBK5hwBb20YJz7YOm9x4L4E=;
        b=mNsR/eZJoHSrRYhBJUcGjJPK+noEeN2ncfnll+iZrS8EeJkAa1Nfg2WCAO/EO+doLe
         xRIVeLW2mTgsLBhPRPs9+/pc1agpP94ad23NCqdW0jSVc+Lrx7CjUjzUEBuJekvP1EBR
         CHkyc57gEvEb5uXfV7piODm3vlqpiKuppmzbKPlUlrIQX7Ix/Pf48VeF4mQvRxnlhXGh
         e+jLdvx5gmJIjiPIa6L0BsKkuzRhGu1Ec624M5pNFFxPi1hDNP6c9NrKDTG6iH9lTpV6
         QjbSA1VojNK10hpW4hQThCn35SC6z9R2PbE/0FlJ8wiW6DddFM2xqw/5UkIB6gmapjU3
         fJmQ==
X-Gm-Message-State: AOJu0Yx1PcaIMaT8hgstjOgYOIlLhUfm+3OIrM853Rg1ySCc6poGTE1i
	LPUYmBh7d+rQveRTPkiSXXkRoQ==
X-Google-Smtp-Source: AGHT+IGUVQH82U3M6N+LIrmpbwDAgOk8qDJI3k10x+RZOm4I6k7dxUmPvfPK9RmDvzM1gsHxP/20aw==
X-Received: by 2002:a05:6a00:22d0:b0:68f:d320:58bb with SMTP id f16-20020a056a0022d000b0068fd32058bbmr631169pfj.8.1694749252213;
        Thu, 14 Sep 2023 20:40:52 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x14-20020a056a00270e00b0068fe7c4148fsm2016065pfv.57.2023.09.14.20.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 20:40:51 -0700 (PDT)
Date: Thu, 14 Sep 2023 20:40:51 -0700
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] dax: refactor deprecated strncpy
Message-ID: <202309142040.7FCE9E230A@keescook>
References: <20230913-strncpy-drivers-dax-bus-c-v1-1-bee91f20825b@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230913-strncpy-drivers-dax-bus-c-v1-1-bee91f20825b@google.com>

On Wed, Sep 13, 2023 at 01:10:24AM +0000, Justin Stitt wrote:
> `strncpy` is deprecated for use on NUL-terminated destination strings [1].
> 
> We should prefer more robust and less ambiguous string interfaces.
> 
> `dax_id->dev_name` is expected to be NUL-terminated and has been zero-allocated.
> 
> A suitable replacement is `strscpy` [2] due to the fact that it
> guarantees NUL-termination on the destination buffer. Moreover, due to
> `dax_id` being zero-allocated the padding behavior of `strncpy` is not
> needed and a simple 1:1 replacement of strncpy -> strscpy should
> suffice.
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Looks correct to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
