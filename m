Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B708A168
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 05:12:59 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id o201so13423289pfd.1
        for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 22:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sj/ubujvDJn+tlwsupDed8IcALbOcjCactAn0/S6HQw=;
        b=rBY1rKgkJTN61vby7Hleb1gyZwgstf4gOxOpA1KBlIBR9/BpaI9/XD+P3aS9Dz7cO3
         cyhH5setx+QASoO5+FgYuYAXbq+kgwQGoTCdrgbSL447RhanB9sKMDoomFkw+UP05a+K
         /Mmap6TN60uUVna1UQwN2WJrDAGQCfkFsS9FVLJWRgxav1inb+I3Rrta3jMS6evT1fqs
         Dwpv5KrZVJqtl39QSaOnb1QS0kqkRuE997CmycXlhmQIAPD0FeZslweOxnz5H6/gi9mg
         1o76YYw0oWcyAy9kJXVv6FAfZ3GMQWK+HBPepyKGP1jOsj9ATjC6qlWfiiG1GOx76yps
         9J5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sj/ubujvDJn+tlwsupDed8IcALbOcjCactAn0/S6HQw=;
        b=MI7Du1jjeHogeb6oI1+VHaqYvfy+wkyC+0vA/ZMvbTAokj3mQ3MD2m3flIZWYnqdc2
         eOnmKl9MSAUfwkg41p0D3K2BmWakQET97sbI+cvwQ0Zc25QxPW94mx4PTR7JFPrB4con
         YB8Gb5SY4r5CHoPu5afM8+NhLcdCycdCUZawtfufDxr9xYozoCQ2vbWQz/HpK3oOqZQl
         sYYQDbAwLn/MM2sgYFGO2S3kt3khfTVw0RnYOpq0SFSAN5gPw1YWI/MnAJ3f2BFFeOWd
         W7Oa6jiFLop/OEqE7CMkepmdp4S38ru8VGpXqSovyOYtVsdOzKe5GrppJ7h12ApO4cUy
         qDbQ==
X-Gm-Message-State: AOAM530MQue2WDsgF7ejGsiIKD1jI6sio2jg2wfFleBGO6gA9NBtBb1K
	x18/9pFxILcwYBay6qESL9uIMW0MeQ3SZAxWAXMYmA==
X-Google-Smtp-Source: ABdhPJxX8eF3A/XjpEyHN+TQuxLtQREUcUheHvloxBERshoIfVg+WjDlruFgnnquRDU0yc0o3wACzXPs5ewwimTGD/k=
X-Received: by 2002:a05:6a00:d53:b029:32a:2db6:1be3 with SMTP id
 n19-20020a056a000d53b029032a2db61be3mr2602575pfv.71.1626153179012; Mon, 12
 Jul 2021 22:12:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210701201005.3065299-1-vishal.l.verma@intel.com> <20210701201005.3065299-5-vishal.l.verma@intel.com>
In-Reply-To: <20210701201005.3065299-5-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Jul 2021 22:12:48 -0700
Message-ID: <CAPcyv4iyhpSYkDKYDjWP61PaahtZrn3pGh7NnfC6jDaNbVEu+w@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 04/21] libcxl: add support for command query and submission
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org, 
	Ben Widawsky <ben.widawsky@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 1, 2021 at 1:10 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a set of APIs around 'cxl_cmd' for querying the kernel for supported
> commands, allocating and validating command structures against the
> supported set, and submitting the commands.
>
> 'Query Commands' and 'Send Command' are implemented as IOCTLs in the
> kernel. 'Query Commands' returns information about each supported
> command, such as flags governing its use, or input and output payload
> sizes. This information is used to validate command support, as well as
> set up input and output buffers for command submission.

It strikes me after reading the above that it would be useful to have
a cxl list option that enumerates the command support on a given
memdev. Basically a "query-to-json" helper.

>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/lib/private.h  |  33 ++++
>  cxl/lib/libcxl.c   | 388 +++++++++++++++++++++++++++++++++++++++++++++
>  cxl/libcxl.h       |  11 ++
>  cxl/lib/libcxl.sym |  13 ++
>  4 files changed, 445 insertions(+)
>
[..]
> +static int cxl_cmd_alloc_query(struct cxl_cmd *cmd, int num_cmds)
> +{
> +       size_t size;
> +
> +       if (!cmd)
> +               return -EINVAL;
> +
> +       if (cmd->query_cmd != NULL)
> +               free(cmd->query_cmd);
> +
> +       size = sizeof(struct cxl_mem_query_commands) +
> +                       (num_cmds * sizeof(struct cxl_command_info));

This is asking for the kernel's include/linux/overflow.h to be
imported into ndctl so that struct_size() could be used here. The file
is MIT licensed, just the small matter of factoring out only the MIT
licensed bits.

Other than that, looks good to me.
