Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B63168
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 00:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1626135590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h05RHa9mgcLrKnnSZa6FxrsmP2UtZa6XuyjEobCl9ho=;
	b=K4IhLmY6/wr0k+SAbU6mQg23MxjEstZEHSim219akS9T65TKSZzOZ1tcUQgKE6dDNktSRu
	SWnMSdsqU6HLjNOxgoo+CqMK6EwbxtIXMS0bDcYyayAZIEOe/xDSm9Ye9av+mbT7xwcFZP
	ak1MuXOlzCEZ4aohwCSjA51jCioW75Y=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-2NHR9cGhMoWtQvO1IETr2w-1; Mon, 12 Jul 2021 20:19:49 -0400
X-MC-Unique: 2NHR9cGhMoWtQvO1IETr2w-1
Received: by mail-yb1-f197.google.com with SMTP id x15-20020a25ce0f0000b029055bb0981111so24727230ybe.7
        for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 17:19:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h05RHa9mgcLrKnnSZa6FxrsmP2UtZa6XuyjEobCl9ho=;
        b=YRbCRZksh+xWrO0cVdjTDcfFrkjtOD4+gWCLn8I+8fERaDvyks/ZUz57YaiV0yFyr3
         a0ohHl1qQLBUHf3jd5nILPSHduz90H2gcU+niz5S/y7IynvAGXx+WXUdWYoeLQEWPU/f
         Z7tGyITr+PoF8jfngAkRCTybBbeCFRaHx3HFyqp8QdcnkNb+RmdWLhv/sNZDLE1Tv9s9
         2tUIishORDCxFAoewbUZaVt0drJnZAw3Lcr2W9gyDa6/sQYgVchmwvENUvk8ggCDew0U
         4b4hta4SfmZLO8S0Mx+peBi7gEnXstzJv12dagy2bLtqXrh384VEvg0n91WBTSFITWKF
         9mxA==
X-Gm-Message-State: AOAM533G2KbBWwg+mnpHXfgma1EKgacbSxxI5woDocpsBFBrP3ziZf3a
	Mnvxbs4LNwtG2u34tnmneTZzmV+z5Glrm5WrT2dnU7Adp2GPIOK2PALlynD2o2EggILJ900a90A
	vehLk8SIXrCeIBNircZiG+izlWPtcSzzp
X-Received: by 2002:a25:e756:: with SMTP id e83mr2081623ybh.133.1626135588522;
        Mon, 12 Jul 2021 17:19:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYiBIIqOM3+m2K59FaBTAnePZgiOQxouDmxHIVyA9x8UhGc+A/JuwuK/6YlIClCD8e4Y8iQV+/J4lAYf2m4A8=
X-Received: by 2002:a25:e756:: with SMTP id e83mr2081602ybh.133.1626135588300;
 Mon, 12 Jul 2021 17:19:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210708100104.168348-1-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20210708100104.168348-1-aneesh.kumar@linux.ibm.com>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Tue, 13 Jul 2021 08:19:36 +0800
Message-ID: <CAHj4cs_t9sMw9b5XRPMkYE37BfAEMkWCFFpU1C8heKYBbRcnbA@mail.gmail.com>
Subject: Re: [PATCH] ndctl: Avoid confusing error message when operating on
 all the namespaces
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=yizhan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Jeff had posted one patch to fix similar issue
https://lore.kernel.org/linux-nvdimm/x49r1lohpty.fsf@segfault.boston.devel.redhat.com/T/#u

Hi Dan/Visha
Could we make some progress on this issue?


On Thu, Jul 8, 2021 at 6:41 PM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> With only seed namespace present, ndctl results in confusing error messages as
> below.
>
> ndctl# ./ndctl/ndctl  enable-namespace all
> error enabling namespaces: No such device or address
> enabled 0 namespaces
>
> ndctl# ./ndctl/ndctl  disable-namespace all
> disabled 3 namespaces
>
> ndctl# ./ndctl/ndctl  destroy-namespace all -f
>   Error: destroy namespace: namespace1.0 failed to enable for zeroing, continuing
>
>   Error: destroy namespace: namespace1.1 failed to enable for zeroing, continuing
>
>   Error: destroy namespace: namespace0.0 failed to enable for zeroing, continuing
>
> destroyed 0 namespaces
> ndctl#
>
> With the patch we get
> ndctl# ./ndctl/ndctl  disable-namespace all
> disabled 0 namespaces
>
> ndctl# ./ndctl/ndctl  enable-namespace all
> enabled 0 namespaces
>
> ndctl# ./ndctl/ndctl  destroy-namespace all -f
> destroyed 0 namespaces
> ndctl#
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  ndctl/namespace.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 0c8df9fa8b47..c52daeae562a 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -2205,8 +2205,15 @@ static int do_xaction_namespace(const char *namespace,
>                                 return rc;
>                         }
>                         ndctl_namespace_foreach_safe(region, ndns, _n) {
> -                               ndns_name = ndctl_namespace_get_devname(ndns);
>
> +                               if (!strcmp(namespace, "all")
> +                                               && !ndctl_namespace_get_size(ndns)) {
> +                                       if (!*processed && rc)
> +                                               rc  = 0;
> +                                       continue;
> +                               }
> +
> +                               ndns_name = ndctl_namespace_get_devname(ndns);
>                                 if (strcmp(namespace, "all") != 0
>                                                 && strcmp(namespace, ndns_name) != 0)
>                                         continue;
> --
> 2.31.1
>
>


-- 
Best Regards,
  Yi Zhang

