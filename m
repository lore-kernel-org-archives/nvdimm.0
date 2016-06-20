From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Mon, 20 Jun 2016 14:00:43 -0400
Message-ID: <20160620180043.GA21261@redhat.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
 <20160613225756.GA18417@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160613225756.GA18417-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Mon, Jun 13 2016 at  6:57pm -0400,
Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, Jun 13 2016 at  6:21pm -0400,
> Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
> 
> > This patch-set adds DAX support to device-mapper dm-linear devices
> > used by LVM.  It works with LVM commands as follows:
> >  - Creation of a logical volume with all DAX capable devices (such
> >    as pmem) sets the logical volume DAX capable as well.
> >  - Once a logical volume is set to DAX capable, the volume may not
> >    be extended with non-DAX capable devices.
> > 
> > The direct_access interface is added to dm and dm-linear to map
> > a request to a target device.
> > 
> >  - Patch 1-2 introduce GENHD_FL_DAX flag to indicate DAX capability.
> >  - Patch 3-4 add direct_access functions to dm and dm-linear.
> >  - Patch 5-6 set GENHD_FL_DAX to dm when all targets are DAX capable.
> > 
> > ---
> > Toshi Kani (6):
> >  1/6 genhd: Add GENHD_FL_DAX to gendisk flags
> >  2/6 block: Check GENHD_FL_DAX for DAX capability
> >  3/6 dm: Add dm_blk_direct_access() for mapped device
> >  4/6 dm-linear: Add linear_direct_access()
> >  5/6 dm, dm-linear: Add dax_supported to dm_target
> >  6/6 dm: Enable DAX support for mapper device
> 
> Thanks a lot for doing this.  I recently added it to my TODO so your
> patches come at a great time.
> 
> I'll try to get to reviewing/testing your work by the end of this week.

I rebased your patches on linux-dm.git's 'for-next' (which includes what
I've already staged for the 4.8 merge window).  And I folded/changed
some of the DM patches so that there are only 2 now (1 for DM core and 1
for dm-linear).  Please see the 4 topmost commits in my 'wip' here:

http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip

Feel free to pick these patches up to use as the basis for continued
work or re-posting of this set.. either that or I could post them as v2
on your behalf.

As for testing, I've verified that basic IO works to a pmem-based DM
linear device and that mixed table types are rejected as expected.

Mike
