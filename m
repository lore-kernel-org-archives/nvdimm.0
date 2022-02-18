Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0084ABB
	for <nvdimm@lists.linux.dev>; Fri, 18 Feb 2022 18:06:49 +0000 (UTC)
Received: by mail-oo1-f47.google.com with SMTP id y15-20020a4a650f000000b0031c19e9fe9dso1449537ooc.12
        for <nvdimm@lists.linux.dev>; Fri, 18 Feb 2022 10:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j28LsEyKO8fhnvouEfWy5wWPWcngh3hdC6d0wPRNOHw=;
        b=Tc8NRnRggxrDmjg3L2ct4nrSkx07K06UkPIviAKlfLFrk2ctwl541YfpN2b5ABGjUa
         SV0RYScbzN6Zc8aMKLpBaAxWZabKT3hxdcPEcpVaTDDNvwzpXIfffQALwlnyq6akvrFl
         t2lRsZUYVLw9ZrGs7O8NABu51Rjth5d1zxUDpTg5C4OUZB5/BXk/WVeYaKw5Plhgz+b3
         8x+6AgPxBNh4D0iRXP7U8/9+S+N0OdzmPfL39gS6ki3gWldvwWXbblz6MkiUSUX+Bq+A
         3Ho+J1w0Ja0CRzoonVgBKrJi1Eakch0KYaabCiSVl8+TI3ljw3jVmhK/kycCPwu72/V3
         Yiuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j28LsEyKO8fhnvouEfWy5wWPWcngh3hdC6d0wPRNOHw=;
        b=I5/TYVT605qY6DxEq4ZMNHb+doiyquxdzv/aVpKJLyj8hYcvuiHzBCRU+q13Jr2I93
         nqJ2/fv7qX0Iwdnmr2gd9AMWWRUZp5d7vX1Z+lJqm6+5BSMGgwcyMaCrKc1ETOBqdRaA
         sD7OIzuhIzEm0YvDomzL89csUqq9fqpZ6YVZhSM582aaYD3QYCiOhuVkZuKHN6SbQY3d
         e0vDfApmxhZBrM1zjQL6ej6wtjxlBPZGjGQVGamDN2TwMUGus8nBcUXLc7BsWksis9ff
         Rvs8Hy02cc57ZNEWlPRhjriivXf6t/dXMYbprpweh+/NHFIeF/qd7zXd2bykhzemkgsM
         srNQ==
X-Gm-Message-State: AOAM533hz6nTXi/0Pszrv3ApXLHZVDkl0UhbWEMzD87XjOBUARSPW0hI
	Zonadv7uM7bdHmBJyAtZshH205ICPiEKubgTqdBKmw==
X-Google-Smtp-Source: ABdhPJzXHeMUfUpHFz9cX4KAvTQ8Kr6vcAte/GQmMLl8KbpIaHiH9oO/JX/8xW2dkD2gcjeaiGq0I+RIHUNxzzDNqno=
X-Received: by 2002:a05:6871:586:b0:d2:672a:8dd with SMTP id
 u6-20020a056871058600b000d2672a08ddmr3618682oan.16.1645207607939; Fri, 18 Feb
 2022 10:06:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220217163357.276036-1-kjain@linux.ibm.com>
In-Reply-To: <20220217163357.276036-1-kjain@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 Feb 2022 10:06:36 -0800
Message-ID: <CAPcyv4jwpMbz0woftSfm3EO05pr3ZG9rVMJCkYVsapKYSOn3xw@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] Add perf interface to expose nvdimm
To: Kajol Jain <kjain@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Santosh Sivaraj <santosh@fossix.org>, maddy@linux.ibm.com, rnsastry@linux.ibm.com, 
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, atrajeev@linux.vnet.ibm.com, 
	Vaibhav Jain <vaibhav@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 17, 2022 at 8:34 AM Kajol Jain <kjain@linux.ibm.com> wrote:
>
> Patchset adds performance stats reporting support for nvdimm.
> Added interface includes support for pmu register/unregister
> functions. A structure is added called nvdimm_pmu to be used for
> adding arch/platform specific data such as cpumask, nvdimm device
> pointer and pmu event functions like event_init/add/read/del.
> User could use the standard perf tool to access perf events
> exposed via pmu.
>
> Interface also defines supported event list, config fields for the
> event attributes and their corresponding bit values which are exported
> via sysfs. Patch 3 exposes IBM pseries platform nmem* device
> performance stats using this interface.
>
> Result from power9 pseries lpar with 2 nvdimm device:
>
> Ex: List all event by perf list
>
> command:# perf list nmem
>
>   nmem0/cache_rh_cnt/                                [Kernel PMU event]
>   nmem0/cache_wh_cnt/                                [Kernel PMU event]
>   nmem0/cri_res_util/                                [Kernel PMU event]
>   nmem0/ctl_res_cnt/                                 [Kernel PMU event]
>   nmem0/ctl_res_tm/                                  [Kernel PMU event]
>   nmem0/fast_w_cnt/                                  [Kernel PMU event]
>   nmem0/host_l_cnt/                                  [Kernel PMU event]
>   nmem0/host_l_dur/                                  [Kernel PMU event]
>   nmem0/host_s_cnt/                                  [Kernel PMU event]
>   nmem0/host_s_dur/                                  [Kernel PMU event]
>   nmem0/med_r_cnt/                                   [Kernel PMU event]
>   nmem0/med_r_dur/                                   [Kernel PMU event]
>   nmem0/med_w_cnt/                                   [Kernel PMU event]
>   nmem0/med_w_dur/                                   [Kernel PMU event]
>   nmem0/mem_life/                                    [Kernel PMU event]
>   nmem0/poweron_secs/                                [Kernel PMU event]
>   ...
>   nmem1/mem_life/                                    [Kernel PMU event]
>   nmem1/poweron_secs/                                [Kernel PMU event]
>
> Patch1:
>         Introduces the nvdimm_pmu structure
> Patch2:
>         Adds common interface to add arch/platform specific data
>         includes nvdimm device pointer, pmu data along with
>         pmu event functions. It also defines supported event list
>         and adds attribute groups for format, events and cpumask.
>         It also adds code for cpu hotplug support.
> Patch3:
>         Add code in arch/powerpc/platform/pseries/papr_scm.c to expose
>         nmem* pmu. It fills in the nvdimm_pmu structure with pmu name,
>         capabilities, cpumask and event functions and then registers
>         the pmu by adding callbacks to register_nvdimm_pmu.
> Patch4:
>         Sysfs documentation patch
>
> Changelog
> ---
> Resend v5 -> v6
> - No logic change, just a rebase to latest upstream and
>   tested the patchset.
>
> - Link to the patchset Resend v5: https://lkml.org/lkml/2021/11/15/3979
>
> v5 -> Resend v5
> - Resend the patchset
>
> - Link to the patchset v5: https://lkml.org/lkml/2021/9/28/643
>
> v4 -> v5:
> - Remove multiple variables defined in nvdimm_pmu structure include
>   name and pmu functions(event_int/add/del/read) as they are just
>   used to copy them again in pmu variable. Now we are directly doing
>   this step in arch specific code as suggested by Dan Williams.
>
> - Remove attribute group field from nvdimm pmu structure and
>   defined these attribute groups in common interface which
>   includes format, event list along with cpumask as suggested by
>   Dan Williams.
>   Since we added static defination for attrbute groups needed in
>   common interface, removes corresponding code from papr.
>
> - Add nvdimm pmu event list with event codes in the common interface.
>
> - Remove Acked-by/Reviewed-by/Tested-by tags as code is refactored
>   to handle review comments from Dan.

I don't think review comments should invalidate the Acked-by tags in
this case. Nothing fundamentally changed in the approach, and I would
like to have the perf ack before taking this through the nvdimm tree.

Otherwise this looks good to me.

Peter, might you have a chance to re-Ack this series, or any concerns
about me retrieving those Acks from the previous postings?
