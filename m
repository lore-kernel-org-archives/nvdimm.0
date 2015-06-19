Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v3 1/3] acpi: Add acpi_map_pxm_to_online_node()
Date: Sat, 20 Jun 2015 01:26:48 +0200
Message-ID: <1533407.DRfAxUaIRz@vostro.rjw.lan>
In-Reply-To: <1434737914-18466-2-git-send-email-toshi.kani@hp.com>
References: <1434737914-18466-1-git-send-email-toshi.kani@hp.com> <1434737914-18466-2-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: dan.j.williams@intel.com, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Friday, June 19, 2015 12:18:32 PM Toshi Kani wrote:
> The kernel initializes CPU & memory's NUMA topology from ACPI
> SRAT table.  Some other ACPI tables, such as NFIT and DMAR, also
> contain proximity IDs for their device's NUMA topology.  This
> information can be used to improve performance of these devices.
> 
> This patch introduces acpi_map_pxm_to_online_node(), which is
> similar to acpi_map_pxm_to_node(), but always returns an on-line
> node.  When the mapped node from a given proximity ID is off-line,
> it looks up the node distance table and returns the nearest
> on-line node.
> 
> ACPI device drivers, which are called after the NUMA initialization
> has completed in the kernel, can call this interface to obtain their
> device NUMA topology from ACPI tables.  Such drivers do not have to
> deal with off-line nodes.  A node may be off-line when a device
> proximity ID is unique, SRAT memory entry does not exist, or NUMA is
> disabled, ex. "numa=off" on x86.
> 
> This patch also moves the pxm range check from acpi_get_node() to
> acpi_map_pxm_to_node().
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/acpi/numa.c  |   50 +++++++++++++++++++++++++++++++++++++++++++++++---
>  include/linux/acpi.h |    5 +++++
>  2 files changed, 52 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index 1333cbdc..0b6e3a0 100644
> --- a/drivers/acpi/numa.c
> +++ b/drivers/acpi/numa.c
> @@ -29,6 +29,8 @@
>  #include <linux/errno.h>
>  #include <linux/acpi.h>
>  #include <linux/numa.h>
> +#include <linux/nodemask.h>
> +#include <linux/topology.h>
>  
>  #define PREFIX "ACPI: "
>  
> @@ -70,7 +72,12 @@ static void __acpi_map_pxm_to_node(int pxm, int node)
>  
>  int acpi_map_pxm_to_node(int pxm)
>  {
> -	int node = pxm_to_node_map[pxm];
> +	int node;
> +
> +	if (pxm < 0 || pxm >= MAX_PXM_DOMAINS)
> +		return NUMA_NO_NODE;
> +
> +	node = pxm_to_node_map[pxm];
>  
>  	if (node == NUMA_NO_NODE) {
>  		if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
> @@ -83,6 +90,45 @@ int acpi_map_pxm_to_node(int pxm)
>  	return node;
>  }
>  
> +/**
> + * acpi_map_pxm_to_online_node - Map proximity ID to on-line node
> + * @pxm: ACPI proximity ID
> + *
> + * This is similar to acpi_map_pxm_to_node(), but always returns an on-line
> + * node.  When the mapped node from a given proximity ID is off-line, it
> + * looks up the node distance table and returns the nearest on-line node.
> + *
> + * ACPI device drivers, which are called after the NUMA initialization has
> + * completed in the kernel, can call this interface to obtain their device
> + * NUMA topology from ACPI tables.  Such drivers do not have to deal with
> + * off-line nodes.  A node may be off-line when a device proximity ID is
> + * unique, SRAT memory entry does not exist, or NUMA is disabled, ex.
> + * "numa=off" on x86.

The dash in "off-line" and "on-line" is not needed, we spell those things as
"offline" and "online" as a rule.

It looks good to me apart from this small detail.

Thanks,
Rafael

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
