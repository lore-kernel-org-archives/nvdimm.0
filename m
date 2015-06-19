Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 1/3] acpi: Add acpi_map_pxm_to_online_node()
Date: Fri, 19 Jun 2015 02:42:26 +0200
Message-ID: <2008104.uoxDMul6Vd@vostro.rjw.lan>
In-Reply-To: <1433891440-3515-2-git-send-email-toshi.kani@hp.com>
References: <1433891440-3515-1-git-send-email-toshi.kani@hp.com> <1433891440-3515-2-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: dan.j.williams@intel.com, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tuesday, June 09, 2015 05:10:38 PM Toshi Kani wrote:
> The kernel initializes CPU & memory's NUMA topology from ACPI
> SRAT table.  Some other ACPI tables, such as NFIT and DMAR,
> also contain proximity IDs for their device's NUMA topology.
> This information can be used to improve performance of these
> devices.
> 
> This patch introduces acpi_map_pxm_to_online_node(), which maps
> a given pxm to an online node.  This allows ACPI device driver
> modules to obtain a node from a device proximity ID.  Unlike
> acpi_map_pxm_to_node(), this interface is guaranteed to return
> an online node so that the caller module can use the node without
> dealing with the node status.  A node may be offline when a device
> proximity ID is unique, SRAT memory entry does not exist, or
> NUMA is disabled (ex. numa_off on x86).
> 
> This patch also moves the pxm range check from acpi_get_node()
> to acpi_map_pxm_to_node().
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/acpi/numa.c  |   40 +++++++++++++++++++++++++++++++++++++---
>  include/linux/acpi.h |    5 +++++
>  2 files changed, 42 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index 1333cbdc..a64947e 100644
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
> @@ -83,6 +90,35 @@ int acpi_map_pxm_to_node(int pxm)
>  	return node;
>  }
>  
> +/*
> + * Return an online node from a pxm.  This interface is intended for ACPI
> + * device drivers that obtain device NUMA topology from ACPI table, but
> + * do not initialize the node status.
> + */

Can you make this a proper kerneldoc, please?  *Especially* that it is an
exported function.

The description is a bit terse too in my view.

> +int acpi_map_pxm_to_online_node(int pxm)
> +{
> +	int node, n, dist, min_dist;
> +
> +	node = acpi_map_pxm_to_node(pxm);
> +
> +	if (node == NUMA_NO_NODE)
> +		node = 0;
> +
> +	if (!node_online(node)) {
> +		min_dist = INT_MAX;
> +		for_each_online_node(n) {
> +			dist = node_distance(node, n);
> +			if (dist < min_dist) {
> +				min_dist = dist;
> +				node = n;
> +			}
> +		}
> +	}
> +
> +	return node;
> +}
> +EXPORT_SYMBOL(acpi_map_pxm_to_online_node);
> +
>  static void __init
>  acpi_table_print_srat_entry(struct acpi_subtable_header *header)
>  {
> @@ -328,8 +364,6 @@ int acpi_get_node(acpi_handle handle)
>  	int pxm;
>  
>  	pxm = acpi_get_pxm(handle);
> -	if (pxm < 0 || pxm >= MAX_PXM_DOMAINS)
> -		return NUMA_NO_NODE;
>  
>  	return acpi_map_pxm_to_node(pxm);
>  }
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index e4da5e3..1b3bbb1 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -289,8 +289,13 @@ extern void acpi_dmi_osi_linux(int enable, const struct dmi_system_id *d);
>  extern void acpi_osi_setup(char *str);
>  
>  #ifdef CONFIG_ACPI_NUMA
> +int acpi_map_pxm_to_online_node(int pxm);
>  int acpi_get_node(acpi_handle handle);
>  #else
> +static inline int acpi_map_pxm_to_online_node(int pxm)
> +{
> +	return 0;
> +}
>  static inline int acpi_get_node(acpi_handle handle)
>  {
>  	return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
