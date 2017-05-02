Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D21921A134A4
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 14:24:03 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id l18so12706736oig.2
 for <linux-nvdimm@lists.01.org>; Tue, 02 May 2017 14:24:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493760092.30303.42.camel@hpe.com>
References: <149375673867.14088.8455971000052942105.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4jYsPCvp5_kgVvGxGy-YT84ADM2QdCRSwGh3kLB+pzeqQ@mail.gmail.com>
 <1493760092.30303.42.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 May 2017 14:24:02 -0700
Message-ID: <CAPcyv4gxZYn6Z21vEgS3nyjeXqkkvM_7kEOtVr254CtpPi6q7Q@mail.gmail.com>
Subject: Re: [PATCH v5] ndctl: add clear error support for ndctl
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 2, 2017 at 2:21 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Tue, 2017-05-02 at 13:54 -0700, Dan Williams wrote:
>> On Tue, May 2, 2017 at 1:26 PM, Dave Jiang <dave.jiang@intel.com>
>> wrote:
>  :
>> > +read sector len <
>> > /sys/bus/platform/devices/nfit_test.0/$dev/$region/badblocks
>> > +echo "sector: $sector len: $len"
>> > +
>> > +# clearing using ndctl
>> > +$NDCTL clear-error -f /dev/$chardev -s $sector -l $len
>>
>> Ok, so I'm glad you wrote this test it highlights one mismatched
>> assumption.  The "ndctl clear-error" options should be device-
>> relative "sector" offsets not region offsets. So, "ndctl clear-error
>> /dev/dev0.0 -s 0" should clear device-dax instance offset 0, not
>> region offset 0 A device-dax instance starts at an offset from the
>> namespace, and the namespace may start anywhere within a region. So
>> the clear-error command needs to translate that device-dax sector
>> offset to the region offset. device-dax offset to namespace offset
>> can be calculated by subtracting the device-dax instance size from
>> the namespace size, the namespace offset can be calculated by
>> subtracting the region resource base from the namespace resource
>> base. Now, the difficulty will be that the resource values for
>> nfit_test are garbage because they are vmalloc'd based, I need to
>> give that some thought...
>
> Using device-relative sector makes sense, but how does user come up
> with this sector number when sysfs only provides regionN/badblocks?

Right, we need a "list" helper that is also device-relative.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
