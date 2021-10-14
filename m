Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80892C81
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 21:27:18 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id f21so5052673plb.3
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 14:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kNGCBwGGQSw99cENJKftH/ORXKCPl8SOyv4sQBu0lqA=;
        b=ANWhszpbkpC3qEqly9uwkomufNNiXvix8cHVLsmwPZGXE6VeTJUzVSCTExZH9u7XEw
         zt+gCgzHk2akz17Yg01zZ6LN7L28oTDmVNcABF+FwvZVoJxRNItDj/jGbbqrtg6KG7pY
         IOnMcY+lJ3XQh32FIciSJU5Rck1OmCjwLNl/Ne3WlV50REyf98N+nozcmKPeD8em/OGS
         LO9xqCP6zuiUQNnXifJOsnfd3OZ7+GiY9mk/eWwPjPnFsTJtOYwl4YREXH/qSvCzJ16F
         uOOAS+ks7Wy3HLblcQRgY4XRyvv7ur5PgJOPNobAFyawPZgAWCCui5MGWraBUk+bOnE1
         0Olg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kNGCBwGGQSw99cENJKftH/ORXKCPl8SOyv4sQBu0lqA=;
        b=I02E3N9honHRBK6gbxkRPKXcFeRVNF6DC1jePjBI+7/10F/Kx6aXLo0unokWzLvk7M
         zbRITvDIHgMkk7vW2rSviUpuT7jKHp0/N3ohxbeIHc+7hpBiPHMYSwMuCDBiUnfyPAW5
         sWMXBWy6+AnbJ320ApW5sI0BMnWpXb6Tva+Y0kqEZn5YJua6LSK8T3Wk9NVmkF80cpiO
         wbpHMzKQNv3Jw4zNQM6lcNIJ6o6mPheTOabg4ks4ip8kfaIL2yHy/XC8iXlCX0ZbBHIF
         0LqgUx8ObjbPpJAxUHs5zMYNIIoCzAkZ3iI3gsg2HidTPEYSKFCgWOIWLQ0Hev+Q/0UO
         CAcQ==
X-Gm-Message-State: AOAM530SZcWnYrwxig15f3G1bqV7Dtl6kNBsrMMjKB01Z2NjPTPUOEmn
	Z/sw5IuiRld8HDIMJVn9dwmxJDDGOz39QcYyNd/kWU2QYKA=
X-Google-Smtp-Source: ABdhPJzkZUuNvTnX4n8TX8b0la1zgjhjNektpLA2Hj9UlB5DGvGiaTKZUYj1dHznm5KDmV84pc6PlIikSsdgHymRLTA=
X-Received: by 2002:a17:90a:a085:: with SMTP id r5mr22972907pjp.8.1634246837935;
 Thu, 14 Oct 2021 14:27:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com> <20211007082139.3088615-13-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-13-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 14:27:07 -0700
Message-ID: <CAPcyv4h49Cei27qLAL8oUmcpa=Su_VArrAEzGwt3VSbpCoxYTw@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 12/17] libcxl: add interfaces for label operations
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add libcxl interfaces to allow performinfg label (LSA) manipulations.
> Add a 'cxl_cmd_new_set_lsa' interface to create a 'Set LSA' mailbox
> command payload, and interfaces to read, write, and zero the LSA area on
> a memdev.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/lib/private.h  |   6 ++
>  cxl/lib/libcxl.c   | 137 +++++++++++++++++++++++++++++++++++++++++++++
>  cxl/libcxl.h       |   7 +++
>  cxl/lib/libcxl.sym |   4 ++
>  4 files changed, 154 insertions(+)
>
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 671f12f..89212df 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -79,6 +79,12 @@ struct cxl_cmd_get_lsa_in {
>         le32 length;
>  } __attribute__((packed));
>
> +struct cxl_cmd_set_lsa {
> +       le32 offset;
> +       le32 rsvd;
> +       unsigned char lsa_data[0];
> +} __attribute__ ((packed));
> +
>  struct cxl_cmd_get_health_info {
>         u8 health_status;
>         u8 media_status;
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 59d091c..8dd69cf 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1126,3 +1126,140 @@ CXL_EXPORT int cxl_cmd_get_out_size(struct cxl_cmd *cmd)
>  {
>         return cmd->send_cmd->out.size;
>  }
> +
> +CXL_EXPORT struct cxl_cmd *cxl_cmd_new_write_label(struct cxl_memdev *memdev,
> +               void *lsa_buf, unsigned int offset, unsigned int length)
> +{
> +       struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +       struct cxl_cmd_set_lsa *set_lsa;
> +       struct cxl_cmd *cmd;
> +       int rc;
> +
> +       cmd = cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_LSA);
> +       if (!cmd)
> +               return NULL;
> +
> +       /* this will allocate 'in.payload' */
> +       rc = cxl_cmd_set_input_payload(cmd, NULL, sizeof(*set_lsa) + length);
> +       if (rc) {
> +               err(ctx, "%s: cmd setup failed: %s\n",
> +                       cxl_memdev_get_devname(memdev), strerror(-rc));
> +               goto out_fail;
> +       }
> +       set_lsa = (void *)cmd->send_cmd->in.payload;

...the cast is still nagging at me especially when this knows what the
payload is supposed to be. What about a helper per command type of the
form:

struct cxl_cmd_$name *to_cxl_cmd_$name(struct cxl_cmd *cmd)
{
    if (cmd->send_cmd->id != CXL_MEM_COMMAND_ID_$NAME)
        return NULL;
    return (struct cxl_cmd_$name *) cmd->send_cmd->in.payload;
}

> +       set_lsa->offset = cpu_to_le32(offset);
> +       memcpy(set_lsa->lsa_data, lsa_buf, length);
> +
> +       return cmd;
> +
> +out_fail:
> +       cxl_cmd_unref(cmd);
> +       return NULL;
> +}
> +
> +enum lsa_op {
> +       LSA_OP_GET,
> +       LSA_OP_SET,
> +       LSA_OP_ZERO,
> +};
> +
> +static int lsa_op(struct cxl_memdev *memdev, int op, void **buf,
> +               size_t length, size_t offset)
> +{
> +       const char *devname = cxl_memdev_get_devname(memdev);
> +       struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +       struct cxl_cmd *cmd;
> +       void *zero_buf = NULL;
> +       ssize_t ret_len;
> +       int rc = 0;
> +
> +       if (op != LSA_OP_ZERO && (buf == NULL || *buf == NULL)) {
> +               err(ctx, "%s: LSA buffer cannot be NULL\n", devname);
> +               return -EINVAL;
> +       }
> +
> +       /* TODO: handle the case for offset + len > mailbox payload size */
> +       switch (op) {
> +       case LSA_OP_GET:
> +               if (length == 0)
> +                       length = memdev->lsa_size;

What's the use case to support a default size for get? If someone
wants to do a zero length lsa_op shouldn't that just return immediate
success just like 0 length read(2)?

> +               cmd = cxl_cmd_new_read_label(memdev, offset, length);
> +               if (!cmd)
> +                       return -ENOMEM;
> +               rc = cxl_cmd_set_output_payload(cmd, *buf, length);
> +               if (rc) {
> +                       err(ctx, "%s: cmd setup failed: %s\n",
> +                           cxl_memdev_get_devname(memdev), strerror(-rc));
> +                       goto out;
> +               }
> +               break;
> +       case LSA_OP_ZERO:
> +               if (length == 0)

This one makes sense because the caller just wants the whole area zeroed.

> +                       length = memdev->lsa_size;
> +               zero_buf = calloc(1, length);
> +               if (!zero_buf)
> +                       return -ENOMEM;
> +               buf = &zero_buf;


> +               /* fall through */
> +       case LSA_OP_SET:

...and if length == 0 here there's no need to go any further, we're done.

> +               cmd = cxl_cmd_new_write_label(memdev, *buf, offset, length);
> +               if (!cmd) {
> +                       rc = -ENOMEM;
> +                       goto out_free;
> +               }
> +               break;
> +       default:
> +               return -EOPNOTSUPP;
> +       }
> +
> +       rc = cxl_cmd_submit(cmd);
> +       if (rc < 0) {
> +               err(ctx, "%s: cmd submission failed: %s\n",
> +                       devname, strerror(-rc));
> +               goto out;
> +       }
> +
> +       rc = cxl_cmd_get_mbox_status(cmd);
> +       if (rc != 0) {
> +               err(ctx, "%s: firmware status: %d\n",
> +                       devname, rc);
> +               rc = -ENXIO;
> +               goto out;
> +       }
> +
> +       if (op == LSA_OP_GET) {
> +               ret_len = cxl_cmd_read_label_get_payload(cmd, *buf, length);
> +               if (ret_len < 0) {
> +                       rc = ret_len;
> +                       goto out;
> +               }
> +       }
> +
> +       /*
> +        * TODO: If writing, the memdev may need to be disabled/re-enabled to
> +        * refresh any cached LSA data in the kernel.
> +        */

I think we're sufficiently protected by the nvdimm-bridge up/down
dependency. I.e. if the above commands actually worked then nothing
should have had the labels cached in the kernel.

After fixing the the length == 0 case you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
