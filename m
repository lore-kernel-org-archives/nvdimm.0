Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7496672
	for <nvdimm@lists.linux.dev>; Wed,  8 Sep 2021 01:03:59 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id m21-20020a17090a859500b00197688449c4so323261pjn.0
        for <nvdimm@lists.linux.dev>; Tue, 07 Sep 2021 18:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0iKng76PsWyRz/8pjKL65aYQlih1TWo8dnb6KnDDehM=;
        b=gA2AKqSYLA1MsQE3BMExMBWz0L/kPrN0d88m681N9dDRm9y82WlVbC6+jWD0ghSlB2
         SyFe6JEC96j2lU/x/FecVxc0WYkUZcUG9uoZpqzpweENWnSLhz5JKPTrGO9eCS27Vbvc
         ewatD2c1ew2eWWvkKyoX+9LBmuw46PIVIINoX6SHItS4Kk47q7OabMVfkxbBnPtll2SG
         Uqu7JK1N11ylCIyfv3MbaMrhirdiv3iPRTLfZIakN0PCojZw5OfR2W7zsOippo2Hb2UC
         XSBHw7iAga4VdN4tdA1JthLBERWT0L+AMeMHrii+pyS1jLW0BcEpe1VSAu9txz4ZfQZo
         Th3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0iKng76PsWyRz/8pjKL65aYQlih1TWo8dnb6KnDDehM=;
        b=Qd3nPqIEC8Gxkf9EasMLg+/5958IZMs959YV9COnB5rkFoedXWsRJBt+NSPclO815a
         VDj+iAi2wWZjubEuA/z4nS6QyaeimEnzWW5WuAX7W99+dijkCeIDcawQMcrSseXRUqyZ
         HyWSCg3CoSpX0NflT1EUTojMSMcqVc9p8eXaj2Jm2+VsOReOtFQp3gNBB3OdcZ1VLSwZ
         24CTOmz1ggi4A5Y8sjdbLk7sqpwap8geB2suz0fiAS0cFDwoTzem3+A+xXiiLTuWzzFb
         LI1ypb2GzSedpE0OTcrzmx27wBJ726ewjePlB+USDgnwtEf7YNmDKSFhg+IsOuGezeYl
         dVJg==
X-Gm-Message-State: AOAM531EA6U6wacctTPoNOELVveoE/qmgBUKRW56PGFU9oxoKEoJxhBQ
	+qHCzitZ2rmim6BEhhDCVC+eYgkhfPSW+Jpkhq2iVw==
X-Google-Smtp-Source: ABdhPJyamM17dGx2IKarxEjJH/roNB9B0xLZUNSeDoP4i/s+QWcFqzVWNormFy+djtNq4zfCina5FNZQADngZlT7D84=
X-Received: by 2002:a17:90b:3b84:: with SMTP id pc4mr1194364pjb.220.1631063038886;
 Tue, 07 Sep 2021 18:03:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210903050914.273525-1-kjain@linux.ibm.com> <20210903050914.273525-5-kjain@linux.ibm.com>
In-Reply-To: <20210903050914.273525-5-kjain@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Sep 2021 18:03:48 -0700
Message-ID: <CAPcyv4h-MgZmteMSUfdeQL+XCxL5HvxK87HA3JYB0OoQUaPipQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v4 4/4] powerpc/papr_scm: Document papr_scm sysfs
 event format entries
To: Kajol Jain <kjain@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, maddy@linux.ibm.com, 
	Santosh Sivaraj <santosh@fossix.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
	Vaibhav Jain <vaibhav@linux.ibm.com>, atrajeev@linux.vnet.ibm.com, 
	Thomas Gleixner <tglx@linutronix.de>, rnsastry@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 2, 2021 at 10:11 PM Kajol Jain <kjain@linux.ibm.com> wrote:
>
> Details is added for the event, cpumask and format attributes
> in the ABI documentation.
>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>
> Tested-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
> Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-papr-pmem | 31 +++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-papr-pmem b/Documentation/ABI/testing/sysfs-bus-papr-pmem
> index 95254cec92bf..4d86252448f8 100644
> --- a/Documentation/ABI/testing/sysfs-bus-papr-pmem
> +++ b/Documentation/ABI/testing/sysfs-bus-papr-pmem
> @@ -61,3 +61,34 @@ Description:
>                 * "CchRHCnt" : Cache Read Hit Count
>                 * "CchWHCnt" : Cache Write Hit Count
>                 * "FastWCnt" : Fast Write Count
> +
> +What:          /sys/devices/nmemX/format
> +Date:          June 2021
> +Contact:       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, nvdimm@lists.linux.dev,
> +Description:   (RO) Attribute group to describe the magic bits
> +                that go into perf_event_attr.config for a particular pmu.
> +                (See ABI/testing/sysfs-bus-event_source-devices-format).
> +
> +                Each attribute under this group defines a bit range of the
> +                perf_event_attr.config. Supported attribute is listed
> +                below::
> +
> +                   event  = "config:0-4"  - event ID
> +
> +               For example::
> +                   noopstat = "event=0x1"
> +
> +What:          /sys/devices/nmemX/events

That's not a valid sysfs path. Did you mean /sys/bus/nd/devices/nmemX?

> +Date:          June 2021
> +Contact:       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, nvdimm@lists.linux.dev,
> +Description:    (RO) Attribute group to describe performance monitoring
> +                events specific to papr-scm. Each attribute in this group describes
> +                a single performance monitoring event supported by this nvdimm pmu.
> +                The name of the file is the name of the event.
> +                (See ABI/testing/sysfs-bus-event_source-devices-events).

Given these events are in the generic namespace the ABI documentation
should be generic as well. So I think move these entries to
Documentation/ABI/testing/sysfs-bus-nvdimm directly.

You can still mention papr-scm, but I would expect something like:

What:           /sys/bus/nd/devices/nmemX/events
Date:           September 2021
KernelVersion:  5.16
Contact:        Kajol Jain <kjain@linux.ibm.com>
Description:
                (RO) Attribute group to describe performance monitoring events
                for the nvdimm memory device. Each attribute in this group
                describes a single performance monitoring event supported by
                this nvdimm pmu.  The name of the file is the name of the event.
                (See ABI/testing/sysfs-bus-event_source-devices-events). A
                listing of the events supported by a given nvdimm provider type
                can be found in Documentation/driver-api/nvdimm/$provider, for
                example: Documentation/driver-api/nvdimm/papr-scm.



> +
> +What:          /sys/devices/nmemX/cpumask
> +Date:          June 2021
> +Contact:       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, nvdimm@lists.linux.dev,
> +Description:   (RO) This sysfs file exposes the cpumask which is designated to make
> +                HCALLs to retrieve nvdimm pmu event counter data.

Seems this one would be provider generic, so no need to refer to PPC
specific concepts like HCALLs.
