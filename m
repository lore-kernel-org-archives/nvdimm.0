Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4470621F3C184
 for <linux-nvdimm@lists.01.org>; Tue, 10 Oct 2017 00:10:45 -0700 (PDT)
Date: Tue, 10 Oct 2017 09:14:06 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [ndctl PATCH] ndctl, test: rdma vs dax
Message-ID: <20171010071406.tnzvgsmjt55e626b@linux-x5ow.site>
References: <150738928223.25087.18137727671163532987.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171009080745.zxckckm4xdtx4i7j@linux-x5ow.site>
 <CAPcyv4hPA=hvQS8KJcihEEx-yVeJwPMPUBVe1oRw=tXeO-Kerw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hPA=hvQS8KJcihEEx-yVeJwPMPUBVe1oRw=tXeO-Kerw@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 09, 2017 at 08:45:41AM -0700, Dan Williams wrote:
> On Mon, Oct 9, 2017 at 1:07 AM, Johannes Thumshirn <jthumshirn@suse.de> w=
rote:
> > On Sat, Oct 07, 2017 at 08:14:42AM -0700, Dan Williams wrote:
> > [...]
> >
> >> +rxe_cfg stop
> >> +rxe_cfg start
> >> +if ! rxe_cfg status | grep -n rxe0; then
> >> +     rxe_cfg add eth0
> >> +fi
> >
> > Can we maybe skip the dependency on rxe_cfg? All that is needed is modp=
robe
> > and echo.
> =

> Sure, I'll take a look.

For my NVMe over Soft-RoCE test setup with Rapido [1] I used the following:

modprobe rdma-rxe
echo eth0 > /sys/module/rdma_rxe/parameters/add

> =

> > Also hard coding eth0 might be problematic in this case. This works
> > on your test-setup but surely isn't portable.
> =

> Yes,  which is part of the reason I have this listed under the
> "destructive" tests. Any advice on how to make it portable would be
> appreciated.

Maybe:
ETH=3D${ETH:-eth0}
echo $ETH > /sys/module/rdma_rxe/parameters/add

Byte,
	Johannes

[1] https://github.com/rapido-linux/rapido/blob/master/nvme_rdma_autorun.sh=
#L74

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
