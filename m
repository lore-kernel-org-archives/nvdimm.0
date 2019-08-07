Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 46F3B212FD404
 for <linux-nvdimm@lists.01.org>; Tue,  6 Aug 2019 21:15:48 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id j11so41687154otp.10
 for <linux-nvdimm@lists.01.org>; Tue, 06 Aug 2019 21:13:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190807040029.11344-1-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20190807040029.11344-1-aneesh.kumar@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Aug 2019 21:13:06 -0700
Message-ID: <CAPcyv4haXOjn7K-HgPV_WLqbfqRQbbiq=LvLt5Ue=OPAaBWN6A@mail.gmail.com>
Subject: Re: [PATCH] nvdimm/of_pmem: Provide a unique name for bus provider
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 6, 2019 at 9:00 PM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> ndctl utility requires the ndbus to have unique names. If not while
> enumerating the bus in userspace it drops bus with similar names.
> This results in us not listing devices beneath the bus.

It does?

>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  drivers/nvdimm/of_pmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
> index a0c8dcfa0bf9..97187d6c0bdb 100644
> --- a/drivers/nvdimm/of_pmem.c
> +++ b/drivers/nvdimm/of_pmem.c
> @@ -42,7 +42,7 @@ static int of_pmem_region_probe(struct platform_device *pdev)
>                 return -ENOMEM;
>
>         priv->bus_desc.attr_groups = bus_attr_groups;
> -       priv->bus_desc.provider_name = "of_pmem";
> +       priv->bus_desc.provider_name = kstrdup(pdev->name, GFP_KERNEL);

This looks ok to me to address support for older ndctl binaries, but
I'd like to also fix the ndctl bug that makes non-unique provider
names fail.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
