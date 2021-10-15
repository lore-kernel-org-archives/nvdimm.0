Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D24972
	for <nvdimm@lists.linux.dev>; Fri, 15 Oct 2021 21:15:56 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id r2so9665665pgl.10
        for <nvdimm@lists.linux.dev>; Fri, 15 Oct 2021 14:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uVxjIXB320G0utlagZyh71XBvtZ8hGEI7ml4ZXDQLYY=;
        b=8F/jlLx3H/ai61cbaiyD8fsL8LSIY+NEhqNYZ5VHqwvg+4s5vFLg+BpfVpcvtQG0mp
         WNIOGKanog95rHFfnzU8kZuG2G60duDdDlCZ/0Kc//8UHtuccaYeaEXlfZHuwqdC4VPi
         RgQbuVPLiuzSnxeINN3QkqM/k/9lhuM5O+KOUemkfL6EmrtPwUqKszO0cs+cu8pFeBfn
         PZO3gMPckkQssS+Izrpb2kxNG6ar2jGYjYZ885J5sEKi89ZuEWWeK9l+fNJdQSDVhQxs
         clJapaoMw3xqe8kV38xm8c0nGCAemXCZJmD1zAlNLUgPTk2uTbNCh8+7K1W+JpQn/eDj
         E0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uVxjIXB320G0utlagZyh71XBvtZ8hGEI7ml4ZXDQLYY=;
        b=KH8bjxLQ+G3mPdYtJy1skhQZ5utaviVj8zX+Z92rNGosxRwq5vOSfMx6ghvMrhjcDx
         H7gJtw2yfvcXmK6KIobYKkDncvE4uQX8NwSsACvITBm1swUraZf4XZSedeUFIildED6a
         oGp4BfWNvNmZl4KAmblvxJoctkmjg8EdAdqxQDc7fobRmxHXda4r/h3kJ/tUcumke66r
         Q+hQpAes7OFeMYJEaVUrbkM0RdrbB578tD4QlFUM7/xx9jREKYp0bJQEJmWsppdP7iFN
         7ZYqPWBDW0i1tUnlhNNOx6LmhhY71jyy694GAn0FMtaTP1J9IBdYwx3Fu/OH0pDl4m0b
         xe6w==
X-Gm-Message-State: AOAM532nncKS38qv4t3Hca0YQ0J4zvwmDpHnZXLhcLMdV0p8MKxRkPZX
	/e61cugeXtfkQurLCNbp6vrgfiI8hKmCzvP2KB77jx9e
X-Google-Smtp-Source: ABdhPJxg8UyfYiobupsrYJQASYUkON3lKi4grucUkPOxIj6dEkJFzgu/tHduON6DhchCYWFobryx5JgxUJVGk3hIxK0=
X-Received: by 2002:a62:1b92:0:b0:3eb:3f92:724 with SMTP id
 b140-20020a621b92000000b003eb3f920724mr13773526pfb.3.1634332556001; Fri, 15
 Oct 2021 14:15:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
 <20211007082139.3088615-18-vishal.l.verma@intel.com> <d20b7fd17067aa49a5ccdd2c649f345ab17cb12e.camel@intel.com>
In-Reply-To: <d20b7fd17067aa49a5ccdd2c649f345ab17cb12e.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Oct 2021 14:15:47 -0700
Message-ID: <CAPcyv4joKOhTdaRBJVeoOtqhRjBvdtt9902TS=c39=zWTZXvuw@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 17/17] cxl: add health information to cxl-list
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "Widawsky, Ben" <ben.widawsky@intel.com>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 14, 2021 at 4:42 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Thu, 2021-10-07 at 02:21 -0600, Vishal Verma wrote:
> > Add JSON output for fields from the 'GET_HEALTH_INFO' mailbox command
> > to memory device listings.
> >
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  Documentation/cxl/cxl-list.txt |   4 +
> >  util/json.h                    |   1 +
> >  cxl/list.c                     |   5 +
> >  util/json.c                    | 189 +++++++++++++++++++++++++++++++++
> >  4 files changed, 199 insertions(+)
> >
> > diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> > index bd377b3..dc86651 100644
> > --- a/Documentation/cxl/cxl-list.txt
> > +++ b/Documentation/cxl/cxl-list.txt
> > @@ -53,6 +53,10 @@ OPTIONS
> >  --idle::
> >       Include idle (not enabled / zero-sized) devices in the listing
> >
> > +-H::
> > +--health::
> > +     Include health information in the memdev listing
> > +
> >  include::human-option.txt[]
> >
> >  include::verbose-option.txt[]
> > diff --git a/util/json.h b/util/json.h
> > index 91918c8..ce575e6 100644
> > --- a/util/json.h
> > +++ b/util/json.h
> > @@ -19,6 +19,7 @@ enum util_json_flags {
> >       UTIL_JSON_CONFIGURED    = (1 << 7),
> >       UTIL_JSON_FIRMWARE      = (1 << 8),
> >       UTIL_JSON_DAX_MAPPINGS  = (1 << 9),
> > +     UTIL_JSON_HEALTH        = (1 << 10),
> >  };
> >
> >  struct json_object;
> > diff --git a/cxl/list.c b/cxl/list.c
> > index 3dea73f..2fa155a 100644
> > --- a/cxl/list.c
> > +++ b/cxl/list.c
> > @@ -16,6 +16,7 @@ static struct {
> >       bool memdevs;
> >       bool idle;
> >       bool human;
> > +     bool health;
> >  } list;
> >
> >  static unsigned long listopts_to_flags(void)
> > @@ -26,6 +27,8 @@ static unsigned long listopts_to_flags(void)
> >               flags |= UTIL_JSON_IDLE;
> >       if (list.human)
> >               flags |= UTIL_JSON_HUMAN;
> > +     if (list.health)
> > +             flags |= UTIL_JSON_HEALTH;
> >       return flags;
> >  }
> >
> > @@ -57,6 +60,8 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
> >               OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
> >               OPT_BOOLEAN('u', "human", &list.human,
> >                               "use human friendly number formats "),
> > +             OPT_BOOLEAN('H', "health", &list.health,
> > +                             "include memory device health information "),
> >               OPT_END(),
> >       };
> >       const char * const u[] = {
> > diff --git a/util/json.c b/util/json.c
> > index 3be3a92..dfc7b8e 100644
> > --- a/util/json.c
> > +++ b/util/json.c
> > @@ -1442,6 +1442,190 @@ struct json_object *util_badblock_rec_to_json(u64 block, u64 count,
> >       return NULL;
> >  }
> >
> > +static struct json_object *util_cxl_memdev_health_to_json(
> > +             struct cxl_memdev *memdev, unsigned long flags)
> > +{
> > +     const char *devname = cxl_memdev_get_devname(memdev);
> > +     struct json_object *jhealth;
> > +     struct json_object *jobj;
> > +     struct cxl_cmd *cmd;
> > +     u32 field;
> > +     int rc;
> > +
> > +     jhealth = json_object_new_object();
> > +     if (!jhealth)
> > +             return NULL;
> > +     if (!memdev)
> > +             goto err_jobj;
> > +
> > +     cmd = cxl_cmd_new_get_health_info(memdev);
> > +     if (!cmd)
> > +             goto err_jobj;
> > +
> > +     rc = cxl_cmd_submit(cmd);
> > +     /* ENOTTY - command not supported by the memdev */
> > +     if (rc == -ENOTTY)
> > +             goto err_cmd;
>
> I'll remove this special case, as well as the error prints below. The
> cmd submission could fail for any number of reasons, including
> unsupported by hardware - I think for any of those cases, we can just
> silently skip printing the json fields here.

Sounds good. If someone really cares, the debug prints inside
cxl_cmd_submit() should be enough to indicate what went wrong.
