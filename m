Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219CD7B
	for <nvdimm@lists.linux.dev>; Fri, 21 Oct 2022 11:42:42 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id r8-20020a056830120800b00661a0a236efso1655578otp.4
        for <nvdimm@lists.linux.dev>; Fri, 21 Oct 2022 04:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5PwdDXVu5A11cVv6wJuG3gZctd4QRKpsxJeBckZ3fGo=;
        b=DE2jFHwTCLaJZKNXRFpcGV7F9oYrDcTgin68ddiLvmSVj7qsqTyMUi4RIbwW5Oe+if
         7Rr4jMKrJeV2vk7KsQXL0yyAopaHkuLwC0Km67MNC4pWxDq2BhmEKwxsCS5Hhbya01fP
         wzW8WS0Nj/oIKB+NnQFEPENeAym4Atjquli+3OdFHqEUCjxZm38DlfwzQqCnCt4hNK4a
         Jis9X5xOEn2GVKQ+dNTjBD7eQhEAu/nDy+bggd6+paAMX7wGt+FrV0Nl7c0mqvRxd8HT
         rInJCusJHTq0E9lO5WWRQBQlyIXFTCn09HTBcEQbXehVbXFSmkWg+dWi9WjXpgN7YJwz
         CnyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5PwdDXVu5A11cVv6wJuG3gZctd4QRKpsxJeBckZ3fGo=;
        b=O9vCAeox41dxUtHKEWwaHGyK6JWg4Bgb1jxYTm+iE/239OMtwzwILeirXQpuovsMkU
         1BA/EezJkWWb4Dy2AU0Pb6hYNRGtt1xR1nGOkhfPnVUGO35JGLZra4BTTZna2FChDH4D
         +JZRdVdg/K7ZwznRVyLWfzeFt1kjCm5HItu+PQaNeWjFUk69z3n7035x2CjUcy0R9eQr
         h+G4rn7lBQSnR+9S8n1A+y6zCP1sTypWMbSGmd6v+QksfSQZ8muhZRzjrygHDs00kGEj
         qPVJTcw6bxPyQo9+UmDqwmXcBpLY7WGQhUCmXNAqOOBEojRYFK1zikbSbNV9Slk45BjX
         NnmQ==
X-Gm-Message-State: ACrzQf2kYvwz/HAvxn8Jdhdl6i5hXCes224cTw5o+7h7HTyfnLDrx9PR
	GyVvSwUWU1kvAfyilHcGiEosMXvn5CgeYuvuwfo=
X-Google-Smtp-Source: AMsMyM4MlL2lx2850kkZhBccJdvjF9LkaoDGMT+SR3ZXRJtr91+cINSTOEUZYpzEfNjB/7WXVfOGbX3ghN9Ri7GGsJw=
X-Received: by 2002:a05:6830:4115:b0:661:a2c4:3bcd with SMTP id
 w21-20020a056830411500b00661a2c43bcdmr10255936ott.368.1666352561091; Fri, 21
 Oct 2022 04:42:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221017171118.1588820-1-sammler@google.com>
In-Reply-To: <20221017171118.1588820-1-sammler@google.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Fri, 21 Oct 2022 13:42:28 +0200
Message-ID: <CAM9Jb+ggq5L9XZZHhfA98XDO+P=8y-mT+ct0JFAtXRbsCuORsA@mail.gmail.com>
Subject: Re: [PATCH v1] virtio_pmem: populate numa information
To: Michael Sammler <sammler@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Compute the numa information for a virtio_pmem device from the memory
> range of the device. Previously, the target_node was always 0 since
> the ndr_desc.target_node field was never explicitly set. The code for
> computing the numa node is taken from cxl_pmem_region_probe in
> drivers/cxl/pmem.c.
>
> Signed-off-by: Michael Sammler <sammler@google.com>
> ---
>  drivers/nvdimm/virtio_pmem.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index 20da455d2ef6..a92eb172f0e7 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -32,7 +32,6 @@ static int init_vq(struct virtio_pmem *vpmem)
>  static int virtio_pmem_probe(struct virtio_device *vdev)
>  {
>         struct nd_region_desc ndr_desc = {};
> -       int nid = dev_to_node(&vdev->dev);
>         struct nd_region *nd_region;
>         struct virtio_pmem *vpmem;
>         struct resource res;
> @@ -79,7 +78,15 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>         dev_set_drvdata(&vdev->dev, vpmem->nvdimm_bus);
>
>         ndr_desc.res = &res;
> -       ndr_desc.numa_node = nid;
> +
> +       ndr_desc.numa_node = memory_add_physaddr_to_nid(res.start);
> +       ndr_desc.target_node = phys_to_target_node(res.start);
> +       if (ndr_desc.target_node == NUMA_NO_NODE) {
> +               ndr_desc.target_node = ndr_desc.numa_node;
> +               dev_dbg(&vdev->dev, "changing target node from %d to %d",
> +                       NUMA_NO_NODE, ndr_desc.target_node);
> +       }

As this memory later gets hotplugged using "devm_memremap_pages". I don't
see if 'target_node' is used for fsdax case?

It seems to me "target_node" is used mainly for volatile range above
persistent memory ( e.g kmem driver?).

Thanks,
Pankaj

> +
>         ndr_desc.flush = async_pmem_flush;
>         ndr_desc.provider_data = vdev;
>         set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> --
