Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A86A521A18AAA
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 08:37:55 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [ndctl PATCH] ndctl,
 check: Add a sigbus handler to detect metadata corruption
References: <20170414000251.23904-1-vishal.l.verma@intel.com>
Date: Mon, 17 Apr 2017 11:37:53 -0400
In-Reply-To: <20170414000251.23904-1-vishal.l.verma@intel.com> (Vishal Verma's
 message of "Thu, 13 Apr 2017 18:02:51 -0600")
Message-ID: <x49lgqzqc32.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Vishal Verma <vishal.l.verma@intel.com> writes:

> If we have poison/badblocks in the BTT metadata sections, the mmap-reads
> happening in the checker will trigger a SIGBUS, and the program will
> halt abruptly. Add a sigbus handler which notifies the user of this, and
> prints out a relevant error message:

This isn't much better than just segfaulting.  Did you consider whether
it was possible to reconstruct corrupt metadata in any circumstances?

-Jeff

>
>   namespace5.0: namespace_check: checking namespace5.0
>   namespace5.0: btt_discover_arenas: found 1 BTT arena
>   namespace5.0: btt_check_arenas: checking arena 0
>   namespace5.0: namespace_check: Received a SIGBUS
>   namespace5.0: namespace_check: Metadata corruption found, recovery is not possible
>   error checking namespaces: Bad address
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/check.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/ndctl/check.c b/ndctl/check.c
> index 3b30a98..3775c2e 100644
> --- a/ndctl/check.c
> +++ b/ndctl/check.c
> @@ -13,6 +13,8 @@
>  #include <stdio.h>
>  #include <fcntl.h>
>  #include <errno.h>
> +#include <setjmp.h>
> +#include <signal.h>
>  #include <stdint.h>
>  #include <stdlib.h>
>  #include <unistd.h>
> @@ -40,6 +42,13 @@
>  #include <ndctl.h>
>  #endif
>  
> +static sigjmp_buf sj_env;
> +
> +static void sigbus_hdl(int sig, siginfo_t *siginfo, void *ptr)
> +{
> +	siglongjmp(sj_env, 1);
> +}
> +
>  static int repair_msg(struct btt_chk *bttc)
>  {
>  	info(bttc, "  Run with --repair to make the changes\n");
> @@ -872,6 +881,7 @@ int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts)
>  	int raw_mode, rc, disabled_flag = 0, open_flags;
>  	struct btt_sb *btt_sb;
>  	struct btt_chk *bttc;
> +	struct sigaction act;
>  	char path[50];
>  
>  	bttc = calloc(1, sizeof(*bttc));
> @@ -882,6 +892,15 @@ int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts)
>  	if (opts->verbose)
>  		bttc->ctx.log_priority = LOG_DEBUG;
>  
> +	memset(&act, 0, sizeof(act));
> +	act.sa_sigaction = sigbus_hdl;
> +	act.sa_flags = SA_SIGINFO;
> +
> +	if (sigaction(SIGBUS, &act, 0)) {
> +		err(bttc, "Unable to set sigaction\n");
> +		return -errno;
> +	}
> +
>  	bttc->opts = opts;
>  	bttc->start_off = BTT_START_OFFSET;
>  	bttc->sys_page_size = sysconf(_SC_PAGESIZE);
> @@ -949,6 +968,18 @@ int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts)
>  		goto out_sb;
>  	}
>  
> +	/*
> +	 * This is where we jump to if we receive a SIGBUS, prior to doing any
> +	 * mmaped reads, and can safely abort
> +	 */
> +	if (sigsetjmp(sj_env, 1)) {
> +		err(bttc, "Received a SIGBUS\n");
> +		err(bttc,
> +			"Metadata corruption found, recovery is not possible\n");
> +		rc = -EFAULT;
> +		goto out_close;
> +	}
> +
>  	rc = btt_info_read_verify(bttc, btt_sb, bttc->start_off);
>  	if (rc) {
>  		rc = btt_recover_first_sb(bttc);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
