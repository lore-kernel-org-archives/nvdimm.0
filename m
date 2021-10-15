Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CC92C83
	for <nvdimm@lists.linux.dev>; Fri, 15 Oct 2021 00:09:48 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so5972980pjb.5
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 17:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eax0i+Emf2DSekUFPitc2WNCYRA37HTROoGfceUiop4=;
        b=fL+AoSGDlhYovg8TYeYb41Pzz9ZlBL6zaLf/d5CwK/gDp8ptigweC8vb7EKk5TbeKp
         QvAaIypK7FsjSeCGunAigbJW7dFcCDORSD0XygN5UMmHpPJpAETO6qw3JPsx4lYTqTwm
         m/VE1SRdkH7pUM5YKsW3kOpZk7DtQupQ3mWnqekThWwS+fJAf8koBZM3d6oQGH4WLVuY
         KblitKdn1u9d+keJhjh9kjfbJ4lyFJ/AeqEvD3sK1+2MuWEQcs4eSAjwUPuDSFgvaQWS
         McBp4vEv/CnladpJQFB39ZDejSry9FxaChBzeHt1sYccr9AxPpDUvph3u9lk/w7JZPTm
         JfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eax0i+Emf2DSekUFPitc2WNCYRA37HTROoGfceUiop4=;
        b=2OiGqxeUXpIlIYJu9YNUWVL5ux2aJS7CP2xNnGQ94evatLQyIaStK/s5k0HfHdiVhV
         QZK2gqFr7wszcpcIoDApie5YsWt3NzwKzA5PX3XAGncVBPst3O/IIf45ksjJqqFpTiS2
         ec+nv5EOML8Ohx9soURuPa2yVMbuNMMAMHgQfb2rKda5/h/14avzm06McDkVOHb+/Btk
         Gg5coYp6tyvNE+rIYaT9Bv82yFWdW/CyYxIS0IFTCI7jlhdB1KS/b9QG7uApqpHWZbJl
         4Y6RreWyaDX5RYPBfEgplB+kVaO6JJk3GAUXZ/6EGVIUpNS2qjjq1EGSKYuvDiBazknu
         Z6CQ==
X-Gm-Message-State: AOAM530Zv/qU3TORtZf4qUjmL3NUSC92gpiu57MHtWqcd3eqnHp3pX+g
	tGnASXpSKatUk+7e9ut73J6Oo9dTBoPjq4zkBdLwXcnOqGEe6g==
X-Google-Smtp-Source: ABdhPJztxcNpm9n5KLSzYP9Wx+J3szqQeK65/JAFrjTtoGjGTIClqb9YnFQ5R5AXtjjSGZuFzKaEeA4CsI9oshiYqm4=
X-Received: by 2002:a17:90a:a085:: with SMTP id r5mr23781136pjp.8.1634256588166;
 Thu, 14 Oct 2021 17:09:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
 <20211007082139.3088615-18-vishal.l.verma@intel.com> <8144d0576ce15828456a0ba0c8461162f604bc38.camel@intel.com>
In-Reply-To: <8144d0576ce15828456a0ba0c8461162f604bc38.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 17:09:38 -0700
Message-ID: <CAPcyv4jCye=C76m52EcxhZMbRdaTLV47VTyxdi-pGxf4aMfZaA@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 17/17] cxl: add health information to cxl-list
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "Widawsky, Ben" <ben.widawsky@intel.com>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 11, 2021 at 3:07 PM Verma, Vishal L
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
> > +     if (rc < 0) {
> > +             fprintf(stderr, "%s: cmd submission failed: %s\n", devname,
> > +                 strerror(-rc));
> > +             goto err_cmd;
> > +     }
> > +     rc = cxl_cmd_get_mbox_status(cmd);
> > +     if (rc != 0) {
> > +             fprintf(stderr, "%s: firmware status: %d\n", devname, rc);
> > +             rc = -ENXIO;
> > +             goto err_cmd;
> > +     }
> > +
> > +     /* health_status fields */
> > +     rc = cxl_cmd_health_info_get_maintenance_needed(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "maintenance_needed", jobj);
> > +
> > +     rc = cxl_cmd_health_info_get_performance_degraded(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "performance_degraded", jobj);
> > +
> > +     rc = cxl_cmd_health_info_get_hw_replacement_needed(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "hw_replacement_needed", jobj);
> > +
> > +     /* media_status fields */
> > +     rc = cxl_cmd_health_info_get_media_normal(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "media_normal", jobj);
> > +
> > +     rc = cxl_cmd_health_info_get_media_not_ready(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "media_not_ready", jobj);
> > +
> > +     rc = cxl_cmd_health_info_get_media_persistence_lost(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "media_persistence_lost", jobj);
> > +
> > +     rc = cxl_cmd_health_info_get_media_data_lost(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "media_data_lost", jobj);
> > +
> > +     rc = cxl_cmd_health_info_get_media_powerloss_persistence_loss(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "media_powerloss_persistence_loss", jobj);
> > +
> > +     rc = cxl_cmd_health_info_get_media_shutdown_persistence_loss(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "media_shutdown_persistence_loss", jobj);
> > +
> > +     rc = cxl_cmd_health_info_get_media_persistence_loss_imminent(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "media_persistence_loss_imminent", jobj);
> > +
> > +     rc = cxl_cmd_health_info_get_media_powerloss_data_loss(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "media_powerloss_data_loss", jobj);
> > +
> > +     rc = cxl_cmd_health_info_get_media_shutdown_data_loss(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "media_shutdown_data_loss", jobj);
> > +
> > +     rc = cxl_cmd_health_info_get_media_data_loss_imminent(cmd);
> > +     jobj = json_object_new_boolean(rc);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "media_data_loss_imminent", jobj);
> > +
> > +     /* ext_status fields */
> > +     if (cxl_cmd_health_info_get_ext_life_used_normal(cmd))
> > +             jobj = json_object_new_string("normal");
> > +     else if (cxl_cmd_health_info_get_ext_life_used_warning(cmd))
> > +             jobj = json_object_new_string("warning");
> > +     else if (cxl_cmd_health_info_get_ext_life_used_critical(cmd))
> > +             jobj = json_object_new_string("critical");
> > +     else
> > +             jobj = json_object_new_string("unknown");
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "ext_life_used", jobj);
> > +
> > +     if (cxl_cmd_health_info_get_ext_temperature_normal(cmd))
> > +             jobj = json_object_new_string("normal");
> > +     else if (cxl_cmd_health_info_get_ext_temperature_warning(cmd))
> > +             jobj = json_object_new_string("warning");
> > +     else if (cxl_cmd_health_info_get_ext_temperature_critical(cmd))
> > +             jobj = json_object_new_string("critical");
> > +     else
> > +             jobj = json_object_new_string("unknown");
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "ext_temperature", jobj);
> > +
> > +     if (cxl_cmd_health_info_get_ext_corrected_volatile_normal(cmd))
> > +             jobj = json_object_new_string("normal");
> > +     else if (cxl_cmd_health_info_get_ext_corrected_volatile_warning(cmd))
> > +             jobj = json_object_new_string("warning");
> > +     else
> > +             jobj = json_object_new_string("unknown");
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "ext_corrected_volatile", jobj);
> > +
> > +     if (cxl_cmd_health_info_get_ext_corrected_persistent_normal(cmd))
> > +             jobj = json_object_new_string("normal");
> > +     else if (cxl_cmd_health_info_get_ext_corrected_persistent_warning(cmd))
> > +             jobj = json_object_new_string("warning");
> > +     else
> > +             jobj = json_object_new_string("unknown");
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "ext_corrected_persistent", jobj);
> > +
> > +     /* other fields */
> > +     field = cxl_cmd_health_info_get_life_used(cmd);
> > +     if (field != 0xff) {
> > +             jobj = json_object_new_int(field);
> > +             if (jobj)
> > +                     json_object_object_add(jhealth, "life_used_percent", jobj);
> > +     }
> > +
> > +     field = cxl_cmd_health_info_get_temperature(cmd);
> > +     if (field != 0xffff) {
> > +             jobj = json_object_new_int(field);
> > +             if (jobj)
> > +                     json_object_object_add(jhealth, "temperature", jobj);
> > +     }
> > +
> > +     field = cxl_cmd_health_info_get_dirty_shutdowns(cmd);
> > +     jobj = json_object_new_uint64(field);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "dirty_shutdowns", jobj);
> > +
> > +     field = cxl_cmd_health_info_get_volatile_errors(cmd);
> > +     jobj = json_object_new_uint64(field);
> > +     if (jobj)
> > +             json_object_object_add(jhealth, "volatile_errors", jobj);
> > +
> > +     field = cxl_cmd_health_info_get_pmem_errors(cmd);
> > +     jobj = json_object_new_uint64(field);
>
> json_object_new_uint64() seems to be a relatively new interface in
> json-c - Some Ubuntu LTS and CentOS 8 distros dont' have a recent
> enough json-c to have this.
>
> I'm thinking I'll switch these three above to json_object_new_int64.
> I'd originally chosen the uint64 variant because that seemsed to be the
> only unsigned int option available. The fields we're trying to print
> are all u32's. So I think using int64 should be sufficient that we
> won't end up with spurious negative listings.
>
> Thoughts?
>

We do have util_json_object_hex() to work around the earlier
unavailability of an unsigned 64-bit quantity. I think to move to
json_object_new_uint64() it would need to have build system
auto-detect support and likely a compat fallback for environments that
are already expecting that ndctl 64-bit integers might be negative. So
json_object_new_int64() in the near term sounds good to me.
