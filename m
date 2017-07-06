Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22a.google.com (mail-yw0-x22a.google.com
 [IPv6:2607:f8b0:4002:c05::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22BB020958969
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 17:06:03 -0700 (PDT)
Received: by mail-yw0-x22a.google.com with SMTP id l21so1744357ywb.1
 for <linux-nvdimm@lists.01.org>; Wed, 05 Jul 2017 17:07:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1499297819.2042.5.camel@hpe.com>
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149875884190.10031.6179599135820559644.stgit@dwillia2-desk3.amr.corp.intel.com>
 <595552F5.5040008@hpe.com>
 <CAPcyv4jr0U-a521+wAL7RDca_AoUrtvO6yeY6d0UQpY7d=CHuQ@mail.gmail.com>
 <59556E37.80808@hpe.com>
 <CAPcyv4g6ijkWncZAbP-Bmbf+J7a2hR-JFLSX-ji6v-+oG0PDJQ@mail.gmail.com>
 <d073b4a1-ff90-b44a-adf2-ad44c0d70c69@hpe.com>
 <CAPcyv4huf0ENTz=LEVC6xC7xKRPc-GAZJsZMTSYpy+UoaduTMg@mail.gmail.com>
 <595580A6.9000004@hpe.com>
 <CAPcyv4gtTYEUELPtr9mi5QkGL+cm=jcFR-Oe07OCuNM9izh6jA@mail.gmail.com>
 <d545a1ea-0199-7462-58c5-067cdc22cacc@hpe.com>
 <CAPcyv4gnkpWXJ7jOJ7r0kWLKoLfuqJzdHTjANBUPztyTWUrOjA@mail.gmail.com>
 <595589CF.5010605@hpe.com>
 <CAPcyv4iTaXc92ggQcBnqJ=P0jsMF9HhnV4nAsr1Qos4pjrRDLA@mail.gmail.com>
 <1499297819.2042.5.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Jul 2017 17:07:41 -0700
Message-ID: <CAPcyv4ixQFNT_8tGFyf2ABqxpPd-jmtXKVeLBRdzBW12u3TJbg@mail.gmail.com>
Subject: Re: [PATCH v4 12/16] libnvdimm,
 nfit: enable support for volatile ranges
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 5, 2017 at 4:46 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Thu, 2017-06-29 at 18:28 -0700, Dan Williams wrote:
>> On Thu, Jun 29, 2017 at 4:14 PM, Linda Knippers <linda.knippers@hpe.c
>> om> wrote:
>> > On 06/29/2017 06:58 PM, Dan Williams wrote:
>> > > On Thu, Jun 29, 2017 at 3:49 PM, Linda Knippers <linda.knippers@h
>> > > pe.com> wrote:
>> > > > > The parent region of the namespace will have a 'volatile'
>> > > > > type:
>> > > > >
>> > > > > # cat /sys/bus/nd/devices/region0/devtype
>> > > > > nd_volatile
>> > > >
>> > > >
>> > > > If all I know is the /dev/pmem device name, how do I find that?
>> > > >
>> > >
>> > >     cat $(readlink -f /sys/block/pmem0/device)/../devtype
>> > >
>> > > ...this is where 'ndctl list' will get the information.
>> > >
>> >
>> > Thanks.
>> >
>> > I think we need a section 4 pmem manpage like exists for
>> > mem, sd, fd, md, etc., where we can put stuff like this, as well
>> > as providing some overview information that will point people to
>> > other resources.  I'll give that some thought unless there is one
>> > already that I'm not finding.
>> >
>>
>> A "pmem" man page sounds like a great idea, I wasn't aware we even
>> had an sd man page.
>
> Sorry for being late to respond, but I agree with Linda that this
> naming policy is likely to confuse users.  I also care less about the
> current users who use memmap option.  This case is pmem-emulation and
> they know what they are doing.
>
> Assuming block device interface is needed (in addition to device-dax)
> for volatile range for use-cases like swap device, I wonder if user can
> actually specify a right pmem device for swap from OS-install GUI when
> both volatile and persistent block devices are listed as /dev/pmemN.
> Sometimes we are restricted with GUI menu.  Some users use GUI all the
> time like Windows as well.
>
> Can we differentiate the naming by adding 'v' like 'pmemNv' (if you
> can't go with 'vmemN')?  I don't think having 's' for BTT was that bad.
>  It's been helpful to tell users that these pmem devices are not byte-
> addressable.  I also think that BTT for volatile range makes no sense
> (unless emulated as persistent memory by memmap option).

I'm more worried about sending the wrong signal the other way. That
users believe that the 'p' means definitely "persistent" when we have
no way to guarantee that.

If it was only memmap= that we had to worry about that would be one
thing, but we apparently have vendors that are shipping "e820-type-12
memory" as their NVDIMM solution [1].

We've also been shipping the policy that 'pmem' may front a volatile
range ever since v4.8 (commit c2f32acdf848 "acpi, nfit: treat virtual
ramdisk SPA as pmem region"). At least now we have the "nd_volatile"
region type. Any change of the device name now is potentially a
regression for environments that are already expecting /dev/pmemX.

As far as I know there are no OS installers that understand pmem. When
they do add support I think it would be straightforward to avoid
confusion and filter "volatile" hosted pmem devices from the install
target list. I don't see this being much different from the confusion
when users can not differentiate their 'sd' device between USB and
SATA. We have symlinks in /dev/disk/by* to make it easier to identify
storage devices, I think it makes sense to add udev rules for
identifying volatile pmem and not try to differentiate this in the
default kernel device name.

[1]: https://github.com/pmem/ndctl/issues/21
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
