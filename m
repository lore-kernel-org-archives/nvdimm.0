Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DBF2FB2
	for <nvdimm@lists.linux.dev>; Fri, 25 Jun 2021 23:49:44 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id 13-20020a17090a08cdb029016eed209ca4so6474246pjn.1
        for <nvdimm@lists.linux.dev>; Fri, 25 Jun 2021 16:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oqRYOB4yhufrE4KfV5rz7mou0hPzahcFWImUQvPEHrY=;
        b=h7+a3XPdlF75hruXah7r7X1pmp33Al/uDN7q6nB47Nd05Ab3//kzWD3HwhOaf8pDJ1
         oHhvtD3Qlic9HcfDrBtOsyEaVdjVzOyDIHep6Us7zVkZZsrjMbAblZ7ga8woohHGc6Ii
         OjP+Ckx3Y8dSyV1KUyfJa5Dk49egthOuWAKCcN+iQY1nozYBkwr1P6OBcInv/KmhfZA6
         i6QXtC1AeqBoLAZlyor+L/ojzw1gQlCLBcp2JSK7rQMRku3VllAu+Uug78+A1iIVEuCs
         5IxPdI39BfU1Sj1jxl7v8N6Dhv2sgZl04oztMA2a3WIsPF81BAPrEooNc+1x+XXG77Dk
         lTdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oqRYOB4yhufrE4KfV5rz7mou0hPzahcFWImUQvPEHrY=;
        b=OhhJOgYwIKiUk8BDIRx0qwAXArM2We+VCGSEeCmtP5Dl7ekxxapjC/61cn3DtRbqm/
         BfVM3bL7J52PzefOPRqQrCifhwm73JVMKuqA5A9z8ci9Na2vPdbVGaDdTRfaXAQxJN5r
         TofZSl3n2Ubmch5Yy0u4VdHDG50YEjaNvNrapIys3j88O/Qf6DGLOzw9MjbFjiFmfLqb
         tMW/fYMR5ONzk+2R06PNd9x2pewspp+34e9aFGXXjdx+G299f5o+CTl9lgLtc0UYkhxB
         VTDWDEDlq/Xyqc/ixMgCKTLVlAw/qK6/ys4j2mfzYwxYNYg0doBhh4uyR3WORG+MJoJm
         PkJg==
X-Gm-Message-State: AOAM530qnyK+w7/oaVQ+Zb9z+qFV8Jv/K0ijYJgMc2hNqCYNxaAT007k
	skCvwOsBaFBCzUbX+z1fCc8uZ9hVhW/pgGFVVURnpw==
X-Google-Smtp-Source: ABdhPJxpw7ILMjuH3VcDx8Tni4D7lyMQrYk9NrDho+FvwHhjZwwIyyfWB/74vNHaH0tIy0EtDqsmlZrknf4uJht5w18=
X-Received: by 2002:a17:902:b497:b029:115:e287:7b55 with SMTP id
 y23-20020a170902b497b0290115e2877b55mr11191631plr.79.1624664983670; Fri, 25
 Jun 2021 16:49:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <327f9156-9b28-d20e-2850-21c125ece8c7@oracle.com>
 <YNErtAaG/i3HBII+@garbanzo> <81b46576-f30e-5b92-e926-0ffd20c7deac@oracle.com>
 <CAPcyv4hDJiAwAfvdfvnnReMik=ZVM5oNv2SH5Qo+YV3oY=VLBQ@mail.gmail.com> <ffc97a208ada4c7f8e3d3113dd323f78@intel.com>
In-Reply-To: <ffc97a208ada4c7f8e3d3113dd323f78@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Jun 2021 16:49:33 -0700
Message-ID: <CAPcyv4ixeE+fDaGxkdhV8uVA+_9OYkd086wA5pARA2HM6UZQGw@mail.gmail.com>
Subject: Re: set_memory_uc() does not work with pmem poison handling
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jun 25, 2021 at 4:22 PM Luck, Tony <tony.luck@intel.com> wrote:
>
> -       else
> -               rc = set_memory_uc(decoy_addr, 1);
> +       else {
> +               /*
> +                * Bypass memtype checks since memory-failure has shot
> +                * down mappings.
> +                */
> +               rc = _set_memory_uc(decoy_addr, 1);
> +       }
>
> Does pmem "fix" poison addresses yet? If it does (or will) does it matter that
> you skip the memtype_reserve() call?

It does fix them via clear_mce_nospec(), but that also looks like it
should be using the _set_memory_wb() version to bypass the memory type
reservation twiddling.

That said, I don't understand why set_memory_wb(), non "_" version,
thinks it can unconditionally delete any memtype reservation that
might exist for that pfn? The set_memory_* apis seem disjoint (wrt
memtype) for a reason that eludes me.
