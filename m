Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6223.austin.hp.com (g1t6223.austin.hp.com [15.73.96.124])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EBBA61A202B
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 16:00:18 -0700 (PDT)
Subject: Re: [ndctl PATCH 4/8] ndctl, create-namespace: report failures due to
 namespace being mounted
References: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146135444310.4228.7151000859132505494.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <571AAD01.3080801@hpe.com>
Date: Fri, 22 Apr 2016 19:00:17 -0400
MIME-Version: 1.0
In-Reply-To: <146135444310.4228.7151000859132505494.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 4/22/2016 3:47 PM, Dan Williams wrote:
> In the case when a filesystem is mounted on a namespace targeted for
> reconfiguration or destruction, emit a message so the user knows to
> unmount the filesystem.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  builtin-xaction-namespace.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
> index 53ff82bc2c8d..e2e6d518c64d 100644
> --- a/builtin-xaction-namespace.c
> +++ b/builtin-xaction-namespace.c
> @@ -550,6 +550,8 @@ static int namespace_destroy(struct ndctl_region *region,
>  			 * stopping the !bdev case from racing to mount an fs or
>  			 * re-enabling the namepace.
>  			 */
> +			error("%s: %s is mounted, failing operation\n",
> +					devname, bdev);

I'm seeing this error message in cases where the device is not mounted,
such as when I forget to run ndctl as root/sudo.  That's a more
likely reason that the open() may fail.  Perhaps you could check the
errno from the open() failure and display an error based on that?
You might simply do a perror().

-- ljk

>  			return -EBUSY;
>  		}
>  	}
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
