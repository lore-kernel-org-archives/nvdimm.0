Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A975207E4E17
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 09:29:17 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id h6-v6so6905135otj.0
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 09:29:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180531150716.GA19764@linux.intel.com>
References: <20180531112731.0CAC.E1E9C6FF@jp.fujitsu.com>
 <20180531150716.GA19764@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 May 2018 09:29:15 -0700
Message-ID: <CAPcyv4jpffaM60tTdLTojhh0CDwcbVUdS8td7R6LKWM3bb15dw@mail.gmail.com>
Subject: Re: Question about Experimental of Filesystem DAX.
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
Cc: Jan Kara <jack@suse.cz>, NVDIMM-ML <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Yasunori Goto <y-goto@jp.fujitsu.com>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 31, 2018 at 8:07 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Thu, May 31, 2018 at 11:27:33AM +0900, Yasunori Goto wrote:
>> Hello,
>>
>>
>> I would like to know about the Experimental message of Filesystem DAX.
>> --------------------------------------------------------
>> DAX enabled. Warning: EXPERIMENTAL, use at your own risk
>> --------------------------------------------------------
>>
>> AFAIK, the final issue of Filesystem DAX is metadata update problem,
>> and it is(will be?) solved by great effort of MAP_SYNC and
>> "fix dma vs truncate/hole-punch" patch set.
>> So, I suppose that the Experimental message can be removed,
>> but I'm not sure.
>>
>> Is it possible?
>> Otherwise, are there any other issues in Filesystem DAX yet?
>>
>> If this is silly question, sorry for noise....
>>
>> Thanks,
>> ---
>> Yasunori Goto
>
> Adding in the XFS and ext4 developers, as it's really their call when to
> remove this notice.
>
> We've talked about this off and on for a long while, but IMHO we should remove
> the EXPERIMENTAL warning.  The last few things that we had on our TODO list
> before this was removed were:
>
> 1) Get consistent handling of the DAX mount option.  We currently have this,
> as both filesystems will behave the same and fall back and remove the DAX
> mount option if it is unsupported by the block device, etc.
>
> 2) Get consistent handling of the DAX inode option.  We currently have this,
> as all DAX behavior now happens through the mount option.  If/when we
> re-enable the per-inode DAX flag we should do it consistently for all DAX
> enabled filesystems.
>
> 3) Make DAX work with other XFS features like reflink, etc.  This one isn't
> done, but we at least disallow DAX with XFS features like reflink where it
> could be an issue.  Darrick, do you still feel like we need to get these
> working together to remove EXPERIMENTAL, or are you happy enough that we're
> keeping them separated and that we're keeping user data safe?
>
> Jan and the other ext4 guys, do you have any additional things you need done
> before removing the EXPERIMENTAL warning from ext4 + DAX?

The one's on my list are:

1/ Get proper support for recovering userspace consumed poison in DAX
mappings (may not make 4.18)

2/ The DAX-DMA vs Truncate fix (queued for 4.18).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
