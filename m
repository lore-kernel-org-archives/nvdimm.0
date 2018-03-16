Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0FD2F22135D5D
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 12:03:41 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id c18so9488267oiy.9
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 12:10:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180316190443.GF3671@lst.de>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152112914933.24669.5543317105428477772.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180316190443.GF3671@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Mar 2018 12:10:05 -0700
Message-ID: <CAPcyv4iii7i-W-NvX+PaPfwATuWJamD38cdNUHvP=Cn-5vL3Ww@mail.gmail.com>
Subject: Re: [PATCH v6 12/15] xfs: require mmap lock for xfs_break_layouts()
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 16, 2018 at 12:04 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Mar 15, 2018 at 08:52:29AM -0700, Dan Williams wrote:
>> In preparation for adding coordination between truncate operations and
>> busy dax-pages, extend xfs_break_layouts() to assume it must be called
>> with the mmap lock held. This locking scheme will be required for
>> coordinating the break of 'dax layouts' (non-idle dax (ZONE_DEVICE)
>> pages mapped into the file's address space).
>
> This requirement wasn't really there in the last series, why do we
> require it now?

It seems I misinterpreted your feedback.

>
> As far as I can tell all we'd need is to just drop this assert:
>
>> -     ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
>> +     ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
>> +                             | XFS_MMAPLOCK_EXCL));
>
> entirely.
>
>>       while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
>>               xfs_iunlock(ip, *iolock);
>>               error = break_layout(inode, true);
>> -             *iolock = XFS_IOLOCK_EXCL;
>> +             *iolock &= ~XFS_IOLOCK_SHARED;
>> +             *iolock |= XFS_IOLOCK_EXCL;
>>               xfs_ilock(ip, *iolock);
>
> And take this one hunk from your patch.
>
> To enable the DAX use case.

Yeah, that looks good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
