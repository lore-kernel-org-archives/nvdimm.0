Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <552BC660.4000202@plexistor.com>
Date: Mon, 13 Apr 2015 16:36:32 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [GIT PULL] PMEM driver for v4.1
References: <20150413093309.GA30219@gmail.com> <20150413093541.GA5147@lst.de> <20150413104531.GB30556@gmail.com> <552BB4CA.6060808@plexistor.com> <20150413123535.GA2666@gmail.com>
In-Reply-To: <20150413123535.GA2666@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 04/13/2015 03:35 PM, Ingo Molnar wrote:
> 
<>
> 
> How does splice work with DAX files? AFAICS vmsplice() won't work, as 
> it uses get_user_pages(), which needs struct page backing. Also, how 
> will f_op->sendpage() work? That too needs page backing.
> 

I'm not sure about f_op->sendpage(). I do not see it in ext4 so I assumed
it works through f_op->splice_read/write.

The way f_op->splice_XX works is through the read/write_iter system
and this one is fully supported with DAX. It will do an extra copy.

[You can see this patch in linux-next:
	8b22559 dax: unify ext2/4_{dax,}_file_operations
 that explains a bit about this issue
]

>>>    - zero copy O_DIRECT into DAX areas.
>>
>> DAX is always O_DIRECT.
>>
>> What does not work is mmap of DAX file and use that pointer in an
>> O_DIRECT operation of another device. (unless it is a DAX device)
> 
> That is what I meant: O_DIRECT into (or from) DAX mmap()-ed areas, 
> from a different device.
> 

Yes. For me the one missing the most is RDMA to/from pmem copy-less.

Is why I'm pushing for my page-struct patches. But so far people
rejected it. I hope to resend it soon, once the dust settles and see
if people might change their mind.

> I'm not promoting the use of these APIs, some of them are quirky, just 
> wanted to list the known limitations. The pmem driver is already 
> useful as-is.
> 
> Thanks,
> 	Ingo
> 

Thanks
Boaz

