Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6350072
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 19:59:48 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id g5so4913321plg.1
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 12:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pRxO7pEcWaFAN3H/Vkdkhf6TU9ZHNhgzj7NEna7LxnI=;
        b=jmmf0SaTMM2bM4h7kW7VAf0QQx3SCkMM8LbF7A8kr5lPo/EVAqm5rmJtBtwgCC4LFO
         7XYbN2Qr5H3nW9nQasX52WGJWUj2pb3tp6xt6zCI7CsQi4n5Ynyrg4+/AipaFwQAPism
         QtOwkPEuJE/rC/kBczOG5gOys0Nrfpap2IWy7EzoDFiBEM9UuF5Z+cb0uij2/cFnPwEE
         rzuaaY6xrFUSsjoJuQyjM3ASX+azv9n2c+VFhX+FO7y57d1A0BSRcJRsymwDlNG8UWuA
         klVHl3W6/OLvqUS5rYP03EmgkdZFVcGlQeVl9CGkptcvvVQIW079PGOZ4Vr/HVYQasSj
         KdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pRxO7pEcWaFAN3H/Vkdkhf6TU9ZHNhgzj7NEna7LxnI=;
        b=SnAK7Q3w6BR5a68cX37vmIo1AxZkLChdAWYDcAIgTke7/XlFl0ghA30JvUYCrF/lqM
         6dlxXDuDZciIX1yIEAu2OzgoD5Xgq50g+c47I+Jil8Rfc5Zi23ChRt+hzdjIht9pfCuH
         AKZFLbd5o0iW+Tf0kSQIaZN9RT01u5Xat228G+xFTmi9iNC4yYnz3GmWTsKzkTzEG0D0
         rW1xepD72MC1rcE8R8Sg+AmTi5RudU4i2vDdTUGl7XhXfkpeYlPDYgTi6K82cmNS2yWU
         2qvAJ+3goDEPPfrR9MDuDQaRArPEvgEbGyzoHAm28XeJMrE73AJQ05ApeFkC9SNV1vzt
         /onw==
X-Gm-Message-State: AOAM531oB5IHN85n0/QkhGI1GLARFFZSvx9QpwJuM6YhuOvDoZiXk7BS
	d60SkXAwg6yJ0KHwUGkJoZOp2G9CTaImZdR23J9T7w==
X-Google-Smtp-Source: ABdhPJzAQmOuZqqjlFs10QKbcPpR2s4cDGEru7akZ4yyhi5nWW2d2GQNpcsmh+MYUqPWsz1j0VZLJVU+cn7vjftwYDw=
X-Received: by 2002:a17:902:ab50:b0:13f:4c70:9322 with SMTP id
 ij16-20020a170902ab5000b0013f4c709322mr6821007plb.89.1634241587765; Thu, 14
 Oct 2021 12:59:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com> <20211007082139.3088615-12-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-12-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 12:59:37 -0700
Message-ID: <CAPcyv4hzozQnG-s1G_vf=Ej_sgOS+9=bRNbOn6v_fm_RiEdbMg@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 11/17] libcxl: add a stub interface to determine
 whether a memdev is active
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add an interface to determine whether a memdev is bound to a region
> driver and therefore is currently active.
>
> For now, this just returns '0' all the time - i.e. devices are always
> considered inactive. Flesh this out fully once the region driver is
> available.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/lib/libcxl.c   | 10 ++++++++++
>  cxl/libcxl.h       |  1 +
>  cxl/lib/libcxl.sym |  1 +
>  3 files changed, 12 insertions(+)
>
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index de3a8f7..59d091c 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -362,6 +362,16 @@ CXL_EXPORT size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev)
>         return memdev->lsa_size;
>  }
>
> +CXL_EXPORT int cxl_memdev_is_active(struct cxl_memdev *memdev)
> +{
> +       /*
> +        * TODO: Currently memdevs are always considered inactive. Once we have
> +        * cxl_bus drivers that are bound/unbound to memdevs, we'd use that to
> +        * determine the active/inactive state.
> +        */

So I jumped ahead to look at the use case for this and it brings up
questions if this is the right check for the label helpers to be
using. Note that the LSA commands may still be disabled even if the
memdev is inactive. This is because the NVDIMM bridge might be up and
have claimed the label operations for exclusive access via /dev/nmemX.

So perhaps this should become a narrower focused
cxl_memdev_label_area_active() or cxl_memdev_nvdimm_bridge_active().

I think Ben and I still need to arm wrestle how to mediate the label
area, but my going-in position is that the CXL subsystem works through
the NVDIMM subsystem to coordinate label updates. So
cxl_memdev_nvdimm_bridge_active() should be a sufficient check for
now. That's determined simply by the existence of a pmemX device as a
child of a memX device.


> +       return 0;
> +}
> +
>  CXL_EXPORT void cxl_cmd_unref(struct cxl_cmd *cmd)
>  {
>         if (!cmd)
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index d3b97a1..2e24371 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -43,6 +43,7 @@ unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
>  unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
>  const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
>  size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
> +int cxl_memdev_is_active(struct cxl_memdev *memdev);
>
>  #define cxl_memdev_foreach(ctx, memdev) \
>          for (memdev = cxl_memdev_get_first(ctx); \
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index b9feb93..0e82030 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -79,4 +79,5 @@ global:
>  LIBCXL_4 {
>  global:
>         cxl_memdev_get_label_size;
> +       cxl_memdev_is_active;
>  } LIBCXL_3;
> --
> 2.31.1
>
