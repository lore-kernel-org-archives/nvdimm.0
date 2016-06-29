From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] dm: update table type check for dax
Date: Tue, 28 Jun 2016 20:40:49 -0400
Message-ID: <20160629004049.GA9721@redhat.com>
References: <1467142636-21094-1-git-send-email-toshi.kani@hpe.com>
 <1467142636-21094-2-git-send-email-toshi.kani@hpe.com>
 <20160628200714.GC8300@redhat.com>
 <1467145398.3504.439.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467145398.3504.439.camel-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Jun 28 2016 at  4:23pm -0400,
Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:

> On Tue, 2016-06-28 at 16:07 -0400, Mike Snitzer wrote:
> > On Tue, Jun 28 2016 at=A0=A03:37pm -0400,
> > Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
> =A0:
> > You said in the 0th header: "Patch 1 solves an error when lvremove is
> > made to a snapshot device."
> > =

> > I'm not seeing why this patch 1 fixes anything specific to snapshot
> > device removal (but I can see why patch 2 makes snapshot creation
> > "work").=A0=A0I'll apply your 2nd patch and see if I can see what you m=
ean.
> > =

> > I actually see this error, without either of your 2 proposed patches
> > applied, when I try to create a snapshot of a DAX capable LV:
> > =

> > # lvcreate -s -n snap -L 100M pmem/lv
> > =A0 device-mapper: reload ioctl on (253:7) failed: Invalid argument
> > =A0 Failed to lock logical volume pmem/lv.
> > =A0 Aborting. Manual intervention required.
> > Jun 28 15:57:28 rhel-storage-02 kernel: device-mapper: ioctl: can't cha=
nge
> > device type after initial table load.
> =

> Yes, patch 2 fixes this error.
> =

> I have not looked into why lvremove does this, but lvremove to a snapshot
> device fails to reload DM table of "<dev>-lvsnap" device (which is marked=
 as
> DM_TYPE_BIO_BASED) with DM_TYPE_DAX_BIO_BASED. =A0Patch 1 fixes this erro=
r.

It looks like a strange intermediate state that lvm2 uses during
snapshot removal.

Full listing of snapshot related DM tables (before lvremove):

pmem-lv-real: 0 6086656 linear 259:0 2048
pmem-lv: 0 6086656 snapshot-origin 253:5
pmem-snap-cow: 0 204800 linear 259:0 6088704
pmem-snap: 0 6086656 snapshot 253:5 253:6 P 8

When removing this snapshot we're wanting to be left with:

pmem-lv: 0 6086656 linear 259:0 2048

I augmented the DM core error to be more expressive, resulting in:
  device-mapper: ioctl: 253:7: can't change device type (from 1 to 4) after=
 initial table load.

1 is DM_TYPE_BIO_BASED and 4 is DM_TYPE_DAX_BIO_BASED -- which makes
sense given the linear target is DM_TYPE_DAX_BIO_BASED.

The previous DM table for 253:7 was:
  pmem-snap: 0 6086656 snapshot 253:5 253:6 P 8

The intermediate table that lvm2 is trying to load for 253:7 is:
  0 204800 linear 259:0 6088704

(this linear target was previously pmem-snap-cow)

> I think it also generally makes sense to allow this case.

You're probably right but I need to think about it a little bit more.
