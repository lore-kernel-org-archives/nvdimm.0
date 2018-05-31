Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2DFB52063D753
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 11:26:45 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id 11-v6so20325419ois.8
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 11:26:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180531174636.GA7825@magnolia>
References: <20180531112731.0CAC.E1E9C6FF@jp.fujitsu.com>
 <20180531150716.GA19764@linux.intel.com>
 <CAPcyv4jpffaM60tTdLTojhh0CDwcbVUdS8td7R6LKWM3bb15dw@mail.gmail.com>
 <20180531174636.GA7825@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 May 2018 11:26:43 -0700
Message-ID: <CAPcyv4gS1GCN9TFjngTmmHu83-uMgRpvvx842ZGnvxB3PbgU+Q@mail.gmail.com>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>, NVDIMM-ML <linux-nvdimm@lists.01.org>, linux-xfs <linux-xfs@vger.kernel.org>, Yasunori Goto <y-goto@jp.fujitsu.com>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 31, 2018 at 10:46 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, May 31, 2018 at 09:29:15AM -0700, Dan Williams wrote:
>> On Thu, May 31, 2018 at 8:07 AM, Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>> > On Thu, May 31, 2018 at 11:27:33AM +0900, Yasunori Goto wrote:
>> >> Hello,
>> >>
>> >>
>> >> I would like to know about the Experimental message of Filesystem DAX.
>> >> --------------------------------------------------------
>> >> DAX enabled. Warning: EXPERIMENTAL, use at your own risk
>> >> --------------------------------------------------------
>> >>
>> >> AFAIK, the final issue of Filesystem DAX is metadata update problem,
>> >> and it is(will be?) solved by great effort of MAP_SYNC and
>> >> "fix dma vs truncate/hole-punch" patch set.
>> >> So, I suppose that the Experimental message can be removed,
>> >> but I'm not sure.
>> >>
>> >> Is it possible?
>> >> Otherwise, are there any other issues in Filesystem DAX yet?
>> >>
>> >> If this is silly question, sorry for noise....
>> >>
>> >> Thanks,
>> >> ---
>> >> Yasunori Goto
>> >
>> > Adding in the XFS and ext4 developers, as it's really their call when to
>> > remove this notice.
>> >
>> > We've talked about this off and on for a long while, but IMHO we should remove
>> > the EXPERIMENTAL warning.  The last few things that we had on our TODO list
>> > before this was removed were:
>> >
>> > 1) Get consistent handling of the DAX mount option.  We currently have this,
>> > as both filesystems will behave the same and fall back and remove the DAX
>> > mount option if it is unsupported by the block device, etc.
>
> <nod>
>
> As an aside, I wonder if Christoph's musings about "just have the kernel
> determine the appropriate dax/non-dax setting from the acpi tables and
> skip the inode flag entirely" ever got resolved?
>
>> > 2) Get consistent handling of the DAX inode option.  We currently have this,
>> > as all DAX behavior now happens through the mount option.  If/when we
>> > re-enable the per-inode DAX flag we should do it consistently for all DAX
>> > enabled filesystems.
>
> The behavior of the inode flag isn't all that consistent.  ext4 doesn't
> support it at all.  On XFS, you can set or clear FS_XFLAG_DAX on a
> directory which will propagate the setting to any files created in that
> directory.
>
> However, if you set or clear it on a file we update the on-disk inode
> but we can't change the in-core state flag (S_DAX) until the next
> in-core inode instantiation.  It's weird that users can change the flag
> but the intended behavior changes won't happen until some ... time ...
> in the future??
>
>> > 3) Make DAX work with other XFS features like reflink, etc.  This one isn't
>> > done, but we at least disallow DAX with XFS features like reflink where it
>> > could be an issue.  Darrick, do you still feel like we need to get these
>> > working together to remove EXPERIMENTAL, or are you happy enough that we're
>> > keeping them separated and that we're keeping user data safe?
>
> Yes, reflink and dax still need to work together.  I've not heard any
> good arguments for why page sharing + copy on write are fundamentally
> incompatible with the dax model, or why dax users will never, ever
> require reflink.

Right, but that's separate from DAX being scream in your face
"EXPERIMENTAL!". It's just an additional feature that can be added on
once all the normal expectations of a userspace mapping work. I think
reliable rmap is the last of those requirements.

> The recent thread between Jan and Dan make me wonder if making mappings
> share struct pages is going to be a nightmare to add to the mm code,
> though...

It's going to be a bit messy because a singular page->mapping
association is fundamentally incompatible with DAX. Perhaps a linked
list of mapping "siblings"?

> Also: ideally XFS would also be able to consume poison event
> notifications from the pmem so that it can try to deal with metadata
> loss, but that's probably a separate effort.

Right, not a gating item for declaring DAX ready for prime time.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
