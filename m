Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
 by ml01.01.org (Postfix) with ESMTP id 521F92128DD28
 for <linux-nvdimm@lists.01.org>; Tue, 28 May 2019 19:18:03 -0700 (PDT)
Subject: Re: [PATCH 04/18] dax: Introduce IOMAP_DAX_COW to CoW edges during
 writes
References: <20190429172649.8288-1-rgoldwyn@suse.de>
 <20190429172649.8288-5-rgoldwyn@suse.de> <20190521165158.GB5125@magnolia>
 <1e9951c1-d320-e480-3130-dc1f4b81ef2c@cn.fujitsu.com>
 <20190523115109.2o4txdjq2ft7fzzc@fiona>
 <1620c513-4ce2-84b0-33dc-2675246183ea@cn.fujitsu.com>
 <20190528091729.GD9607@quack2.suse.cz>
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <a3a919e6-ecad-bdf6-423c-fc01f9cfa661@cn.fujitsu.com>
Date: Wed, 29 May 2019 10:01:58 +0800
MIME-Version: 1.0
In-Reply-To: <20190528091729.GD9607@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: kilobyte@angband.pl, "Darrick J. Wong" <darrick.wong@oracle.com>, nborisov@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-nvdimm@lists.01.org, david@fromorbit.com, dsterba@suse.cz, willy@infradead.org, linux-fsdevel@vger.kernel.org, hch@lst.de, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


On 5/28/19 5:17 PM, Jan Kara wrote:
> On Mon 27-05-19 16:25:41, Shiyang Ruan wrote:
>> On 5/23/19 7:51 PM, Goldwyn Rodrigues wrote:
>>>>
>>>> Hi,
>>>>
>>>> I'm working on reflink & dax in XFS, here are some thoughts on this:
>>>>
>>>> As mentioned above: the second iomap's offset and length must match the
>>>> first.  I thought so at the beginning, but later found that the only
>>>> difference between these two iomaps is @addr.  So, what about adding a
>>>> @saddr, which means the source address of COW extent, into the struct iomap.
>>>> The ->iomap_begin() fills @saddr if the extent is COW, and 0 if not.  Then
>>>> handle this @saddr in each ->actor().  No more modifications in other
>>>> functions.
>>>
>>> Yes, I started of with the exact idea before being recommended this by Dave.
>>> I used two fields instead of one namely cow_pos and cow_addr which defined
>>> the source details. I had put it as a iomap flag as opposed to a type
>>> which of course did not appeal well.
>>>
>>> We may want to use iomaps for cases where two inodes are involved.
>>> An example of the other scenario where offset may be different is file
>>> comparison for dedup: vfs_dedup_file_range_compare(). However, it would
>>> need two inodes in iomap as well.
>>>
>> Yes, it is reasonable.  Thanks for your explanation.
>>
>> One more thing RFC:
>> I'd like to add an end-io callback argument in ->dax_iomap_actor() to update
>> the metadata after one whole COW operation is completed.  The end-io can
>> also be called in ->iomap_end().  But one COW operation may call
>> ->iomap_apply() many times, and so does the end-io.  Thus, I think it would
>> be nice to move it to the bottom of ->dax_iomap_actor(), called just once in
>> each COW operation.
> 
> I'm sorry but I don't follow what you suggest. One COW operation is a call
> to dax_iomap_rw(), isn't it? That may call iomap_apply() several times,
> each invocation calls ->iomap_begin(), ->actor() (dax_iomap_actor()),
> ->iomap_end() once. So I don't see a difference between doing something in
> ->actor() and ->iomap_end() (besides the passed arguments but that does not
> seem to be your concern). So what do you exactly want to do?

Hi Jan,

Thanks for pointing out, and I'm sorry for my mistake.  It's 
->dax_iomap_rw(), not ->dax_iomap_actor().

I want to call the callback function at the end of ->dax_iomap_rw().

Like this:
dax_iomap_rw(..., callback) {

     ...
     while (...) {
         iomap_apply(...);
     }

     if (callback != null) {
         callback();
     }
     return ...;
}

> 
> 								Honza
> 

-- 
Thanks,
Shiyang Ruan.


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
