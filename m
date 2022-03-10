Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC79D7A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 05:08:47 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso4203019pjo.5
        for <nvdimm@lists.linux.dev>; Wed, 09 Mar 2022 21:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vx3jrxPiNIo98gCv83TF5dMqDfpV8pYAw6iSM9f/F5k=;
        b=g/MJcp38patdOv3r8qxTwnp2zPKzdbMTTbWWm8bqFpWmkiUZ9EBt1NcDDtzBdNFEjE
         z14xUTv6AV8lVZOOK//7QzkvagSDHIDs0iBnhGb8ek/aRmvVq6sYd9K3U2S1rxaqXhhH
         n9twbc3yFgPv2WLcAslot1DG/Y93DfMoKFnmnA+s8/2cXlz3bxtmnmX5rGe+cjEgxqOz
         3MPSzhg1Mja+BFVKj4gEdVC4VnL2t7Dg5dgkU1JeiLNeDJr35SAjUa5YzImsmjJ1DCiC
         z4Tb28dqPA6j0nR72zj7MoyyDwW5k2H1OX/jMvhnpZ/H76NOtWksD7KLx7o8A+zixMzM
         0pKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vx3jrxPiNIo98gCv83TF5dMqDfpV8pYAw6iSM9f/F5k=;
        b=2jQNN0lfNjiHVF1OwECbjZ9NafZFH+EyJrtidTFrw6bw0ZyEU+lxAZS42B/qFh/1+s
         6YbInb4H0bvDS+FCGN4QwlhX3V42dF0aF8Zvb0GDRs/TgrZLM1MtbXLki42v7iBhDbpQ
         erzZZdMTFgEVNQ7ENrCkNUyQrQln8DNMhSLOrsuFnXp262M5DPIGuAMoKgOMFzpNU7rh
         U49c9SoebkRKovDkjKLM7A6EylAkcZaZRxsmNjsFgLjvk5EAoMGqv6UXwVrewt+/5QII
         8/oxOqFRGw91GtvaPu1jSo7l5jSX/XBLAICC+xJFj0FFqPO2MO1Q3EEvWMUhlCnLrWkc
         jMrA==
X-Gm-Message-State: AOAM532BUw4MxR2fJ/Y8psmm0K7o0UlACVoK0S7OTZNME+MorUNTwHvc
	MlwsuoNaUpgN9eWBTMxP3VvxFtThCMGFUnLXOK6K3w==
X-Google-Smtp-Source: ABdhPJwbpnJGBhGCvtGDfxVPB8IEyjhbA0Vcu6XL0x5iAF4lObLLmyo2alFAEC40PFkEcocm/pnY+n3EqLanhKPd06Q=
X-Received: by 2002:a17:903:32d1:b0:151:da5c:60ae with SMTP id
 i17-20020a17090332d100b00151da5c60aemr3299570plr.34.1646888927080; Wed, 09
 Mar 2022 21:08:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220304203756.3487910-1-ira.weiny@intel.com>
In-Reply-To: <20220304203756.3487910-1-ira.weiny@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Mar 2022 21:08:36 -0800
Message-ID: <CAPcyv4juDzD4W_xAff2CdTFzKQhqfFkn93Zo_4Mw23v+Rq=1+g@mail.gmail.com>
Subject: Re: [PATCH] fs/dax: Fix run_dax() missing prototype
To: "Weiny, Ira" <ira.weiny@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 4, 2022 at 12:38 PM <ira.weiny@intel.com> wrote:
>
> From: Ira Weiny <ira.weiny@intel.com>
>
> The function run_dax() was missing a prototype when compiling with
> warnings.
>
> Add bus.h to fix this.
>

Always include the warning and the compiler in the changelog. I
suspect you hit this with LLVM and not gcc?

super.c has no business including bus.h. If the bots are tripping over
this a better fix is to move it into dax-private.h.
