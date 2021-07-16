Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FDC72
	for <nvdimm@lists.linux.dev>; Fri, 16 Jul 2021 02:25:00 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id k20so8538263pgg.7
        for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 19:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dsmWR57B5qjYPe7/nAaUcKvyZqjUJoqo/cc9p2STRaY=;
        b=Is96pXiL9IoaDtEeJ38AuI8HCzID2Z4Zvazhm4W/79LKGtJSqulMHXf9+3aG5PYZyI
         ikcZ5eQUr7gh/e36Nw2rexN3Z4NISBqA1EmoXdlw7yn+UyxjYbvBJLmOU9aHkokLKLoz
         rSivMlICP64ziRi2amFuUM7YVPi3bAh/OMysoz+dVCwso0ZLDkZnD2Iq2i8NLcyA///g
         JELpf0Sbz/K2dgNXyLDLRbB2RmbyE/DB9hhbcJ5dwgTauTddMStPfWKG5+3hFI2bNntN
         at+xLP7O5PLzsfvy8kh0RDQKampyTbw2xdvx1jYNA4ZZ9gYnbYrDPGekbVjgqNU0OTsR
         UNIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dsmWR57B5qjYPe7/nAaUcKvyZqjUJoqo/cc9p2STRaY=;
        b=DG1JZmm3gRL++6qGWsArbhHjaZZEQlaEMLFaQUb+pPOuLp4TzInKxCy4QfIT8ZSHza
         ra3okQGwcS2nvJVkhHYFPGuO2RF5J3MGwi94eYDIm+RwIzhrgHhBZs+ZOQrICT6wY+47
         H2msWb2ovyGsmKyz9vUoe3J8mLdSTafXMXUEEkE1qU958q/HNJ8SDjKIfWo0jMMeeHRx
         R/G2evxlQ9ysKGix4g4T9hH4J7MblCu0x7FWgIMpffpKMtS+3xT6DXDpKQ3xp5m1bFka
         xMbAB183LaDPoqO/HF9rYxm9K1IIs6Pr7i1CAdtggMNPWerJsMQW0Xhkvq1va/Kgw4hg
         Xueg==
X-Gm-Message-State: AOAM532MmdMPv2KLTnp068adLcRX2EeNQ+r84M+rpwSvhFeWLpmxk8Xh
	nbkHRlPjkZtVeURrbuXHOq0FjDuOm30pOP6St2hgzg==
X-Google-Smtp-Source: ABdhPJxq2jVmpjYdU+IiAup4Wc7fmZv0IV3TmNlL2CLi8S9voqqoAfcrul6yrd6QJUxGsN/vq6+ZjyD2qBpDwsbCMFY=
X-Received: by 2002:a63:d54b:: with SMTP id v11mr7521289pgi.450.1626402299646;
 Thu, 15 Jul 2021 19:24:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210701201005.3065299-1-vishal.l.verma@intel.com> <20210701201005.3065299-11-vishal.l.verma@intel.com>
In-Reply-To: <20210701201005.3065299-11-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Jul 2021 19:24:48 -0700
Message-ID: <CAPcyv4j_raDF131vGmsX-p=rPj4tMUcv0Eo7cRygFCVsSYyq7Q@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 10/21] libcxl: add support for the 'GET_LSA' command
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org, 
	Ben Widawsky <ben.widawsky@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 1, 2021 at 1:10 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a command allocator and accessor APIs for the 'GET_LSA' mailbox
> command.
>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/lib/private.h  |  5 +++++
>  cxl/lib/libcxl.c   | 31 +++++++++++++++++++++++++++++++
>  cxl/libcxl.h       |  3 +++
>  cxl/lib/libcxl.sym |  2 ++
>  4 files changed, 41 insertions(+)
>
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 2232f4c..fb1dd8e 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -73,6 +73,11 @@ struct cxl_cmd_identify {
>         u8 qos_telemetry_caps;
>  } __attribute__((packed));
>
> +struct cxl_cmd_get_lsa_in {
> +       le32 offset;
> +       le32 length;
> +} __attribute__((packed));
> +
>  struct cxl_cmd_get_health_info {
>         u8 health_status;
>         u8 media_status;
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 2e33c5e..d2c38c9 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -799,6 +799,37 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev,
>         return cmd;
>  }
>
> +CXL_EXPORT struct cxl_cmd *cxl_cmd_new_get_lsa(struct cxl_memdev *memdev,
> +               unsigned int offset, unsigned int length)

What about a rename here to cxl_cmd_new_read_label? Because, like
before, 'get' is overloaded in lib{cxl,ndctl,daxctl} land, and 'lsa'
is a spec acronym that we don't need to be matchy-matchy with if
there's a better name for libcxl users.

That said, that's only a mild preference if you like the symmetry with the spec.

> +{
> +       struct cxl_cmd_get_lsa_in *get_lsa;
> +       struct cxl_cmd *cmd;
> +
> +       cmd = cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_GET_LSA);
> +       if (!cmd)
> +               return NULL;
> +
> +       get_lsa = (void *)cmd->send_cmd->in.payload;
> +       get_lsa->offset = cpu_to_le32(offset);
> +       get_lsa->length = cpu_to_le32(length);
> +       return cmd;
> +}
> +
> +#define cmd_get_void(cmd, N) \
> +do { \
> +       void *p = (void *)cmd->send_cmd->out.payload; \
> +       if (cmd->send_cmd->id != CXL_MEM_COMMAND_ID_##N) \
> +               return NULL; \
> +       if (cmd->status < 0) \
> +               return NULL; \
> +       return p; \
> +} while(0);
> +
> +CXL_EXPORT void *cxl_cmd_get_lsa_get_payload(struct cxl_cmd *cmd)

Here's another get_X_get that might be better as cxl_cmd_read_label_get_payload.

I also liked the ndctl behavior where it was made difficult to do out
of bounds access to this buffer because the user had to go through
ndctl_cmd_cfg_read_get_data() which did error checking if they tried
to access more of the payload than was initially requested.

> +{
> +       cmd_get_void(cmd, GET_LSA);
> +}
> +
>  CXL_EXPORT int cxl_cmd_submit(struct cxl_cmd *cmd)
>  {
>         struct cxl_memdev *memdev = cmd->memdev;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 56ae4af..6edbd8d 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -71,6 +71,9 @@ int cxl_cmd_get_health_info_get_temperature(struct cxl_cmd *cmd);
>  int cxl_cmd_get_health_info_get_dirty_shutdowns(struct cxl_cmd *cmd);
>  int cxl_cmd_get_health_info_get_volatile_errors(struct cxl_cmd *cmd);
>  int cxl_cmd_get_health_info_get_pmem_errors(struct cxl_cmd *cmd);
> +struct cxl_cmd *cxl_cmd_new_get_lsa(struct cxl_memdev *memdev,
> +               unsigned int offset, unsigned int length);
> +void *cxl_cmd_get_lsa_get_payload(struct cxl_cmd *cmd);
>
>  #ifdef __cplusplus
>  } /* extern "C" */
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index e00443d..2c6193b 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -52,4 +52,6 @@ global:
>         cxl_cmd_get_health_info_get_dirty_shutdowns;
>         cxl_cmd_get_health_info_get_volatile_errors;
>         cxl_cmd_get_health_info_get_pmem_errors;
> +       cxl_cmd_new_get_lsa;
> +       cxl_cmd_get_lsa_get_payload;
>  } LIBCXL_2;
> --
> 2.31.1
>
