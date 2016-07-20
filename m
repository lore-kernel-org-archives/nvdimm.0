Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B85BD1A1E2A
 for <linux-nvdimm@lists.01.org>; Wed, 20 Jul 2016 00:57:02 -0700 (PDT)
Date: Wed, 20 Jul 2016 09:56:10 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [ndctl PATCH] ndctl: permit NULL as a parameter to ndctl_cmd_unref
Message-ID: <20160720075610.b24vsuhzkdlvqqxt@c203.arch.suse.de>
References: <146896920956.18759.7000784801515467749.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146896920956.18759.7000784801515467749.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Tiffany Kasanicky <tiffany.j.kasanicky@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 19, 2016 at 04:00:09PM -0700, Dan Williams wrote:
> Similar to libc free() allow NULL as a valid parameter to this freeing
> routine.  This mirrors the behavior of the other *_unref() routines in
> the library.
> =

> Cc: Tiffany Kasanicky <tiffany.j.kasanicky@intel.com>
> Reported-by: Linda Knippers <linda.knippers@hpe.com>
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
