Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4977E1A1F30
 for <linux-nvdimm@lists.01.org>; Mon, 14 Mar 2016 14:23:41 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id c203so144042088oia.2
 for <linux-nvdimm@lists.01.org>; Mon, 14 Mar 2016 14:23:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160314152544.GD14621@c203.arch.suse.de>
References: <1457685810-4103-1-git-send-email-jthumshirn@suse.de>
 <CAPcyv4hde7eGwyiFYWnybbrgxUBkGJGhZYFnFMx1xOYQPnPsvw@mail.gmail.com>
 <20160314083141.GW16624@c203.arch.suse.de>
 <CAPcyv4grO=y-NcvQgFCT_mpRMpQ1suqMsCn5w+egYSyGEgpaeA@mail.gmail.com>
 <20160314152544.GD14621@c203.arch.suse.de>
Date: Mon, 14 Mar 2016 14:23:22 -0700
Message-ID: <CAPcyv4gNE9fzVyPSo5zyaunLs8qX3z2VgpFJcQY5h+8U0k06+g@mail.gmail.com>
Subject: Re: [ndctl PATCH v2] ndctl: Grab kernel version from utsname()
From: Dan Williams <dan.j.williams@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 14, 2016 at 8:25 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Mon, Mar 14, 2016 at 08:11:10AM -0700, Dan Williams wrote:
>> On Mon, Mar 14, 2016 at 1:31 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>> > On Fri, Mar 11, 2016 at 10:28:27AM -0800, Dan Williams wrote:
>> >> On Fri, Mar 11, 2016 at 12:43 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>> >> > Grab the kernel version used for tests dynamically via utsname() instead of
>> >> > hardcoding the version of the build host.
>> >> >
>> >> > Otherwise tests will be skipped if the build host had a too old kernel
>> >> > version.
>> >> >
>> >> > flodin:~ # ./ndctl test
>> >> > __ndctl_test_attempt: skip test_libndctl:1950 requires: 4.2.0 current: 4.1.0
>> >> > test-libndctl: SKIP
>> >> > __ndctl_test_attempt: skip test_dpa_alloc:300 requires: 4.2.0 current: 4.1.0
>> >> > test-dpa-alloc: SKIP
>> >> > __ndctl_test_attempt: skip test_parent_uuid:230 requires: 4.3.0 current: 4.1.0
>> >> > test-parent-uuid: SKIP
>> >> > attempted: 3 skipped: 3
>> >> >
>> >> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>> >> > ---
>> >> >  test/core.c |   15 ++++++++++++++-
>> >> >  1 file changed, 14 insertions(+), 1 deletion(-)
>> >> >
>> >> >  Changes to v1:
>> >> >  Use utsname.release which is obviously correct.
>> >> >  On my test system utsname.release = "4.4.4-default"
>> >> >
>> >> >  I can only imagine the sscanf() failing and on stack garbage in a, b, c being
>> >> >  greater than KERNEL_VERSION(4, 3, 0).
>> >>
>> >> Looks good to me, applied for v52.  I've pushed it out on the
>> >> 'pending' branch.  It will move to 'master' after the v4.6-rc1 kernel
>> >> is released.
>> >
>> > Thanks. Though I'm still not too happy with the general case of version
>> > checking in the tests at all. Actually it should check for the presence of a
>> > feature and not when a feature was introduced in the mainline kernel. Some
>> > distro kernels tend to be an rather old version with havily backported
>> > features *cough* ours *cough*. I'll see if I can come up with something, maybe
>> > for the 4.7 window.
>> >
>>
>> For backport kernels the idea was to use "ndctl test -f" to turn on
>> all tests regardless of nominal version.  The automatic version
>> determination was only meant for use in the 0day-kbuild-robot that
>> might be running bisects.
>
> OK, but having a ioctl or file in sysfs with a bit mask flipping "feature
> bits" on and off won't break the 0day bot and enhance the "user experience"
> (not really the right term I know).

Sounds interesting in theory, but how do you have a bit mask for
behavior changes?  In other words, these compatibility points aren't
delineated on clear feature boundaries.  While a behavior change
will/must not break old binaries, new tests check the new behavior out
of existing interfaces.

> Oh and btw, thanks for having unit tests for the nvdimm subsystem.

:-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
