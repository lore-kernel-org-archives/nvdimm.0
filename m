Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 10E2621C9127B
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 23:05:37 -0700 (PDT)
Date: Fri, 4 Aug 2017 08:07:47 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 5/5] libnvdimm: add DMA support for pmem blk-mq
Message-ID: <20170804060747.GA4218@linux-x5ow.site>
References: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
 <150153988620.49768.12914164179718467335.stgit@djiang5-desk3.ch.intel.com>
 <mqdy3r3zqpy.fsf@linux-x5ow.site>
 <CAPcyv4hvY4swcyijRaSR8QpMEv1w=g52udpW7F9Qs-1oS0bskQ@mail.gmail.com>
 <20170803080615.GB4333@linux-x5ow.site>
 <CAPcyv4ibnZ8xPLyL3AUUvZrhyU7-dT9hk5aA-eF=E3cxYinATw@mail.gmail.com>
 <2dc39cda-ba3f-7b5f-6f96-69ee4fd71a25@intel.com>
 <CAPcyv4joibpPF1LhoMVnPjSwqDkrp4FzzPojbaFiZ9KOs=+fuw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4joibpPF1LhoMVnPjSwqDkrp4FzzPojbaFiZ9KOs=+fuw@mail.gmail.com>
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
Cc: "Koul, Vinod" <vinod.koul@intel.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 03, 2017 at 09:15:12AM -0700, Dan Williams wrote:
> > I can put in a tunable knob like Johannes suggested and leave the
> > default for that to what it is currently. And we can adjust as necessary
> > as we do more testing.
> =

> That's the problem, we need a multi-dimensional knob. It's not just
> transfer-size that effects total delivered bandwidth.

If Dan opposes it so much, I'm OK with no tunable. I'm just expressing my
concern that we get reports like this [1] one here as a result.

Thanks,
	Johannes

[1] http://marc.info/?l=3Dlinux-kernel&m=3D150175029403913&w=3D2

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
