Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6CC5922468020
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 18:10:15 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id l5-v6so12162637otf.9
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 18:16:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152116964416.8343.514895686858363582.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152116964416.8343.514895686858363582.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Mar 2018 18:16:39 -0700
Message-ID: <CAPcyv4iLs7rdTxA19Syp4stQSfKbDYP912dD01_e_1QMnf3FkQ@mail.gmail.com>
Subject: Re: [PATCH] acpi, numa: fix pxm to online numa node associations
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
To: linux-nvdimm <linux-nvdimm@lists.01.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

[ adding Toshi's correct address ]

On Thu, Mar 15, 2018 at 8:08 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Commit 99759869faf1 "acpi: Add acpi_map_pxm_to_online_node()" added
> support for mapping a given proximity to its nearest, by SLIT distance,
> online node. However, it sometimes returns unexpected results due to the
> fact that it switches from comparing the PXM node to the last node that
> was closer than the current max.
>
>     for_each_online_node(n) {
>             dist = node_distance(node, n);
>             if (dist < min_dist) {
>                     min_dist = dist;
>                     node = n;   <---- from this point we're using the
>                                       wrong node for node_distance()
>
>
> Fixes: 99759869faf1 ("acpi: Add acpi_map_pxm_to_online_node()")
> Cc: <stable@vger.kernel.org>
> Cc: Toshi Kani <toshi.kani@hp.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Rafael, I can take this through the nvdimm tree with your ack. I have a
> few other nvdimm fixes pending for 4.16.
>
>  drivers/acpi/numa.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index 8ccaae3550d2..85167603b9c9 100644
> --- a/drivers/acpi/numa.c
> +++ b/drivers/acpi/numa.c
> @@ -103,25 +103,27 @@ int acpi_map_pxm_to_node(int pxm)
>   */
>  int acpi_map_pxm_to_online_node(int pxm)
>  {
> -       int node, n, dist, min_dist;
> +       int node, min_node;
>
>         node = acpi_map_pxm_to_node(pxm);
>
>         if (node == NUMA_NO_NODE)
>                 node = 0;
>
> +       min_node = node;
>         if (!node_online(node)) {
> -               min_dist = INT_MAX;
> +               int min_dist = INT_MAX, dist, n;
> +
>                 for_each_online_node(n) {
>                         dist = node_distance(node, n);
>                         if (dist < min_dist) {
>                                 min_dist = dist;
> -                               node = n;
> +                               min_node = n;
>                         }
>                 }
>         }
>
> -       return node;
> +       return min_node;
>  }
>  EXPORT_SYMBOL(acpi_map_pxm_to_online_node);
>
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
