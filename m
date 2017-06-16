Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8978621CA358C
 for <linux-nvdimm@lists.01.org>; Fri, 16 Jun 2017 10:12:50 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] ndctl: daxctl: Adding io option for daxctl
References: <149756654995.49071.10157586966796129090.stgit@djiang5-desk3.ch.intel.com>
 <x49r2yjc1go.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4iPVD_hzNz_LzR4fLEOC4hx6c0ecdVGNzFgJVjDT0B0ZQ@mail.gmail.com>
Date: Fri, 16 Jun 2017 13:14:07 -0400
In-Reply-To: <CAPcyv4iPVD_hzNz_LzR4fLEOC4hx6c0ecdVGNzFgJVjDT0B0ZQ@mail.gmail.com>
 (Dan Williams's message of "Fri, 16 Jun 2017 10:05:45 -0700")
Message-ID: <x49shiz6ejk.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Fri, Jun 16, 2017 at 10:00 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Dave Jiang <dave.jiang@intel.com> writes:
>>
>>> The daxctl io option allows I/Os to be performed between block/file to
>>> and from device dax files. It also provides a way to zero a device dax
>>> device.
>>>
>>> i.e. daxctl io --input=/home/myfile --output=/dev/dax1.0
>>
>> Does that really belong in daxctl?
>
> I'm open to teaching other utilities how to do mmap based i/o, but is
> there any harm in carrying this dedicated utility for this purpose?

Well, what is the purpose of daxctl, exactly?  Given the 'ctl' in the
name, I figured it was used for configuration.

> Certainly the error clearing interface to send custom nvdimm ioctls is
> not something I expect 'cp' or 'dd' to comprehend.

Sure, clearing errors makes sense.  I don't see a need to reimplement dd
or xfs_io, though.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
