Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 42C501A1E04
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 19:52:55 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id l65so306289044oib.1
 for <linux-nvdimm@lists.01.org>; Wed, 03 Aug 2016 19:52:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160803231655.GY16044@dastard>
References: <20160803003354.GP16044@dastard>
 <20160803171127.GA15876@linux.intel.com>
 <20160803223713.GA22364@linux.intel.com> <20160803231655.GY16044@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 Aug 2016 19:52:53 -0700
Message-ID: <CAPcyv4hsMSG6S=BaOyCYnwmhu1uUWkryoA2SqoLff4nuK5dysA@mail.gmail.com>
Subject: Re: [4.8 hang] xfstests generic/361 hangs on dax enabled filesystems
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 3, 2016 at 4:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Aug 03, 2016 at 04:37:13PM -0600, Ross Zwisler wrote:
>> On Wed, Aug 03, 2016 at 11:11:27AM -0600, Ross Zwisler wrote:
>> > On Wed, Aug 03, 2016 at 10:33:54AM +1000, Dave Chinner wrote:
>> > > Hi folks,
>> > >
>> > > Just hit a reproducable hang in generic/361. Essentially this on
>> > > a 8GB pmem device:
>> > >
>> > > mkfs.xfs -f /dev/pmem1
>> > > mount -o dax /dev/pmem1 /mnt/scratch
>> > > xfs_io -f -c "truncate 1g" test.img
>> > > losetup -f --show /mnt/scratch/test.img
>> > > mkfs.xfs -f /dev/loop0
>> > >
>> > > And the mkfs.xfs command hangs with a discard that never completes:
> ....
>> > > This only reproduces when the underlying filesystem is mounted with
>> > > -o dax, so there is a bad interaction with loop devices and DAX
>> > > occurring somewhere. generic/361 is a recent test (committed june 14)
>> > > so this probably hasn't actually been tested until now.
>> > >
>> > > I haven't got time to look at this right now, hence the report.
>> >
>> > Cool, thanks for the report.  I've reproduced this with linux/master, and the
>> > test passes with v4.7.
>> >
>> > Running a bisect...
>>
>> This bisected to a commit to the block layer code.  I've sent a bug report to
>> the author of the commit.
>
> And the commit id is ...?

c2df40dfb8c0 drivers: use req op accessor
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
