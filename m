Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 25 Jan 2017 07:49:43 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] nvdimm: constify device_type structures
In-Reply-To: <1485312569.12563.52.camel@perches.com>
Message-ID: <alpine.DEB.2.20.1701250745340.2011@hadrien>
References: <1485285847-7006-1-git-send-email-bhumirks@gmail.com>
 <1485311842.12563.50.camel@perches.com>
 <CAPcyv4i7-vT+-VqU2n4bxrtcwrYtJ5rcVg3=bf5gCx-YRe3HkA@mail.gmail.com>
 <1485312569.12563.52.camel@perches.com>
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
To: Joe Perches <joe@perches.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bhumika Goyal <bhumirks@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>



On Tue, 24 Jan 2017, Joe Perches wrote:

> On Tue, 2017-01-24 at 18:40 -0800, Dan Williams wrote:
> > On Tue, Jan 24, 2017 at 6:37 PM, Joe Perches <joe@perches.com> wrote:
> > > On Wed, 2017-01-25 at 00:54 +0530, Bhumika Goyal wrote:
> > > > Declare device_type structure as const as it is only stored in the
> > > > type field of a device structure. This field is of type const, so a=
dd
> > > > const to declaration of device_type structure.
> > > >
> > > > File size before:
> > > >   text           data     bss     dec     hex filename
> > > >   19278          3199      16   22493    57dd nvdimm/namespace_devs=
.o
> > > >
> > > > File size after:
> > > >   text           data     bss     dec     hex filename
> > > >   19929          3160      16   23105    5a41 nvdimm/namespace_devs=
.o
> > >
> > > Fine, but are you sure about the sizes?
> > >
> > > It seems odd the text went up 651 bytes
> > > while the data went down just 39 bytes.
> > >
> >
> > Right, the size data wasn't why I applied it. It was the general rule
> > of "make function pointer data read-only whenever possible to
> > eliminate a kernel attack vector".
>
> Exactly the correct reason it's a fine patch and one
> that should be applied.
>
> > Bhumika, you might want to mention
> > this as the motivating reason to apply the patch if you do more of
> > these changes.
>
> Regardless, the object sizes are still odd.
>
> The config should be mentioned because actually,
> the commonly compiles sizes reported are not correct.
>
> with an x86-64 defconfig I get:
>
> $ size drivers/nvdimm/namespace_devs.o*
> =A0=A0=A0text	=A0=A0=A0data	=A0=A0=A0=A0bss	=A0=A0=A0=A0dec	=A0=A0=A0=A0h=
ex	filename
> =A0 14615	=A0=A0=A0=A0519	=A0=A0=A0=A0=A016	=A0=A015150	=A0=A0=A03b2e	dri=
vers/nvdimm/namespace_devs.o.new
> =A0 14439	=A0=A0=A0=A0695	=A0=A0=A0=A0=A016	=A0=A015150	=A0=A0=A03b2e	dri=
vers/nvdimm/namespace_devs.o.old

What does the data column actually represent?  I tried size on the .o file
generated from:

commit a65f0161f4d69d6738d4821e649448312cd818e2
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Tue Jan 17 15:22:28 2017 +1100

with CONFIG_X86_64=3Dy and I get:

   text	   data	    bss	    dec	    hex	filename
  19726	   3480	     16	  23222	   5ab6	drivers/nvdimm/namespace_devs.o

but when I run objdump -sh drivers/nvdimm/namespace_devs.o, I find a .data
segment of size 1008 and a .data.unlikely segment of size 8, which don't
match up with the results of size.

julia
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
