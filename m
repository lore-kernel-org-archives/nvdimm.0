Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB7B81A1E85
 for <linux-nvdimm@lists.01.org>; Mon, 23 May 2016 02:18:09 -0700 (PDT)
Date: Mon, 23 May 2016 11:17:58 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/2] libnvdimm, dax: fix alignment validation
Message-ID: <20160523091758.git26qatm2yav5rg@c203.arch.suse.de>
References: <146361503689.37798.44566892348278285.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146361504728.37798.4211838382035993859.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146361504728.37798.4211838382035993859.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 18, 2016 at 04:44:07PM -0700, Dan Williams wrote:
> Testing the dax-device autodetect support revealed a probe failure with
> the following result:
> =

>     dax0.1: bad offset: 0x8200000 dax disabled
> =

> The original pfn-device implementation inferred the alignment from
> ilog2(offset), now that the alignment is explicit the is_power_of_2()
> needs replacing with a real sanity check against the recorded alignment.
> Otherwise the alignment check is useless in the implicit case and only
> the minimum size of the offset matters.
> =

> This self-consistency check is further validated by the probe path that
> will re-check that the offset is large enough to contain all the
> metadata required to enable the device.
> =

> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

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
