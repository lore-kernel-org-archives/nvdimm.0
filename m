Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506C67A
	for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 02:11:07 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id q1-20020a17090a4f8100b001c6575ae105so1094660pjh.0
        for <nvdimm@lists.linux.dev>; Mon, 21 Mar 2022 19:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gGZp+MDIUzKlsOtQAo2TyTq0vVOirk1X0NOX9ev9OMc=;
        b=jsl5hTKisonrNJYTeMtNHzyDFdCfEUgD/ujMhDJCupZnphMkfd0uzKApmqk/n3FaED
         i46ZTIJ+Lj99NIG2v73jtrSrTVhoCDEpoHo9w7f4fY0L5l88DtDWVG91DqRej+vdmVzy
         Xp6pL5ctDPnLYuyosqtk4O/t+86XwfOHd3CCYIEVOeCa0p5eOsaD1qEqq8a0aXbxvWHf
         gX803FBk8yWx2Q0ft0SZnpgZ40r22BPfvagHhSHp0vKlLkzolVbE4jP+k1HbJAXZQKRY
         0piuCSEkh7Hwa3M83oI+taVZYG/M22LqqoyUtOWoKSK3WFjcvR01ygKRGV4swgcRolZg
         Dgeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gGZp+MDIUzKlsOtQAo2TyTq0vVOirk1X0NOX9ev9OMc=;
        b=MX/rrrGVa86Xu/ua1W+ikMi+arg/RVG7gb91V4ZRXEKbUeCkN4RsTtHiV9QDJfsIfa
         2+xTJoeOAHIB/l6/AiLPOvOLWhFT10Hr35qRiOeV/xre6G7lwiwOD/0v0mamvzGWrpLW
         +w86e6K7PNldoJ+jSEbr+1uQADhjI4loWleS61BTIrSQDc+s8pakH6QRtQFE+fXzpvIG
         RhshoVlCUxsDzXfue9zRksMc8r1S00IJpHSJif9j9rYgsadQM6OsFSaKJntPDLeRzyLG
         MCd9XfF3loxoTKm1Mc9U1XFUwEKCLDgF16HvfAwvDHL0+1OfdkkqOiUUyDlioyTy7spC
         jRGg==
X-Gm-Message-State: AOAM530M+1j2mnoPw15TfjeO+rpXxAnLS/mWkSrR/jhUgeC6h+yU+8wA
	9zaxeXGgKs5aAhui3Of7NGdeQCPyfERcYjsh1uDOoQ==
X-Google-Smtp-Source: ABdhPJygUAsAdOWYyNjrdBLj+QkLKtyI/POLyJ7Ul6xPNIok2S+vw4/PZsNEToVHKjT2+REJe94s9PJMZnnk/6DQ+mw=
X-Received: by 2002:a17:90a:430d:b0:1bc:f340:8096 with SMTP id
 q13-20020a17090a430d00b001bcf3408096mr2221086pjg.93.1647915066682; Mon, 21
 Mar 2022 19:11:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220318114133.113627-1-kjain@linux.ibm.com>
In-Reply-To: <20220318114133.113627-1-kjain@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 21 Mar 2022 19:10:59 -0700
Message-ID: <CAPcyv4jNJy70b6jK6S9TYDrLLZxzSNQxfN7-bzOpVa+ffZN3hw@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers/nvdimm: Fix build failure when
 CONFIG_PERF_EVENTS is not set
To: Kajol Jain <kjain@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux-Next Mailing List <linux-next@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Santosh Sivaraj <santosh@fossix.org>, maddy@linux.ibm.com, 
	rnsastry@linux.ibm.com, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
	atrajeev@linux.vnet.ibm.com, Vaibhav Jain <vaibhav@linux.ibm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Linux MM <linux-mm@kvack.org>, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 18, 2022 at 4:42 AM Kajol Jain <kjain@linux.ibm.com> wrote:
>
> The following build failure occures when CONFIG_PERF_EVENTS is not set
> as generic pmu functions are not visible in that scenario.
>
> |-- s390-randconfig-r044-20220313
> |   |-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_migrate_context
> |   |-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_register
> |   `-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_unregister
>
> Similar build failure in nds32 architecture:
> nd_perf.c:(.text+0x21e): undefined reference to `perf_pmu_migrate_context'
> nd_perf.c:(.text+0x434): undefined reference to `perf_pmu_register'
> nd_perf.c:(.text+0x57c): undefined reference to `perf_pmu_unregister'
>
> Fix this issue by adding check for CONFIG_PERF_EVENTS config option
> and disabling the nvdimm perf interface incase this config is not set.
>
> Also removed function declaration of perf_pmu_migrate_context,
> perf_pmu_register, perf_pmu_unregister functions from nd.h as these are
> common pmu functions which are part of perf_event.h and since we
> are disabling nvdimm perf interface incase CONFIG_PERF_EVENTS option
> is not set, we not need to declare them in nd.h
>
> Fixes: 0fab1ba6ad6b ("drivers/nvdimm: Add perf interface to expose
> nvdimm performance stats") (Commit id based on linux-next tree)
> Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
> Link: https://lore.kernel.org/all/62317124.YBQFU33+s%2FwdvWGj%25lkp@intel.com/
> Reported-by: kernel test robot <lkp@intel.com>
> ---
>  drivers/nvdimm/Makefile | 2 +-
>  include/linux/nd.h      | 7 ++++---
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> ---
> - This fix patch changes are added and tested on top of linux-next tree
>   on the 'next-20220315' branch.
> ---
> diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
> index 3fb806748716..ba0296dca9db 100644
> --- a/drivers/nvdimm/Makefile
> +++ b/drivers/nvdimm/Makefile
> @@ -15,7 +15,7 @@ nd_e820-y := e820.o
>  libnvdimm-y := core.o
>  libnvdimm-y += bus.o
>  libnvdimm-y += dimm_devs.o
> -libnvdimm-y += nd_perf.o
> +libnvdimm-$(CONFIG_PERF_EVENTS) += nd_perf.o
>  libnvdimm-y += dimm.o
>  libnvdimm-y += region_devs.o
>  libnvdimm-y += region.o
> diff --git a/include/linux/nd.h b/include/linux/nd.h
> index 7b2ccbdc1cbc..a4265eaf5ae8 100644
> --- a/include/linux/nd.h
> +++ b/include/linux/nd.h
> @@ -8,8 +8,10 @@
>  #include <linux/ndctl.h>
>  #include <linux/device.h>
>  #include <linux/badblocks.h>
> +#ifdef CONFIG_PERF_EVENTS
>  #include <linux/perf_event.h>

Why must this not be included? Doesn't it already handle the
CONFIG_PERF_EVENTS=n case internally?

>  #include <linux/platform_device.h>

I notice now that this platform-device header should have never been
added in the first place, just forward declare:

struct platform_device;

> +#endif
>
>  enum nvdimm_event {
>         NVDIMM_REVALIDATE_POISON,
> @@ -25,6 +27,7 @@ enum nvdimm_claim_class {
>         NVDIMM_CCLASS_UNKNOWN,
>  };
>
> +#ifdef CONFIG_PERF_EVENTS
>  #define NVDIMM_EVENT_VAR(_id)  event_attr_##_id
>  #define NVDIMM_EVENT_PTR(_id)  (&event_attr_##_id.attr.attr)

Why must these be inside the ifdef guard?

>
> @@ -63,9 +66,7 @@ extern ssize_t nvdimm_events_sysfs_show(struct device *dev,
>
>  int register_nvdimm_pmu(struct nvdimm_pmu *nvdimm, struct platform_device *pdev);
>  void unregister_nvdimm_pmu(struct nvdimm_pmu *nd_pmu);

Shouldn't there also be stub functions in the CONFIG_PERF_EVENTS=n case?

static inline int register_nvdimm_pmu(struct nvdimm_pmu *nvdimm,
struct platform_device *pdev)
{
    return -ENXIO;
}

static inline void unregister_nvdimm_pmu(struct nvdimm_pmu *nd_pmu)
{
}

> -void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu);
> -int perf_pmu_register(struct pmu *pmu, const char *name, int type);
> -void perf_pmu_unregister(struct pmu *pmu);

Yeah, I should have caught these earlier.

> +#endif
>
>  struct nd_device_driver {
>         struct device_driver drv;
> --
> 2.31.1
>
