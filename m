Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5C23FC4
	for <nvdimm@lists.linux.dev>; Mon, 13 Sep 2021 22:21:47 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id u18so10835275pgf.0
        for <nvdimm@lists.linux.dev>; Mon, 13 Sep 2021 15:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CO6JNhGxwzlrYeg/t2AMJl6r/zmgLnJENxYGTPgzp7I=;
        b=ih7DrdV4MOPf9iq7oHtkUamUdVH3SELbHI6yydBl4+sUK/+sYuiYt59B/uyllCZMIa
         7grK8W7MJ1XW4XnqgnFDCFZAcWClFY59Y+5HonPqmXGQ0q241/U7YBExdIupdlSmy9Gx
         bHXRiF538qqn9oW9mwu8DQAHgws/YySDaw9X3uE6yBYuYdh4moSgOmRqXUO8+cWswitp
         BZW101MWvvGjAsQvmyFIbn3fwxqM3vdnEcIzDe5CjbhhI27boUg5dBh04dooNkt2O798
         Qx1V90qrV5iCccgdDNatuovJved4GQ+cr7npOvt51g6KSCZfCoZ4/MXoD1wHVPGdBP5G
         lQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CO6JNhGxwzlrYeg/t2AMJl6r/zmgLnJENxYGTPgzp7I=;
        b=WL2bcYEHAlBBOd1J9CQdVW8DwvUekcCLPfyiiZAYdXVIZ4lsjjVGw978PJ1exjISMS
         fDuH6JjDoby+aKGHeeW/zvNCvRxOzOJnfp5R1E6JwcDYNRk+urTl9mj8aYG9442D5sjV
         F2Gfnj9sQNuv/VYHNig42x4TpgoQn4kO42Nd+P68aK9W4wNOlKUfY0ATeJYvEH0yN4pX
         37I1+ZQ1Q68IYDG5JGKv2Vk68pueBp9HWMVSxlu1WreXY37i54uuBjg/Y/Ycv7mJWGg2
         vCjA2qqznijbsUvTGXOgsDiZWo5KfcyGRqNrWV1XaCn/qec98GMnilOeMaISKVm8tmuq
         lJ5g==
X-Gm-Message-State: AOAM530qyiCq6P21MH0RJ3B9kFb/o1oCjTmvzS9orfGHeOAn0wu6CDlf
	b3fg/cH/JJkptnp6l0PCMBYROXda+35o+XzkribaFw==
X-Google-Smtp-Source: ABdhPJxRuPQAZqMjZlfQKUFNoNHsUfGvEt+EA8LeQiMKmg81qB6nYrbAQSpzw9xayxgeJiZiE6AhzqDuK8tZEIu0Ia4=
X-Received: by 2002:a63:1262:: with SMTP id 34mr12878848pgs.356.1631571707431;
 Mon, 13 Sep 2021 15:21:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116433533.2460985.14299233004385504131.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163157154183.2652718.10987214856112022775.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163157154183.2652718.10987214856112022775.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Sep 2021 15:21:36 -0700
Message-ID: <CAPcyv4gZ2WGsFZb0H1O+NirSRKRs2NDhByAF+nVdhFB-pdZgdA@mail.gmail.com>
Subject: Re: [PATCH v5 08/21] cxl/pci: Clean up cxl_mem_get_partition_info()
To: linux-cxl@vger.kernel.org
Cc: Ira Weiny <ira.weiny@intel.com>, Ben Widawsky <ben.widawsky@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huwei.com>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 13, 2021 at 3:20 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Commit 0b9159d0ff21 ("cxl/pci: Store memory capacity values") missed
> updating the kernel-doc for 'struct cxl_mem' leading to the following
> warnings:
>
> ./scripts/kernel-doc -v drivers/cxl/cxlmem.h 2>&1 | grep warn
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'total_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'volatile_only_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'persistent_only_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'partition_align_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'active_volatile_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'active_persistent_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'next_volatile_bytes' not described in 'cxl_mem'
> drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'next_persistent_bytes' not described in 'cxl_mem'
>
> Also, it is redundant to describe those same parameters in the
> kernel-doc for cxl_mem_get_partition_info(). Given the only user of that
> routine updates the values in @cxlm, just do that implicitly internal to
> the helper.
>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Reported-by: Ben Widawsky <ben.widawsky@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huwei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Changes since v4:
> - Update the kdoc for @partition_align_bytes (Ben)
> - Collect Jonathan's reviewed-by pending above update.

Ugh, nope, still had this change in my working tree. v6 inbound.
