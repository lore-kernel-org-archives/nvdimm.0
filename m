Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4C671
	for <nvdimm@lists.linux.dev>; Fri,  7 May 2021 14:12:47 +0000 (UTC)
Received: by mail-ed1-f42.google.com with SMTP id c22so10385006edn.7
        for <nvdimm@lists.linux.dev>; Fri, 07 May 2021 07:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kLniGNx4BxwN5Xd2zc0IGUwak+T5o8FFC1I3NPRJVXE=;
        b=uSs5tE4pdnmy1J5EesfN1eVWvpFDfJ1ly/S1gTE+RpFTbkyv0qiHb7E3qglgh8xHeS
         51bFyaQw0kQBalHPUo0unemVmMkSLKeHgnWjmLyZviH5ltlwQ5w8sEy88hLzBwu7ad/B
         zId42r9UHXvzucZJhnw6CY46qlzIOkoSgUuGrt9Qln+5C8FcQvhsJ2TJNZ8XMIPfRNpe
         hH2GQpcVWp/1TFmPymsPLa+DjiOZsOXrMSqn3NO5nSt30M5AUVcS1/z6Jfs5LgU9uaAq
         Z/Xli3WwfSlv2I4lCwDksdIsO3RJhiGl3/c9yr6lKw5xT5P2QsOrTRaen476Jl00SkKB
         KyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kLniGNx4BxwN5Xd2zc0IGUwak+T5o8FFC1I3NPRJVXE=;
        b=tOeSHzqCocdmqs2rk5XKOM7+PEbL7/AcayxSmFExO2ISW60lBlSZ/4yc0ztFRYu16d
         cQPj0l0tODjBImV9h1lOvkDL3vpHgF1mXL3QjQC0QPTtLFfihvrdN/jppQffCd2rM0HJ
         x0Ya3X7GurRINf0pegHDuCfcqdzLs/l4jGWmVrMAcMqSrbY9XtRorWibr2fZagbNxK7b
         3Oom9WcJmclDCM4NzH3Y1sf6jluPcjlHxl7wvRdaWA0+QLilDuKxLit4XjrIiRT1W6+R
         X4fUvkqdTC1x11HGiVPkvjl4dSEFJtWIL2G1E7iUMideP9pNmfnZlfZ3qSfAAzhlXRM4
         hNVQ==
X-Gm-Message-State: AOAM5327tHk6OnRn+uTj9ntDBcqTBaRMeotK6v2FYIBpJ1ioEdl2Lwfu
	n6Az5hj/uQtR2uV9DnAxS8qWqqpJ0QNay5yTQzZ2YQ==
X-Google-Smtp-Source: ABdhPJwWyScMuqXDcIBAuztYBHKcNDRNOaJtIKcFL4gBL8++2X0f1kwToRZXeC3Mdnv0qiilb3DxuPS08o181IP/mbQ=
X-Received: by 2002:a50:f0d6:: with SMTP id a22mr11880375edm.354.1620396766237;
 Fri, 07 May 2021 07:12:46 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162037273007.1195827.10907249070709169329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAJZ5v0gBCxFQ1pC1PTRximwzGXOSQDCzOfjX497aqBq5GQ48tA@mail.gmail.com>
In-Reply-To: <CAJZ5v0gBCxFQ1pC1PTRximwzGXOSQDCzOfjX497aqBq5GQ48tA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 7 May 2021 07:12:51 -0700
Message-ID: <CAPcyv4jUdebFQvrhi0yzNyZ1wwzeGDpf6T34m=bfL593s-PEcA@mail.gmail.com>
Subject: Re: [PATCH] ACPI: NFIT: Fix support for variable 'SPA' structure size
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rafael Wysocki <rafael.j.wysocki@intel.com>, Bob Moore <robert.moore@intel.com>, 
	Erik Kaneda <erik.kaneda@intel.com>, Yi Zhang <yi.zhang@redhat.com>, nvdimm@lists.linux.dev, 
	linux-nvdimm <linux-nvdimm@lists.01.org>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, May 7, 2021 at 2:47 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> Hi Dan,
>
> On Fri, May 7, 2021 at 9:33 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > ACPI 6.4 introduced the "SpaLocationCookie" to the NFIT "System Physical
> > Address (SPA) Range Structure". The presence of that new field is
> > indicated by the ACPI_NFIT_LOCATION_COOKIE_VALID flag. Pre-ACPI-6.4
> > firmware implementations omit the flag and maintain the original size of
> > the structure.
> >
> > Update the implementation to check that flag to determine the size
> > rather than the ACPI 6.4 compliant definition of 'struct
> > acpi_nfit_system_address' from the Linux ACPICA definitions.
> >
> > Update the test infrastructure for the new expectations as well, i.e.
> > continue to emulate the ACPI 6.3 definition of that structure.
> >
> > Without this fix the kernel fails to validate 'SPA' structures and this
> > leads to a crash in nfit_get_smbios_id() since that routine assumes that
> > SPAs are valid if it finds valid SMBIOS tables.
> >
> >     BUG: unable to handle page fault for address: ffffffffffffffa8
> >     [..]
> >     Call Trace:
> >      skx_get_nvdimm_info+0x56/0x130 [skx_edac]
> >      skx_get_dimm_config+0x1f5/0x213 [skx_edac]
> >      skx_register_mci+0x132/0x1c0 [skx_edac]
> >
> > Cc: Bob Moore <robert.moore@intel.com>
> > Cc: Erik Kaneda <erik.kaneda@intel.com>
> > Fixes: cf16b05c607b ("ACPICA: ACPI 6.4: NFIT: add Location Cookie field")
>
> Do you want me to apply this (as the commit being fixed went in
> through the ACPI tree)?

Yes, I would need to wait for a signed tag so if you're sending urgent
fixes in the next few days please take this one, otherwise I'll circle
back next week after -rc1.

>
> If you'd rather take care of it yourself:
>
> Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Thanks!
