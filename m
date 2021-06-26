Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A124177
	for <nvdimm@lists.linux.dev>; Sat, 26 Jun 2021 17:43:26 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id u14so4665396pga.11
        for <nvdimm@lists.linux.dev>; Sat, 26 Jun 2021 10:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5lzS3c978KWVZhp9dx/lJ7t8+OWX7BevxD99uFCYCLw=;
        b=TEKJ4tT2dwiVznc1KdZgOX7jo1ciZgIUvxxu9uZI31WHGV88slpNhl83mHcDRZgEmu
         fU+I8MOtxrqEcg3/K+I8zC1KC4e5LA/7o7wAujjLvO5HeULS+fArZ8c4YaAx6lNR778N
         cPodhq6zKDx6tCl846+hdDKKkv8Yl2w37yCMzv5fChJNm1CHecZus8FPsTAuKEeEKX0h
         z9qgDyvIJRTK+wrEkC/HMu7YXv8sWMSsFxlorTZgnzN0lhFGyYNw7vUDBjLDvifviUyy
         2v3a5/73Osk7shpGrXgeekreL4yiUkYvs0xbavtaUynL0Gnp65k/Nj4RCk4meV6Tl9KW
         3B0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5lzS3c978KWVZhp9dx/lJ7t8+OWX7BevxD99uFCYCLw=;
        b=RLPHOwoMPTkrG3nWp4kO6CKmcPXqH0KS2+VtK4xt3UMT2BcxHYwTDIlUz8Fok4wqP0
         y7sx/NtQVBj/YweMXwiIOlPKXJfuC9ATf2VQPwtOtbKNARaHS1DOMOdqmtkmSM1iHDWR
         2DTBserZ+eADQe1sOkKzEhXxf+cCg0fhuajaGYV3Y0SVHAp76cPusglJx0dAF2kQLPGp
         AdyilwKI+AaR/ZfQ08mGjC2VPMueIvFVK+pLL+o2AZ3tHi92wHAUUPswQJU8ozamDitt
         h03N5lwYuglsPURU8qgMl49MakSNJ+UeAz+Q4FXq5FcXfkxHNZuEoNn6DiVUWX/UPJ9z
         oE1Q==
X-Gm-Message-State: AOAM530Mx67qJ3OboU1JDCuKjs/WU1eoOXT7PK8RhZw9ZZdsxSMs9Ntt
	UQXmHxr0f/ElaSYNtuPMEKXVDWUFR5wvL9kgepuBlg==
X-Google-Smtp-Source: ABdhPJwDJWNvFeSOl/aHQkL4aR6n+XOQLuyDu1ETB1JWNzeOgPmAjuaVlFygur/FTWNpJhjikW3TvgIaSGjr9vig020=
X-Received: by 2002:a62:768c:0:b029:2ff:2002:d3d0 with SMTP id
 r134-20020a62768c0000b02902ff2002d3d0mr16409804pfc.70.1624729406065; Sat, 26
 Jun 2021 10:43:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210624080621.252038-1-vaibhav@linux.ibm.com>
In-Reply-To: <20210624080621.252038-1-vaibhav@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 26 Jun 2021 10:43:15 -0700
Message-ID: <CAPcyv4g7Y0AQDWq4DN2o+=iDQAuWjd0f9DCY2jR7A-=eED=dZQ@mail.gmail.com>
Subject: Re: [RESEND-PATCH v2] powerpc/papr_scm: Add support for reporting dirty-shutdown-count
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Santosh Sivaraj <santosh@fossix.org>, Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jun 24, 2021 at 1:07 AM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>
> Persistent memory devices like NVDIMMs can loose cached writes in case
> something prevents flush on power-fail. Such situations are termed as
> dirty shutdown and are exposed to applications as
> last-shutdown-state (LSS) flag and a dirty-shutdown-counter(DSC) as
> described at [1]. The latter being useful in conditions where multiple
> applications want to detect a dirty shutdown event without racing with
> one another.
>
> PAPR-NVDIMMs have so far only exposed LSS style flags to indicate a
> dirty-shutdown-state. This patch further adds support for DSC via the
> "ibm,persistence-failed-count" device tree property of an NVDIMM. This
> property is a monotonic increasing 64-bit counter thats an indication
> of number of times an NVDIMM has encountered a dirty-shutdown event
> causing persistence loss.
>
> Since this value is not expected to change after system-boot hence
> papr_scm reads & caches its value during NVDIMM probe and exposes it
> as a PAPR sysfs attributed named 'dirty_shutdown' to match the name of
> similarly named NFIT sysfs attribute. Also this value is available to
> libnvdimm via PAPR_PDSM_HEALTH payload. 'struct nd_papr_pdsm_health'
> has been extended to add a new member called 'dimm_dsc' presence of
> which is indicated by the newly introduced PDSM_DIMM_DSC_VALID flag.
>
> References:
> [1] https://pmem.io/documents/Dirty_Shutdown_Handling-V1.0.pdf
>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

Belated:

Acked-by: Dan Williams <dan.j.williams@intel.com>

It's looking like CXL will add one of these as well. Might be time to
add a unified location when that happens and deprecate these
bus-specific locations.
