Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C362C9C
	for <nvdimm@lists.linux.dev>; Tue,  8 Feb 2022 20:21:07 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id v4so232031pjh.2
        for <nvdimm@lists.linux.dev>; Tue, 08 Feb 2022 12:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NwDCa47X8Eug/6v4MV2A+Ugh8JIZON4rC1VssoGwWug=;
        b=PUWbGF762qJ5VB5iMSegsOVyt7vSjfFE5HqcdzbFEnVB9tgByxv3jbVbYGmyNBPtjS
         C4Zij8hof/AsHAFNdc/TAKq16cB5AI4ECwpsz8gO107BzL7wYlUkPacgotO4awIHBd6b
         rHi3tWhS9+fge33+/ANnkara1OU6ZbWTCT8C9ecsooSGOCXLDDO+mzOdMRPX3k4mzyb2
         5IQB/2x+dSCb9dqf3634MXxrO3BbPGWCV3bo1pgy9Az/hDx3VcrFmqjZ82WeyYqxkv57
         r21/mxPARolAjsCX1vhj/msGSadaGxmZS9oha8ODSTWtzKvBzmJQlRPYwmgadDpDlUiM
         MOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NwDCa47X8Eug/6v4MV2A+Ugh8JIZON4rC1VssoGwWug=;
        b=PG5rb0Q7MVPyVijsuQFFxmgS+B7hzXyY0D96iYfEgLRE18TnF2vxOYrlaF3Ffkm/MN
         crklD2lEK5eRtlqCRsMjWI3RWVGKESewJt03hfu5mUibRAOiNfSa41KbL2oYN6qNvnVm
         pKFPYKoANFtVCNjJNEOpWc/PejIJwxMAX4FOwEqo4Jw1tKEvo01Sq33O7CryTpuAzqxS
         taZ9IP9EKenHsgb80KOb1JfrAHsLkUSMXFnzevd6SFz79SXxXIdP3ti+kH556IaX/ap7
         wuFpfuM1E4ivg8+Iv2Kf1B8miQGBNspi/lsN0nWjT0VF08R/aqjKLVpvnjN5wwOeCCNe
         K2mw==
X-Gm-Message-State: AOAM531O5n4N+63YuVJdQwMzQGDaM3plwLcQ7IEQWc9jRzBgQvwkTtDn
	WaqSVszb1Vs+B+U4eSxWC/fl1DuFRsSnJpSWTRaI5A==
X-Google-Smtp-Source: ABdhPJxTihnpY483LhDWGsBo6kyaE/KdpoRJtMDGkwYdmu4m+Y+UW1gLv1d9qGwk7mCaSpTG5Zvxyr8MsWXsdXDDNHc=
X-Received: by 2002:a17:90b:3ece:: with SMTP id rm14mr3216000pjb.220.1644351667395;
 Tue, 08 Feb 2022 12:21:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1644271559.git.alison.schofield@intel.com> <396ccc39525b3eb829acd4e06f704f6fb57a94a8.1644271559.git.alison.schofield@intel.com>
In-Reply-To: <396ccc39525b3eb829acd4e06f704f6fb57a94a8.1644271559.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Feb 2022 12:20:56 -0800
Message-ID: <CAPcyv4gYbLGkd99fvKixAmLAhpkfQU8gNJ0e0BHrmVUZ3wWA_A@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 1/6] libcxl: add GET_PARTITION_INFO mailbox
 command and accessors
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 7, 2022 at 3:06 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> Users need access to the CXL GET_PARTITION_INFO mailbox command
> to inspect and confirm changes to the partition layout of a memory
> device.
>
> Add libcxl APIs to create a new GET_PARTITION_INFO mailbox command,
> the command output data structure (privately), and accessor APIs to
> return the different fields in the partition info output.
>
> Per the CXL 2.0 specification, devices report partition capacities
> as multiples of 256MB. Define and use a capacity multiplier to
> convert the raw data into bytes for user consumption. Use byte
> format as the norm for all capacity values produced or consumed
> using CXL Mailbox commands.
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  Documentation/cxl/lib/libcxl.txt |  1 +
>  cxl/lib/libcxl.c                 | 57 ++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym               |  5 +++
>  cxl/lib/private.h                | 10 ++++++
>  cxl/libcxl.h                     |  5 +++
>  util/size.h                      |  1 +
>  6 files changed, 79 insertions(+)
>
> diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> index 4392b47..a6986ab 100644
> --- a/Documentation/cxl/lib/libcxl.txt
> +++ b/Documentation/cxl/lib/libcxl.txt
> @@ -131,6 +131,7 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
>                           size_t offset);
>  int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf, size_t length,
>                            size_t offset);
> +struct cxl_cmd *cxl_cmd_new_get_partition(struct cxl_memdev *memdev);
>
>  ----
>
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index e0b443f..33cf06b 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1985,6 +1985,12 @@ static int cxl_cmd_validate_status(struct cxl_cmd *cmd, u32 id)
>         return 0;
>  }
>
> +static unsigned long long
> +capacity_to_bytes(unsigned long long size)

If this helper converts an encoded le64 to bytes then the function
signature should reflect that:

static uint64_t cxl_capacity_to_bytes(leint64_t size)

> +{
> +       return le64_to_cpu(size) * CXL_CAPACITY_MULTIPLIER;
> +}
> +
>  /* Helpers for health_info fields (no endian conversion) */
>  #define cmd_get_field_u8(cmd, n, N, field)                             \
>  do {                                                                   \
> @@ -2371,6 +2377,57 @@ CXL_EXPORT ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd,
>         return length;
>  }
>
> +CXL_EXPORT struct cxl_cmd *cxl_cmd_new_get_partition(struct cxl_memdev *memdev)
> +{
> +       return cxl_cmd_new_generic(memdev,
> +                                  CXL_MEM_COMMAND_ID_GET_PARTITION_INFO);
> +}
> +
> +static struct cxl_cmd_get_partition *
> +cmd_to_get_partition(struct cxl_cmd *cmd)
> +{

This could also check for cmd == NULL just to be complete.

> +       if (cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_GET_PARTITION_INFO))
> +               return NULL;
> +
> +       return cmd->output_payload;
> +}
> +
> +CXL_EXPORT unsigned long long
> +cxl_cmd_partition_get_active_volatile_size(struct cxl_cmd *cmd)
> +{
> +       struct cxl_cmd_get_partition *c;
> +
> +       c = cmd_to_get_partition(cmd);
> +       return c ? capacity_to_bytes(c->active_volatile) : ULLONG_MAX;

I'd prefer kernel coding style which wants:

if (!c)
    return ULLONG_MAX;
return cxl_capacity_to_bytes(c->active_volatile);

Otherwise, looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
