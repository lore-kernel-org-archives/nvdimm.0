Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22a.google.com (mail-ot0-x22a.google.com
 [IPv6:2607:f8b0:4003:c0f::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4D2481EE5
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 09:49:03 -0800 (PST)
Received: by mail-ot0-x22a.google.com with SMTP id f9so108146509otd.1
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 09:49:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170123174257.GA19362@linux.intel.com>
References: <20170120031234.24226-1-vishal.l.verma@intel.com>
 <CAPcyv4gU5ujYJt0PLbNb4t64vRCnXhBxhfdB9ineZmgdAys2vg@mail.gmail.com>
 <20170123174257.GA19362@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Jan 2017 09:49:02 -0800
Message-ID: <CAPcyv4gFKnvvm6=wkseLKzX2GGa0yrFwv6w7zE7uNiFaFQvfDQ@mail.gmail.com>
Subject: Re: [PATCH] ndctl: add a BTT check utility
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 23, 2017 at 9:42 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, Jan 20, 2017 at 12:04:46PM -0800, Dan Williams wrote:
>> [ adding Jeff ]
>>
>> Some comments on boilerplate / organization items...
>>
>>
>> On Thu, Jan 19, 2017 at 7:12 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
>> > Add the check-namespace command to ndctl. This will check the BTT
>> > metadata layout for the given namespace, and if requested, correct any
>> > errors found. Not all metadata corruption is detectable or fixable.
>> >
>> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> <>
>> > +static int btt_read_info(struct btt_chk *bttc, struct btt_sb *btt_sb, __u64 off)
>> > +{
>> > +       int fd, rc = 0;
>> > +       ssize_t size;
>> > +
>> > +       fd = open(bttc->path, O_RDONLY);
>>
>> Let's not open and close the btt device on each call. Open it once at
>> the beginning of time and open it O_EXCL so that we prevent the kernel
>> trying to claim the device. Let's also use O_DIRECT to bypass the
>> block_device page cache.
>
> I thought O_EXCL only mattered if it was used for creation of new files with
> O_CREAT?
>
> https://linux.die.net/man/3/open
>
> For us bttc->path is our device in /dev/, so that O_EXCL shouldn't do anything
> for us?

You overlooked this bit in man 2 open:

"In general, the behavior of  O_EXCL  is  undefined  if  it  is  used
without O_CREAT.   There is one exception: on Linux 2.6 and later,
O_EXCL can be used without O_CREAT if pathname refers to a block
device.  If the block device is in use by the system (e.g., mounted),
open() fails with the error EBUSY."
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
