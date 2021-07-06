Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF88168
	for <nvdimm@lists.linux.dev>; Tue,  6 Jul 2021 20:43:25 +0000 (UTC)
Received: by mail-oo1-f50.google.com with SMTP id o3-20020a4a84c30000b0290251d599f19bso2953490oog.8
        for <nvdimm@lists.linux.dev>; Tue, 06 Jul 2021 13:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pxMY07o9eA6SvMdwqfO/Cy/RP18zRy8WHvKUzTEaaNE=;
        b=cMEULcwqLZ1Wut54PhoGe8eWn9DWOkTBGefRRfl5OdVDl+rs626G5wMaH28cgDjzcy
         C3SrxS4IBWN9GT87WmK8g47N1LXQplCWDOfx8int0/GS3k/x/nkilLmTHNlFEJRG7MNd
         XBIkEEXZ1pU0eRvjS1TRSvA1B76ydqAA34SpYmKB2ihzHjiFB86o3rkOkpvBUwbSv3hH
         SAJ7sWW3535WnApBT/aqgm8mqOlZd3rAIlZ18pf5XSKHOT2S+byWJIp1xZIbcvBH0etl
         zsjB18jSpkL6JUn2+voD9bKAbUaWuj/V1AbjBFUkZHMHiCqgtvfqmj4sQqDjclnu51kM
         rRng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pxMY07o9eA6SvMdwqfO/Cy/RP18zRy8WHvKUzTEaaNE=;
        b=SeOOouXEeUZczjdC3NT2XLmTcQwSRRaWM1rfc8DXSe6pQpm1C/fGpiFPaBA/Bu2o42
         J8nXlYjUkOV9nXQMm4E0zmE9jpDuJZBoHa6Ke3ylLlEHcP8TsD47XGsepZcPd5yWe1h+
         C8B36LicqR4eFJZedtiTG7t0t+rivVuThXp9uDDyM1k8JiA9+0MZQlHjPGywaz7oNZow
         tkwI8fuwD+4dNRqloX9pKcCPCESm3uBn/JdcddobDfTBLY5Bc2h/H0Zpii9gJobyxUS8
         TFRkmsg3y/dbJTfEM6MI5AN1n9VUJ6QdWf6EMFG/NmCzd9AFFNA4IaHveIm0r2VXv32p
         W3sg==
X-Gm-Message-State: AOAM5323/v4vWW3u/HMkmcn73d8rQDnfFVHBtVZ1YhkELoacTyU8mOlu
	Ph1KVQy9NIfe/Uj6D6d+YS9y+w==
X-Google-Smtp-Source: ABdhPJxDvDPv3ADYsyyhWPVlnzb7CaqMGlOMdSkFiej4dUoXbTCedb2luVlDDH/zGyqw6KpVymfMhg==
X-Received: by 2002:a4a:d6cc:: with SMTP id j12mr2894172oot.0.1625604204373;
        Tue, 06 Jul 2021 13:43:24 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id x130sm1332892oix.22.2021.07.06.13.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 13:43:23 -0700 (PDT)
Date: Tue, 6 Jul 2021 15:43:21 -0500
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Cc: nvdimm@lists.linux.dev, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-fpga@vger.kernel.org, linux-pci@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-cxl@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, target-devel@vger.kernel.org,
	linux-i2c@vger.kernel.org, linux-i3c@lists.infradead.org,
	linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org,
	linux-staging@lists.linux.dev, linux-acpi@vger.kernel.org,
	industrypack-devel@lists.sourceforge.net,
	linux-input@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-sunxi@lists.linux.dev, linux-media@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-remoteproc@vger.kernel.org, greybus-dev@lists.linaro.org,
	virtualization@lists.linux-foundation.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	netdev@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-spi@vger.kernel.org, kernel@pengutronix.de,
	dmaengine@vger.kernel.org, linux-ntb@googlegroups.com,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 4/4] bus: Make remove callback return void
Message-ID: <YOTAaQ7AnkCvRQaS@yoga>
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
 <20210706154803.1631813-5-u.kleine-koenig@pengutronix.de>
 <YOSb1+yeVeLxiSRc@yoga>
 <20210706184323.fudcbsiu4i34dojs@pengutronix.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706184323.fudcbsiu4i34dojs@pengutronix.de>

On Tue 06 Jul 13:43 CDT 2021, Uwe Kleine-K?nig wrote:

> Hello Bjorn,
> 
> On Tue, Jul 06, 2021 at 01:08:18PM -0500, Bjorn Andersson wrote:
> > On Tue 06 Jul 10:48 CDT 2021, Uwe Kleine-K?nig wrote:
> > > diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
> > > index c1404d3dae2c..7f6fac618ab2 100644
> > > --- a/drivers/rpmsg/rpmsg_core.c
> > > +++ b/drivers/rpmsg/rpmsg_core.c
> > > @@ -530,7 +530,7 @@ static int rpmsg_dev_probe(struct device *dev)
> > >  	return err;
> > >  }
> > >  
> > > -static int rpmsg_dev_remove(struct device *dev)
> > > +static void rpmsg_dev_remove(struct device *dev)
> > >  {
> > >  	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
> > >  	struct rpmsg_driver *rpdrv = to_rpmsg_driver(rpdev->dev.driver);
> > > @@ -546,8 +546,6 @@ static int rpmsg_dev_remove(struct device *dev)
> > >  
> > >  	if (rpdev->ept)
> > >  		rpmsg_destroy_ept(rpdev->ept);
> > > -
> > > -	return err;
> > 
> > This leaves err assigned but never used, but I don't mind following up
> > with a patch cleaning that up after this has landed.
> 
> Ah, good catch. If I send out a v3 I will fold the following into this
> patch:
> 
> diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
> index 7f6fac618ab2..9151836190ce 100644
> --- a/drivers/rpmsg/rpmsg_core.c
> +++ b/drivers/rpmsg/rpmsg_core.c
> @@ -534,10 +534,9 @@ static void rpmsg_dev_remove(struct device *dev)
>  {
>  	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
>  	struct rpmsg_driver *rpdrv = to_rpmsg_driver(rpdev->dev.driver);
> -	int err = 0;
>  
>  	if (rpdev->ops->announce_destroy)
> -		err = rpdev->ops->announce_destroy(rpdev);
> +		rpdev->ops->announce_destroy(rpdev);
>  
>  	if (rpdrv->remove)
>  		rpdrv->remove(rpdev);
> 

Sounds good, feel free to keep my ack on this.

> Maybe .announce_destroy() should then be changed to return void, too?
> Something like:
> 

Yes, I saw this opportunity as well. But that will fan out further, so
let's postpone that until your series has landed and we can follow up
with such changes through the remoteproc tree.

> diff --git a/drivers/rpmsg/rpmsg_internal.h b/drivers/rpmsg/rpmsg_internal.h
> index a76c344253bf..d5204756714c 100644
> --- a/drivers/rpmsg/rpmsg_internal.h
> +++ b/drivers/rpmsg/rpmsg_internal.h
> @@ -40,7 +40,7 @@ struct rpmsg_device_ops {
>  					    struct rpmsg_channel_info chinfo);
>  
>  	int (*announce_create)(struct rpmsg_device *ept);
> -	int (*announce_destroy)(struct rpmsg_device *ept);
> +	void (*announce_destroy)(struct rpmsg_device *ept);
>  };
>  
>  /**
> diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
> index 8e49a3bacfc7..4e05994634f8 100644
> --- a/drivers/rpmsg/virtio_rpmsg_bus.c
> +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
> @@ -340,7 +340,7 @@ static int virtio_rpmsg_announce_create(struct rpmsg_device *rpdev)
>  	return err;
>  }
>  
> -static int virtio_rpmsg_announce_destroy(struct rpmsg_device *rpdev)
> +static void virtio_rpmsg_announce_destroy(struct rpmsg_device *rpdev)
>  {
>  	struct virtio_rpmsg_channel *vch = to_virtio_rpmsg_channel(rpdev);
>  	struct virtproc_info *vrp = vch->vrp;
> @@ -360,8 +360,6 @@ static int virtio_rpmsg_announce_destroy(struct rpmsg_device *rpdev)
>  		if (err)
>  			dev_err(dev, "failed to announce service %d\n", err);
>  	}
> -
> -	return err;
>  }
>  
>  static const struct rpmsg_device_ops virtio_rpmsg_ops = {
> 
> though it's not obvious for me that the last hunk is sensible. (OTOH the
> return code is ignored anyhow as rpmsg_dev_remove() is the only caller.
> 

I need to backtrack a little bit more to figure out why we ended up with
this...

Thanks,
Bjorn
