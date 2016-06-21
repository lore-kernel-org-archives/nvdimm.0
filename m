From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Tue, 21 Jun 2016 09:45:33 -0700
Message-ID: <CAPcyv4ht8B7dHe1ckv5d=bOrRzCy3=ZDVSTD0rRsak_LYD8r8g@mail.gmail.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
 <20160613225756.GA18417@redhat.com>
 <20160620180043.GA21261@redhat.com>
 <1466446861.3504.243.camel@hpe.com>
 <20160620194026.GA21657@redhat.com>
 <20160620195217.GB21657@redhat.com>
 <1466452883.3504.244.camel@hpe.com>
 <1466457467.3504.249.camel@hpe.com>
 <20160620222236.GA22461@redhat.com>
 <20160621134147.GA26392@redhat.com>
 <1466523280.3504.262.camel@hpe.com>
 <CAPcyv4gFREc94ANuFD_Lyddx3iqRTN2UDebgeJe3LqPL8xrVzg@mail.gmail.com>
 <1466526342.3504.270.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1466526342.3504.270.camel-ZPxbGqLxI0U@public.gmane.org>
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
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Jun 21, 2016 at 9:35 AM, Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
> On Tue, 2016-06-21 at 09:25 -0700, Dan Williams wrote:
>> On Tue, Jun 21, 2016 at 8:44 AM, Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
>> wrote:
>> >
>> > On Tue, 2016-06-21 at 09:41 -0400, Mike Snitzer wrote:
>> > >
>> > > On Mon, Jun 20 2016 at  6:22pm -0400,
>> > > Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > > >
>> > > > On Mon, Jun 20 2016 at  5:28pm -0400,
>> > > > Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
>> >  :
>> > > > Looks good, I folded it in and tested it to work.  Pushed to my 'wip'
>> > > > branch.
>> > > >
>> > > > No longer seeing any corruption in my test that was using partitions
>> > > > to span pmem devices with a dm-linear device.
>> > > >
>> > > > Jens, any chance you'd be open to picking up the first 2 patches in
>> > > > this series?  Or would you like to see them folded or something
>> > > > different?
>> > >
>> > > I'm now wondering if we'd be better off setting a new QUEUE_FLAG_DAX
>> > > rather than establish GENHD_FL_DAX on the genhd?
>> > >
>> > > It'd be quite a bit easier to allow upper layers (e.g. XFS and ext4) to
>> > > check for a queue flag.
>> >
>> > I think GENHD_FL_DAX is more appropriate since DAX does not use a request
>> > queue, except for protecting the underlining device being disabled while
>> > direct_access() is called (b2e0d1625e19).
>> >
>> > About protecting direct_access, this patch assumes that the underlining
>> > device cannot be disabled until dtr() is called.  Is this correct?  If
>> > not, I will need to call dax_map_atomic().
>>
>> Kernel internal usages of dax should be using dax_map_atomic() to
>> safely resolve device removal races.
>
> Will do.  In such case, shall I move dax_[un]map_atomic() to block_dev.c and
> rename them to bdev_dax_[un]map_atomic()?

Sounds good to me.  I know Jeff and Christoph don't like the current
calling convention of passing in a structure.  Just note that they
might ask you to change it back to a list of parameters if it moves to
bdev_dax_map_atomic().
