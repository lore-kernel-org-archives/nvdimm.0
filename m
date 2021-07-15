Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A02168
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 23:50:34 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d12so7205745pfj.2
        for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 16:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WeRQtE8czXRC3vHnYtVPZfatQHSWqTUj9BO8MixzJpQ=;
        b=AF6jXzAQLQdLHD+7jWZJyvPnOvb5LJSvHvMM7Ze/oQ4dQB7d7n3uDXa9my80sqI8wu
         PWXJTY8dTiKpLTyqQeEgycRqhnRQnhFoPYSxLv8IRBeZ/YLQSia9wtJGu+CzbgvFTHw/
         yhJM1r8C1U5/DDaFK82S7QJXXQTqbuKNXO1pCHXuCHf5A6q0wT6h2f5HHLEKUlXuAeoA
         zFtkwU4ai+1CMTEWzyDrYoJ/ab9GiexmwVtITvMWhi3Vm8D89o7aFr65zesJ2BxX9so+
         PmQv3y08b8/yD/8HRntqynHNhDC99xSDMCng66DzHTKJpAv0CYKFbDODh0RevIOi69Ix
         QcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WeRQtE8czXRC3vHnYtVPZfatQHSWqTUj9BO8MixzJpQ=;
        b=S0hyV7dAx6hi4o48ZdKnIAoCELPcwoXFIcZzsKkKF2wwZ+y+3hQhfhccjzmVdkx5+k
         MImgBBHRRQiOwEqr4NM6cR2FEQU+m3Qn0IqGtumMT9Iu3oJQBvpiu53c0/l0HLOV6irR
         Yc0Vg3Y4lwLTUVDNEJBQa0Rr0GiN5cwLlvlFsqAJQ5xQcIs5+t7jt+O55lTcJ0fccGgs
         cYK2hXuKFTxAbTs3WDWrtuGK/DJJheYLr4ZirV5AepTdIVN3rL64LyZshxo8Q7UwOuhw
         /R0fvRz7/PC3mlFqUZse72vKl89pHtkWQYs/7sy7huM68H7fj8wE5exr2gG/Cb56W/KK
         rmTA==
X-Gm-Message-State: AOAM531a7vNZbeopyhMsOMHzwAa7t35Ee3i8bwqv6zepzuEq7YVA6g59
	XSjBRvm5VQwZECx8j+3anlOhVLC98B4gwkP0wYP5Dw==
X-Google-Smtp-Source: ABdhPJw2qNnSs9ZeRbIg4kKlxQomcAx0gzhsCnPx3hC9xC1n6lKcF0Gy2YOwSKN1acym9UWOZI15SVUTbKNNLsWvymg=
X-Received: by 2002:a63:4c3:: with SMTP id 186mr6961497pge.240.1626393033705;
 Thu, 15 Jul 2021 16:50:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210701201005.3065299-1-vishal.l.verma@intel.com> <20210701201005.3065299-6-vishal.l.verma@intel.com>
In-Reply-To: <20210701201005.3065299-6-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Jul 2021 16:50:22 -0700
Message-ID: <CAPcyv4iBSn37iwq_yL0Vjg5vx07YvfKs0OPONfa9am57mh2g=A@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 05/21] libcxl: add support for the 'Identify
 Device' command
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org, 
	Ben Widawsky <ben.widawsky@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 1, 2021 at 1:10 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add APIs to allocate and send an 'Identify Device' command, and
> accessors to retrieve some of the fields from the resulting data.
>
> Only add a handful accessor functions; more can be added as the need
> arises. The fields added are fw_revision, partition_align, and
> lsa_size.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/lib/private.h  | 19 ++++++++++++++++++
>  cxl/lib/libcxl.c   | 49 ++++++++++++++++++++++++++++++++++++++++++++++
>  cxl/libcxl.h       |  4 ++++
>  cxl/lib/libcxl.sym |  4 ++++
>  4 files changed, 76 insertions(+)
>
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 87ca17e..3273f21 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -54,6 +54,25 @@ struct cxl_cmd {
>         int status;
>  };
>
> +#define CXL_CMD_IDENTIFY_FW_REV_LENGTH 0x10
> +
> +struct cxl_cmd_identify {
> +       char fw_revision[CXL_CMD_IDENTIFY_FW_REV_LENGTH];
> +       le64 total_capacity;
> +       le64 volatile_capacity;
> +       le64 persistent_capacity;
> +       le64 partition_align;
> +       le16 info_event_log_size;
> +       le16 warning_event_log_size;
> +       le16 failure_event_log_size;
> +       le16 fatal_event_log_size;
> +       le32 lsa_size;
> +       u8 poison_list_max_mer[3];
> +       le16 inject_poison_limit;
> +       u8 poison_caps;
> +       u8 qos_telemetry_caps;
> +} __attribute__((packed));
> +
>  static inline int check_kmod(struct kmod_ctx *kmod_ctx)
>  {
>         return kmod_ctx ? 0 : -ENXIO;
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 3be4f3d..06a6c20 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -13,7 +13,10 @@
>  #include <sys/sysmacros.h>
>  #include <uuid/uuid.h>
>  #include <ccan/list/list.h>
> +#include <ccan/endian/endian.h>
> +#include <ccan/minmax/minmax.h>
>  #include <ccan/array_size/array_size.h>
> +#include <ccan/short_types/short_types.h>
>
>  #include <util/log.h>
>  #include <util/sysfs.h>
> @@ -670,6 +673,52 @@ CXL_EXPORT const char *cxl_cmd_get_devname(struct cxl_cmd *cmd)
>         return cxl_memdev_get_devname(cmd->memdev);
>  }
>
> +CXL_EXPORT struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev)
> +{
> +       return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_IDENTIFY);
> +}
> +
> +CXL_EXPORT int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev,
> +               int fw_len)
> +{
> +       struct cxl_cmd_identify *id = (void *)cmd->send_cmd->out.payload;
> +
> +       if (cmd->send_cmd->id != CXL_MEM_COMMAND_ID_IDENTIFY)
> +               return -EINVAL;
> +       if (cmd->status < 0)
> +               return cmd->status;
> +
> +       if (fw_len > 0)
> +               memcpy(fw_rev, id->fw_revision,
> +                       min(fw_len, CXL_CMD_IDENTIFY_FW_REV_LENGTH));
> +       return 0;
> +}
> +
> +CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
> +               struct cxl_cmd *cmd)
> +{
> +       struct cxl_cmd_identify *id = (void *)cmd->send_cmd->out.payload;
> +
> +       if (cmd->send_cmd->id != CXL_MEM_COMMAND_ID_IDENTIFY)
> +               return -EINVAL;
> +       if (cmd->status < 0)
> +               return cmd->status;
> +
> +       return le64_to_cpu(id->partition_align);
> +}
> +
> +CXL_EXPORT unsigned int cxl_cmd_identify_get_lsa_size(struct cxl_cmd *cmd)
> +{
> +       struct cxl_cmd_identify *id = (void *)cmd->send_cmd->out.payload;
> +
> +       if (cmd->send_cmd->id != CXL_MEM_COMMAND_ID_IDENTIFY)
> +               return -EINVAL;
> +       if (cmd->status < 0)
> +               return cmd->status;
> +
> +       return le32_to_cpu(id->lsa_size);
> +}
> +
>  CXL_EXPORT struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev,
>                 int opcode)
>  {
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 6e87b80..9ed8c83 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -58,6 +58,10 @@ void cxl_cmd_unref(struct cxl_cmd *cmd);
>  int cxl_cmd_submit(struct cxl_cmd *cmd);
>  int cxl_cmd_get_mbox_status(struct cxl_cmd *cmd);
>  int cxl_cmd_get_out_size(struct cxl_cmd *cmd);
> +struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev);
> +int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
> +unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
> +unsigned int cxl_cmd_identify_get_lsa_size(struct cxl_cmd *cmd);
>
>  #ifdef __cplusplus
>  } /* extern "C" */
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 493429c..d6aa0b2 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -39,4 +39,8 @@ global:
>         cxl_cmd_submit;
>         cxl_cmd_get_mbox_status;
>         cxl_cmd_get_out_size;
> +       cxl_cmd_new_identify;
> +       cxl_cmd_identify_get_fw_rev;
> +       cxl_cmd_identify_get_partition_align;
> +       cxl_cmd_identify_get_lsa_size;
>  } LIBCXL_2;
> --
> 2.31.1
>
