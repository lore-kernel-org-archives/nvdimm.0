From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Tue, 21 Jun 2016 14:17:28 -0400
Message-ID: <20160621181728.GA27821@redhat.com>
References: <20160613225756.GA18417@redhat.com>
 <20160620180043.GA21261@redhat.com>
 <1466446861.3504.243.camel@hpe.com>
 <20160620194026.GA21657@redhat.com>
 <20160620195217.GB21657@redhat.com>
 <1466452883.3504.244.camel@hpe.com>
 <1466457467.3504.249.camel@hpe.com>
 <20160620222236.GA22461@redhat.com>
 <20160621134147.GA26392@redhat.com>
 <1466523280.3504.262.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466523280.3504.262.camel-ZPxbGqLxI0U@public.gmane.org>
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
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Jun 21 2016 at 11:44am -0400,
Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:

> On Tue, 2016-06-21 at 09:41 -0400, Mike Snitzer wrote:
> > On Mon, Jun 20 2016 at=A0=A06:22pm -0400,
> > Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > =

> > > On Mon, Jun 20 2016 at=A0=A05:28pm -0400,
> > > Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
> > > =

> =A0:
> > > Looks good, I folded it in and tested it to work.=A0=A0Pushed to my '=
wip'
> > > branch.
> > > =

> > > No longer seeing any corruption in my test that was using partitions =
to
> > > span pmem devices with a dm-linear device.
> > > =

> > > Jens, any chance you'd be open to picking up the first 2 patches in t=
his
> > > series?=A0=A0Or would you like to see them folded or something differ=
ent?
> >
> > I'm now wondering if we'd be better off setting a new QUEUE_FLAG_DAX
> > rather than establish GENHD_FL_DAX on the genhd?
> > =

> > It'd be quite a bit easier to allow upper layers (e.g. XFS and ext4) to
> > check for a queue flag.
> =

> I think GENHD_FL_DAX is more appropriate since DAX does not use a request
> queue, except for protecting the underlining device being disabled while
> direct_access() is called (b2e0d1625e19). =A0

The devices in question have a request_queue.  All bio-based device have
a request_queue.

I don't have a big problem with GENHD_FL_DAX.  Just wanted to point out
that such block device capabilities are generally advertised in terms of
a QUEUE_FLAG.
 =

> About protecting direct_access, this patch assumes that the underlining
> device cannot be disabled until dtr() is called. =A0Is this correct? =A0I=
f not,
> I will need to call=A0dax_map_atomic().

One of the big design considerations for DM that a DM device can be
suspended (with or without flush) and any new IO will be blocked until
the DM device is resumed.

So ideally DM should be able to have the same capability even if using
DAX.

But that is different than what commit b2e0d1625e19 is addressing.  For
DM, I wouldn't think you'd need the extra protections that
dax_map_atomic() is providing given that the underlying block device
lifetime is managed via DM core's dm_get_device/dm_put_device (see also:
dm.c:open_table_device/close_table_device).
