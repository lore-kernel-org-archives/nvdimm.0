Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1433550818.23540.198.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/3] acpi: Fix acpi_map_pxm_to_node() to handle numa_off
From: Toshi Kani <toshi.kani@hp.com>
Date: Fri, 05 Jun 2015 18:33:38 -0600
In-Reply-To: <1433291212-23367-2-git-send-email-toshi.kani@hp.com>
References: <1433291212-23367-1-git-send-email-toshi.kani@hp.com>
	 <1433291212-23367-2-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net
Cc: dan.j.williams@intel.com, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2015-06-02 at 18:26 -0600, Toshi Kani wrote:
> When numa_off is set, NUMA is turned off and node 0 is the only
> valid node on the system.  The kernel skips parsing ACPI SRAT
> table in this case.
> 
> Change acpi_map_pxm_to_node() to always return 0 when numa_off
> is set.  Also move the range check of a proximity ID from
> acpi_get_node() to acpi_map_pxm_to_node() after the numa_off
> check.  This keeps the interfaces to return 0 regardless of
> proximity ID values.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/acpi/numa.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index 1333cbdc..4898082 100644
> --- a/drivers/acpi/numa.c
> +++ b/drivers/acpi/numa.c
> @@ -70,7 +70,15 @@ static void __acpi_map_pxm_to_node(int pxm, int node)
>  
>  int acpi_map_pxm_to_node(int pxm)
>  {
> -	int node = pxm_to_node_map[pxm];
> +	int node;
> +
> +	if (numa_off)
> +		return 0;

I found an issue in this patch.  numa_off is only defined in x86, but
this numa.c (ACPI_NUMA) can be enabled on x86 and IA64.  I will fix or
drop it in the next version.

Thanks,
-Toshi


