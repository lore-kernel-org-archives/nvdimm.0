Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1056021ED1C40
 for <linux-nvdimm@lists.01.org>; Wed,  7 Mar 2018 23:57:05 -0800 (PST)
Date: Thu, 8 Mar 2018 09:03:19 +0100
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] acpi, nfit: remove redundant __func__ in dev_dbg
Message-ID: <20180308080319.ndkspvrrxxlfiigu@linux-x5ow.site>
References: <20180302122049.13900-1-jthumshirn@suse.de>
 <20180306040630.GA9905@linux.intel.com>
 <CAPcyv4giwg1mStkA+7hXnABb8fV6VH2qQPstRfYU26-P56X4ug@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4giwg1mStkA+7hXnABb8fV6VH2qQPstRfYU26-P56X4ug@mail.gmail.com>
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
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux NV-DIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 06, 2018 at 08:52:21AM -0800, Dan Williams wrote:
> > Oh, Johannes I noticed that here is one stray one still in
> > drivers/acpi/nfit/mce.c.  Do you mind pulling it into your patch to kee=
p the
> > drivers/acpi/nfit/* changes together?
> =

> I'll fix this locally.

Sorry for the late response, I was some days off.

Thanks Dan,
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
