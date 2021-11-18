Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143812C81
	for <nvdimm@lists.linux.dev>; Thu, 18 Nov 2021 03:40:43 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id k4so4031729plx.8
        for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 19:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=86/wM2P3LVS747F1G3vrnS9GBDN3H6+uBMTp/Hu/yRk=;
        b=PW80NnIMbSEGsfOO1LCwPUkhzrL9IGHRDzvAcGxO5xqFInG3j/Kw4liMlLsP7csKId
         pPidv2M1AHO5z5DN78m3FxmpmybqBCUvJTuBVOJxz4QN3jczRwHc0jtBZrYjzrTZqfIp
         AMcAe2BeSoXBrSl4O8uFwvhp5FUQg7DlLoeuVZlZsiXdaoVFus1DqmnrZX3frJQ2vVyZ
         Riw5V9UUQbHTjuKbkBuawyuywi155o+0qvK7cYPDYwDgGW0n2O/v245FADSNT8k1UFu1
         2bGdKbuC9KgtvXJGOv1qhtj3MtIikZt+mz9ismAIQGnXKNZGN1Fv2TdwPiXRXgldk3kx
         WTxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=86/wM2P3LVS747F1G3vrnS9GBDN3H6+uBMTp/Hu/yRk=;
        b=mcpG7t6k/lCdmuTpXS5VqiDBt89p1aFFwWvp0JrhoGSEnUXwJ+x/26/V5kT/tjGvSG
         Ph2XnRay+reKCAse48K30ky/VT+O5aWkv6vhfVcnmDtA9qSmezV8mC0llTcyH8T0n0I7
         CxzWkk8E8y11aurtp1HHzrcz02HorAI0gkLQB8lR8KrNHrQ/iBTmX9SyCb43yMovwKgZ
         QcLmhXUP0Kim/UACR9onfCKOueitnVUr73S3jyykpWqZdPrcTJuJQ8nG71ltHmVcM/cu
         FomJxNsXJlLQO3uEcD365iiqzpaLNjqaVE82qjvJ5lDtVj471e/xvWR2WFCPXHc0aEPX
         hWjQ==
X-Gm-Message-State: AOAM533M3enmKE/6ZRSSCnP6pamW9bdaxTrPsCBI2Hnx71n7plG66IDP
	wJxQGxCibuPM4B80YVkuIsbbbOzMRXOJdBPzrCDStQ==
X-Google-Smtp-Source: ABdhPJx93e8FoICBoIusqmEOEnulBJ0q6C43fCcSc1sCnSXDm6qrU0fAEqbtkRe9M5bahztxUV6CI2iWk0sPBUh5fok=
X-Received: by 2002:a17:902:a50f:b0:143:7dec:567 with SMTP id
 s15-20020a170902a50f00b001437dec0567mr62831919plq.18.1637206843537; Wed, 17
 Nov 2021 19:40:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
 <20210831090459.2306727-8-vishal.l.verma@intel.com> <CAPcyv4jYeu8y3t9Np495DVMyLt84jQy9EtQjdMDQ4fj91bnZgw@mail.gmail.com>
 <bb9ea18f9845ec93ae72f77a42c563693ac8aaab.camel@intel.com>
In-Reply-To: <bb9ea18f9845ec93ae72f77a42c563693ac8aaab.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Nov 2021 19:40:32 -0800
Message-ID: <CAPcyv4h4-txd-o0gYZU_D=2VPg63v_69QEpO=cY28H47Ju3Wqg@mail.gmail.com>
Subject: Re: [ndctl PATCH 7/7] daxctl: add systemd service and udev rule for auto-onlining
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 17, 2021 at 6:40 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Fri, 2021-09-17 at 11:10 -0700, Dan Williams wrote:
> > On Tue, Aug 31, 2021 at 2:05 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
> > >
> > > Install a helper script that calls daxctl-reconfigure-device with the
> > > new 'check-config' option for a given device. This is meant to be called
> > > via a systemd service.
> > >
> > > Install a systemd service that calls the above wrapper script with a
> > > daxctl device passed in to it via the environment.
> > >
> > > Install a udev rule that is triggered for every daxctl device, and
> > > triggers the above oneshot systemd service.
> > >
> > > Together, these three things work such that upon boot, whenever a daxctl
> > > device is found, udev triggers a device-specific systemd service called,
> > > for example:
> > >
> > >   daxdev-reconfigure@-dev-dax0.0.service
> >
> > I'm thinking the service would be called daxdev-add, because it is
> > servicing KOBJ_ADD events, or is the convention to name the service
> > after what it does vs what it services?
>
> I don't know of a convention - but 'what it does' seemed more natural
> for a service than 'when it's called'. It also correlates better with
> usual system service names (i.e. they are named after what they do).
>
> >
> > Also, I'm curious why would "dax0.0" be in the service name, shouldn't
> > this be scanning all dax devices and internally matching based on the
> > config file?
>
> Systemd black magic? the dax0.0 doesn't come from anything I configure
> - that's just how systemd's 'instantiated services' work. Each newly
> added device gets it's own service tied to a unique identifier for the
> device. For these, it happens to be /dev/dax0.0, which gets escaped to
> -dev-dax0.0.
>
> More reading here:
> http://0pointer.de/blog/projects/instances.html
>
> >
> > >
> > > This initiates a daxctl-reconfigure-device with a config lookup for the
> > > 'dax0.0' device. If the config has an '[auto-online <unique_id>]'
> > > section, it uses the information in that to set the operating mode of
> > > the device.
> > >
> > > If any device is in an unexpected status, 'journalctl' can be used to
> > > view the reconfiguration log for that device, for example:
> > >
> > >   journalctl --unit daxdev-reconfigure@-dev-dax0.0.service
> >
> > There will be a log per-device, or only if there is a service per
> > device? My assumption was that this service is firing off for all
> > devices so you would need to filter the log by the device-name if you
> > know it... or maybe I'm misunderstanding how this udev service works.
>
> There will be both a log and a service per device - the unit file we
> supply/install is essentially a template for these instantiated
> services, but the actual service kicked off is <foo>@<device-
> id>.service

Ah, ok, that makes sense.
