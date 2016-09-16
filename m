Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA1EE1A1EEF
 for <linux-nvdimm@lists.01.org>; Thu, 15 Sep 2016 19:04:28 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id w11so95340575oia.2
 for <linux-nvdimm@lists.01.org>; Thu, 15 Sep 2016 19:04:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160916012458.GW22388@dastard>
References: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147392247875.9873.4205533916442000884.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160915082615.GA9772@lst.de>
 <CAPcyv4jTw3cXpmmJRh7t16Xy2uYofDe+fJ+X_jnz+Q=o0uGneg@mail.gmail.com>
 <20160915230748.GS30497@dastard>
 <CAPcyv4jvcWEc2TkRh6-MoKb_-1VbFoiKUJEB=svQO+BVN8s-Sg@mail.gmail.com>
 <20160916012458.GW22388@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Sep 2016 19:04:27 -0700
Message-ID: <CAPcyv4hoTNw8OM-hoYOqzCS04ZNh+Tv_xhLAiP3AXVcGK6H_mg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm, dax: add VM_DAX flag for DAX VMAs
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
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Nicholas Piggin <npiggin@gmail.com>, XFS Developers <xfs@oss.sgi.com>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 15, 2016 at 6:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Sep 15, 2016 at 05:16:42PM -0700, Dan Williams wrote:
>> On Thu, Sep 15, 2016 at 4:07 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Thu, Sep 15, 2016 at 10:01:03AM -0700, Dan Williams wrote:
>> >> On Thu, Sep 15, 2016 at 1:26 AM, Christoph Hellwig <hch@lst.de> wrote:
>> >> > On Wed, Sep 14, 2016 at 11:54:38PM -0700, Dan Williams wrote:
>> >> >> The DAX property, page cache bypass, of a VMA is only detectable via the
>> >> >> vma_is_dax() helper to check the S_DAX inode flag.  However, this is
>> >> >> only available internal to the kernel and is a property that userspace
>> >> >> applications would like to interrogate.
>> >> >
>> >> > They have absolutely no business knowing such an implementation detail.
>> >>
>> >> Hasn't that train already left the station with FS_XFLAG_DAX?
>> >
>> > No, that's an admin flag, not a runtime hint for applications. Just
>> > because that flag is set on an inode, it does not mean that DAX is
>> > actually in use - it will be ignored if the backing dev is not dax
>> > capable.
>>
>> What's the point of an admin flag if an admin can't do cat /proc/<pid
>> of interest>/smaps, or some other mechanism, to validate that the
>> setting the admin cares about is in effect?
>
> Sorry, I don't follow - why would you be looking at mapping file
> regions in /proc to determine if some file somewhere in a filesystem
> has a specific flag set on it or not?
>
> FS_XFLAG_DAX is an inode attribute flag, not something you can
> query or administrate through mmap:
>
> I.e.
> # xfs_io -c "lsattr" -c "chattr +x" -c lsattr -c "chattr -x" -c "lsattr" foo
>  --------------- foo
>  --------------x foo
>  --------------- foo
> #
>
> What happens when that flag is set on an inode is determined by a
> whole bunch of other things that are completely separate to the
> management of the inode flag itself.

Right, I understand that, but how does an admin audit those "bunch of
other things" that actually gate whether DAX ends up being used in
practice?  There's currently no way for userspace to observe that a
file with FS_XFLAG_DAX actually results in a change in mmap behavior.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
