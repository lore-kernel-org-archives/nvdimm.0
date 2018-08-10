Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com
 [IPv6:2607:f8b0:4864:20::943])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C15BE210E38C2
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 12:25:08 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id u11-v6so3037032uan.13
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 12:25:08 -0700 (PDT)
MIME-Version: 1.0
References: <153374942137.42241.10539674028265137668.stgit@djiang5-desk3.ch.intel.com>
 <be8603ab-ccb2-3f0d-4dbf-7935fc3ed357@redhat.com>
 <c4580e0d-e403-88a4-0e3a-7be8d0489f09@intel.com>
In-Reply-To: <c4580e0d-e403-88a4-0e3a-7be8d0489f09@intel.com>
From: Ross Zwisler <zwisler@gmail.com>
Date: Fri, 10 Aug 2018 09:24:54 -1000
Message-ID: <CAOxpaSWwfd4Wat3v_iH1QymGh51QdcK1=7fsOUeXrdfqui4K=g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] [PATCH] xfs: Close race between direct IO and
 xfs_break_layouts()
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
To: dave.jiang@intel.com
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, lczerner@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 10, 2018 at 9:23 AM Dave Jiang <dave.jiang@intel.com> wrote:
> On 08/10/2018 11:31 AM, Eric Sandeen wrote:
> > On 8/8/18 12:31 PM, Dave Jiang wrote:
> >> This patch is the duplicate of ross's fix for ext4 for xfs.
> >>
> >> If the refcount of a page is lowered between the time that it is returned
> >> by dax_busy_page() and when the refcount is again checked in
> >> xfs_break_layouts() => ___wait_var_event(), the waiting function
> >> xfs_wait_dax_page() will never be called.  This means that
> >> xfs_break_layouts() will still have 'retry' set to false, so we'll stop
> >> looping and never check the refcount of other pages in this inode.
> >>
> >> Instead, always continue looping as long as dax_layout_busy_page() gives us
> >> a page which it found with an elevated refcount.
> >
> > Hi Dave, does this have a testcase?  Have you seen the issue using Ross's
> > xfstest generic/503 or is there some other test?  Apologies if I missed
> > prior discussion on a testcase or race frequency...
>
> I do not have a testcase. I know Ross replicated it on ext4. And Jan
> asked to create the same fix with XFS when he reviewed Ross's fix for ext4.

In my testing I couldn't get this race to hit with XFS.  I couldn't
even get a failure with generic/503 when testing XFS before Dan's
initial patches went in which added xfs_break_layouts() et al.  I
think that Dan had to manually insert timing delays to get the warning
to hit for XFS when testing his patches.

The race we're fixing happens consistently with ext4 and through code
inspection we can see that the race exists in XFS.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
