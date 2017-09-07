Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C61321E9781A
 for <linux-nvdimm@lists.01.org>; Thu,  7 Sep 2017 13:51:56 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id z73so1687104oia.2
 for <linux-nvdimm@lists.01.org>; Thu, 07 Sep 2017 13:54:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170906170754.GB17663@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 7 Sep 2017 13:54:45 -0700
Message-ID: <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
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
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Lukas Czerner <lczerner@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 6, 2017 at 10:07 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Tue, Sep 05, 2017 at 09:12:35PM -0500, Eric Sandeen wrote:
>> On 9/5/17 5:35 PM, Ross Zwisler wrote:
>> > The original intent of this series was to add a per-inode DAX flag to ext4
>> > so that it would be consistent with XFS.  In my travels I found and fixed
>> > several related issues in both ext4 and XFS.
>>
>> Hi Ross -
>>
>> hch had a lot of reasons to nuke the dax flag from orbit, and we just
>> /disabled/ it in xfs due to its habit of crashing the kernel...
>
> Ah, sorry, I wasn't CC'd on those threads and missed them.  For any interested
> bystanders:
>
> https://www.spinics.net/lists/linux-ext4/msg57840.html
> https://www.spinics.net/lists/linux-xfs/msg09831.html
> https://www.spinics.net/lists/linux-xfs/msg10124.html
>
>> so a couple questions:
>>
>> 1) does this series pass hch's "test the per-inode DAX flag" fstest?
>
> Nope, it has the exact same problems as the XFS per-inode DAX flag.
>
>> 2) do we have an agreement that we need this flag at all, or is this
>>    just a parity item because xfs has^whad a per-inode flag?
>
> It was for parity, and because it allows admins finer grained control over
> their system.  Basically all things discussed in response to Lukas's original
> patch in the first link above.

I think it's more than parity. When pmem is slower than page cache it
is actively harmful to have DAX enabled globally for a filesystem. So,
not only should we push for per-inode DAX control, we should also push
to deprecate the mount option. I agree with Christoph that we should
try to automatically and transparently enable DAX where it makes
sense, but we also need a finer-grained mechanism than a mount flag to
force the behavior one way or the other.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
