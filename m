Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F297F80348
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 01:30:27 -0800 (PST)
Subject: Re: [PATCH 4/5] acpi_nfit, libnvdimm: Add support for clear poison
 list and bad blocks
References: <148883211285.49239.17952572594430933942.stgit@djiang5-desk3.ch.intel.com>
 <148883236818.49239.12371446691877974041.stgit@djiang5-desk3.ch.intel.com>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <ca401cc3-db44-32a7-ecc5-2c06c0322177@suse.de>
Date: Tue, 7 Mar 2017 10:30:25 +0100
MIME-Version: 1.0
In-Reply-To: <148883236818.49239.12371446691877974041.stgit@djiang5-desk3.ch.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Jiang <dave.jiang@intel.com>, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 03/06/2017 09:32 PM, Dave Jiang wrote:
> Providing mechanism to clear poison list via the ndctl ND_CMD_CLEAR_ERROR
> call. We will update the poison list and also the badblocks at region lev=
el
> if the region is in dax mode or in pmem mode and not active.
> =

> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---

[...]

> +	if ((cmd !=3D ND_CMD_CLEAR_ERROR) || !nvdimm_bus || !clear_err->cleared)
             ^~ Unnecessary parenthesis?

[...]

> +
> +		/* make sure clear_err range is within a SPA range */
> +		if (((clear_begin >=3D spa_begin) &&
> +					(clear_begin < (spa_end))) &&
> +				((clear_end > spa_begin) &&
> +				 (clear_end <=3D spa_end))) {

Indentation looks a bit odd here and the superfluous parenthesis aren't
improving the situation.

[...]


> +	if (nd_btt || nd_pfn || nd_dax) {
> +		if (nd_btt)
> +			ndns =3D nd_btt->ndns;
> +		else if (nd_pfn)
> +			ndns =3D nd_pfn->ndns;
> +		else if (nd_dax)
> +			ndns =3D nd_dax->nd_pfn.ndns;
> +
> +		if (!ndns)
> +			return 0;

How can this (the !ndns case) ever happen?

And anyways isn't this sufficient, or am I missing something:

	if (nd_btt)
		ndns =3D nd_btt->ndns;
	else if (nd_pfn)
		ndns =3D nd_pfn->ndns;
	else if (nd_dax)
		ndns =3D nd_dax->nd_pfn.ndns;
	else
		ndns =3D to_ndns(dev);

> +	} else
> +		ndns =3D to_ndns(dev);
> +

Thanks,
	Johannes

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
