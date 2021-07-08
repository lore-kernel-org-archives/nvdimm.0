Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A553172
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 21:24:15 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id a14so3885094pls.4
        for <nvdimm@lists.linux.dev>; Thu, 08 Jul 2021 14:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F7qsmEb8ey2v8y0REF6i/dtziPA+Gus4xfYU77wMYUY=;
        b=n+Ly2atkF5mNQha8ygOsg8vTRXcoPEtQ4FUvGnAK6+b6Kg8bOiBLiUG3nY4cWZEAiF
         h8uA9LJqdf0CrVK2JuDD5x8b9yCpsetMhBzmfrq4YvWscXKc73TnRB3DG+uYr8JSNGRc
         lRKdbgzUMUeqHg3dxSDbfcxEW4hQRTWF8l4gdQfD6CCVihmwdVXyBkdKZBEIhmwpOxl5
         4+Ps+lpKD4Y2gFtqRSpoX6amwIlPciIM7Vev50L66Ub5TNDVqP8ewwUa9gezKNcuZf0R
         uJWHNyWTaVBxxfcJtn7Qzbn10L96R4H+Ed/g9G7102QkC0hYOgs9fedbsSHOTW+tauak
         ZoWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F7qsmEb8ey2v8y0REF6i/dtziPA+Gus4xfYU77wMYUY=;
        b=D/hmoYZ0pSAJR5hGmqZ2dtJnbikXjwG95qraNiH6eRBs78RSqlzQI2s+/njlHm/sax
         DMQvEztEfbaV7LmumE/JPhtvR8dwtKRPOAJzj9uD4ipPT+D2dNPRIAZscgDMdzn4V2x/
         8esKSmf/cmwlqi+/N4V2Gm4TrxOtoPkfKyPuuKian5cFmrBTJy90TQUg1ijVHjj4yuNA
         SQkDmcjvQFWpEkIehE4hWWcDlouGjnEB4l6LDmyZCiVQEVhGdhHKsDW82g4/Go37tYCT
         GrlQ0ulv/0eAiO8x57x0xTn1aWJnVVVkedkmeXhGXYF3FWq5lT8TpAijBQDOE/1mi3Mu
         4a3Q==
X-Gm-Message-State: AOAM531FPnxJck0Ke8aHa5sF7JyhqTMs6orY9ouHfzuQNWgedkVPfrH/
	PpXYUbQBv4b/hCecehv7DF9yX0AbdJ61hhHhNv7eeQ==
X-Google-Smtp-Source: ABdhPJyRurawPQQZXLp6l7IYoFYZUnOs1vhVj0W0wVaODvdgKHJHth1aJTjr8OYLvBLZ/KI689Xp7difM/3dVnrefVA=
X-Received: by 2002:a17:902:8c81:b029:129:a9a8:67f9 with SMTP id
 t1-20020a1709028c81b0290129a9a867f9mr13486160plo.79.1625779454947; Thu, 08
 Jul 2021 14:24:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210708183741.2952-1-james.sushanth.anandraj@intel.com>
In-Reply-To: <20210708183741.2952-1-james.sushanth.anandraj@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Jul 2021 14:24:04 -0700
Message-ID: <CAPcyv4iQqL7dGxgN_pSR0Gu27DXX4-d6SNhi2nUs38Mrq+jB=Q@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] ndctl: Add pcdctl tool with pcdctl list and
 reconfigure-region commands
To: James Anandraj <james.sushanth.anandraj@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, jmoyer <jmoyer@redhat.com>, 
	=?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, 
	Adam Borowski <kilobyte@angband.pl>
Content-Type: text/plain; charset="UTF-8"

[ add Jeff, Michal, and Adam ]

Hey ndctl distro maintainers,

Just wanted to highlight this new tool submission for your
consideration. The goal here is to have a Linux native provisioning
tool that covers the basics of the functionality that is outside of
the ACPI specification, and reduce the need for ipmctl outside of
exceptional device-specific debug scenarios. Recall that the ACPI NFIT
communicates the static region configuration to the OS, but changing
that configuration is a device-specific protocol plus a reboot. Until
the arrival of pcdctl, region provisioning required ipmctl.

I will note that CXL moves the region configuration into the base CXL
specification so the ndctl project will pick up a "cxl-cli" tool for
that purpose. In general, the ndctl project is open to carrying
support for persistent memory devices with open specifications. In
this case the provisioning specification for devices formerly driven
by ipmctl was opened up and provided here:

https://cdrdv2.intel.com/v1/dl/getContent/634430

Please comment on its suitability for shipping in distros alongside
the ndctl tool.

On Thu, Jul 8, 2021 at 11:38 AM James Anandraj
<james.sushanth.anandraj@intel.com> wrote:
>
> From: James Sushanth Anandraj <james.sushanth.anandraj@intel.com>
>
> The Intel Optane Persistent Memory OS provisioning specification
> describes how to support basic provisioning for Intel Optane
> persistent memory 100 and 200 series for use in different
> operating modes using OS software.
>
> This patch set introduces a new utility pcdctl that implements
> basic provisioning as described in the provisioning specification
> document at https://cdrdv2.intel.com/v1/dl/getContent/634430 .
>
> The pcdctl utility provides enumeration and region reconfiguration
> commands for "nvdimm" subsystem devices (Non-volatile Memory). This
> is implemented as a separate tool rather than as a feature of ndctl as
> the steps for provisioning are specific to Intel Optane devices and
> are as follows.
> 1..Generate a new region configuration request using this utility.
> 2. Reset the platform.
> 3. Use this utility to list the status of operation.
>
> James Sushanth Anandraj (4):
>   Documentation/pcdctl: Add documentation for pcdctl tool and commands
>   pcdctl/list: Add pcdctl-list command to enumerate 'nvdimm' devices
>   pcdctl/reconfigure: Add pcdctl-reconfigure-region command
>   pcdctl/reconfigure: Add support for pmem and iso-pmem modes
>
>  Documentation/pcdctl/Makefile.am              |   59 +
>  .../pcdctl/asciidoctor-extensions.rb          |   30 +
>  Documentation/pcdctl/pcdctl-list.txt          |   56 +
>  .../pcdctl/pcdctl-reconfigure-region.txt      |   50 +
>  Documentation/pcdctl/pcdctl.txt               |   40 +
>  Documentation/pcdctl/theory-of-operation.txt  |   28 +
>  Makefile.am                                   |    4 +-
>  configure.ac                                  |    2 +
>  pcdctl/Makefile.am                            |   18 +
>  pcdctl/builtin.h                              |    9 +
>  pcdctl/list.c                                 |  114 ++
>  pcdctl/list.h                                 |   11 +
>  pcdctl/pcat.c                                 |   59 +
>  pcdctl/pcat.h                                 |   13 +
>  pcdctl/pcd.h                                  |  381 +++++
>  pcdctl/pcdctl.c                               |   88 +
>  pcdctl/reconfigure.c                          | 1458 +++++++++++++++++
>  pcdctl/reconfigure.h                          |   12 +
>  util/main.h                                   |    1 +
>  19 files changed, 2431 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/pcdctl/Makefile.am
>  create mode 100644 Documentation/pcdctl/asciidoctor-extensions.rb
>  create mode 100644 Documentation/pcdctl/pcdctl-list.txt
>  create mode 100644 Documentation/pcdctl/pcdctl-reconfigure-region.txt
>  create mode 100644 Documentation/pcdctl/pcdctl.txt
>  create mode 100644 Documentation/pcdctl/theory-of-operation.txt
>  create mode 100644 pcdctl/Makefile.am
>  create mode 100644 pcdctl/builtin.h
>  create mode 100644 pcdctl/list.c
>  create mode 100644 pcdctl/list.h
>  create mode 100644 pcdctl/pcat.c
>  create mode 100644 pcdctl/pcat.h
>  create mode 100644 pcdctl/pcd.h
>  create mode 100644 pcdctl/pcdctl.c
>  create mode 100644 pcdctl/reconfigure.c
>  create mode 100644 pcdctl/reconfigure.h
>
> --
> 2.20.1
>
>
