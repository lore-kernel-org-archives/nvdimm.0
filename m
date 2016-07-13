From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: dm stripe: add DAX support
Date: Tue, 12 Jul 2016 22:01:01 -0400
Message-ID: <20160713020100.GA5872@redhat.com>
References: <1466792610-30369-1-git-send-email-toshi.kani@hpe.com>
 <20160624182859.GD13898@redhat.com>
 <1468362104.8908.43.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468362104.8908.43.camel-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org
Cc: "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Jul 12 2016 at  6:22pm -0400,
Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:

> On Fri, 2016-06-24 at 14:29 -0400, Mike Snitzer wrote:
> >=A0
> > BTW, if in your testing you could evaluate/quantify any extra overhead
> > from DM that'd be useful to share.=A0=A0It could be there are bottlenec=
ks
> > that need to be fixed, etc.
> =

> Here are some results from fio benchmark. =A0The test is single-threaded =
and is
> bound to one CPU.
> =

> =A0DAX =A0LVM =A0 IOPS =A0 NOTE
> =A0---------------------------------------
> =A0 Y =A0 =A0N =A0 =A0790K
> =A0 Y =A0 =A0Y =A0 =A0754K =A0 5% overhead with LVM
> =A0 N =A0 =A0N =A0 =A0567K
> =A0 N =A0 =A0Y =A0 =A0457K =A0 20% overhead with LVM
> =

> =A0DAX: Y: mount -o dax,noatime, N: mount -o noatime
> =A0LVM: Y: dm-linear on pmem0 device, N: pmem0 device
> =A0fio: bs=3D4k, size=3D2G, direct=3D1, rw=3Drandread,=A0numjobs=3D1
> =

> Among the 5% overhead with DAX/LVM, the new DM direct_access interfaces
> account for less than 0.5%.
> =

> =A0dm_blk_direct_access 0.28%
> =A0linear_direct_access 0.17%
> =

> The average latency increases slightly from 0.93us to 0.95us. =A0I think =
most of
> the overhead comes from the submit_bio() path, which is used only for
> accessing metadata with DAX. =A0I believe this is due to cloning bio for =
each
> request in DM. =A0There is 12% more L2 miss in total.
> =

> Without DAX, 20% overhead is observed with LVM. =A0Average latency increa=
ses
> from 1.39us to 1.82us. =A0Without DAX, bio is cloned for both data and me=
tadata.

Thanks for putting this summary together.  Unfortunately none of the DM
changes can be queued for 4.8 until Jens takes the 2 block core patches:
https://patchwork.kernel.org/patch/9196021/
https://patchwork.kernel.org/patch/9196019/

Not sure what the hold up and/or issue is with them.  But I've asked
twice (and implicilty a 3rd time here).  Hopefully they land in time for
4.8.

Mike
