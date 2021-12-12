Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F60A68
	for <nvdimm@lists.linux.dev>; Sun, 12 Dec 2021 14:23:52 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id gt5so10124351pjb.1
        for <nvdimm@lists.linux.dev>; Sun, 12 Dec 2021 06:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8lwwZWzMg5a3s7lwMASlg5tu9b+fzGmp/D7TMwKxKFc=;
        b=C1VDazYvOsHerGRum3UpDemvC3bLBABNz77cgqTNDNW/AlDRjmxr+knCqOb3lbM8WO
         nCuRMxTi17hjy2mfZFS6DLg1CC+TyYg8zaU2aBeKKFky3Rcsp4/9vOZKTntOjByb+hJ5
         0z6NFJU2SLN62ZWqorLtNFaHccHYM1JZ7Mu2yHUUiPrzmD1llDNRqRtKoHw0vprZZn1C
         nm6MqHIyalByp/KuSOcHH4nPAdw2l3b13tMdWhLdbsNZfg7ms1Wl3ArmPz5baUq43ARi
         V4c990kOWIh9SL0yrCBDZ7oIc/+hdYouELCNB6m6IMhS2kuwbJLs9VZytg0tPw2o9EEM
         7w2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8lwwZWzMg5a3s7lwMASlg5tu9b+fzGmp/D7TMwKxKFc=;
        b=RkMzuPryodv01MkiW1fslu25cPpsRZAN71kdl3dnmMMRbAkFlgzad/Z1pChEIer8GG
         JNirajOni9oHVWkKEY7w3DRW0bDnpmSWjJncWi4jCtXQifS7VTugtQvFB0YOFK+zCS3j
         c6jvw+32ZiZgvDu2+074/V2FWXw+F7w63AAAfJR8unZryun+ElJVilmiosHEw45M+uQI
         iLIWuyhbOE1LJISnDFpAG+L2dE81QpQpckhgONTxr5AHraTUpaZxfUxzFRy//qGc52hL
         jEY5aWn1OfMteINCPAzYrVl8/uHPxnECTp70oDtW7ebfzY9m4neuI63gM1Ig9cxoTETO
         ED0w==
X-Gm-Message-State: AOAM531dC7JqFvW5sem9P5H0imBtMTIdqsBk2tdUvHRT8PuABE1H/ysQ
	vKgetlx0nXF+4CvH9Q01T/vw+gJM2WbtTFk2cl9yXg==
X-Google-Smtp-Source: ABdhPJwD+M0MBopqkFuJGa9sgfSVBzZnNozNDZqwXOq1RFaO0zbunOMva9BpA++y2ooxKRxQrM2G01fpVQgDA3WnFR8=
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr38028565pjb.220.1639319032132;
 Sun, 12 Dec 2021 06:23:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de> <20211209063828.18944-3-hch@lst.de>
In-Reply-To: <20211209063828.18944-3-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Dec 2021 06:23:41 -0800
Message-ID: <CAPcyv4gZvE69C8wCukFGgFLqzD49U8Wn8X4F9N6RmMFebgyqzg@mail.gmail.com>
Subject: Re: [PATCH 2/5] dax: simplify dax_synchronous and set_dax_synchronous
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Matthew Wilcox <willy@infradead.org>, device-mapper development <dm-devel@redhat.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 8, 2021 at 10:38 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Remove the pointless wrappers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, not sure why those ever existed.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> ---
>  drivers/dax/super.c |  8 ++++----
>  include/linux/dax.h | 12 ++----------
>  2 files changed, 6 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index e7152a6c4cc40..e18155f43a635 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -208,17 +208,17 @@ bool dax_write_cache_enabled(struct dax_device *dax_dev)
>  }
>  EXPORT_SYMBOL_GPL(dax_write_cache_enabled);
>
> -bool __dax_synchronous(struct dax_device *dax_dev)
> +bool dax_synchronous(struct dax_device *dax_dev)
>  {
>         return test_bit(DAXDEV_SYNC, &dax_dev->flags);
>  }
> -EXPORT_SYMBOL_GPL(__dax_synchronous);
> +EXPORT_SYMBOL_GPL(dax_synchronous);
>
> -void __set_dax_synchronous(struct dax_device *dax_dev)
> +void set_dax_synchronous(struct dax_device *dax_dev)
>  {
>         set_bit(DAXDEV_SYNC, &dax_dev->flags);
>  }
> -EXPORT_SYMBOL_GPL(__set_dax_synchronous);
> +EXPORT_SYMBOL_GPL(set_dax_synchronous);
>
>  bool dax_alive(struct dax_device *dax_dev)
>  {
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 87ae4c9b1d65b..3bd1fdb5d5f4b 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -48,16 +48,8 @@ void put_dax(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
>  bool dax_write_cache_enabled(struct dax_device *dax_dev);
> -bool __dax_synchronous(struct dax_device *dax_dev);
> -static inline bool dax_synchronous(struct dax_device *dax_dev)
> -{
> -       return  __dax_synchronous(dax_dev);
> -}
> -void __set_dax_synchronous(struct dax_device *dax_dev);
> -static inline void set_dax_synchronous(struct dax_device *dax_dev)
> -{
> -       __set_dax_synchronous(dax_dev);
> -}
> +bool dax_synchronous(struct dax_device *dax_dev);
> +void set_dax_synchronous(struct dax_device *dax_dev);
>  /*
>   * Check if given mapping is supported by the file / underlying device.
>   */
> --
> 2.30.2
>
