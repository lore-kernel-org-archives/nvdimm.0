Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v3-UPDATE 1/3] acpi: Add acpi_map_pxm_to_online_node()
Date: Mon, 22 Jun 2015 16:03:17 +0200
Message-ID: <1755114.P62PKe0Htk@vostro.rjw.lan>
In-Reply-To: <1434755655-17272-1-git-send-email-toshi.kani@hp.com>
References: <1434755655-17272-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: dan.j.williams@intel.com, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Friday, June 19, 2015 05:14:15 PM Toshi Kani wrote:
> The kernel initializes CPU & memory's NUMA topology from ACPI
> SRAT table.  Some other ACPI tables, such as NFIT and DMAR, also
> contain proximity IDs for their device's NUMA topology.  This
> information can be used to improve performance of these devices.
> 
> This patch introduces acpi_map_pxm_to_online_node(), which is
> similar to acpi_map_pxm_to_node(), but always returns an online
> node.  When the mapped node from a given proximity ID is offline,
> it looks up the node distance table and returns the nearest
> online node.
> 
> ACPI device drivers, which are called after the NUMA initialization
> has completed in the kernel, can call this interface to obtain their
> device NUMA topology from ACPI tables.  Such drivers do not have to
> deal with offline nodes.  A node may be offline when a device
> proximity ID is unique, SRAT memory entry does not exist, or NUMA is
> disabled, ex. "numa=off" on x86.
> 
> This patch also moves the pxm range check from acpi_get_node() to
> acpi_map_pxm_to_node().
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Better now. :-)

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>>

> ---
> UPDATE: Remove "-" from "on-line" and "off-line".
> ---
>  drivers/acpi/numa.c  |   50 +++++++++++++++++++++++++++++++++++++++++++++++---
>  include/linux/acpi.h |    5 +++++
>  2 files changed, 52 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index 1333cbdc..acaa3b4 100644
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
> + * acpi_map_pxm_to_online_node - Map proximity ID to online node
> + * @pxm: ACPI proximity ID
> + *
> + * This is similar to acpi_map_pxm_to_node(), but always returns an online
> + * node.  When the mapped node from a given proximity ID is offline, it
> + * looks up the node distance table and returns the nearest online node.
> + *
> + * ACPI device drivers, which are called after the NUMA initialization has
> + * completed in the kernel, can call this interface to obtain their device
> + * NUMA topology from ACPI tables.  Such drivers do not have to deal with
> + * offline nodes.  A node may be offline when a device proximity ID is
> + * unique, SRAT memory entry does not exist, or NUMA is disabled, ex.
> + * "numa=off" on x86.
> + */
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
> @@ -328,8 +374,6 @@ int acpi_get_node(acpi_handle handle)
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

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
