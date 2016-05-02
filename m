Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x233.google.com (mail-wm0-x233.google.com
 [IPv6:2a00:1450:400c:c09::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 28AB11A1EDC
 for <linux-nvdimm@lists.01.org>; Mon,  2 May 2016 12:22:14 -0700 (PDT)
Received: by mail-wm0-x233.google.com with SMTP id g17so2370691wme.1
 for <linux-nvdimm@lists.01.org>; Mon, 02 May 2016 12:22:14 -0700 (PDT)
Message-ID: <5727A8E2.8000507@plexistor.com>
Date: Mon, 02 May 2016 22:22:10 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>	<5727753F.6090104@plexistor.com>	<CAPcyv4jWPTDbbw6uMFEEt2Kazgw+wb5Pfwroej--uQPE+AtUbA@mail.gmail.com>	<57277EDA.9000803@plexistor.com>	<CAPcyv4jnz69a3S+XZgLaLojHZmpfoVXGDkJkt_1Q=8kk0gik9w@mail.gmail.com>	<572791E1.7000103@plexistor.com>	<CAPcyv4hGV07gpADT32xn=3brEq75P4RJA592vp-1A+jXMQCeOQ@mail.gmail.com>	<57279D57.5020800@plexistor.com>
 <CAPcyv4i3QteM508fVams8DxzoPTo5AXT6RQQ4=gR-iAN-B4-6g@mail.gmail.com>
In-Reply-To: <CAPcyv4i3QteM508fVams8DxzoPTo5AXT6RQQ4=gR-iAN-B4-6g@mail.gmail.com>
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

On 05/02/2016 09:48 PM, Dan Williams wrote:
<>
>> And then it keeps broken the aligned buffered writes, which are still
>> broken after this set.
> 
> ...identical to the current situation with a traditional disk.
> 

Not true!! please see what I wrote "aligned buffered writes"
If there are no reads involved then there are no errors returned
to application.

>> I have by now read the v2 patches. And I think you guys did not yet try
>> the proper fix for dax_do_io. I think you need to go deeper into the loops
>> and selectively call bdev_* when error on a specific page copy. No need to
>> go through direct_IO path at all.
> 
> We still reach a point where the minimum granularity of
> bdev_direct_access() is larger than a sector, so you end up still
> needing to have the application understand how to send a properly
> aligned I/O.  The semantics of how to send a properly aligned
> direct-I/O are already well understood, so we simply reuse that path.
> 

You are making a mountain out of a mouse. The simple copy of a file
from start (offset ZERO) to end-of-file which is the most common usage
on earth is perfectly aligned and needs not any O_DIRECT and is what is used
everywhere.

>> Do you need that I send you a patch to demonstrate what I mean?
> 
> I remain skeptical of what you are proposing, but yes, a patch has a
> better chance to move the discussion forward.
> 

Sigh! OK
Boaz

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
