Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D5BC226C7C4F
 for <linux-nvdimm@lists.01.org>; Tue,  3 Apr 2018 10:34:49 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id h55-v6so18775972ote.9
 for <linux-nvdimm@lists.01.org>; Tue, 03 Apr 2018 10:34:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180403142415.30083-2-oohall@gmail.com>
References: <20180403142415.30083-1-oohall@gmail.com>
 <20180403142415.30083-2-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 3 Apr 2018 10:34:48 -0700
Message-ID: <CAPcyv4i4w0qXwM338MeKaUWJmHdg6OqAotc+=Xsa7zhHGT7Thg@mail.gmail.com>
Subject: Re: [RESEND v2 2/4] libnvdimm: Add device-tree based driver
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 3, 2018 at 7:24 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
> This patch adds peliminary device-tree bindings for persistent memory
> regions. The driver registers a libnvdimm bus for each pmem-region
> node and each address range under the node is converted to a region
> within that bus.
>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
> v2: Made each bus have a separate node rather having a shared bus.
>     Renamed to of_pmem rather than of_nvdimm.
>     Changed log level of happy-path messages to debug.
> ---
[..]
> +static struct platform_driver of_nd_region_driver = {
> +       .probe = of_nd_region_probe,
> +       .remove = of_nd_region_remove,
> +       .driver = {
> +               .name = "of_pmem",
> +               .owner = THIS_MODULE,
> +               .of_match_table = of_nd_region_match,
> +       },
> +};

This and the other patches look good to me. Just a nit on the
naming... since you name the regions pmem-regions in the device-tree
description shouldn't this be the "of_pmem_region" or "of_pmem_range"
driver? Otherwise, it is confusing to me that anything named
*nd_region would be creating an nvdimm_bus. In general An nd_region is
always a child of a bus.

That said, with an ack/reviewed-by on the device-tree bindings I can
take these through the nvdimm tree. I'll reply to patch 4 with that
request for ack.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
