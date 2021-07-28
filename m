Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB8F3481
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 07:30:42 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id i1so1601930plr.9
        for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 00:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NqBINzippdeAi2AUoM8Hkgi2WKFqvanJBMGmS1p+Xcs=;
        b=m8+KioYWU5HcHAf03pb9llrLo1TzP76HPELHuGb/Etbo8asLxCQSh9F/oGXlIiB6GM
         uVA47IXLQRBJzElI3CMtSS1swD/F+dIDTZ8/is84Qigm0BbQ4liDCW3YVcKcsVgr7zjn
         iX0HWTmyCyWrhOCD1vL3tGmfwhK7AkTk2hV4qb2uLNNECKf6bVqEE57aiZ/7xxRIhf0G
         BBQz3JKlXxxq1w4iR4D5R0LsuqZNQbMyo+T8Uk4IA/9f45q0PeMX2NRuQVmP2StJ7n3z
         q3TOMEMGnt8skKjG6IFHe8HSqt7oe+TD5+xshm5BYIe45oIl+ZYRLPbjqX4mkQTyGSWW
         y2Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NqBINzippdeAi2AUoM8Hkgi2WKFqvanJBMGmS1p+Xcs=;
        b=S4vhh26+TCPp2a6lXVHgAQprLqDWdq/lbcZ++6GuKgUwAvgIlUJxFFwAj9YyD7ckHw
         Qo+xMZkJkk9nCXvsvm4nAASzBIKWNOYq3AQkQ3Ar7+xCn+HiKogz1M+t1+32fCmC1K2v
         S2K0X9XbDTlEGc5wpyfZ9PP04E7WsS492Budukyu7CIwBA9w03LqAPVeiWISE1csvgbB
         e3bIZDjKJmAl1EI0LRCIk3e7lmncWa+7IEhnvhem0YTHArRKsvnZ9nwvZ1y6bB6Wdn5r
         DTHw4kuxlaK/Gyurtba7S3bPTlp43AE4xnootEzZIdr55h16diSxa3HLHyQQc7arrYP+
         I4Gg==
X-Gm-Message-State: AOAM531BwfR+Nzc1iR+fk61adVdQVWy8AD9elptySrX7EBA32HtXvsgS
	K5iiMFhFCdP5fbFXAgw1Cs/k3D7XvUAvaRgNPyGnAw==
X-Google-Smtp-Source: ABdhPJxyIIHHl86lkJ8BKYd8Sr40+PFPjq08zj2oGDSc7bXZBce3xcsJXqCNSwrIRSxqXD0wTgM3ITFht3olLzROjE4=
X-Received: by 2002:a65:5544:: with SMTP id t4mr27532425pgr.240.1627457441692;
 Wed, 28 Jul 2021 00:30:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-12-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-12-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jul 2021 00:30:30 -0700
Message-ID: <CAPcyv4hv+LXmAs-BMATuyoPLRAF_-+d5Yap450sbCDFTcvGO4w@mail.gmail.com>
Subject: Re: [PATCH v3 11/14] device-dax: ensure dev_dax->pgmap is valid for
 dynamic devices
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> Right now, only static dax regions have a valid @pgmap pointer in its
> struct dev_dax. Dynamic dax case however, do not.
>
> In preparation for device-dax compound pagemap support, make sure that
> dev_dax pgmap field is set after it has been allocated and initialized.

I think this is ok to fold into the patch that needs it.

>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/dax/device.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 0b82159b3564..6e348b5f9d45 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -426,6 +426,8 @@ int dev_dax_probe(struct dev_dax *dev_dax)
>         }
>
>         pgmap->type = MEMORY_DEVICE_GENERIC;
> +       dev_dax->pgmap = pgmap;
> +
>         addr = devm_memremap_pages(dev, pgmap);
>         if (IS_ERR(addr))
>                 return PTR_ERR(addr);
> --
> 2.17.1
>
