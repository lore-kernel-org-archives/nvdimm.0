From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ndctl PATCH] ndctl: support machines without numa
Date: Thu, 05 Jan 2017 09:55:49 -0500
Message-ID: <x497f6936a2.fsf@segfault.boston.devel.redhat.com>
References: <148357532903.9100.4272827749663933501.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <148357532903.9100.4272827749663933501.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 (Dan Williams's message of "Wed, 04 Jan 2017 16:15:57 -0800")
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

> From: Diego Dompe <dompe-ZPxbGqLxI0U@public.gmane.org>
>
> Currently when using ndctl in machines that do not have numa, the ndctl
> command fails because it fails to find the numa_node attribute in
> systems.

s/machines that do not have numa/kernels compiled with CONFIG_NUMA=n/

I don't know that this was the right decision for the kernel, but that
ship's sailed.

> Just assume the default, zero, in these cases rather than fail.

Looks fine to me.

Reviewed-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

>
> Link: https://github.com/pmem/ndctl/pull/9
> [djbw: minor style fixups]
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>
> Diego, if this reworked version looks good to you I'll add your
> "Signed-off-by: Diego Dompe <dompe-ZPxbGqLxI0U@public.gmane.org>" to the tags. Let me know.
> Thanks for the fix!
>
>  ndctl/lib/libndctl.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ea3111eb6c93..8240235dff5c 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -2780,9 +2780,8 @@ static void *add_namespace(void *parent, int id, const char *ndns_base)
>  	ndns->raw_mode = strtoul(buf, NULL, 0);
>  
>  	sprintf(path, "%s/numa_node", ndns_base);
> -	if (sysfs_read_attr(ctx, path, buf) < 0)
> -		goto err_read;
> -	ndns->numa_node = strtol(buf, NULL, 0);
> +	if (sysfs_read_attr(ctx, path, buf) == 0)
> +		ndns->numa_node = strtol(buf, NULL, 0);
>  
>  	switch (ndns->type) {
>  	case ND_DEVICE_NAMESPACE_BLK:
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
