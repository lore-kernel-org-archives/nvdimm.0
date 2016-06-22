From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Wed, 22 Jun 2016 12:15:25 -0700
Message-ID: <CAPcyv4gqiNQ-FRqCV3WxBzjUBZNY6eZVA9ioc0q+Lm=oG8bWAg@mail.gmail.com>
References: <20160613225756.GA18417@redhat.com>
 <20160620180043.GA21261@redhat.com>
 <1466446861.3504.243.camel@hpe.com> <20160620194026.GA21657@redhat.com>
 <20160620195217.GB21657@redhat.com> <1466452883.3504.244.camel@hpe.com>
 <1466457467.3504.249.camel@hpe.com> <20160620222236.GA22461@redhat.com>
 <20160621134147.GA26392@redhat.com> <1466523280.3504.262.camel@hpe.com>
 <20160621181728.GA27821@redhat.com> <1466616868.3504.320.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1466616868.3504.320.camel-ZPxbGqLxI0U@public.gmane.org>
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

On Wed, Jun 22, 2016 at 10:44 AM, Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
> On Tue, 2016-06-21 at 14:17 -0400, Mike Snitzer wrote:
>> On Tue, Jun 21 2016 at 11:44am -0400,
>> Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
>> >
>> > On Tue, 2016-06-21 at 09:41 -0400, Mike Snitzer wrote:
>> > >
>> > > On Mon, Jun 20 2016 at  6:22pm -0400,
>> > > Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>  :
>> > > I'm now wondering if we'd be better off setting a new QUEUE_FLAG_DAX
>> > > rather than establish GENHD_FL_DAX on the genhd?
>> > >
>> > > It'd be quite a bit easier to allow upper layers (e.g. XFS and ext4) to
>> > > check for a queue flag.
>> >
>> > I think GENHD_FL_DAX is more appropriate since DAX does not use a request
>> > queue, except for protecting the underlining device being disabled while
>> > direct_access() is called (b2e0d1625e19).
>>
>> The devices in question have a request_queue.  All bio-based device have
>> a request_queue.
>
> DAX-capable devices have two operation modes, bio-based and DAX.  I agree that
> bio-based operation is associated with a request queue, and its capabilities
> should be set to it.  DAX, on the other hand, is rather independent from a
> request queue.
>
>> I don't have a big problem with GENHD_FL_DAX.  Just wanted to point out
>> that such block device capabilities are generally advertised in terms of
>> a QUEUE_FLAG.
>
> I do not have a strong opinion, but feel a bit odd to associate DAX to a
> request queue.

Given that we do not support dax to a raw block device [1] it seems a
gendisk flag is more misleading than request_queue flag that specifies
what requests can be made of the device.

[1]: acc93d30d7d4 Revert "block: enable dax for raw block devices"


>> > About protecting direct_access, this patch assumes that the underlining
>> > device cannot be disabled until dtr() is called.  Is this correct?  If
>> > not, I will need to call dax_map_atomic().
>>
>> One of the big design considerations for DM that a DM device can be
>> suspended (with or without flush) and any new IO will be blocked until
>> the DM device is resumed.
>>
>> So ideally DM should be able to have the same capability even if using
>> DAX.
>
> Supporting suspend for DAX is challenging since it allows user applications to
> access a device directly.  Once a device range is mmap'd, there is no kernel
> intervention to access the range, unless we invalidate user mappings.  This
> isn't done today even after a driver is unbind'd from a device.
>
>> But that is different than what commit b2e0d1625e19 is addressing.  For
>> DM, I wouldn't think you'd need the extra protections that
>> dax_map_atomic() is providing given that the underlying block device
>> lifetime is managed via DM core's dm_get_device/dm_put_device (see also:
>> dm.c:open_table_device/close_table_device).
>
> I thought so as well.  But I realized that there is (almost) nothing that can
> prevent the unbind operation.  It cannot fail, either.  This unbind proceeds
> even when a device is in-use.  In case of a pmem device, it is only protected
> by pmem_release_queue(), which is called when a pmem device is being deleted
> and calls blk_cleanup_queue() to serialize a critical section between
> blk_queue_enter() and blk_queue_exit() per b2e0d1625e19.  This prevents from a
> kernel DTLB fault, but does not prevent a device disappeared while in-use.
>
> Protecting DM's underlining device with blk_queue_enter() (or something
> similar) requires more thoughts...  blk_queue_enter() to a DM device cannot be
> redirected to its underlining device.  So, this is TBD for now.  But I do not
> think this is a blocker issue since doing unbind to a underlining device is
> quite harmful no matter what we do - even if it is protected with
> blk_queue_enter().

I still have the "block device removed" notification patches on my
todo list.  It's not a blocker, but there are scenarios where we can
keep accessing memory via dax of a disabled device leading to memory
corruption.  I'll bump that up in my queue now that we are looking at
additional scenarios where letting DAX mappings leak past the
reconfiguration of a block device could lead to trouble.
