Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AF46ACA
	for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 21:17:19 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id i1so6058702plr.2
        for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 13:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wcLO/DsAxaLfi5/b2/mtuFadfkpKXF/EUQvaL26ETM8=;
        b=39luujE51p1TOwhFigHUe3/smVkTSMc2mJarc9lCov4oRdLWGxXYiYCO/W39NXrf2Q
         rslTqbX3YHUXHamp556f3pG9oehBMOMt1WuFEdEhpQUavfZq+WzPB9HTf37HIqAU3+WL
         7Em72YPtYehAU0cGOLbjKlqhek5YEr36sdXRluBAH7Q7HMpmATR5fSk576i7xQbBJBhG
         IGekvTrHdXQMZ2nSHCmYkS6I6ZFgZ38GH0JTLq6c7H5ah24PFteyKNYozk4mTPO+r76P
         3tvcKnM8Ndbe0trEPddIUIQzeV+jUMQ1NRehFVh6S7Czlk9+Ch2ScVQbD7gDTvttErQt
         9B8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wcLO/DsAxaLfi5/b2/mtuFadfkpKXF/EUQvaL26ETM8=;
        b=TyaZB4qW4PC2mQBPessF+WkA8lAfZrI7OVC4j53FUJUh94M7NqEWEW75+6HgZdcrcT
         /C3sow7WzOwOVVO9X1lXEQv5jO79yvfNyi9Dp3K5zDXx1QoC2X0RiQvz//8bs5lo5qhG
         r+qm1TWHKXu7ylIOx/uJ+6OOLbH/vkDalqBko5DwLGTnOwYXpCEMHuyMkTvVOr++wP0q
         CcZ6I4cVg2u9s8Lb5fwXFbq4n2q3BFdFV43A6kTf8V2iBUFgRGnDJw+jlTjvA7U1RAdX
         iHEAsdHv68eartvmn70EahQeHvm3LJIAZph3vqCiw6IZzgLGXw+54a9aFPX9/G+Zoj2c
         y0Qg==
X-Gm-Message-State: AOAM532Sqbo0sjJ6/vOMmz1QOtukAySYWVR/wGWZW49POZU1a1WoovGL
	M04Y/chtg0b/XkqUNgKhPiIEzwVbOPEqVGdGiRyD7Q==
X-Google-Smtp-Source: ABdhPJz71jjeyXpAaQfHMtXS5jdm1SjDPb2i/xbUDUNrdZNB2VBI8lrF8+Uf0rxZGYol9vDDIVQcg/XDf5QCmz3GI9U=
X-Received: by 2002:a17:90a:990c:b0:1bc:3c9f:2abe with SMTP id
 b12-20020a17090a990c00b001bc3c9f2abemr1274790pjp.220.1645651038711; Wed, 23
 Feb 2022 13:17:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220217163357.276036-1-kjain@linux.ibm.com> <CAPcyv4jwpMbz0woftSfm3EO05pr3ZG9rVMJCkYVsapKYSOn3xw@mail.gmail.com>
 <CAPcyv4hkLA_KJsKO_avTDZCVL2zGhcRNxVc+2P2uR6-5b2uwVA@mail.gmail.com>
In-Reply-To: <CAPcyv4hkLA_KJsKO_avTDZCVL2zGhcRNxVc+2P2uR6-5b2uwVA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Feb 2022 13:17:07 -0800
Message-ID: <CAPcyv4jCeweE3A90bP-xUkM9pNQw=XdsFxvFye4=bVRNKWwHKQ@mail.gmail.com>
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

On Wed, Feb 23, 2022 at 11:07 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Fri, Feb 18, 2022 at 10:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > On Thu, Feb 17, 2022 at 8:34 AM Kajol Jain <kjain@linux.ibm.com> wrote:
> > >
> > > Patchset adds performance stats reporting support for nvdimm.
> > > Added interface includes support for pmu register/unregister
> > > functions. A structure is added called nvdimm_pmu to be used for
> > > adding arch/platform specific data such as cpumask, nvdimm device
> > > pointer and pmu event functions like event_init/add/read/del.
> > > User could use the standard perf tool to access perf events
> > > exposed via pmu.
> > >
> > > Interface also defines supported event list, config fields for the
> > > event attributes and their corresponding bit values which are exported
> > > via sysfs. Patch 3 exposes IBM pseries platform nmem* device
> > > performance stats using this interface.
> > >
> > > Result from power9 pseries lpar with 2 nvdimm device:
> > >
> > > Ex: List all event by perf list
> > >
> > > command:# perf list nmem
> > >
> > >   nmem0/cache_rh_cnt/                                [Kernel PMU event]
> > >   nmem0/cache_wh_cnt/                                [Kernel PMU event]
> > >   nmem0/cri_res_util/                                [Kernel PMU event]
> > >   nmem0/ctl_res_cnt/                                 [Kernel PMU event]
> > >   nmem0/ctl_res_tm/                                  [Kernel PMU event]
> > >   nmem0/fast_w_cnt/                                  [Kernel PMU event]
> > >   nmem0/host_l_cnt/                                  [Kernel PMU event]
> > >   nmem0/host_l_dur/                                  [Kernel PMU event]
> > >   nmem0/host_s_cnt/                                  [Kernel PMU event]
> > >   nmem0/host_s_dur/                                  [Kernel PMU event]
> > >   nmem0/med_r_cnt/                                   [Kernel PMU event]
> > >   nmem0/med_r_dur/                                   [Kernel PMU event]
> > >   nmem0/med_w_cnt/                                   [Kernel PMU event]
> > >   nmem0/med_w_dur/                                   [Kernel PMU event]
> > >   nmem0/mem_life/                                    [Kernel PMU event]
> > >   nmem0/poweron_secs/                                [Kernel PMU event]
> > >   ...
> > >   nmem1/mem_life/                                    [Kernel PMU event]
> > >   nmem1/poweron_secs/                                [Kernel PMU event]
> > >
> > > Patch1:
> > >         Introduces the nvdimm_pmu structure
> > > Patch2:
> > >         Adds common interface to add arch/platform specific data
> > >         includes nvdimm device pointer, pmu data along with
> > >         pmu event functions. It also defines supported event list
> > >         and adds attribute groups for format, events and cpumask.
> > >         It also adds code for cpu hotplug support.
> > > Patch3:
> > >         Add code in arch/powerpc/platform/pseries/papr_scm.c to expose
> > >         nmem* pmu. It fills in the nvdimm_pmu structure with pmu name,
> > >         capabilities, cpumask and event functions and then registers
> > >         the pmu by adding callbacks to register_nvdimm_pmu.
> > > Patch4:
> > >         Sysfs documentation patch
> > >
> > > Changelog
> > > ---
> > > Resend v5 -> v6
> > > - No logic change, just a rebase to latest upstream and
> > >   tested the patchset.
> > >
> > > - Link to the patchset Resend v5: https://lkml.org/lkml/2021/11/15/3979
> > >
> > > v5 -> Resend v5
> > > - Resend the patchset
> > >
> > > - Link to the patchset v5: https://lkml.org/lkml/2021/9/28/643
> > >
> > > v4 -> v5:
> > > - Remove multiple variables defined in nvdimm_pmu structure include
> > >   name and pmu functions(event_int/add/del/read) as they are just
> > >   used to copy them again in pmu variable. Now we are directly doing
> > >   this step in arch specific code as suggested by Dan Williams.
> > >
> > > - Remove attribute group field from nvdimm pmu structure and
> > >   defined these attribute groups in common interface which
> > >   includes format, event list along with cpumask as suggested by
> > >   Dan Williams.
> > >   Since we added static defination for attrbute groups needed in
> > >   common interface, removes corresponding code from papr.
> > >
> > > - Add nvdimm pmu event list with event codes in the common interface.
> > >
> > > - Remove Acked-by/Reviewed-by/Tested-by tags as code is refactored
> > >   to handle review comments from Dan.
> >
> > I don't think review comments should invalidate the Acked-by tags in
> > this case. Nothing fundamentally changed in the approach, and I would
> > like to have the perf ack before taking this through the nvdimm tree.
> >
> > Otherwise this looks good to me.
> >
> > Peter, might you have a chance to re-Ack this series, or any concerns
> > about me retrieving those Acks from the previous postings?
>
> Reached Peter offline and he refreshed his Acked-by.

There's still time for the tags from:

"Madhavan Srinivasan"
"Nageswara R Sastry"

...to be reapplied, but I'll go ahead with pushing this to Linux-next
in the meantime.
