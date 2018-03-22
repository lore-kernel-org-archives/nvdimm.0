Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22b.google.com (mail-ot0-x22b.google.com
 [IPv6:2607:f8b0:4003:c0f::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 994272252CBDA
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 08:44:12 -0700 (PDT)
Received: by mail-ot0-x22b.google.com with SMTP id i28-v6so9955965otf.8
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 08:50:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180322072734.GB28713@lst.de>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167310580.5268.18270880990191450094.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180322072734.GB28713@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Mar 2018 08:50:43 -0700
Message-ID: <CAPcyv4hPR4fFH61Vg5ik=GCnBgrC9+vN==A146YqB9Dts8Fv0g@mail.gmail.com>
Subject: Re: [PATCH v7 13/14] xfs: prepare xfs_break_layouts() for another
 layout type
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

On Thu, Mar 22, 2018 at 12:27 AM, Christoph Hellwig <hch@lst.de> wrote:
>> +     ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
>> +                             | (reason == BREAK_UNMAPI
>> +                                     ? XFS_MMAPLOCK_EXCL : 0)));
>
> please split the assert, e.g.:
>
>         ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
>
>         switch (reason) {
> +       case BREAK_UNMAPI:
>                 ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));

Sure, I was thinking to keep it out of the loop, but the common case
is that this loop only iterates once.

>> +             /* fall through */
>> +     case BREAK_WRITE:
>> +             error = xfs_break_leased_layouts(inode, iolock, &did_unlock);
>> +             break;
>> +     default:
>> +             error = -EINVAL;
>> +             break;
>> +     }
>> +
>> +     return error;
>
> I have to say I'd prefer BREAK_UNMAP over BREAK_UNMAPI given that weird
> I suffix doesn't buy us anything, but that's just a minor issue.

Ok will do.

> Otherwise looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
