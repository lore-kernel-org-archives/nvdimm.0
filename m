Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0A8EB21104FA6
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 14:35:31 -0700 (PDT)
Date: Mon, 18 Jun 2018 15:35:30 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, test: Update tests for capacity vs
 namespace-label locking
Message-ID: <20180618213530.GB4226@vverma7-mobl4.lm.intel.com>
References: <152902249055.9927.9157713405568345680.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152902249055.9927.9157713405568345680.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 06/14, Dan Williams wrote:
> Check that namespaces can be enumerated, but are disabled if the labels
> are readable while the DIMM is locked. Alternatively, if the namespace
> label area is locked, validate that regions with the affected DIMM fail
> to enable.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  test/Makefile.am |   10 +-
>  test/dsm-fail.c  |  305 ++++++++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 257 insertions(+), 58 deletions(-)
> 
> diff --git a/test/Makefile.am b/test/Makefile.am
> index 92cf29d6065e..f6483910af45 100644
> --- a/test/Makefile.am
> +++ b/test/Makefile.am
> @@ -69,9 +69,15 @@ libndctl_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
>  
>  dsm_fail_SOURCES =\
>  	dsm-fail.c \
> -	$(testcore)
> +	$(testcore) \
> +	../ndctl/namespace.c \
> +	../ndctl/check.c \
> +	../util/json.c
>  
> -dsm_fail_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
> +dsm_fail_LDADD = $(LIBNDCTL_LIB) \
> +		$(KMOD_LIBS) \
> +		$(JSON_LIBS) \
> +		../libutil.a
>  
>  ack_shutdown_count_set_SOURCES =\
>  	ack-shutdown-count-set.c \
> diff --git a/test/dsm-fail.c b/test/dsm-fail.c
> index 90d3e074f12b..b0df9da8ffab 100644
> --- a/test/dsm-fail.c
> +++ b/test/dsm-fail.c
> @@ -24,6 +24,7 @@
>  
>  #include <ccan/array_size/array_size.h>
>  #include <ndctl/libndctl.h>
> +#include <builtin.h>
>  #include <ndctl.h>
>  #include <test.h>
>  
> @@ -38,20 +39,153 @@ static void reset_bus(struct ndctl_bus *bus)
>  	ndctl_region_foreach(bus, region)
>  		ndctl_region_disable_invalidate(region);
>  
> -	ndctl_dimm_foreach(bus, dimm)
> -		ndctl_dimm_zero_labels(dimm);
> +	ndctl_dimm_foreach(bus, dimm) {
> +		struct ndctl_cmd *cmd_read = ndctl_dimm_read_labels(dimm);

This results in an unused variable warning for cmd_read. Perhaps if we
just want tp perform the read but not do anything with the cmd struct,
we can call it without storing the return anywhere?

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
