Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x22d.google.com (mail-yb0-x22d.google.com
 [IPv6:2607:f8b0:4002:c09::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5EF842193B80E
 for <linux-nvdimm@lists.01.org>; Sat, 15 Jul 2017 16:21:17 -0700 (PDT)
Received: by mail-yb0-x22d.google.com with SMTP id w187so9076434ybc.0
 for <linux-nvdimm@lists.01.org>; Sat, 15 Jul 2017 16:23:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49shiz6ejk.fsf@segfault.boston.devel.redhat.com>
References: <149756654995.49071.10157586966796129090.stgit@djiang5-desk3.ch.intel.com>
 <x49r2yjc1go.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4iPVD_hzNz_LzR4fLEOC4hx6c0ecdVGNzFgJVjDT0B0ZQ@mail.gmail.com>
 <x49shiz6ejk.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 15 Jul 2017 16:23:06 -0700
Message-ID: <CAPcyv4iqY2_JtpGu+D-RATe8JLwwp4u7XNz5sdLh4HEL-m8x5Q@mail.gmail.com>
Subject: Re: [PATCH] ndctl: daxctl: Adding io option for daxctl
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 16, 2017 at 10:14 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> On Fri, Jun 16, 2017 at 10:00 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Dave Jiang <dave.jiang@intel.com> writes:
>>>
>>>> The daxctl io option allows I/Os to be performed between block/file to
>>>> and from device dax files. It also provides a way to zero a device dax
>>>> device.
>>>>
>>>> i.e. daxctl io --input=/home/myfile --output=/dev/dax1.0
>>>
>>> Does that really belong in daxctl?
>>
>> I'm open to teaching other utilities how to do mmap based i/o, but is
>> there any harm in carrying this dedicated utility for this purpose?
>
> Well, what is the purpose of daxctl, exactly?  Given the 'ctl' in the
> name, I figured it was used for configuration.
>
>> Certainly the error clearing interface to send custom nvdimm ioctls is
>> not something I expect 'cp' or 'dd' to comprehend.
>
> Sure, clearing errors makes sense.  I don't see a need to reimplement dd
> or xfs_io, though.

Neither dd nor xfs_io tool does what I want which is read from stdin
and write to a device-dax instance. This is explicitly not trying to
be a dd replacement as it enforces that one of the arguments must be a
device-dax instance. If neither input nor output is device-dax the
user is expected to just use dd.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
