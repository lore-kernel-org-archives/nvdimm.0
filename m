Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE8741A1E77
 for <linux-nvdimm@lists.01.org>; Fri,  8 Apr 2016 00:20:53 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [ndctl PATCH v2] ndctl, list: add a '--health' option
Date: Fri, 08 Apr 2016 09:20:50 +0200
Message-ID: <5045500.AxyWr25szt@c203>
In-Reply-To: <20160407224113.24903.58908.stgit@dwillia2-desk3.jf.intel.com>
References: <20160407010720.30641.60021.stgit@dwillia2-desk3.jf.intel.com>
 <20160407224113.24903.58908.stgit@dwillia2-desk3.jf.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Donnerstag, 7. April 2016 15:42:29 CEST Dan Williams wrote:
> Dump dimm smart data in the dimm listing when '--health' is specified.
> =

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Changes in v2:
> * add an error message if health retrieval fails unexpectedly (jth)
> * add threshold data to the health listing

Thanks for working that in,
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
