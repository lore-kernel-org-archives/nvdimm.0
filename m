Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F062F24
	for <nvdimm@lists.linux.dev>; Tue,  8 Feb 2022 20:34:34 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id i17so422427pfq.13
        for <nvdimm@lists.linux.dev>; Tue, 08 Feb 2022 12:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gXOr74ZqxDbW2NHi8mT1BWeZ44BcpKSk2J1e3DuFzZ4=;
        b=AXaCk3sp+x06s/HtFgY8v5DpUjMNsvko9jEBwdAvKBBd0qN1IFbJU+MzgFdwdggwdk
         gYpVS5CiGAcQROCTr9WPYJ1IJTT0Z8VxC/yC0QXR61VFjwvREM/ibPlFtUE5ukCTFzON
         4aMK4HYDVMnLi4Ym8CDj/Ozet+noj61YbYkKQlBfC6r9ER1n9CLuC7EXqqlg2mcPFRN0
         ZgFAfwTKpoWBkDMy8R4KaswPAEGKZXsWBmU/wl6S4Odgi3iM9TKW59a2Wjes0YjoPAfp
         lVGY0t7KFMRcTRW6hRwwpcDTZGU+ZXZ1qenoV7rG53fV61itt2Z+/e/3hwFxBjSDh2cB
         YR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gXOr74ZqxDbW2NHi8mT1BWeZ44BcpKSk2J1e3DuFzZ4=;
        b=I72u8Ew96SurlGX1cwo0U0kQUvy6gjPLLS3jFYxWBnIDA+Xfw6+Nn7T/NV4kLGOHTG
         ST5Uzpu4CvIDaTC1w0jAXDSsd2qG3ssfYoHnXd5DcE73ShdPKwpUztGZQpGYpTWfld7i
         eFpXxV+B/vIzi2ICYeRToN3aX78ZXSkYrUE/5rh8EU4SMj7sASajF8Hx8Mii6nYPmo/0
         rfSdLQKYaDbXG6jIDlzMYa2bAlktrNsp4zVJkkoDGp5TJRZVM9hnZ15N6cSBLQjVulja
         YvCiMaSb46kUbfomDQuDuIihhLSXT0g9ecLh3/K7Aa5C7FPLuOaTDmiAzUfOJWM5QIPU
         4+iA==
X-Gm-Message-State: AOAM532Ar/z2cOx2AjbLV2tDEKk9XtPSV99TIt4F3lNidSBvXJjOoHxF
	mCHkX/jZLNZpU3IesxEf+5tRb2yDxvmOChFoD8JgpA==
X-Google-Smtp-Source: ABdhPJw5zlCGQ2nGF2qvA47+wUptq6SIuYOpA4S1R/pn67LuSNBMzaR5jgmoWVKQ2nMoG7BOYXz1SpO9PH5AG0fEdl4=
X-Received: by 2002:a63:4717:: with SMTP id u23mr4989089pga.74.1644352474249;
 Tue, 08 Feb 2022 12:34:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1644271559.git.alison.schofield@intel.com> <034755a71999a66da79356ec7efbabeaa4eacd88.1644271559.git.alison.schofield@intel.com>
In-Reply-To: <034755a71999a66da79356ec7efbabeaa4eacd88.1644271559.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Feb 2022 12:34:23 -0800
Message-ID: <CAPcyv4juShujHXrh5ZB7d2sVtE4+sn6idi-KCbKZ=4pwz6jxpg@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 2/6] libcxl: add accessors for capacity fields of
 the IDENTIFY command
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 7, 2022 at 3:06 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> Users need access to a few additional fields reported by the IDENTIFY

Ah, I see the "Users need" pattern... To me, the "Users need"
statement is a step removed / secondary from the real driving
motivation which is the "CXL PMEM provisioning model specifies /
mandates".

It feels like a watered down abstraction to me.

> mailbox command: total, volatile_only, and persistent_only capacities.
> These values are useful when defining partition layouts.
>
> Add accessors to the libcxl API to retrieve these values from the
> IDENTIFY command.
>
> The fields are specified in multiples of 256MB per the CXL 2.0 spec.
> Use the capacity multiplier to convert the raw data into bytes for user
> consumption.
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/lib/libcxl.c   | 36 ++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |  3 +++
>  cxl/libcxl.h       |  3 +++
>  3 files changed, 42 insertions(+)
>
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 33cf06b..e9d7762 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -2322,6 +2322,42 @@ CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
>         return le32_to_cpu(id->lsa_size);
>  }
>
> +static struct cxl_cmd_identify *
> +cmd_to_identify(struct cxl_cmd *cmd)
> +{
> +       if (cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_IDENTIFY))
> +               return NULL;
> +
> +       return cmd->output_payload;
> +}
> +
> +CXL_EXPORT unsigned long long
> +cxl_cmd_identify_get_total_size(struct cxl_cmd *cmd)
> +{
> +       struct cxl_cmd_identify *c;
> +
> +       c = cmd_to_identify(cmd);
> +       return c ? capacity_to_bytes(c->total_capacity) : ULLONG_MAX;
> +}
> +
> +CXL_EXPORT unsigned long long
> +cxl_cmd_identify_get_volatile_only_size(struct cxl_cmd *cmd)
> +{
> +       struct cxl_cmd_identify *c;
> +
> +       c = cmd_to_identify(cmd);
> +       return c ? capacity_to_bytes(c->volatile_capacity) : ULLONG_MAX;
> +}
> +
> +CXL_EXPORT unsigned long long
> +cxl_cmd_identify_get_persistent_only_size(struct cxl_cmd *cmd)
> +{
> +       struct cxl_cmd_identify *c;
> +
> +       c = cmd_to_identify(cmd);
> +       return c ? capacity_to_bytes(c->persistent_capacity) : ULLONG_MAX;

Same style comments as last patch, but otherwise:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
