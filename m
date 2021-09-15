Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC783FD0
	for <nvdimm@lists.linux.dev>; Wed, 15 Sep 2021 04:11:25 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id w19so1428941pfn.12
        for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 21:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Www1Sy/iGaECDjccUq89+Q4UC3DZFrVqkJMRs3jnAoA=;
        b=f5JtWLoOAwop2HOyICQphlrTyYGhbXJ4qzohTu9cza9ymnaDVDmPoOXlWMNlsYZ63j
         48HThtIL3ulmBpXV0ywVISKr9usamlhlXBbyLfygAnd2803JLkoKDTpAeO5i/txnwsXF
         h1WNbhrz0rP6nIh4Wt1SElozQDPJW3xMcoZV8A50E0aFLtPG7ytbSJuvZGrXsRvmMfb5
         fhOef76SGMSCcSV5p+Yo2XFgSLD3X5/lciKLKcK4hDQns1tgB33yK+6T5vk6ny5JXT4d
         wK4l0b1z1iXjLq1DziyR7UVbUgxWsUqeFEj2UwAB4EVUuk1iGb+WIa+zTL88czpx4uWl
         flgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Www1Sy/iGaECDjccUq89+Q4UC3DZFrVqkJMRs3jnAoA=;
        b=fB/MQgvahXpbA6PC+rwHQluQ0og/IYOzEZzrSmfYgR18+YLuwBsHZGGNFS6QILkPv9
         ADaC1sBetUZ9qFsIpokaMtpBw6gNUj9H3tx8jgVAMQqjoyh0L6ECnyUEb4N9EHo1VLoS
         Xrc3XBlUrciTTN0cQLg+rwH17kLWQX+fp00ldSKBEwqDfI/ea/Hrckyo1CNweTSPMMDv
         jHkHfTHObFDJeO0cwyjZSneLrTrwnSDCvYyn85SuLaVB40z4r6aIRByk4rFDGiAwB0Q6
         GeSnDyzlm7Ee1yVkaUhMzJ476hQ3/gYvg8caxjJjzvK0XnZLt+2WCuVHfCmwcLBsRKsY
         Pt7w==
X-Gm-Message-State: AOAM530kx6HiyvhAWA4qpgM+tsbD+/fSF1khSMMyUBdS89LpNW/80sp2
	ulyjHg/M8lsjrtTvsqMSQKyyomnEodBqogbWbsVQRg==
X-Google-Smtp-Source: ABdhPJzVXf0or9qBPzNfUFPKqhXw6K1+8mdqK8CY5lJZTuBV/KxnpGf4inQTjJwy/A58j34e85JTiH17oUDNfhLWDfc=
X-Received: by 2002:a63:1e0e:: with SMTP id e14mr18563273pge.5.1631679085171;
 Tue, 14 Sep 2021 21:11:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210903050914.273525-1-kjain@linux.ibm.com> <20210903050914.273525-2-kjain@linux.ibm.com>
 <CAPcyv4jSL2cDxGiXEtyyce3eNEE_QUnnMjuLXb3iCwO8_7a7LQ@mail.gmail.com>
 <d7f8bf51-059f-4496-37c4-6516a703e209@linux.ibm.com> <CAPcyv4hE4rh5R+8zy3X4gDJeuPzQ0oQHmHbe_pppgWB2_RjfAg@mail.gmail.com>
In-Reply-To: <CAPcyv4hE4rh5R+8zy3X4gDJeuPzQ0oQHmHbe_pppgWB2_RjfAg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 14 Sep 2021 21:11:14 -0700
Message-ID: <CAPcyv4hZZX4WscR41PUSXZhDLPR6LuXHNRcJDO52gb+3MahYAA@mail.gmail.com>
Subject: Re: [RESEND PATCH v4 1/4] drivers/nvdimm: Add nvdimm pmu structure
To: kajoljain <kjain@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, maddy@linux.ibm.com, 
	Santosh Sivaraj <santosh@fossix.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
	Vaibhav Jain <vaibhav@linux.ibm.com>, atrajeev@linux.vnet.ibm.com, 
	Thomas Gleixner <tglx@linutronix.de>, rnsastry@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 14, 2021 at 9:08 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Thu, Sep 9, 2021 at 12:56 AM kajoljain <kjain@linux.ibm.com> wrote:
> >
> >
> >
> > On 9/8/21 3:29 AM, Dan Williams wrote:
> > > Hi Kajol,
> > >
> > > Apologies for the delay in responding to this series, some comments below:
> >
> > Hi Dan,
> >     No issues, thanks for reviewing the patches.
> >
> > >
> > > On Thu, Sep 2, 2021 at 10:10 PM Kajol Jain <kjain@linux.ibm.com> wrote:
> > >>
> > >> A structure is added, called nvdimm_pmu, for performance
> > >> stats reporting support of nvdimm devices. It can be used to add
> > >> nvdimm pmu data such as supported events and pmu event functions
> > >> like event_init/add/read/del with cpu hotplug support.
> > >>
> > >> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > >> Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>
> > >> Tested-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
> > >> Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
> > >> ---
> > >>  include/linux/nd.h | 43 +++++++++++++++++++++++++++++++++++++++++++
> > >>  1 file changed, 43 insertions(+)
> > >>
> > >> diff --git a/include/linux/nd.h b/include/linux/nd.h
> > >> index ee9ad76afbba..712499cf7335 100644
> > >> --- a/include/linux/nd.h
> > >> +++ b/include/linux/nd.h
> > >> @@ -8,6 +8,8 @@
> > >>  #include <linux/ndctl.h>
> > >>  #include <linux/device.h>
> > >>  #include <linux/badblocks.h>
> > >> +#include <linux/platform_device.h>
> > >> +#include <linux/perf_event.h>
> > >>
> > >>  enum nvdimm_event {
> > >>         NVDIMM_REVALIDATE_POISON,
> > >> @@ -23,6 +25,47 @@ enum nvdimm_claim_class {
> > >>         NVDIMM_CCLASS_UNKNOWN,
> > >>  };
> > >>
> > >> +/* Event attribute array index */
> > >> +#define NVDIMM_PMU_FORMAT_ATTR         0
> > >> +#define NVDIMM_PMU_EVENT_ATTR          1
> > >> +#define NVDIMM_PMU_CPUMASK_ATTR                2
> > >> +#define NVDIMM_PMU_NULL_ATTR           3
> > >> +
> > >> +/**
> > >> + * struct nvdimm_pmu - data structure for nvdimm perf driver
> > >> + *
> > >> + * @name: name of the nvdimm pmu device.
> > >> + * @pmu: pmu data structure for nvdimm performance stats.
> > >> + * @dev: nvdimm device pointer.
> > >> + * @functions(event_init/add/del/read): platform specific pmu functions.
> > >
> > > This is not valid kernel-doc:
> > >
> > > include/linux/nd.h:67: warning: Function parameter or member
> > > 'event_init' not described in 'nvdimm_pmu'
> > > include/linux/nd.h:67: warning: Function parameter or member 'add' not
> > > described in 'nvdimm_pmu'
> > > include/linux/nd.h:67: warning: Function parameter or member 'del' not
> > > described in 'nvdimm_pmu'
> > > include/linux/nd.h:67: warning: Function parameter or member 'read'
> > > not described in 'nvdimm_pmu'
> > >
> > > ...but I think rather than fixing those up 'struct nvdimm_pmu' should be pruned.
> > >
> > > It's not clear to me that it is worth the effort to describe these
> > > details to the nvdimm core which is just going to turn around and call
> > > the pmu core. I'd just as soon have the driver call the pmu core
> > > directly, optionally passing in attributes and callbacks that come
> > > from the nvdimm core and/or the nvdimm provider.
> >
> > The intend for adding these callbacks(event_init/add/del/read) is to give
> > flexibility to the nvdimm core to add some common checks/routines if required
> > in the future. Those checks can be common for all architecture with still having the
> > ability to call arch/platform specific driver code to use its own routines.
> >
> > But as you said, currently we don't have any common checks and it directly
> > calling platform specific code, so we can get rid of it.
> > Should we remove this part for now?
>
> Yes, lets go direct to the perf api for now and await the need for a
> common core wrapper to present itself.
>
> >
> >
> > >
> > > Otherwise it's also not clear which of these structure members are
> > > used at runtime vs purely used as temporary storage to pass parameters
> > > to the pmu core.
> > >
> > >> + * @attr_groups: data structure for events, formats and cpumask
> > >> + * @cpu: designated cpu for counter access.
> > >> + * @node: node for cpu hotplug notifier link.
> > >> + * @cpuhp_state: state for cpu hotplug notification.
> > >> + * @arch_cpumask: cpumask to get designated cpu for counter access.
> > >> + */
> > >> +struct nvdimm_pmu {
> > >> +       const char *name;
> > >> +       struct pmu pmu;
> > >> +       struct device *dev;
> > >> +       int (*event_init)(struct perf_event *event);
> > >> +       int  (*add)(struct perf_event *event, int flags);
> > >> +       void (*del)(struct perf_event *event, int flags);
> > >> +       void (*read)(struct perf_event *event);
> > >> +       /*
> > >> +        * Attribute groups for the nvdimm pmu. Index 0 used for
> > >> +        * format attribute, index 1 used for event attribute,
> > >> +        * index 2 used for cpusmask attribute and index 3 kept as NULL.
> > >> +        */
> > >> +       const struct attribute_group *attr_groups[4];
> > >
> > > Following from above, I'd rather this was organized as static
> > > attributes with an is_visible() helper for the groups for any dynamic
> > > aspects. That mirrors the behavior of nvdimm_create() and allows for
> > > device drivers to compose the attribute groups from a core set and /
> > > or a provider specific set.
> >
> > Since we don't have any common events right now, Can I use papr
> > attributes directly or should we create dummy events for common thing and
> > then merged it with papr event list.
>
> Just use papr events directly.

That is to say...I think if another implementation followed it should
try to match as many common event names as papr_scm picked, and
possibly extend with its own rather than start with a papr_scm
specific namespace for everything.
