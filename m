Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CE872
	for <nvdimm@lists.linux.dev>; Tue,  7 Sep 2021 22:00:06 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id t1so298002pgv.3
        for <nvdimm@lists.linux.dev>; Tue, 07 Sep 2021 15:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eEjYbhAR02sgc7ovVsHyjAGZLSxtoc/tH2wPYp1Ypy8=;
        b=elcY35Sre5FRsVc5U7wrWxG59izHA38dFgmaHKIrZXPYnJABcHEWwH4WRekxYV8xTl
         72KxyD9kGd9FiJUW5mBrfPqmXaB7MxDmL/3NzRhvIoKpdxZaWEf99X1ru0Q/XLHtzFDL
         sGIZeHs9IHxA7Lee/Gkkoh145uPlhwzHwkNlzNSP5tDnh6igl77FtJr0SzfyTd3PPxSO
         YFlOudrMPSjcolvyPVOp+QbwxZNIWEzD3MAmIGB89LH6AIs2RV1hpD38ds8V5sh37dUK
         1vN3GRRPQeLW2fVGN9oQOvTv7wuPTOPJljZI1PXxlA6zhShM74+qRVpdIcijDHAjiD5f
         WX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eEjYbhAR02sgc7ovVsHyjAGZLSxtoc/tH2wPYp1Ypy8=;
        b=riscDVfYz665rfc29yuEghOaEYqdDYnCGVs0IDSsSxEOJRlRK3EoMnmm6xNBqb6t9r
         6O6PrsvAdchTURJoFL100P08ACaH02QCpZqGVKOdbS+XFyLEO63hlPwVYQ5A/7875XbJ
         7s9zX5krc60gEZt/DEBDrfSTryLsjRIKvyeq8oEkIYwGQwSeyimjEpQC4ptuUp29/0ho
         fgtpXqry0TCsOHfPLYFdLMh04QFzXpBLHRRgl0tlU5UXoaEq/YX+h7aDx08CoQgKEEKN
         SUnZUjx7rmLM0mn9OhoMb0SQwaOGOJnkHOqm1djre6Eh30ioPkvNPo1oVPKOm6atXy09
         amRw==
X-Gm-Message-State: AOAM5304+zxlgBfPLU3h4QV0W/1drOkqsbW5IFFXRav2I5W8PCSvWLPo
	cccKXlLVRGJa2Ru2UNVGTT0iXDqcBAsUnJJh3X9wuQ==
X-Google-Smtp-Source: ABdhPJxx4EjbJvjL93bRoVayl6mm//Jv0BDO7s4EwjYNl8kM2qselsqA630wkktzF+3PhiHaezOvZrqOY7JxvIWmAUs=
X-Received: by 2002:a63:1e0e:: with SMTP id e14mr452534pge.5.1631052005753;
 Tue, 07 Sep 2021 15:00:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210903050914.273525-1-kjain@linux.ibm.com> <20210903050914.273525-2-kjain@linux.ibm.com>
In-Reply-To: <20210903050914.273525-2-kjain@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Sep 2021 14:59:55 -0700
Message-ID: <CAPcyv4jSL2cDxGiXEtyyce3eNEE_QUnnMjuLXb3iCwO8_7a7LQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v4 1/4] drivers/nvdimm: Add nvdimm pmu structure
To: Kajol Jain <kjain@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, maddy@linux.ibm.com, 
	Santosh Sivaraj <santosh@fossix.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
	Vaibhav Jain <vaibhav@linux.ibm.com>, atrajeev@linux.vnet.ibm.com, 
	Thomas Gleixner <tglx@linutronix.de>, rnsastry@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"

Hi Kajol,

Apologies for the delay in responding to this series, some comments below:

On Thu, Sep 2, 2021 at 10:10 PM Kajol Jain <kjain@linux.ibm.com> wrote:
>
> A structure is added, called nvdimm_pmu, for performance
> stats reporting support of nvdimm devices. It can be used to add
> nvdimm pmu data such as supported events and pmu event functions
> like event_init/add/read/del with cpu hotplug support.
>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>
> Tested-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
> Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
> ---
>  include/linux/nd.h | 43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>
> diff --git a/include/linux/nd.h b/include/linux/nd.h
> index ee9ad76afbba..712499cf7335 100644
> --- a/include/linux/nd.h
> +++ b/include/linux/nd.h
> @@ -8,6 +8,8 @@
>  #include <linux/ndctl.h>
>  #include <linux/device.h>
>  #include <linux/badblocks.h>
> +#include <linux/platform_device.h>
> +#include <linux/perf_event.h>
>
>  enum nvdimm_event {
>         NVDIMM_REVALIDATE_POISON,
> @@ -23,6 +25,47 @@ enum nvdimm_claim_class {
>         NVDIMM_CCLASS_UNKNOWN,
>  };
>
> +/* Event attribute array index */
> +#define NVDIMM_PMU_FORMAT_ATTR         0
> +#define NVDIMM_PMU_EVENT_ATTR          1
> +#define NVDIMM_PMU_CPUMASK_ATTR                2
> +#define NVDIMM_PMU_NULL_ATTR           3
> +
> +/**
> + * struct nvdimm_pmu - data structure for nvdimm perf driver
> + *
> + * @name: name of the nvdimm pmu device.
> + * @pmu: pmu data structure for nvdimm performance stats.
> + * @dev: nvdimm device pointer.
> + * @functions(event_init/add/del/read): platform specific pmu functions.

This is not valid kernel-doc:

include/linux/nd.h:67: warning: Function parameter or member
'event_init' not described in 'nvdimm_pmu'
include/linux/nd.h:67: warning: Function parameter or member 'add' not
described in 'nvdimm_pmu'
include/linux/nd.h:67: warning: Function parameter or member 'del' not
described in 'nvdimm_pmu'
include/linux/nd.h:67: warning: Function parameter or member 'read'
not described in 'nvdimm_pmu'

...but I think rather than fixing those up 'struct nvdimm_pmu' should be pruned.

It's not clear to me that it is worth the effort to describe these
details to the nvdimm core which is just going to turn around and call
the pmu core. I'd just as soon have the driver call the pmu core
directly, optionally passing in attributes and callbacks that come
from the nvdimm core and/or the nvdimm provider.

Otherwise it's also not clear which of these structure members are
used at runtime vs purely used as temporary storage to pass parameters
to the pmu core.

> + * @attr_groups: data structure for events, formats and cpumask
> + * @cpu: designated cpu for counter access.
> + * @node: node for cpu hotplug notifier link.
> + * @cpuhp_state: state for cpu hotplug notification.
> + * @arch_cpumask: cpumask to get designated cpu for counter access.
> + */
> +struct nvdimm_pmu {
> +       const char *name;
> +       struct pmu pmu;
> +       struct device *dev;
> +       int (*event_init)(struct perf_event *event);
> +       int  (*add)(struct perf_event *event, int flags);
> +       void (*del)(struct perf_event *event, int flags);
> +       void (*read)(struct perf_event *event);
> +       /*
> +        * Attribute groups for the nvdimm pmu. Index 0 used for
> +        * format attribute, index 1 used for event attribute,
> +        * index 2 used for cpusmask attribute and index 3 kept as NULL.
> +        */
> +       const struct attribute_group *attr_groups[4];

Following from above, I'd rather this was organized as static
attributes with an is_visible() helper for the groups for any dynamic
aspects. That mirrors the behavior of nvdimm_create() and allows for
device drivers to compose the attribute groups from a core set and /
or a provider specific set.

> +       int cpu;
> +       struct hlist_node node;
> +       enum cpuhp_state cpuhp_state;
> +
> +       /* cpumask provided by arch/platform specific code */
> +       struct cpumask arch_cpumask;
> +};
> +
>  struct nd_device_driver {
>         struct device_driver drv;
>         unsigned long type;
> --
> 2.26.2
>
