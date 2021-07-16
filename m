Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AA672
	for <nvdimm@lists.linux.dev>; Fri, 16 Jul 2021 01:11:47 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id q10so7378343pfj.12
        for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 18:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tMonkIL38EwRPoXUOBvUJ/ru/jwVcMFLyVE4T+xJ0ms=;
        b=gViLtF2qEtkUWNUY4fBSODEH90MWOrLM9e4g/PGZbQUQuTLoIGoWizc6r45K4sIvD2
         XSQ7CLgCXqeq53d8IJKpWTssX+4uPesJ8Be/P7wHkWAycCm4HWNY255aYkLCWV/UW/M4
         bV3W8EqaBPg8sBUQh9q5mCG0pagHS0UHh3/By+FQx7uJ2lgGRVKIXkimCHDwsPlpgfZ2
         zHT+K5wPtBYj4IXBLoGfU6xIucpconlSPS7+pw94E988HNTtnz3WwB5/nhjMdTIB4FI+
         WHY80jDa8pe1KecDk1ToGmuPMTXXZa4glTsVRttpVK9m24RD5X16SI9+E02+PlxzLAON
         MWBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tMonkIL38EwRPoXUOBvUJ/ru/jwVcMFLyVE4T+xJ0ms=;
        b=IOIWeIZ4w3IBJePAUB6OeMx4fgjOzMkZdl/cHmU/c+U0VyTopLK/GMM2ak7k51h1SS
         1zIp3pDxXnxgz3ZF6Ma+uYxuc2LA9u/vf+J1iR1KKXefEYmXtAlQRx6T6ouc8hLIESJY
         /POr3WYkYeADdl8Q/91uD2fyU3KhM8p/A3wP5PkkwM+gAJk22nkJ9bTRpGK8l5zxjAbG
         t6d0n1+LAtVGhj+Omc2+bVC38pus+pPUqqx7BFjpMtzH5zV0A2v2y7C1ZmPw3NOfHwNX
         DtWL30cokLsomUQrJKrAzJ5bW4wzGEYjphCm6p47HKvvSi09fBBNCj2WydbZABuZn4DA
         DWrg==
X-Gm-Message-State: AOAM533khDP/z56jkJCqex9sLx2N3eeLoIiWQpNs0YrZ4IFxWAazVpN2
	QEzu2Zn8lqrtgzbxcFozypI6HkuRwt32iHhCWmriKw==
X-Google-Smtp-Source: ABdhPJy4vLbuU2rq7tl93kIwbhKHmnYjf5sZfDpaBu+O3UjnuPmNLJCcs4W0zfAJGbA1fveSQINzcGXj4Xu//0qJjzw=
X-Received: by 2002:a65:6248:: with SMTP id q8mr7348503pgv.279.1626397907295;
 Thu, 15 Jul 2021 18:11:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210701201005.3065299-1-vishal.l.verma@intel.com> <20210701201005.3065299-10-vishal.l.verma@intel.com>
In-Reply-To: <20210701201005.3065299-10-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Jul 2021 18:11:36 -0700
Message-ID: <CAPcyv4jSaCWd8j66A3ML2wZruNTEHgB=ty7CYSySeZbduc36mA@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 09/21] libcxl: add GET_HEALTH_INFO mailbox
 command and accessors
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org, 
	Ben Widawsky <ben.widawsky@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 1, 2021 at 1:11 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add libcxl APIs to create a new GET_HEALTH_INFO mailbox command, the
> command output data structure (privately), and accessor APIs to return
> the different fields in the health info output.
>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/lib/private.h  | 11 +++++++++
>  cxl/lib/libcxl.c   | 61 ++++++++++++++++++++++++++++++++++++++++++++++
>  cxl/libcxl.h       |  9 +++++++
>  cxl/lib/libcxl.sym |  9 +++++++
>  4 files changed, 90 insertions(+)
>
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 3273f21..2232f4c 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -73,6 +73,17 @@ struct cxl_cmd_identify {
>         u8 qos_telemetry_caps;
>  } __attribute__((packed));
>
> +struct cxl_cmd_get_health_info {
> +       u8 health_status;
> +       u8 media_status;
> +       u8 ext_status;
> +       u8 life_used;
> +       le16 temperature;
> +       le32 dirty_shutdowns;
> +       le32 volatile_errors;
> +       le32 pmem_errors;
> +} __attribute__((packed));
> +
>  static inline int check_kmod(struct kmod_ctx *kmod_ctx)
>  {
>         return kmod_ctx ? 0 : -ENXIO;
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 06a6c20..2e33c5e 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -673,6 +673,67 @@ CXL_EXPORT const char *cxl_cmd_get_devname(struct cxl_cmd *cmd)
>         return cxl_memdev_get_devname(cmd->memdev);
>  }
>
> +#define cmd_get_int(cmd, n, N, field) \
> +do { \
> +       struct cxl_cmd_##n *c = (void *)cmd->send_cmd->out.payload; \
> +       if (cmd->send_cmd->id != CXL_MEM_COMMAND_ID_##N) \
> +               return EINVAL; \
> +       if (cmd->status < 0) \
> +               return cmd->status; \
> +       return le32_to_cpu(c->field); \
> +} while(0);
> +
> +CXL_EXPORT struct cxl_cmd *cxl_cmd_new_get_health_info(
> +               struct cxl_memdev *memdev)
> +{
> +       return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_GET_HEALTH_INFO);
> +}
> +
> +#define cmd_health_get_int(c, f) \
> +do { \
> +       cmd_get_int(c, get_health_info, GET_HEALTH_INFO, f); \
> +} while (0);
> +
> +CXL_EXPORT int cxl_cmd_get_health_info_get_health_status(struct cxl_cmd *cmd)
> +{
> +       cmd_health_get_int(cmd, health_status);
> +}

I would expect this to broken up into a helper per flag like:

bool cxl_cmd_health_info_get_maintenance_needed(struct cxl_cmd *cmd)
bool cxl_cmd_health_info_get_performance_degraded(struct cxl_cmd *cmd)
bool cxl_cmd_health_info_get_replacement_needed(struct cxl_cmd *cmd)

i.e. the payload helpers should try to hide reserved fields from being
inadvertently communicated, otherwise software that's starts reserved
values being set may break. Rather than masking reserved adding
explicit helpers makes the library usage more readable... but yeah it
makes the library definition a bit more tedious.

I also think it's ok to drop verbs out of command names especially
when the collide with library verb names, i.e.
s/get_health_info_get/s/health_info_get/


> +CXL_EXPORT int cxl_cmd_get_health_info_get_media_status(struct cxl_cmd *cmd)
> +{
> +       cmd_health_get_int(cmd, media_status);
> +}

Similar feedback here, i.e. unless the payload field is literally an
integer it should have a scheme to prevent reserved values from being
passed through, and ideally have formal retrieval methods for each
defined value. In this case I think a library defined enum to mirror
the status values is warranted. No need to make the enum values match
up with payload values.

> +
> +CXL_EXPORT int cxl_cmd_get_health_info_get_ext_status(struct cxl_cmd *cmd)
> +{
> +       cmd_health_get_int(cmd, ext_status);
> +}
> +

This one is fun with enums and flags to parse...

> +CXL_EXPORT int cxl_cmd_get_health_info_get_life_used(struct cxl_cmd *cmd)
> +{
> +       cmd_health_get_int(cmd, life_used);
> +}
> +

This should probably return a positive number from 0-100 or a negative
error code.

> +CXL_EXPORT int cxl_cmd_get_health_info_get_temperature(struct cxl_cmd *cmd)
> +{
> +       cmd_health_get_int(cmd, temperature);
> +}

This is a two's complement value that needs to be cast into a positive
or negative number of degrees.

> +
> +CXL_EXPORT int cxl_cmd_get_health_info_get_dirty_shutdowns(struct cxl_cmd *cmd)
> +{
> +       cmd_health_get_int(cmd, dirty_shutdowns);
> +}
> +
> +CXL_EXPORT int cxl_cmd_get_health_info_get_volatile_errors(struct cxl_cmd *cmd)
> +{
> +       cmd_health_get_int(cmd, volatile_errors);
> +}
> +
> +CXL_EXPORT int cxl_cmd_get_health_info_get_pmem_errors(struct cxl_cmd *cmd)
> +{
> +       cmd_health_get_int(cmd, pmem_errors);
> +}
> +

These 3 seem ok to not need translation helpers, but only as unsigned integers.

>  CXL_EXPORT struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev)
>  {
>         return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_IDENTIFY);
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 9ed8c83..56ae4af 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -62,6 +62,15 @@ struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev);
>  int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
>  unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
>  unsigned int cxl_cmd_identify_get_lsa_size(struct cxl_cmd *cmd);
> +struct cxl_cmd *cxl_cmd_new_get_health_info(struct cxl_memdev *memdev);
> +int cxl_cmd_get_health_info_get_health_status(struct cxl_cmd *cmd);
> +int cxl_cmd_get_health_info_get_media_status(struct cxl_cmd *cmd);
> +int cxl_cmd_get_health_info_get_ext_status(struct cxl_cmd *cmd);
> +int cxl_cmd_get_health_info_get_life_used(struct cxl_cmd *cmd);
> +int cxl_cmd_get_health_info_get_temperature(struct cxl_cmd *cmd);
> +int cxl_cmd_get_health_info_get_dirty_shutdowns(struct cxl_cmd *cmd);
> +int cxl_cmd_get_health_info_get_volatile_errors(struct cxl_cmd *cmd);
> +int cxl_cmd_get_health_info_get_pmem_errors(struct cxl_cmd *cmd);
>
>  #ifdef __cplusplus
>  } /* extern "C" */
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index d6aa0b2..e00443d 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -43,4 +43,13 @@ global:
>         cxl_cmd_identify_get_fw_rev;
>         cxl_cmd_identify_get_partition_align;
>         cxl_cmd_identify_get_lsa_size;
> +       cxl_cmd_new_get_health_info;
> +       cxl_cmd_get_health_info_get_health_status;
> +       cxl_cmd_get_health_info_get_media_status;
> +       cxl_cmd_get_health_info_get_ext_status;
> +       cxl_cmd_get_health_info_get_life_used;
> +       cxl_cmd_get_health_info_get_temperature;
> +       cxl_cmd_get_health_info_get_dirty_shutdowns;
> +       cxl_cmd_get_health_info_get_volatile_errors;
> +       cxl_cmd_get_health_info_get_pmem_errors;
>  } LIBCXL_2;
> --
> 2.31.1
>
