Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8BE168
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 16:01:32 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id s136so2715000pgs.4
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 09:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wc68sjOqyUnrWe0dKVQzk15J1/YhXlYXFkfqftB8FKw=;
        b=IunGJZOeUPcnFl9iIt+ymXw8JXlmoG/mkFgQmvyA+B8leGlgkdk9A4hPnzcVGKwaXk
         r4aakIIKTVhMLRvAwvtCW2U6btqVDfuJzy6IrrZLbSlMe6nbcN8Yw62fK/xnJJ88zDxZ
         z7m6+X67XbyeZLoxRb26g4cU2QoGzj8y9PZRpl6z5KEUzqg3kIgYfPJSZ68xgb1qxleM
         7VKMWKkk9c+MiyuncjEui2FJwTkw4uVGUlisWJ535RVaAqgmaL4yzHstJgnUx5OPBy6Q
         E0bMTG8vyNNOuj19/za0sOE0zvoytoevFchfBqiez25Ngb67AVW0qEfy5SOWq3T9FQwW
         Qu/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wc68sjOqyUnrWe0dKVQzk15J1/YhXlYXFkfqftB8FKw=;
        b=e/XOkq+lIUY4k/YqFYXDmDgDMfPGVVz26h9cX317KVJobYheBqRRQj/oQ2snmzD5qn
         DTd8UbtyDe785kshWzaHvZyERn+WEEK54sSCMVnCdTAk8Ja6CZ9Ulq0K2RTRDDGEhT9v
         jY9h3xW7ds9HIt6qtLDZ04iIOmXEv1iMBdfI5uMhTxF1N8VWPY7LvzBmUZ/w7waYuy9/
         6Mqit7sZHouM6StmMrbQfxozkRx1zgfBPm/KLre+VZJSPTXzmyiLchKbd70IMNpK27EJ
         /EhPsVacY9rUQIbiP+M133DMolt6ZJVOKiHON95hvbjegjj9KkKMWVI7CvrMY8DAYfRq
         MGQg==
X-Gm-Message-State: AOAM533iZ4wGf0FCJk024B+242mvLk9lVus7uL7yPboVJQ0WQl/yVVVr
	aq4DVLct/qOkXa+S114a8vNIQb5TQVjbV7+s5sDqog==
X-Google-Smtp-Source: ABdhPJzjI+14DGMrdA0XJGBCG+5oMYOW+SvY9qEpfQJTN2YkyJVkBj2Hg4gC3iPudVLxERSp+I/bIo/HoOSKsWUzks0=
X-Received: by 2002:a05:6a00:1a01:b0:44c:1ec3:364f with SMTP id
 g1-20020a056a001a0100b0044c1ec3364fmr6364756pfv.86.1634227291751; Thu, 14 Oct
 2021 09:01:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com> <20211007082139.3088615-8-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-8-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 09:01:21 -0700
Message-ID: <CAPcyv4ifss448zuSRphx4d5RAtjZkgiBQirbLPMAJF04NPnZLg@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 07/17] libcxl: add GET_HEALTH_INFO mailbox
 command and accessors
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

)

On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add libcxl APIs to create a new GET_HEALTH_INFO mailbox command, the
> command output data structure (privately), and accessor APIs to return
> the different fields in the health info output.
>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/lib/private.h  |  47 ++++++++
>  cxl/lib/libcxl.c   | 286 +++++++++++++++++++++++++++++++++++++++++++++
>  cxl/libcxl.h       |  38 ++++++
>  util/bitmap.h      |  23 ++++
>  cxl/lib/libcxl.sym |  31 +++++
>  5 files changed, 425 insertions(+)
>
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 3273f21..f76b518 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -73,6 +73,53 @@ struct cxl_cmd_identify {
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
> +/* CXL 2.0 8.2.9.5.3 Byte 0 Health Status */
> +#define CXL_CMD_HEALTH_INFO_STATUS_MAINTENANCE_NEEDED_MASK             BIT(0)
> +#define CXL_CMD_HEALTH_INFO_STATUS_PERFORMANCE_DEGRADED_MASK           BIT(1)
> +#define CXL_CMD_HEALTH_INFO_STATUS_HW_REPLACEMENT_NEEDED_MASK          BIT(2)
> +
> +/* CXL 2.0 8.2.9.5.3 Byte 1 Media Status */
> +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_NORMAL                                0x0
> +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_NOT_READY                     0x1
> +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_PERSISTENCE_LOST              0x2
> +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_DATA_LOST                     0x3
> +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_POWERLOSS_PERSISTENCE_LOSS    0x4
> +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_SHUTDOWN_PERSISTENCE_LOSS     0x5
> +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_PERSISTENCE_LOSS_IMMINENT     0x6
> +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_POWERLOSS_DATA_LOSS           0x7
> +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_SHUTDOWN_DATA_LOSS            0x8
> +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_DATA_LOSS_IMMINENT            0x9
> +
> +/* CXL 2.0 8.2.9.5.3 Byte 2 Additional Status */
> +#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_MASK                         GENMASK(1, 0)
> +#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_NORMAL                       0x0
> +#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_WARNING                      0x1
> +#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_CRITICAL                     0x2
> +#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_MASK                       GENMASK(3, 2)
> +#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_NORMAL                     (0x0 << 2)
> +#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_WARNING                    (0x1 << 2)
> +#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_CRITICAL                   (0x2 << 2)

So the kernel style for this would be to have:

#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_NORMAL                    (0)
#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_WARNING                  (1)
#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_CRITICAL                   (2)

...and then to check the value it would be:

FIELD_GET(CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_MASK, c->ext_status) ==
CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_NORMAL

...that way if we ever wanted to copy libcxl bits into the kernel it
will already be in the matching style to other CXL bitwise
definitions.

I think FIELD_GET() would also clarify a few of your helpers below,
but yeah a bit more infrastructure to import.

The rest of this looks ok to me.
