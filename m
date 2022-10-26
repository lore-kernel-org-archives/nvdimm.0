Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51AF259C
	for <nvdimm@lists.linux.dev>; Wed, 26 Oct 2022 21:29:24 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id x2so16538269edd.2
        for <nvdimm@lists.linux.dev>; Wed, 26 Oct 2022 14:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Idd0Hb78ztmsONfbOU5aIzBiJwVe7VkMWxVXkQJGGR0=;
        b=DinbMQBIydVstQWlIMsTMkASzRhi6Bgsazw851vqWYHRId1tuK0lsLzNSArjgEqwvY
         CfJwqxIK6JyqkH6Tcus2Gils+S+vzbqCkdOaeM6bJERtjQNsAuWQImrR8L4VpBYuMGoE
         CIgSmKIqLEhmop7RoF+9wNri5oDiQAl5VFZkkOU9zrJnvz3UiXXaOWaVOu6FycxEcFPk
         ePm0XIT6cCOufWh5GTYrZkjSuRf34KFfVAswUwrtsj/V/4ZIa6R7ES72DEcwE300g0Ox
         VGR6WVxQuexAlcYhyr8Wa2DiK31AJ2S22HIcIV1D/dTE8ufsd2qQ0PLJDtjneK5tD1dy
         MIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Idd0Hb78ztmsONfbOU5aIzBiJwVe7VkMWxVXkQJGGR0=;
        b=ZMqF9tAKTHAZuCWRUKUd/BaBKOhbiYhFvmNPWLW/5fEkVIPnqkKpmcDIxJ5JQQC4uh
         MfeotcPSmYrab1sITPwVqo8eLgcZS159+QcYBofMmLKPeVJYluwTxW6dHxCPxqDs5G1l
         PlQhz9I40yXZjtV0SA30WtH/DfPaoj3Q6egUUJTIgdD/XYBH4U6LxQom0qSMizBuoNXt
         3BKWoTJBP52zmEuZkbl8d0r2dAC2KyEll9f7itkHKf6GmmiT+kgsl06wJr6MiDelUIQF
         CeFleootpAnDJ0FR9SmcsAa9aMZ0meHUlVOpw33YiSiTw83nkfdn5gRIGj/xpMwal0eR
         IUtQ==
X-Gm-Message-State: ACrzQf1KykdHt2GlIst96j2ge8Z5LpgWsQAKSgr4nqA5AmDy3Q3La1j2
	DspQ7r5Hzg6FvbQTUUJtolZY3hfq9z4FjW43cg/4gg==
X-Google-Smtp-Source: AMsMyM6kRwjV9/szTrjs7h3XAUyi7r15t/ukN7NiqEbr92FgP1GxYSk5dYdN8UduhH7sy0nqw6V6GUgs1GIW3wehPw4=
X-Received: by 2002:a05:6402:26ca:b0:462:7f27:a0dd with SMTP id
 x10-20020a05640226ca00b004627f27a0ddmr2075991edd.132.1666819762711; Wed, 26
 Oct 2022 14:29:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221017171118.1588820-1-sammler@google.com>
In-Reply-To: <20221017171118.1588820-1-sammler@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 26 Oct 2022 17:28:45 -0400
Message-ID: <CA+CK2bCNYe6V9TJDKD5s5cseQ8vzBP9BTykpQfRUtwcaecBkFQ@mail.gmail.com>
Subject: Re: [PATCH v1] virtio_pmem: populate numa information
To: Michael Sammler <sammler@google.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 17, 2022 at 1:11 PM Michael Sammler <sammler@google.com> wrote:
>
> Compute the numa information for a virtio_pmem device from the memory
> range of the device. Previously, the target_node was always 0 since
> the ndr_desc.target_node field was never explicitly set. The code for
> computing the numa node is taken from cxl_pmem_region_probe in
> drivers/cxl/pmem.c.
>
> Signed-off-by: Michael Sammler <sammler@google.com>

Enables the hot-plugging of virtio-pmem memory into correct memory
nodes. Does not look like it effect the FS_DAX.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Thanks,
Pasha

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
> +
>         ndr_desc.flush = async_pmem_flush;
>         ndr_desc.provider_data = vdev;
>         set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> --
> 2.38.0.413.g74048e4d9e-goog
