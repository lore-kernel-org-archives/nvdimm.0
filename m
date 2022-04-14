Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC3C3219
	for <nvdimm@lists.linux.dev>; Thu, 14 Apr 2022 19:43:42 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id i24-20020a17090adc1800b001cd5529465aso5456389pjv.0
        for <nvdimm@lists.linux.dev>; Thu, 14 Apr 2022 12:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YMPolPkFbrluEA7trFzW5vfGL6xOTpY2rpO+rRWfteE=;
        b=aD5O4GRMocgwH2YInqmL40T6Jk55qVWck1TJ1OI0qsVNqYmQVCJP5pBGIVgXGHnCL0
         uZQmAvLy9RVTRE03fIPEewK7KYTFGSm9sEI/+ZaP12yw3Z6e+R6bW4QMjGx6acd1Sb0x
         JWcmgYjHK+52nNHv1qDiHroGDkhFjZ6xRDdsyuhOBydIiMA8z7skSoharKjcq2oNZYcX
         3GazU6w/ihmzJGraYZdRUKcwVu79CgyJzIn/WRXzZI0AHElODTZfy6xAuvYh/aADAMYZ
         l9dqEHA2XSts/NFEDe17rqVXcfqTAg4bNhKU/xR2APWVP8XqY1JwG7dqEQ3xsDfspAli
         rAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YMPolPkFbrluEA7trFzW5vfGL6xOTpY2rpO+rRWfteE=;
        b=6yqb3oIh/XSEauyNNP/AwZZfxByXZUx5h1VthfG8AzGhT4jRM8e3MlM7tg6PCvzyNU
         gk6b/r0qf5L3WYTGg5LzPTpixtan6/DSxhOQKOr3dNNLN6KPpJEGwZg90uqf/573UKV9
         lGeQ4uJ0RVExkDjhVUiY2Moezfg7MZINzI2+lVl1WK+TAIV6QSuN80bM7I5J4dL6BwWg
         +lJkALiGttFi3KW0M5btyhrr7PrFzo23dzY3Qzz9FpJ1JnUS4J5eJpGjE6I360xEIs9H
         CIbucsysfRHlAciwxtZsijH8roS2Apr0ooNbO/P6YMQc9aRR/HwESzxNsedqBnxFf7Ad
         JzyQ==
X-Gm-Message-State: AOAM533piW2299wYwcyTfBobGah/EnnGRnDVJBqtN4Kz54/XYSVy/5El
	Utafzi/GyZbmYx8Qurgp043l4fNTcgmhpJT+syk/Hg==
X-Google-Smtp-Source: ABdhPJxLJx2dhijhY2GgYR6k+AAoWzSxf1ZMV2jWzsPbKL3wihos+1a3+smba0fpXn3HJ0WjmduhiN4tJaiMRMxnaEA=
X-Received: by 2002:a17:902:dac7:b0:158:b284:cdc3 with SMTP id
 q7-20020a170902dac700b00158b284cdc3mr6149439plx.34.1649965422400; Thu, 14 Apr
 2022 12:43:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164982969858.684294.17819743973041389492.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220413084309.GV2731@worktop.programming.kicks-ass.net> <CAPcyv4huZVNkxa7-rQ_J=nVN77+5F1AJg5vi6kLHp8t5khcwHA@mail.gmail.com>
 <Ylf0dewci8myLvoW@hirez.programming.kicks-ass.net> <CAPcyv4hFabn6H064HTrH8=GQ-cxsOk4xEK8s66JQxQavfgAzGw@mail.gmail.com>
 <Ylh3ISDToV5y9/4P@hirez.programming.kicks-ass.net>
In-Reply-To: <Ylh3ISDToV5y9/4P@hirez.programming.kicks-ass.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Apr 2022 12:43:31 -0700
Message-ID: <CAPcyv4hwsKCbaxDhAL6LPZQmLZZV2T4wpja+cNZpjy=enR-eYQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] device-core: Add dev->lock_class to enable
 device_lock() lockdep validation
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-cxl@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Kevin Tian <kevin.tian@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 14, 2022 at 12:34 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Apr 14, 2022 at 10:17:13AM -0700, Dan Williams wrote:
>
> > One more sanity check... So in driver subsystems there are cases where
> > a device on busA hosts a topology on busB. When that happens there's a
> > need to set the lock class late in a driver since busA knows nothing
> > about the locking rules of busB.
>
> I'll pretend I konw what you're talking about ;-)
>
> > Since the device has a longer lifetime than a driver when the driver
> > exits it must set dev->mutex back to the novalidate class, otherwise
> > it sets up a use after free of the static lock_class_key.
>
> I'm not following, static storage has infinite lifetime.

Not static storage in a driver module.

modprobe -r fancy_lockdep_using_driver.ko

Any use of device_lock() by the core on a device that a driver in this
module was driving will de-reference a now invalid pointer into
whatever memory was vmalloc'd for the module static data.

>
> > I came up with this and it seems to work, just want to make sure I'm
> > properly using the lock_set_class() API and it is ok to transition
> > back and forth from the novalidate case:
> >
> > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > index 990b6670222e..32673e1a736d 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> > @@ -405,6 +405,29 @@ struct cxl_nvdimm_bridge
> > *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd);
> >  #define __mock static
> >  #endif
> >
> > +#ifdef CONFIG_PROVE_LOCKING
> > +static inline void cxl_lock_reset_class(void *_dev)
> > +{
> > +       struct device *dev = _dev;
> > +
> > +       lock_set_class(&dev->mutex.dep_map, "__lockdep_no_validate__",
> > +                      &__lockdep_no_validate__, 0, _THIS_IP_);
> > +}
> > +
> > +static inline int cxl_lock_set_class(struct device *dev, const char *name,
> > +                                    struct lock_class_key *key)
> > +{
> > +       lock_set_class(&dev->mutex.dep_map, name, key, 0, _THIS_IP_);
> > +       return devm_add_action_or_reset(dev, cxl_lock_reset_class, dev);
> > +}
> > +#else
> > +static inline int cxl_lock_set_class(struct device *dev, const char *name,
> > +                                    struct lock_class_key *key)
> > +{
> > +       return 0;
> > +}
> > +#endif
>
> Under the assumption that the lock is held (lock_set_class() will
> actually barf if @lock isn't held) this should indeed work as expected

Nice.

> (although I think you got the @name part 'wrong', I think that's
> canonically something like "&dev->mutex" or something).

Ah, yes, I got it wrong for restoring the same name that results from
lockdep_set_novalidate_class(), will fix.
