Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 675B31A1E84
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 05:32:34 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 08/13] libnvdimm,
 blk: move i/o infrastructure to nd_namespace_blk
Date: Thu, 24 Mar 2016 13:22:25 +0100
Message-ID: <7155730.1PoRE68eiN@c203>
In-Reply-To: <20160324012603.21436.60864.stgit@dwillia2-desk3.jf.intel.com>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
 <20160324012603.21436.60864.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mittwoch, 23. M=E4rz 2016 18:26:03 CET Dan Williams wrote:
> Consolidate the information for issuing i/o to a blk-namespace, and
> eliminate some pointer chasing.
> =

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
[...]
>  		BUG_ON(len > PAGE_SIZE);
> -		err =3D nd_blk_do_bvec(blk_dev, bip, bvec.bv_page, len,
> -					bvec.bv_offset, rw, iter.bi_sector);
> +		err =3D nsblk_do_bvec(nsblk, bip, bvec.bv_page, len,
> +				bvec.bv_offset, rw, iter.bi_sector);
>  		if (err) {
> -			dev_info(&blk_dev->nsblk->common.dev,
> +			dev_dbg(&nsblk->common.dev,
>  					"io error in %s sector %lld, len %d,\n",
>  					(rw =3D=3D READ) ? "READ" : "WRITE",
>  					(unsigned long long) iter.bi_sector, len);

Why is an I/O error suddently a debug message instead of an error?

Otherwise
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

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
