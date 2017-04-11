Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA3EC21A04823
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 13:08:39 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] libnvdimm: fix btt vs clear poison locking
References: <149159694856.26101.16830021017958812113.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Tue, 11 Apr 2017 16:08:37 -0400
In-Reply-To: <149159694856.26101.16830021017958812113.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Fri, 07 Apr 2017 13:29:08 -0700")
Message-ID: <x49r30yg116.fsf@segfault.boston.devel.redhat.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> As a minimal fix, disable error clearing when the BTT is enabled. For
> the final fix a larger rework of the poison list locking is needed.

> @@ -243,7 +243,15 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>  	}
>  
>  	if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
> -		if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)) {
> +		/*
> +		 * FIXME: nsio_rw_bytes() may be called from atomic
> +		 * context in the BTT case and nvdimm_clear_poison()
> +		 * takes a sleeping lock. Until the locking can be
> +		 * reworked this capability depends on !BTT or BROKEN.
> +		 */
> +		if ((!IS_ENABLED(CONFIG_BTT) || IS_ENABLED(CONFIG_BROKEN))
> +				&& IS_ALIGNED(offset, 512)
> +				&& IS_ALIGNED(size, 512)) {

I don't like that you've disabled clear error just because the btt
driver was enabled.  Can't you do something like this, instead?

	disable_clear_poison = (ndns->claim && is_nd_btt(ndns->claim));

	if (!disable_clear_poison && IS_ALIGNED(offset, 512)...

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
