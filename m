Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A182FB8
	for <nvdimm@lists.linux.dev>; Tue, 15 Jun 2021 23:20:52 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id v12so139731plo.10
        for <nvdimm@lists.linux.dev>; Tue, 15 Jun 2021 16:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zd5vgVNz+BmI/+O1FJjX2xJNxwUvhrCsjTqsqRhVW9Y=;
        b=CrcZsdj6rEXbgOdwBBdjg1x0Eme5binzIOsQkq/2hl+SeN6h0GaGuYWlr1mHOpmorF
         FId2dpmBgweNYfW9qXSjEBMcpLVIkYFcJ/YyyeT+h+l8zDyk+Zv/BsUdk6Ajt5cRY6Yf
         QnXQpzmjJSoTTf3Z8jBEFcRnOPIMHiVPM2LpRvdltjtRom3YMK4QbdyeTdqncRvWh3Uh
         +AGU1EXL/njsND3pc85Aml2RcFDyi8pJnixCESzkWDWL4sDmXar1ZSxukkI4ukHjR6BP
         iMfHlT2jKaAyIQM27M5km8bKAx0MqS0rxzEFsG4uYCVlg1Ms9G26WSHmkoJazaTb9/bR
         kegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zd5vgVNz+BmI/+O1FJjX2xJNxwUvhrCsjTqsqRhVW9Y=;
        b=amruiBCqeHZ4FbniDhAjM1iMKdKspWEpjpfeT06MGs4rC57tuS2QPRQuO0Ha9M2X3S
         0QHeL0Jgn8sBIPl6PXOzyOtmy+AcFFdARFqQnu603lKGVPjSvem/XZ/9xGM3RGqBPEDj
         zYvqAMkUjCUcnC3497NwNEI91Ky3SX1wjXfJgqvlSMsKgMvlHrUgOQZsjZCu1e2jygXU
         VfdI5UUSepz8pcsXrDrS6axHJPTzeufHM6I2XV8Ksq3ZVCL7uV5j7oOMQK+oTQ8GsZ+5
         42aUg5Spx4GZNwbcrjEE2sJQa7CqMMvD1CASjFN3atW2Id3cAusHVqOaP7P3393LYqaB
         YHDA==
X-Gm-Message-State: AOAM530vD4oyJi48alA6zxpKObDch6kCE3ElcwhCNNGWvU+ThFzH6dFc
	L7HR0TakWl441+o3R0Mw8uAix4yj6B/8JqfgZxlSlw==
X-Google-Smtp-Source: ABdhPJz+py7Ki207LQKkcaYiS/g6TZhrR/NeFcK27HudFHZM+aZpy9smR2p3nJPX2ycC3FVpOMXU9LiZ8BJt+I2gxCU=
X-Received: by 2002:a17:90a:ea8c:: with SMTP id h12mr7223781pjz.149.1623799252369;
 Tue, 15 Jun 2021 16:20:52 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162379908663.2993820.16543025953842049041.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162379908663.2993820.16543025953842049041.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Jun 2021 16:20:41 -0700
Message-ID: <CAPcyv4jPisJ+6hsQn6FGDDtpfcb6K82K2rU2rv3A8HE6z--wvw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] cxl/pmem: Add core infrastructure for PMEM support
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 15, 2021 at 4:18 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Changes since v1 [1]:

Neglected the v1 link:

https://lore.kernel.org/r/162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com

> - cleanup @flush determination in unregister_nvb() (Jonathan)
> - cleanup online_nvdimm_bus() to return a status code (Jonathan)
> - drop unnecessary header includes (Jonathan)
> - drop unused cxl_nvdimm driver data (Jonathan)
> - rename the bus to be unregistered as @victim_bus in
>   cxl_nvb_update_state() (Jonathan)
> - miscellaneous cleanups and pick up reviewed-by's (Jonathan)
>
> ---
>
> CXL Memory Expander devices (CXL 2.0 Type-3) support persistent memory
> in addition to volatile memory expansion. The most significant changes
> this requires of the existing LIBNVDIMM infrastructure, compared to what
> was needed to support ACPI NFIT defined PMEM, is the ability to
> dynamically provision regions in addition to namespaces, and a formal
> model for hotplug.
>
> Before region provisioning can be added the CXL enabling needs to
> enumerate "nvdimm" devices on a CXL nvdimm-bus. This is modeled as a
> CXL-nvdimm-bridge device (bridging CXL to nvdimm) and an associated
> driver to activate and deactivate that bus-bridge. Once the bridge is
> registered it scans for CXL nvdimm devices registered by endpoints.  The
> CXL core bus is used as a rendezvous for nvdimm bridges and endpoints
> allowing them to be registered and enabled in any order.
>
> At the end of this series the ndctl utility can see CXL nvdimm resources
> just like any other nvdimm bus.
>
>     # ndctl list -BDiu -b CXL
>     {
>       "provider":"CXL",
>       "dev":"ndbus1",
>       "dimms":[
>         {
>           "dev":"nmem1",
>           "state":"disabled"
>         },
>         {
>           "dev":"nmem0",
>           "state":"disabled"
>         }
>       ]
>     }
>
> Follow-on patches extend the nvdimm core label support for CXL region
> and namespace labels. For now just add the machinery to register the
> bus and nvdimm base objects.
>
> ---
>
> Dan Williams (5):
>       cxl/core: Add cxl-bus driver infrastructure
>       cxl/pmem: Add initial infrastructure for pmem support
>       libnvdimm: Export nvdimm shutdown helper, nvdimm_delete()
>       libnvdimm: Drop unused device power management support
>       cxl/pmem: Register 'pmem' / cxl_nvdimm devices
>
>
>  drivers/cxl/Kconfig        |   13 ++
>  drivers/cxl/Makefile       |    2
>  drivers/cxl/acpi.c         |   37 ++++++
>  drivers/cxl/core.c         |  280 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h          |   56 +++++++++
>  drivers/cxl/mem.h          |    1
>  drivers/cxl/pci.c          |   23 +++-
>  drivers/cxl/pmem.c         |  230 ++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/bus.c       |   64 ++++++----
>  drivers/nvdimm/dimm_devs.c |   18 +++
>  include/linux/libnvdimm.h  |    1
>  11 files changed, 694 insertions(+), 31 deletions(-)
>  create mode 100644 drivers/cxl/pmem.c
>
> base-commit: 87815ee9d0060a91bdf18266e42837a9adb5972e
