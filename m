Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x229.google.com (mail-wm0-x229.google.com
 [IPv6:2a00:1450:400c:c09::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4A7321A1E96
 for <linux-nvdimm@lists.01.org>; Mon,  2 May 2016 10:44:06 -0700 (PDT)
Received: by mail-wm0-x229.google.com with SMTP id a17so154644042wme.0
 for <linux-nvdimm@lists.01.org>; Mon, 02 May 2016 10:44:06 -0700 (PDT)
Message-ID: <572791E1.7000103@plexistor.com>
Date: Mon, 02 May 2016 20:44:01 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>	<5727753F.6090104@plexistor.com>	<CAPcyv4jWPTDbbw6uMFEEt2Kazgw+wb5Pfwroej--uQPE+AtUbA@mail.gmail.com>	<57277EDA.9000803@plexistor.com>
 <CAPcyv4jnz69a3S+XZgLaLojHZmpfoVXGDkJkt_1Q=8kk0gik9w@mail.gmail.com>
In-Reply-To: <CAPcyv4jnz69a3S+XZgLaLojHZmpfoVXGDkJkt_1Q=8kk0gik9w@mail.gmail.com>
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
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew@wil.cx>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 05/02/2016 07:49 PM, Dan Williams wrote:
> On Mon, May 2, 2016 at 9:22 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>> On 05/02/2016 07:01 PM, Dan Williams wrote:
>>> On Mon, May 2, 2016 at 8:41 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>>>> On 04/29/2016 12:16 AM, Vishal Verma wrote:
>>>>> All IO in a dax filesystem used to go through dax_do_io, which cannot
>>>>> handle media errors, and thus cannot provide a recovery path that can
>>>>> send a write through the driver to clear errors.
>>>>>
>>>>> Add a new iocb flag for DAX, and set it only for DAX mounts. In the IO
>>>>> path for DAX filesystems, use the same direct_IO path for both DAX and
>>>>> direct_io iocbs, but use the flags to identify when we are in O_DIRECT
>>>>> mode vs non O_DIRECT with DAX, and for O_DIRECT, use the conventional
>>>>> direct_IO path instead of DAX.
>>>>>
>>>>
>>>> Really? What are your thinking here?
>>>>
>>>> What about all the current users of O_DIRECT, you have just made them
>>>> 4 times slower and "less concurrent*" then "buffred io" users. Since
>>>> direct_IO path will queue an IO request and all.
>>>> (And if it is not so slow then why do we need dax_do_io at all? [Rhetorical])
>>>>
>>>> I hate it that you overload the semantics of a known and expected
>>>> O_DIRECT flag, for special pmem quirks. This is an incompatible
>>>> and unrelated overload of the semantics of O_DIRECT.
>>>
>>> I think it is the opposite situation, it us undoing the premature
>>> overloading of O_DIRECT that went in without performance numbers.
>>
>> We have tons of measurements. Is not hard to imagine the results though.
>> Specially the 1000 threads case
>>
>>> This implementation clarifies that dax_do_io() handles the lack of a
>>> page cache for buffered I/O and O_DIRECT behaves as it nominally would
>>> by sending an I/O to the driver.
>>
>>> It has the benefit of matching the
>>> error semantics of a typical block device where a buffered write could
>>> hit an error filling the page cache, but an O_DIRECT write potentially
>>> triggers the drive to remap the block.
>>>
>>
>> I fail to see how in writes the device error semantics regarding remapping of
>> blocks is any different between buffered and direct IO. As far as the block
>> device it is the same exact code path. All The big difference is higher in the
>> VFS.
>>
>> And ... So you are willing to sacrifice the 99% hotpath for the sake of the
>> 1% error path? and piggybacking on poor O_DIRECT.
>>
>> Again there are tons of O_DIRECT apps out there, why are you forcing them to
>> change if they want true pmem performance?
> 
> This isn't forcing them to change.  This is the path of least surprise
> as error semantics are identical to a typical block device.  Yes, an
> application can go faster by switching to the "buffered" / dax_do_io()
> path it can go even faster to switch to mmap() I/O and use DAX
> directly.  If we can later optimize the O_DIRECT path to bring it's
> performance more in line with dax_do_io(), great, but the
> implementation should be correct first and optimized later.
> 

Why does it need to be either or. Why not both?
And also I disagree if you are correct and dax_do_io is bad and needs fixing
than you have broken applications. Because in current model:

read => -EIO, write-bufferd, sync()
gives you the same error semantics as: read => -EIO, write-direct-io

In fact this is what the delete, restore from backup model does today.
Who said it uses / must direct IO. Actually I think it does not.

Two things I can think of which are better:
[1]
Why not go deeper into the dax io loops, and for any WRITE
failed page call bdev_rw_page() to let the pmem.c clear / relocate
the error page.

So reads return -EIO - is what you wanted no?
writes get a memory error and retry with bdev_rw_page() to let the bdev
relocate / clear the error - is what you wanted no?

In the partial page WRITE case on bad sectors. we can carefully read-modify-write
sector-by-sector and zero-out the bad-sectors that could not be read, what else?
(Or enhance the bdev_rw_page() API)

[2]
Only switch to slow O_DIRECT, on presence of errors like you wanted. But I still
hate that you overload error semantics with O_DIRECT which does not exist today
see above

Thanks
Boaz

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
