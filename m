Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 7123C1A1E01
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 10:57:57 -0700 (PDT)
Date: Tue, 19 Jul 2016 11:56:39 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH 1/3] pmem: clarify a debug print in pmem_clear_poison
Message-ID: <20160719175639.GE12960@omniknight.lm.intel.com>
References: <1468889100-30698-1-git-send-email-vishal.l.verma@intel.com>
 <1468889100-30698-2-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4gpRGJLVfoC3o-rVypQtppkAKg1hObr=1EhcT3Y3g8KUw@mail.gmail.com>
 <1468948496.30121.60.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1468948496.30121.60.camel@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Luck,, "Rafael J  <rafael.j.wysocki@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 07/19, Verma, Vishal L wrote:
> On Tue, 2016-07-19 at 08:53 -0700, Dan Williams wrote:
> > On Mon, Jul 18, 2016 at 5:44 PM, Vishal Verma <vishal.l.verma@intel.co
> > m> wrote:
> > > Prefix the sector number being cleared with a '0x' to make it clear
> > > that
> > > this is a hex value.
> > > =

> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> > > =A0drivers/nvdimm/pmem.c | 2 +-
> > > =A01 file changed, 1 insertion(+), 1 deletion(-)
> > > =

> > > diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> > > index 608fc44..29ab25b 100644
> > > --- a/drivers/nvdimm/pmem.c
> > > +++ b/drivers/nvdimm/pmem.c
> > > @@ -57,7 +57,7 @@ static void pmem_clear_poison(struct pmem_device
> > > *pmem, phys_addr_t offset,
> > > =A0=A0=A0=A0=A0=A0=A0=A0cleared =3D nvdimm_clear_poison(dev, pmem->ph=
ys_addr + offset,
> > > len);
> > > =

> > > =A0=A0=A0=A0=A0=A0=A0=A0if (cleared > 0 && cleared / 512) {
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dev_dbg(dev, "%s: %llx =
clear %ld sector%s\n",
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dev_dbg(dev, "%s: 0x%ll=
x clear %ld sector%s\n",
> > =

> > %#llx is a bit smaller / more readable.=A0=A0Shall I just fix this up on
> > applying?
> =

> TIL :) Yes you can do the fixup, thanks!

Or since I'm reworking the other two, I'lll fix this up too.

> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
