Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83202C82
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 02:53:44 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id oa4so3715080pjb.2
        for <nvdimm@lists.linux.dev>; Wed, 13 Oct 2021 19:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pVpsGH9QL+KHRg/uYizyXVbiWTS3IE6Hk8UnQH9kZSc=;
        b=CBo3Y8VMIuP9F/1zWBhQpin90T5rhk3BznP+I5XT27ni7u6rLMKnOOeX3TFGtSsM3u
         LJLFipL8pvxMjg/Men7B4yRWaTxBQYv9e0L5OF9OEKGUwqi9Vta39Bw6Q2ZtGFPO0SNu
         8pzgWgBJ5Olppxw62ugK+iX1GFo3j1ojCgiTxZmKakw7Urkkn05g+d0u3aXVJj/g0Fsa
         5j0vEUWS7XXNOW0tS5wYTCcDLaIUIk3UEAs5vAjpc9La6DKNj9QKBmNzpYB5tP4wRMyo
         z60T0zc/at9qo/M4LBW35/7FqdJlKI1xREYximbYZ8ktRXVBmXYCk8ucUYc/md++a5Vu
         v8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pVpsGH9QL+KHRg/uYizyXVbiWTS3IE6Hk8UnQH9kZSc=;
        b=adz6NCahtdAzRNoCVVvHPjX4T23pkAc8RQbhu0zfBFrGxrutmwUrjViLNQStfLpNr4
         Nw7e5ERDhjwNq8axqf+7jsXHvEUbzJg0rEtjIfPk5CYfOOiskClv7Hp0qcMY+9CbWpFy
         QmYzlZ1gqVdPcxxJT0ANWNIWpwn1VTOGZnoIk8KKHbce5hLnYXSxYaKo4F1p4cJsFWmK
         9LWYKXgIOeViW9aSKCArBo0zppswk5LQ5Upk/nF2yRbDwXx0XcRTMC94p0g0IxC/hG2W
         jeF8C/nEJSr2IcUhWNAr9hcHNV3zLZUwWU31bP57xG0nQfy12m4cyUakEQbWEdAbyZUL
         sT1A==
X-Gm-Message-State: AOAM532EkJaGuQ7ZNW3ZO1NSoUfVeFwzMWa6uXQzY5dsZ3fwaNowdD9r
	T/2vot3E4atY2lRJOj2JNxEL5jDftyc8SreOiZZAaQ==
X-Google-Smtp-Source: ABdhPJwM2El7xf3YN1ghBPWV4OXD1TwLVjjmUssbvQ/tiDJLj4d5xzC+fmzoJwg0XlyxbzbEQTU7NHV0hyAB+0xHl6w=
X-Received: by 2002:a17:90a:a085:: with SMTP id r5mr17634635pjp.8.1634180024229;
 Wed, 13 Oct 2021 19:53:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com> <20211007082139.3088615-6-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-6-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Oct 2021 19:53:33 -0700
Message-ID: <CAPcyv4j2=K15QDN2S6G+R37rSQQOQjO3NQP8RHWca0OnwvSh6g@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 05/17] libcxl: add support for command query and submission
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
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
>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
[..]
> +CXL_EXPORT int cxl_cmd_submit(struct cxl_cmd *cmd)
> +{
> +       struct cxl_memdev *memdev = cmd->memdev;
> +       const char *devname = cxl_memdev_get_devname(memdev);
> +       struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +       int rc;
> +
> +       switch (cmd->query_status) {

Ah, now I see why you proposed having another flag in the
cxl_query_cmd() payload to indicate hardware support for the command.
to save having to validate before each command.

I wouldn't mind a TODO here to remind about that... but not critical:

You can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
