Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD7772
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 23:59:49 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so6104551pjb.4
        for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 15:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t02UqgZc2QhnaS2krogft7UDzt5BTgan1OGAY6pK/vs=;
        b=Vie4JoLMrqgeF7o16WIe8gRIzXzPjqIe3wxTea4vBQBEtNfIFptF5eRCjDszp/Ythp
         yV+Gn5/ewyLPbuf2/+Mw5mMLZWej4/mLWTuY4xf2CsnK/0JC9/XluFe+Z+0Pfo6bW7nD
         10HS5itjeiKDGQ5t4PnVOZ1KDN0OdbivQStWaAzRc5YF4y8MUIcYR6iEVsgyUjbQ5yU1
         vgwQeV03meU5AhPpFDhoBY7hr46yMWQ45B5VHbNYARVcZHRSPbcUSuXlriCoSPMc43NR
         ClM0ww9RP+nJ28+AG+dqftrFpvtI5EstWE3gHmpwUKAlXe9UkMYTemEsJEp4b+TbGSMJ
         fQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t02UqgZc2QhnaS2krogft7UDzt5BTgan1OGAY6pK/vs=;
        b=l/2/9t04q40QmWhSAESaw2UOzf7stEccyQjNy9mrnBBb5rRdqwye8HaKyPCcLehbHR
         sFgqAOjkljq0K1IQAk8USwVVM7sHwZJK1p8xxSxomfoWUTTpQljjPFErsHOOlyGnTfHB
         hH+HoI2goCkFUII/GDQ2pQvi63n1ErfKTgALnpIhl7S/T7s4vQi5DlEDj9OsqYvj3SKS
         dQpk5twIV/7TxqCTont4miXhi4xdO4UVp+f9J5Tc31GWut6no8KXfSyqFn17lvCjnVNn
         X+gxCQdASQ1K2TdnEyhy3O1gU21eItFsD2D7dTRm3+FAXyqQEHGz7Jz1mmEv5rSi/oxE
         dDcQ==
X-Gm-Message-State: AOAM531cUQvcRvfzvy01nvrMxcMpcPKyfbWLyNMh8gTG+Mz/0aftluAX
	64SL3OWgxfG1bTq+kOmEXmOlvgVa2uOdoJlgrVZLuA==
X-Google-Smtp-Source: ABdhPJxH7ufDXmgS0mxdiiqLRtOa0NuamwCZbHk26u8TebikwoL/r1wMBHOKYV/DV1sRWEpfHZBdrkaho9QLDaU11GA=
X-Received: by 2002:a17:902:7fcd:b0:142:8ab3:ec0e with SMTP id
 t13-20020a1709027fcd00b001428ab3ec0emr3462762plb.4.1636675189483; Thu, 11 Nov
 2021 15:59:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211111204436.1560365-1-vishal.l.verma@intel.com> <20211111204436.1560365-17-vishal.l.verma@intel.com>
In-Reply-To: <20211111204436.1560365-17-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Nov 2021 15:59:37 -0800
Message-ID: <CAPcyv4gLpfF_fahLJSw7BC4AkrU5pN+HeqA2E3Aj1+-iDGPZ-A@mail.gmail.com>
Subject: Re: [ndctl PATCH v5 16/16] cxl: add health information to cxl-list
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 11, 2021 at 12:45 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add JSON output for fields from the 'GET_HEALTH_INFO' mailbox command
> to memory device listings.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt |   4 +
>  util/json.h                    |   1 +
>  cxl/list.c                     |   5 +
>  util/json.c                    | 179 +++++++++++++++++++++++++++++++++
>  4 files changed, 189 insertions(+)
>
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index bd377b3..dc86651 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -53,6 +53,10 @@ OPTIONS
>  --idle::
>         Include idle (not enabled / zero-sized) devices in the listing
>
> +-H::
> +--health::
> +       Include health information in the memdev listing

Let's include a sample listing here in the man page, like the
following, so that people can get an idea ahead of time about the key
names and value types in the payload. Other than that you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

  {
    "memdev":"mem7",
    "pmem_size":268435456,
    "ram_size":268435456,
    "health":{
      "maintenance_needed":true,
      "performance_degraded":true,
      "hw_replacement_needed":true,
      "media_normal":false,
      "media_not_ready":false,
      "media_persistence_lost":false,
      "media_data_lost":true,
      "media_powerloss_persistence_loss":false,
      "media_shutdown_persistence_loss":false,
      "media_persistence_loss_imminent":false,
      "media_powerloss_data_loss":false,
      "media_shutdown_data_loss":false,
      "media_data_loss_imminent":false,
      "ext_life_used":"normal",
      "ext_temperature":"critical",
      "ext_corrected_volatile":"warning",
      "ext_corrected_persistent":"normal",
      "life_used_percent":15,
      "temperature":25,
      "dirty_shutdowns":10,
      "volatile_errors":20,
      "pmem_errors":30
    }
