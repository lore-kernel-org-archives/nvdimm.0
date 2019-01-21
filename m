Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 943FD211B737C
 for <linux-nvdimm@lists.01.org>; Sun, 20 Jan 2019 19:28:18 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id v23so19359951otk.9
 for <linux-nvdimm@lists.01.org>; Sun, 20 Jan 2019 19:28:18 -0800 (PST)
MIME-Version: 1.0
References: <20190118033544.3980-1-richardw.yang@linux.intel.com>
 <CAPcyv4jOA-S=Z-0mCUW7d4+6gwHNEe1egaFrbyNq5UJL7Uz=Ow@mail.gmail.com>
 <20190118050333.GA4233@richard>
 <CAPcyv4j6Ud_cMkJneN13tv4_WjdAWM41RUhAOJsPPupZ-5KNmg@mail.gmail.com>
 <20190118073117.GA4628@richard>
 <CAPcyv4h+yJjBMfetF3ecxSHySgWjSWBH+Li9JWBZZSruqFBnLg@mail.gmail.com>
 <CAPcyv4ji+=145SNWWc+9Po8XuzuXjSJQhEU2SwgpMR8stiA_kA@mail.gmail.com>
 <20190121005046.GB4544@richard>
In-Reply-To: <20190121005046.GB4544@richard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 20 Jan 2019 19:28:05 -0800
Message-ID: <CAPcyv4jH=rVpf3gyhrqosz7AsSzdzGGFCLQJiSWWtRD5+m4OGw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm,
 pfn: not allocate nd_pfn->pfn_sb if already allocated
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jan 20, 2019 at 4:51 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
[..]
> >I also don't see that this fix is needed. nd_dax_probe()
> >devm-allocates pfn_sb and performs a validation. If the validation
> >succeeds nd_dax_probe() returns 0 which creates a new device and then
> >causes nd_pmem_probe() to fail. At that point devm frees the pfn_sb
>
> If I am correct, nd_dax_probe() creates a device whose driver is
> dax_pmem_driver. So the probe function is dax_pmem_probe.
>
> Based on my test, one more pfn_sb is allocated in dax_pmem_probe and the
> driver attached to the device successfully.
>
> >allocation. The allocation is also freed if the validation step
> >failed.
>
> nd_pmem_probe() will be called on device created by nd_btt_probe() and
> nd_pfn_probe(), if I am right.
>
> So in which case these two driver will fail to to attach the device and
> release the memory?

See nd_pmem_probe():

        /* if we find a valid info-block we'll come back as that personality */
        if (nd_btt_probe(dev, ndns) == 0 || nd_pfn_probe(dev, ndns) == 0
                        || nd_dax_probe(dev, ndns) == 0)
                return -ENXIO;

...all devm allocations are released due to that "return -ENXIO".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
