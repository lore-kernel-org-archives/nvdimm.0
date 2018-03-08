Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1B24320955F18
 for <linux-nvdimm@lists.01.org>; Thu,  8 Mar 2018 00:52:20 -0800 (PST)
Date: Thu, 8 Mar 2018 09:58:34 +0100
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libnvdimm: remove redundant __func__ in dev_dbg
Message-ID: <20180308085834.3p5pikbyhasrkzwa@linux-x5ow.site>
References: <152029856149.39547.12704338925946035297.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180306035434.GC15227@linux.intel.com>
 <CAPcyv4g1Mc5yF1somk94Ogthvc7GVwLSAG_J=K_DCWWXGcL_zw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g1Mc5yF1somk94Ogthvc7GVwLSAG_J=K_DCWWXGcL_zw@mail.gmail.com>
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
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 06, 2018 at 08:59:11AM -0800, Dan Williams wrote:
> >> diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
> >> index e068d72b4357..df17f1cd696d 100644
> >> --- a/drivers/nvdimm/badrange.c
> >> +++ b/drivers/nvdimm/badrange.c
> >> @@ -176,8 +176,7 @@ static void set_badblock(struct badblocks *bb, sec=
tor_t s, int num)
> >>                       (u64) s * 512, (u64) num * 512);
> >>       /* this isn't an error as the hardware will still throw an excep=
tion */
> >>       if (badblocks_set(bb, s, num, 1))
> >> -             dev_info_once(bb->dev, "%s: failed for sector %llx\n",
> >> -                             __func__, (u64) s);
> >> +             dev_info_once(bb->dev, "failed for sector %llx\n", (u64)=
 s);
> >
> > I don't think you should remove this one.  dev_info_once() is just a pr=
intk(),
> > and doesn't inherit the +f flag from the dynamic debugging code. The __=
func__
> > here does add value.
> >
> > The rest of these look correct, though I think you missed one in each of
> > nvdimm_map_release()
> =

> This one is now fixed.

With the above fixed,
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
