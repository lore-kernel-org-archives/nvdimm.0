Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtprelay.hostedemail.com (smtprelay0105.hostedemail.com
 [216.40.44.105])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A70981F1B
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jan 2017 18:49:33 -0800 (PST)
Message-ID: <1485312569.12563.52.camel@perches.com>
Subject: Re: [PATCH] nvdimm: constify device_type structures
From: Joe Perches <joe@perches.com>
Date: Tue, 24 Jan 2017 18:49:29 -0800
In-Reply-To: <CAPcyv4i7-vT+-VqU2n4bxrtcwrYtJ5rcVg3=bf5gCx-YRe3HkA@mail.gmail.com>
References: <1485285847-7006-1-git-send-email-bhumirks@gmail.com>
 <1485311842.12563.50.camel@perches.com>
 <CAPcyv4i7-vT+-VqU2n4bxrtcwrYtJ5rcVg3=bf5gCx-YRe3HkA@mail.gmail.com>
Mime-Version: 1.0
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
Cc: Julia Lawall <julia.lawall@lip6.fr>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bhumika Goyal <bhumirks@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2017-01-24 at 18:40 -0800, Dan Williams wrote:
> On Tue, Jan 24, 2017 at 6:37 PM, Joe Perches <joe@perches.com> wrote:
> > On Wed, 2017-01-25 at 00:54 +0530, Bhumika Goyal wrote:
> > > Declare device_type structure as const as it is only stored in the
> > > type field of a device structure. This field is of type const, so add
> > > const to declaration of device_type structure.
> > > =

> > > File size before:
> > >   text           data     bss     dec     hex filename
> > >   19278          3199      16   22493    57dd nvdimm/namespace_devs.o
> > > =

> > > File size after:
> > >   text           data     bss     dec     hex filename
> > >   19929          3160      16   23105    5a41 nvdimm/namespace_devs.o
> > =

> > Fine, but are you sure about the sizes?
> > =

> > It seems odd the text went up 651 bytes
> > while the data went down just 39 bytes.
> > =

> =

> Right, the size data wasn't why I applied it. It was the general rule
> of "make function pointer data read-only whenever possible to
> eliminate a kernel attack vector".

Exactly the correct reason it's a fine patch and one
that should be applied.

> Bhumika, you might want to mention
> this as the motivating reason to apply the patch if you do more of
> these changes.

Regardless, the object sizes are still odd.

The config should be mentioned because actually,
the commonly compiles sizes reported are not correct.

with an x86-64 defconfig I get:

$ size drivers/nvdimm/namespace_devs.o*
=A0=A0=A0text	=A0=A0=A0data	=A0=A0=A0=A0bss	=A0=A0=A0=A0dec	=A0=A0=A0=A0hex=
	filename
=A0 14615	=A0=A0=A0=A0519	=A0=A0=A0=A0=A016	=A0=A015150	=A0=A0=A03b2e	drive=
rs/nvdimm/namespace_devs.o.new
=A0 14439	=A0=A0=A0=A0695	=A0=A0=A0=A0=A016	=A0=A015150	=A0=A0=A03b2e	drive=
rs/nvdimm/namespace_devs.o.old
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
