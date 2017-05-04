Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22b.google.com (mail-io0-x22b.google.com
 [IPv6:2607:f8b0:4001:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C23121A13493
 for <linux-nvdimm@lists.01.org>; Wed,  3 May 2017 19:01:24 -0700 (PDT)
Received: by mail-io0-x22b.google.com with SMTP id f102so3037124ioi.2
 for <linux-nvdimm@lists.01.org>; Wed, 03 May 2017 19:01:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493854569.30303.53.camel@hpe.com>
References: <20170503153103.30756-1-toshi.kani@hpe.com>
 <CAPcyv4hu9iW-EEaggOj4ax_P6=Y28adi5Hb7Rp1Q1xBTWenJuQ@mail.gmail.com>
 <1493827750.30303.44.camel@hpe.com>
 <CAPcyv4gthc8Gc7SUyxqecDrd+dtOfOzY19bs5sY1qMepQKh=kQ@mail.gmail.com>
 <1493837209.30303.47.camel@hpe.com>
 <CAPcyv4ifW-tpo=WzhL8W4pxfv6XWw=QSxCApXtcXnhbK3Nf6YQ@mail.gmail.com>
 <1493851282.30303.49.camel@hpe.com>
 <CAPcyv4hj3Ynm06LTJwDYKTWmWSnvjUgVQSWpVWMXQCU+tUj0fQ@mail.gmail.com>
 <CAPcyv4g4-H76AMYv2TUtwmFZSc_p58UeiqVmKpJJbOY3g26FwA@mail.gmail.com>
 <1493853934.30303.51.camel@hpe.com> <1493854569.30303.53.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 May 2017 19:01:22 -0700
Message-ID: <CAPcyv4i5_6gNRAipcuV2fk2OpfgXD1gY-Q-Zh-re7j=AODSLZA@mail.gmail.com>
Subject: Re: [RFC PATCH] dax: add badblocks check to Device DAX
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 3, 2017 at 4:36 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Wed, 2017-05-03 at 17:25 -0600, Toshi Kani wrote:
>> On Wed, 2017-05-03 at 16:08 -0700, Dan Williams wrote:
>> > On Wed, May 3, 2017 at 3:51 PM, Dan Williams <dan.j.williams@intel.
>> > co
>> > m> wrote:
>> > > On Wed, May 3, 2017 at 3:41 PM, Kani, Toshimitsu <toshi.kani@hpe.
>> > > co
>> > > m> wrote:
>> > > > On Wed, 2017-05-03 at 14:48 -0700, Dan Williams wrote:
>>
>>  :
>> > >
>> > > I believe we already have all the data needed to calculate the
>> > > data
>> > > offset. Given the following sysfs path:
>> > >
>> > >     /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/regio
>> > > n1
>> > > /dax1.1/dax/dax1.0
>> > >
>> > > ...we can find the associated namespace device from that dax1.1.
>> > > From
>> > > there we have the base address of the namespace and the size
>> > > device-dax instance.
>> > >
>> > >     device_dax_data_offset == namespace_base + namespace_size -
>> > > device_dax_size
>> >
>> > Dave reminds me that we do have the data offset of the device-dax
>> > instance at the libnvdimm level:
>> >
>> >     /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region1
>> > /d
>> > ax1.1/resource
>> >
>> > ...in this example, which maps to ndctl_dax_get_resource().
>>
>> Thanks for the info!  I noticed why I did not catch this info before.
>>
>> # ll /dev/dax*
>> crw------- 1 root root 251, 3 May  3 04:28 /dev/dax0.0
>>
>> # pwd
>> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/dax0.
>> 0
>>
>> # grep . *
>> align:2097152
>> devtype:nd_dax
>> modalias:nd:t7
>> mode:none
>> numa_node:0
>> grep: power: Is a directory
>> grep: resource: No such device or address
>> grep: size: No such device or address
>> grep: subsystem: Is a directory
>> uevent:DEVTYPE=nd_dax
>> uevent:MODALIAS=nd:t7
>>
>> But I noticed that "resource" and "size" that are under
>> ".../region0/dax0.1" work.  Is this intended?

You mean that region0/dax0.1 and region0/dax0.1/dax/dax0.0 are
functional, but region0/dax0.0 is not? Yes, that is expected the
libnvdimm "struct nd_dax" device is on a different device numbering
scheme than the "struct dev_dax" instance. Depending on load and
namespace reconfiguration order you can expect those names to not
match. The dev_dax instance name is "dax region id"."sub-division
instance"

>
> Here is an output from dax0.1 (I removed the size value).  Noticed that
> mode is different.
>
> # pwd
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/dax0.1
>
> # grep . *
> align:2097152
> grep: dax: Is a directory
> grep: dax_region: Is a directory
> devtype:nd_dax
> grep: driver: Is a directory
> modalias:nd:t7
> mode:pmem
> namespace:namespace0.0
> numa_node:0
> grep: power: Is a directory
> resource:0x250200000
> size:(size value)
> grep: subsystem: Is a directory
> uevent:DEVTYPE=nd_dax
> uevent:DRIVER=dax_pmem
> uevent:MODALIAS=nd:t7
> uuid:8c71811f-260d-4788-8487-db88d829d393

The "mode" in this instance is the mode for the struct page
allocation, i.e. whether it is coming from main memory "mem" or the
persistent memory itself "pmem" in this case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
