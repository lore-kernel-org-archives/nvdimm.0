Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976E12C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 21:51:59 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id i30so3779867pgl.0
        for <nvdimm@lists.linux.dev>; Thu, 06 Jan 2022 13:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zxCk8GpDH4bb8/W7p6lnaajV3l8Pn09R+gbYT6KPEIg=;
        b=CLXUcXqBpUJ0ena3XCuiwE/DX6/hwoQediaxTCWyK5vZrxz79JEQgzHsWN0rvsPlSp
         RBp7UkiXr2+Ptav7+xaqd161CjFbsyk7w2aa3yf6OWdvovp/bff9IQ+AWluFV5xHUInC
         0NnlIsz9p2eBvmQdWv9ch3v+5u/qbFstOZL7qbdl5AByEJD6TXuBTdwindX7U6+imk7V
         RizJp50wW32zdYkBrL1jPEj4A5fw1KWGYMp4Y9f/+4vwpy5iZvnMnx0LdvG0O/dMHB7p
         jnI9oDfWlieivx6p6RHf7Hq7D/v9FTimix+P4wFgLbcFnGJep8X8YY0nb8Tt6D76sCHz
         f5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zxCk8GpDH4bb8/W7p6lnaajV3l8Pn09R+gbYT6KPEIg=;
        b=me8YLQ0dV9Oo0Y2JGTUrSdfklnG+H06yoZxTjMVbwm71F4EDB+10UymttiOpVgMypt
         nI22F+0S55PKxuugPcOKGd+vkkNJ0wXOBG3pAWR3zslzsRYlYMY6aF5nhRRZqLoF9Bv5
         QKoMU/CVFU7O3sem1LB3HinJEdxpxbrU3DubuSTiwr98rScIiZTE6tZE4JF+6Ewa6LH7
         71tBwkQNfHHgMUwmlobAPJhwE7oTdSu6hZrmzjWnnVy/DNsQ5sA78yFRpJtLO2zh2i6h
         bP/5iFdct9HeM1+SAGayUsYyHmYv0kwYUWjDrMM2kWsEZ+fKYzcZWr0/klDQtfDtNDCV
         +HHQ==
X-Gm-Message-State: AOAM533vfd56Q0Rz6iXJIpLI2iLNDnykQ+7XTX2Avy2lx9+EGwd3rwAC
	x3IiksmV83wqRX87biNWOUjG3ZFS9wisBzeMFsiLwQ==
X-Google-Smtp-Source: ABdhPJxV4CxWTs4l9TIR1TjoO+dfSu5OAZxBz9kF9BjYVUaVr94I74gPwOso0Po8UKZGXcxlSQkUukEAGscpv0mcvWs=
X-Received: by 2002:a62:4dc2:0:b0:4bc:d793:1e24 with SMTP id
 a185-20020a624dc2000000b004bcd7931e24mr11393305pfb.61.1641505919030; Thu, 06
 Jan 2022 13:51:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1641233076.git.alison.schofield@intel.com> <78ff68a062f23cef48fb6ea1f91bcd7e11e4fa6e.1641233076.git.alison.schofield@intel.com>
In-Reply-To: <78ff68a062f23cef48fb6ea1f91bcd7e11e4fa6e.1641233076.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 6 Jan 2022 13:51:47 -0800
Message-ID: <CAPcyv4iE-tVTbU146U+x81SEPMROimETNgxMab68A9YTqOPLqw@mail.gmail.com>
Subject: Re: [ndctl PATCH 4/7] cxl: add memdev partition information to cxl-list
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 3, 2022 at 12:11 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> Add information useful for managing memdev partitions to cxl-list
> output. Include all of the fields from GET_PARTITION_INFO and the
> partitioning related fields from the IDENTIFY mailbox command.
>
>     "partition":{

Perhaps call it "parition_info"?

>       "active_volatile_capacity":273535729664,
>       "active_persistent_capacity":0,
>       "next_volatile_capacity":0,
>       "next_persistent_capacity":0,
>       "total_capacity":273535729664,
>       "volatile_only_capacity":0,
>       "persistent_only_capacity":0,
>       "partition_alignment":268435456
>     }
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt |  23 +++++++
>  util/json.h                    |   1 +
>  cxl/list.c                     |   5 ++
>  util/json.c                    | 112 +++++++++++++++++++++++++++++++++
>  4 files changed, 141 insertions(+)
>
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index c8d10fb..e65e944 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -85,6 +85,29 @@ OPTIONS
>    }
>  ]
>  ----
> +-P::
> +--partition::
> +       Include partition information in the memdev listing. Example listing:

How about -I/--partition for partition "Info". I had earmarked -P for
including "Port" object in the listing.

Other than that, looks good:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> +----
> +# cxl list -m mem0 -P
> +[
> +  {
> +    "memdev":"mem0",
> +    "pmem_size":0,
> +    "ram_size":273535729664,
> +    "partition":{
> +      "active_volatile_capacity":273535729664,
> +      "active_persistent_capacity":0,
> +      "next_volatile_capacity":0,
> +      "next_persistent_capacity":0,
> +      "total_capacity":273535729664,
> +      "volatile_only_capacity":0,
> +      "persistent_only_capacity":0,
> +      "partition_alignment":268435456
> +    }
> +  }
> +]
> +----
>
>  include::human-option.txt[]
>
> diff --git a/util/json.h b/util/json.h
> index ce575e6..76a8816 100644
> --- a/util/json.h
> +++ b/util/json.h
> @@ -20,6 +20,7 @@ enum util_json_flags {
>         UTIL_JSON_FIRMWARE      = (1 << 8),
>         UTIL_JSON_DAX_MAPPINGS  = (1 << 9),
>         UTIL_JSON_HEALTH        = (1 << 10),
> +       UTIL_JSON_PARTITION     = (1 << 11),
>  };
>
>  struct json_object;
> diff --git a/cxl/list.c b/cxl/list.c
> index b1468b7..368ec21 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -17,6 +17,7 @@ static struct {
>         bool idle;
>         bool human;
>         bool health;
> +       bool partition;
>  } list;
>
>  static unsigned long listopts_to_flags(void)
> @@ -29,6 +30,8 @@ static unsigned long listopts_to_flags(void)
>                 flags |= UTIL_JSON_HUMAN;
>         if (list.health)
>                 flags |= UTIL_JSON_HEALTH;
> +       if (list.partition)
> +               flags |= UTIL_JSON_PARTITION;
>         return flags;
>  }
>
> @@ -62,6 +65,8 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>                                 "use human friendly number formats "),
>                 OPT_BOOLEAN('H', "health", &list.health,
>                                 "include memory device health information "),
> +               OPT_BOOLEAN('P', "partition", &list.partition,
> +                               "include memory device partition information "),
>                 OPT_END(),
>         };
>         const char * const u[] = {
> diff --git a/util/json.c b/util/json.c
> index f97cf07..4254dea 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -1616,6 +1616,113 @@ err_jobj:
>         return NULL;
>  }
>
> +/*
> + * Present complete view of memdev partition by presenting fields from
> + * both GET_PARTITION_INFO and IDENTIFY mailbox commands.
> + */
> +static struct json_object *util_cxl_memdev_partition_to_json(struct cxl_memdev *memdev,
> +               unsigned long flags)
> +{
> +       struct json_object *jobj = NULL;
> +       struct json_object *jpart;
> +       unsigned long long cap;
> +       struct cxl_cmd *cmd;
> +       int rc;
> +
> +       jpart = json_object_new_object();
> +       if (!jpart)
> +               return NULL;
> +       if (!memdev)
> +               goto err_jobj;
> +
> +       /* Retrieve partition info in GET_PARTITION_INFO mbox cmd */
> +       cmd = cxl_cmd_new_get_partition_info(memdev);
> +       if (!cmd)
> +               goto err_jobj;
> +
> +       rc = cxl_cmd_submit(cmd);
> +       if (rc < 0)
> +               goto err_cmd;
> +       rc = cxl_cmd_get_mbox_status(cmd);
> +       if (rc != 0)
> +               goto err_cmd;
> +
> +       cap = cxl_cmd_get_partition_info_get_active_volatile_cap(cmd);
> +       if (cap != ULLONG_MAX) {
> +               jobj = util_json_object_size(cap, flags);
> +               if (jobj)
> +                       json_object_object_add(jpart,
> +                                       "active_volatile_capacity", jobj);
> +       }
> +       cap = cxl_cmd_get_partition_info_get_active_persistent_cap(cmd);
> +       if (cap != ULLONG_MAX) {
> +               jobj = util_json_object_size(cap, flags);
> +               if (jobj)
> +                       json_object_object_add(jpart,
> +                                       "active_persistent_capacity", jobj);
> +       }
> +       cap = cxl_cmd_get_partition_info_get_next_volatile_cap(cmd);
> +       if (cap != ULLONG_MAX) {
> +               jobj = util_json_object_size(cap, flags);
> +               if (jobj)
> +                       json_object_object_add(jpart,
> +                                       "next_volatile_capacity", jobj);
> +       }
> +       cap = cxl_cmd_get_partition_info_get_next_persistent_cap(cmd);
> +       if (cap != ULLONG_MAX) {
> +               jobj = util_json_object_size(cap, flags);
> +               if (jobj)
> +                       json_object_object_add(jpart,
> +                                       "next_persistent_capacity", jobj);
> +       }
> +       cxl_cmd_unref(cmd);
> +
> +       /* Retrieve partition info in the IDENTIFY mbox cmd */
> +       cmd = cxl_cmd_new_identify(memdev);
> +       if (!cmd)
> +               goto err_jobj;
> +
> +       rc = cxl_cmd_submit(cmd);
> +       if (rc < 0)
> +               goto err_cmd;
> +       rc = cxl_cmd_get_mbox_status(cmd);
> +       if (rc != 0)
> +               goto err_cmd;
> +
> +       cap = cxl_cmd_identify_get_total_capacity(cmd);
> +       if (cap != ULLONG_MAX) {
> +               jobj = util_json_object_size(cap, flags);
> +               if (jobj)
> +                       json_object_object_add(jpart, "total_capacity", jobj);
> +       }
> +       cap = cxl_cmd_identify_get_volatile_only_capacity(cmd);
> +       if (cap != ULLONG_MAX) {
> +               jobj = util_json_object_size(cap, flags);
> +               if (jobj)
> +                       json_object_object_add(jpart,
> +                                       "volatile_only_capacity", jobj);
> +       }
> +       cap = cxl_cmd_identify_get_persistent_only_capacity(cmd);
> +       if (cap != ULLONG_MAX) {
> +               jobj = util_json_object_size(cap, flags);
> +               if (jobj)
> +                       json_object_object_add(jpart,
> +                                       "persistent_only_capacity", jobj);
> +       }
> +       cap = cxl_cmd_identify_get_partition_align(cmd);
> +       jobj = util_json_object_size(cap, flags);
> +       if (jobj)
> +               json_object_object_add(jpart, "partition_alignment", jobj);
> +
> +       return jpart;
> +
> +err_cmd:
> +       cxl_cmd_unref(cmd);
> +err_jobj:
> +       json_object_put(jpart);
> +       return NULL;
> +}
> +
>  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>                 unsigned long flags)
>  {
> @@ -1643,5 +1750,10 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>                 if (jobj)
>                         json_object_object_add(jdev, "health", jobj);
>         }
> +       if (flags & UTIL_JSON_PARTITION) {
> +               jobj = util_cxl_memdev_partition_to_json(memdev, flags);
> +               if (jobj)
> +                       json_object_object_add(jdev, "partition", jobj);
> +       }
>         return jdev;
>  }
> --
> 2.31.1
>
