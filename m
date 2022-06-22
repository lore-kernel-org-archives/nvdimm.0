Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEE510F1
	for <nvdimm@lists.linux.dev>; Wed, 22 Jun 2022 03:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655868950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CrTIjE+uV34exQi0VtWd4pJ/23Ao0C65uM5Q/CaQAdg=;
	b=aKt2TIVbh0ejFpPYBpLOuBD5Kk4GNRyqYJZ/dZnnABgACpZVVIcPejcH6F36tsFg9mLaps
	BoHII6+ZrjgatYjI6IGJHoO1C71kjfJpmOriScURheLtV4b2M+97C7Rf5IRf5QrvpsHbCJ
	q9aV/Ouh8wRkWdi5dtTCUIEjFipWWW0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-8s1n1r7mPzmp7_0O4Juyqw-1; Tue, 21 Jun 2022 23:35:49 -0400
X-MC-Unique: 8s1n1r7mPzmp7_0O4Juyqw-1
Received: by mail-lf1-f69.google.com with SMTP id u7-20020a05651206c700b00479723664a9so7884208lff.6
        for <nvdimm@lists.linux.dev>; Tue, 21 Jun 2022 20:35:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CrTIjE+uV34exQi0VtWd4pJ/23Ao0C65uM5Q/CaQAdg=;
        b=RMSo0E6WPc9S+CLRJu+Sy2luYnzgET8vw39zq4lvrAoM+TNjXm/xPUrjBQBWzy8Adp
         0lmPvM5B7An6aWgG+KxjECCD+r57t6OBx8hlPqbPJ/eDVoLWOo+zXsyMTTEg182IEoB+
         vyjDjuCfC0sUJFlNMbOFnvsPlz4EDG56kuw/GhmqlHK3kW7jWRU9MbSOGO0l5eFiyB9o
         FH4U6gX9GQzG3IBDOl9gR3EYnDJtBG0lniBDFadzu55Dnj1P+kRq5jDn8LiIfHWa4c31
         WGYNCYraM/5qg971y2TgKzDut/JCHrbZrnjrdB5Yn6QZ/bghuTtJ1Qa0xUKUX5L28KGa
         b5wQ==
X-Gm-Message-State: AJIora+Q+2Jc+ObbJzOx/QKdWPmmfmOiyvwM7zE21fAK2N6SllDlgxoi
	r8gvWxPQK3w5DqJ3zUKDRqpw1RQ3up66aGhhOnznCVgY72AFo2fVb5EWOejlBjZhUGEK/aQGM7p
	OYj47A1c28Br9Wid7+c1TdKXnGRdmL+Hk
X-Received: by 2002:a2e:b014:0:b0:25a:6d17:c3c8 with SMTP id y20-20020a2eb014000000b0025a6d17c3c8mr674740ljk.487.1655868947360;
        Tue, 21 Jun 2022 20:35:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s2GghcNIGPyJpWNUgc4oz0HMS10q91kFxg0lud2yBoMmYMipD9DZaN0ZLXNkjzyTMugFyfqCM0XXtsnzrhiR8=
X-Received: by 2002:a2e:b014:0:b0:25a:6d17:c3c8 with SMTP id
 y20-20020a2eb014000000b0025a6d17c3c8mr674733ljk.487.1655868947196; Tue, 21
 Jun 2022 20:35:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220620081519.1494-1-jasowang@redhat.com> <CAM9Jb+gKU3b0XSiXj-ePtynH49HNp+SZjEnRzhjHjhw=+uBB9Q@mail.gmail.com>
In-Reply-To: <CAM9Jb+gKU3b0XSiXj-ePtynH49HNp+SZjEnRzhjHjhw=+uBB9Q@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 22 Jun 2022 11:35:36 +0800
Message-ID: <CACGkMEv0cpzh5fA5juf5GcWNeW65EFE055vN=zXYvbsehV96jQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio_pmem: initialize provider_data through nd_region_desc
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Michael S . Tsirkin" <mst@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jasowang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 21, 2022 at 8:44 PM Pankaj Gupta
<pankaj.gupta.linux@gmail.com> wrote:
>
> > We used to initialize the provider_data manually after
> > nvdimm_pemm_region_create(). This seems to be racy if the flush is
> > issued before the initialization of provider_data. Fixing this by
> > initialize the provider_data through nd_region_desc to make sure the
> > provider_data is ready after the pmem is created.
> >
> > Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/nvdimm/virtio_pmem.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > index 995b6cdc67ed..48f8327d0431 100644
> > --- a/drivers/nvdimm/virtio_pmem.c
> > +++ b/drivers/nvdimm/virtio_pmem.c
> > @@ -81,6 +81,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> >         ndr_desc.res = &res;
> >         ndr_desc.numa_node = nid;
> >         ndr_desc.flush = async_pmem_flush;
> > +       ndr_desc.provider_data = vdev;
> >         set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> >         set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> >         nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
> > @@ -89,7 +90,6 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> >                 err = -ENXIO;
> >                 goto out_nd;
> >         }
> > -       nd_region->provider_data = dev_to_virtio(nd_region->dev.parent->parent);
> >         return 0;
> >  out_nd:
> >         nvdimm_bus_unregister(vpmem->nvdimm_bus);
>
> Thank you for adding me.
>
> The patch seems correct to me. Will test this as well.
>
> Acked-by: Pankaj Gupta <pankaj.gupta@amd.com>

Thanks a lot.

I've done a round of tests and everything works well.

>
>
>
> Thanks,
> Pankaj
>

