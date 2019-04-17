Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
 by ml01.01.org (Postfix) with ESMTP id A42E3212017F3
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 19:06:20 -0700 (PDT)
Subject: Re: [RFC PATCH 0/4] xfs: add handle for reflink in dax
References: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
 <20190417013431.GE24622@magnolia>
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <d1030515-ae5f-5c33-9c43-82720109351e@cn.fujitsu.com>
Date: Wed, 17 Apr 2019 10:06:15 +0800
MIME-Version: 1.0
In-Reply-To: <20190417013431.GE24622@magnolia>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 4/17/19 9:34 AM, Darrick J. Wong wrote:
> On Wed, Apr 18, 2019 at 09:27:11AM +0800, Shiyang Ruan wrote:
>> In XFS (under fsdax mode), reflink did not work correctly because xfs
>> iomap operators did not handle the inode with both reflink and dax flag.
>>
>> This patchset aims to take care of this issue to make COW operation work
>> correctly in XFS.
>>
>> XFS uses iomap to do read/write/mmap operations:
>>    vfs interface       xfs:
>>      iomap_bengin();     --> xfs_iomap_begin();
>>      actor();            --> dax_iomap_actor() / mmap actor function
>>      iomap_end();        --> xfs_iomap_end();
>>
>> In xfs_iomap_begin(), COW operation is detected but not told to actor
>> function.  To resolve this, a new field 'src_addr' is added into
>> 'struct iomap' to pass this COW info.  It means the start address of
>> source blocks in a COW operation, for actor functions to copy data
>> before writing.
>>
>> In actor functions, the value of iomap->src_addr determines if it is a
>> COW operation.  If it is, copy data from source blocks to destination
>> blocks first, and then write user data.
>>
>> After the COW operation, it is supposed to update the metadata of the
>> inode.  Added in xfs_iomap_end().
> 
> How do the fs/iomap.c changes in your series compare with Goldwyn's
> "btrfs dax support" series that he put out today?
Sorry, I think I missed his series.  Will check it right now.
> 
> Also, there are a few things missing:
> 
> 1. A DAX-compatible file contents comparison function for the dedupe
> ioctl.
> 
> 2. Checks that we aren't trying to reflink or dedupe between S_DAX and
> !S_DAX files.
> 
> 3. Do we need to make changes to the hairy
> xfs_iolock_two_inodes_and_break_layout function to handle DAX?  Seeing
> as it doesn't call xfs_break_dax_layouts...
Thanks for your comments.  I did not think carefully about 'dedupe'. 
Will take this into consideration.

--
Thanks,
Shiyang Ruan.
> 
> --D
> 
>>
>>
>> Shiyang Ruan (4):
>>    fs/iomap: Introduce src_addr for COW in fsdax mode.
>>    fs/xfs: iomap: add handle for reflink in fsdax mode
>>    fs/dax: copy source blocks before writing when COW
>>    fs/xfs: iomap: update the extent list after a COW
>>
>>   fs/dax.c              | 70 +++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_iomap.c    | 23 +++++++++++---
>>   include/linux/iomap.h |  4 +++
>>   3 files changed, 93 insertions(+), 4 deletions(-)
>>
>> -- 
>> 2.17.0
>>
>>
>>
> 
> 


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
