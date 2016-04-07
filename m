Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 144111A1E55
 for <linux-nvdimm@lists.01.org>; Thu,  7 Apr 2016 01:38:18 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [ndctl PATCH 3/5] ndctl, list: clean up default behavior
Date: Thu, 07 Apr 2016 10:38:16 +0200
Message-ID: <11241582.V4noDax4yR@c203>
In-Reply-To: <20160407010714.30641.19033.stgit@dwillia2-desk3.jf.intel.com>
References: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
 <20160407010714.30641.19033.stgit@dwillia2-desk3.jf.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

On Mittwoch, 6. April 2016 18:07:14 CEST Dan Williams wrote:
> Only list namespaces by default when no other option is specified.
> Otherwise, to limit the listing to dimm info a user would need to run:
> =

> 	ndctl list --dimms --no-namespaces
> =

> ...with the change this is reduced to:
> =

> 	ndctl list --dimms
> =

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Looks good,
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
