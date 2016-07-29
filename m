Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE9AC1A1E20
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 07:44:26 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id j185so108741509oih.0
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 07:44:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160729022152.GZ16044@dastard>
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com>
 <20160727221949.GU16044@dastard> <20160728081033.GC4094@quack2.suse.cz>
 <20160729022152.GZ16044@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Jul 2016 07:44:25 -0700
Message-ID: <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
Subject: Re: Subtle races between DAX mmap fault and write path
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 28, 2016 at 7:21 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jul 28, 2016 at 10:10:33AM +0200, Jan Kara wrote:
>> On Thu 28-07-16 08:19:49, Dave Chinner wrote:
[..]
>> So DAX doesn't need flushing to maintain consistent view of the data but it
>> does need flushing to make sure fsync(2) results in data written via mmap
>> to reach persistent storage.
>
> I thought this all changed with the removal of the pcommit
> instruction and wmb_pmem() going away.  Isn't it now a platform
> requirement now that dirty cache lines over persistent memory ranges
> are either guaranteed to be flushed to persistent storage on power
> fail or when required by REQ_FLUSH?

No, nothing automates cache flushing.  The path of a write is:

cpu-cache -> cpu-write-buffer -> bus -> imc -> imc-write-buffer -> media

The ADR mechanism and the wpq-flush facility flush data thorough the
imc (integrated memory controller) to media.  dax_do_io() gets writes
to the imc, but we still need a posted-write-buffer flush mechanism to
guarantee data makes it out to media.


> https://lkml.org/lkml/2016/7/9/131
>
> And part of that is the wmb_pmem() calls are going away?
>
> https://lkml.org/lkml/2016/7/9/136
> https://lkml.org/lkml/2016/7/9/140
>
> i.e. fsync on pmem only needs to take care of writing filesystem
> metadata now, and the pmem driver handles the rest when it gets a
> REQ_FLUSH bio from fsync?
>
> https://lkml.org/lkml/2016/7/9/134
>
> Or have we somehow ended up with the fucked up situation where
> dax_do_io() writes are (effectively) immediately persistent and
> untracked by internal infrastructure, whilst mmap() writes
> require internal dirty tracking and fsync() to flush caches via
> writeback?

dax_do_io() writes are not immediately persistent.  They bypass the
cpu-cache and cpu-write-bufffer and are ready to be flushed to media
by REQ_FLUSH or power-fail on an ADR system.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
