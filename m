Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7851270
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 02:14:57 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so2185061pjb.3
        for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 19:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nWnWHK81cHSSSYNhV/ky18B/eWmiRGBwsPJhNQ9JxJE=;
        b=Slqkm9exTJPLJIB8INasB6dcy8ztieb/Zvsv0MN53EtTKQFaxdX9F9qkB/vPbdmkIc
         rslPhVpjQJJzVevKA4HyKSKCVSgSEaXJigY/VM4OwIVsjta3zauY54S/eTOGwxUEkIa6
         PKYNY6mXwWTKfsOAVHd7GtqeIArMFqPz1tzK3YXBd6G9M87JvhWuYtZj9xdhBBVi/Js4
         j/urKU31kDGmUKrWzmDH0+2sjVcW1aWDsiJYBfk8fO5tALajOpF7q+hDd3pb4xfuafVl
         ml7EEw8VEO0Kl5Do57UPwRO6UWmF90cPVcwYe/QbSYYt2qv9y3UrWOeC4L/gWGyGtHij
         qI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nWnWHK81cHSSSYNhV/ky18B/eWmiRGBwsPJhNQ9JxJE=;
        b=jWsQKnmFRnt/98FUM+mhnqDDCjeMwoh74o9jYXpImg5VOosHW1bnE9oph+gp09P8p7
         9yncWLuTcWRvlNMmdSF4esn219fd/PvFDUcxsM6WVnECobSVnbo6p+34GhIwIn+ThHst
         c/aXqw8kzDGPoi2BLiwMYAhOlgDgwriPNHWztR0fdp4SkfcEkNSWlD6lsUdmtMMnMCyK
         yxYrLJiMlFwmYn3+d5TnSBpKczApPW8CyAV89GpnaRQ/DQDx+68BReD0xMSTszuDy5AC
         BjWl1EF5MIG3GR8L2SlJmMsB5wnn/DZuQR2BnnZxhZvLmhlDUV96xDmnEcbNqu1etngK
         bWcw==
X-Gm-Message-State: AOAM531iC/y4GOHdgk16yMentb3tsYmP++4kRVG3tWuWolZaCcPPG66e
	fxhK6aWLE6otWkk27JQKwt8lOTRq8LjXaCHQlGibOA==
X-Google-Smtp-Source: ABdhPJxjI3G1JliiDL5lb4M9JD0cysUnjBy+5+KeQRqMz2HrCacDSU7gc575kfwMcqnqF+Dz8nUUJEQofF8F16s++Es=
X-Received: by 2002:a62:5f81:0:b029:3c6:abad:345 with SMTP id
 t123-20020a625f810000b02903c6abad0345mr26549389pfb.31.1628648096952; Tue, 10
 Aug 2021 19:14:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854815819.1980150.14391324052281496748.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210810213459.5zpvfrvbo2rztwmc@intel.com> <CAPcyv4iXZpeahdDxyRLd7ACS6vpV+VA3-J3MiLQvvV2Q6asBFg@mail.gmail.com>
 <20210810220654.nztok7mxvjzaizhk@intel.com> <CAPcyv4iLLPR+yijKNHceEKM4+fKQ4i6r+ZLYH+_b-ao6tznHLQ@mail.gmail.com>
In-Reply-To: <CAPcyv4iLLPR+yijKNHceEKM4+fKQ4i6r+ZLYH+_b-ao6tznHLQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Aug 2021 19:14:45 -0700
Message-ID: <CAPcyv4jn-1V=nCdgOxFJF3bVJd13YpRxnLvjE_BbacJ7_Qmwhw@mail.gmail.com>
Subject: Re: [PATCH 17/23] cxl/mbox: Add exclusive kernel command support
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 10, 2021 at 6:22 PM Dan Williams <dan.j.williams@intel.com> wrote:
[..]
> > > > What's the concurrency this lock is trying to protect against?
> > >
> > > I can add a comment. It synchronizes against in-flight ioctl users to
> > > make sure that any requests have completed before the policy changes.
> > > I.e. do not allow userspace to race the nvdimm subsystem attaching to
> > > get a consistent state of the persistent memory configuration.
> > >
> >
> > Ah, so the expectation is that these things will be set not just on
> > probe/unregister()? I would assume an IOCTL couldn't happen while
> > probe/unregister is happening.
>
> The ioctl is going through the cxl_pci driver. That driver has
> finished probe and published the ioctl before this lockout can run in
> cxl_nvdimm_probe(), so it's entirely possible that label writing
> ioctls are in progress when cxl_nvdimm_probe() eventually fires.
>
> The current policy for /sys/bus/nd/devices/nmemX devices are that
> label writes are allowed as long as the nmemX device is not active in
> any region. I was thinking the CXL policy is coarser. Label writes via
> /sys/bus/cxl/devices/memX ioctls are disallowed as long as the bridge
> for that device into the nvdimm subsystem is active.

Oh, whoops, the mbox_mutex is not taken until we're deep inside
mbox_send. So this synchronization needs to move to the cxl_memdev
rwsem. Thanks for the nudge, I missed that.
