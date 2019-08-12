Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F07F21309D33
 for <linux-nvdimm@lists.01.org>; Mon, 12 Aug 2019 13:47:48 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [ndctl PATCH] daxctl/test: Skip daxctl-devices.sh on older kernels
References: <156531368648.2136155.13013612862545053331.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Mon, 12 Aug 2019 16:45:28 -0400
In-Reply-To: <156531368648.2136155.13013612862545053331.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Thu, 08 Aug 2019 18:21:26 -0700")
Message-ID: <x49pnlagljr.fsf@segfault.boston.devel.redhat.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> If the 'kmem' module is missing skip the test to support running the
> unit tests on older -stable kernels pre-v5.1.
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Note that the kernel module could also just not be configured.

> ---
>  test/daxctl-devices.sh |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/test/daxctl-devices.sh b/test/daxctl-devices.sh
> index 04f53f7b13ab..4102fb6990ae 100755
> --- a/test/daxctl-devices.sh
> +++ b/test/daxctl-devices.sh
> @@ -18,6 +18,13 @@ find_testdev()
>  {
>  	local rc=77
>  
> +	# The kmem driver is needed to change the device mode, only
> +	# kernels >= v5.1 might have it available. Skip if not.
> +	if ! modinfo kmem; then
> +		"Unable to find kmem module"

I think you need a printf, there.  Also, do you want the modinfo output
in the test log?

-Jeff

> +		exit $rc
> +	fi
> +
>  	# find a victim device
>  	testbus="$ACPI_BUS"
>  	testdev=$("$NDCTL" list -b "$testbus" -Ni | jq -er '.[0].dev | .//""')
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
