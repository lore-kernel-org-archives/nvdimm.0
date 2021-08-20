Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C003FC2
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 06:13:33 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AQfYmx6NPgQXlSMBcTv2jsMiBIKoaSvp037BL?=
 =?us-ascii?q?7TEUdfUxSKGlfq+V8sjzqiWftN98YhAdcLO7Scy9qBHnhP1ICOAqVN/MYOCMgh?=
 =?us-ascii?q?rLEGgN1+vf6gylMyj/28oY7q14bpV5YeeaMXFKyer8/ym0euxN/OW6?=
X-IronPort-AV: E=Sophos;i="5.84,336,1620662400"; 
   d="scan'208";a="113175900"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 20 Aug 2021 14:13:31 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 0F8284D0D49D;
	Fri, 20 Aug 2021 14:13:28 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 20 Aug 2021 14:13:28 +0800
Received: from irides.mr (10.167.225.141) by G08CNEXCHPEKD09.g08.fujitsu.local
 (10.167.33.209) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Fri, 20 Aug 2021 14:13:27 +0800
Subject: Re: [PATCH v7 7/8] fsdax: Introduce dax_iomap_ops for end of reflink
To: Dan Williams <dan.j.williams@intel.com>
CC: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs <linux-xfs@vger.kernel.org>, david <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com>
 <20210816060359.1442450-8-ruansy.fnst@fujitsu.com>
 <CAPcyv4jbi=p=SjFYZcHnEAu+KY821pW_k_yA5u6hya4jEfrTUg@mail.gmail.com>
From: ruansy.fnst <ruansy.fnst@fujitsu.com>
Message-ID: <c7e68dc8-5a43-f727-c262-58dcf244c711@fujitsu.com>
Date: Fri, 20 Aug 2021 14:13:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jbi=p=SjFYZcHnEAu+KY821pW_k_yA5u6hya4jEfrTUg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: 0F8284D0D49D.A3BCD
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



On 2021/8/20 上午11:01, Dan Williams wrote:
> On Sun, Aug 15, 2021 at 11:05 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>>
>> After writing data, reflink requires end operations to remap those new
>> allocated extents.  The current ->iomap_end() ignores the error code
>> returned from ->actor(), so we introduce this dax_iomap_ops and change
>> the dax_iomap_*() interfaces to do this job.
>>
>> - the dax_iomap_ops contains the original struct iomap_ops and fsdax
>>      specific ->actor_end(), which is for the end operations of reflink
>> - also introduce dax specific zero_range, truncate_page
>> - create new dax_iomap_ops for ext2 and ext4
>>
>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>> ---
>>   fs/dax.c               | 68 +++++++++++++++++++++++++++++++++++++-----
>>   fs/ext2/ext2.h         |  3 ++
>>   fs/ext2/file.c         |  6 ++--
>>   fs/ext2/inode.c        | 11 +++++--
>>   fs/ext4/ext4.h         |  3 ++
>>   fs/ext4/file.c         |  6 ++--
>>   fs/ext4/inode.c        | 13 ++++++--
>>   fs/iomap/buffered-io.c |  3 +-
>>   fs/xfs/xfs_bmap_util.c |  3 +-
>>   fs/xfs/xfs_file.c      |  8 ++---
>>   fs/xfs/xfs_iomap.c     | 36 +++++++++++++++++++++-
>>   fs/xfs/xfs_iomap.h     | 33 ++++++++++++++++++++
>>   fs/xfs/xfs_iops.c      |  7 ++---
>>   fs/xfs/xfs_reflink.c   |  3 +-
>>   include/linux/dax.h    | 21 ++++++++++---
>>   include/linux/iomap.h  |  1 +
>>   16 files changed, 189 insertions(+), 36 deletions(-)
>>
>> diff --git a/fs/dax.c b/fs/dax.c
>> index 74dd918cff1f..0e0536765a7e 100644
>> --- a/fs/dax.c
>> +++ b/fs/dax.c
>> @@ -1348,11 +1348,30 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>>          return done ? done : ret;
>>   }
>>
>> +static inline int
>> +__dax_iomap_iter(struct iomap_iter *iter, const struct dax_iomap_ops *ops)
>> +{
>> +       int ret;
>> +
>> +       /*
>> +        * Call dax_iomap_ops->actor_end() before iomap_ops->iomap_end() in
>> +        * each iteration.
>> +        */
>> +       if (iter->iomap.length && ops->actor_end) {
>> +               ret = ops->actor_end(iter->inode, iter->pos, iter->len,
>> +                                    iter->processed);
>> +               if (ret < 0)
>> +                       return ret;
>> +       }
>> +
>> +       return iomap_iter(iter, &ops->iomap_ops);
> 
> This reorganization looks needlessly noisy. Why not require the
> iomap_end operation to perform the actor_end work. I.e. why can't
> xfs_dax_write_iomap_actor_end() just be the passed in iomap_end? I am
> not seeing where the ->iomap_end() result is ignored?
> 

The V6 patch[1] was did in this way.
[1]https://lore.kernel.org/linux-xfs/20210526005159.GF202144@locust/T/#m79a66a928da2d089e2458c1a97c0516dbfde2f7f

But Darrick reminded me that ->iomap_end() will always take zero or 
positive 'written' because iomap_apply() handles this argument.

```
	if (ops->iomap_end) {
		ret = ops->iomap_end(inode, pos, length,
				     written > 0 ? written : 0,
				     flags, &iomap);
	}
```

So, we cannot get actual return code from CoW in ->actor(), and as a 
result, we cannot handle the xfs end_cow correctly in ->iomap_end(). 
That's where the result of CoW was ignored.


--
Thanks,
Ruan.



