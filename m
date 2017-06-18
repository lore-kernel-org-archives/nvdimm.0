Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D5E621CA3596
 for <linux-nvdimm@lists.01.org>; Sat, 17 Jun 2017 22:04:47 -0700 (PDT)
Received: from mail-ua0-f172.google.com (mail-ua0-f172.google.com
 [209.85.217.172])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 00D7523A0A
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 05:06:06 +0000 (UTC)
Received: by mail-ua0-f172.google.com with SMTP id 68so43842357uas.0
 for <linux-nvdimm@lists.01.org>; Sat, 17 Jun 2017 22:06:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iPb69e+rE3fJUzm9U_P_dLfhantU9mvYmV-R0oQee4rA@mail.gmail.com>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766213493.22552.4057048843646200083.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CALCETrU1Hg=q4cdQDex--3nVBfwRC1o=9pC6Ss77Z8Lxg7ZJLg@mail.gmail.com>
 <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g@mail.gmail.com>
 <CALCETrUfv26pvmyQ1gOkKbzfSXK2DnmeBG6VmSWjFy1WBhknTw@mail.gmail.com>
 <CAPcyv4iPb69e+rE3fJUzm9U_P_dLfhantU9mvYmV-R0oQee4rA@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Sat, 17 Jun 2017 22:05:45 -0700
Message-ID: <CALCETrVY38h2ajpod2U_2pdHSp8zO4mG2p19h=OnnHmhGTairw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
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
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, andy.rudoff@intel.com
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jun 17, 2017 at 8:15 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Sat, Jun 17, 2017 at 4:50 PM, Andy Lutomirski <luto@kernel.org> wrote:
>> My other objection is that the syscall intentionally leaks a reference
>> to the file.  This means it needs overflow protection and it probably
>> shouldn't ever be allowed to use it without privilege.
>
> We only hold the one reference while S_DAXFILE is set, so I think the
> protection is there, and per Dave's original proposal this requires
> CAP_LINUX_IMMUTABLE.
>
>> Why can't the underlying issue be easily fixed, though?  Could
>> .page_mkwrite just make sure that metadata is synced when the FS uses
>> DAX?
>
> Yes, it most definitely could and that idea has been floated.
>
>> On a DAX fs, syncing metadata should be extremely fast.  This
>> could be conditioned on an madvise or mmap flag if performance might
>> be an issue.  As far as I know, this change alone should be
>> sufficient.
>
> The hang up is that it requires per-fs enabling as it needs to be
> careful to manage mmap_sem vs fs journal locks for example. I know the
> in-development NOVA [1] filesystem is planning to support this out of
> the gate. ext4 would be open to implementing it, but I think xfs is
> cold on the idea. Christoph originally proposed it here [2], before
> Dave went on to propose immutable semantics.

Hmm.  Given a choice between a very clean API that works without
privilege but is awkward to implement on XFS and an awkward-to-use
API, I'd personally choose the former.

Dave, even with the lock ordering issue, couldn't XFS implement
MAP_PMEM_AWARE by having .page_mkwrite work roughly like this:

if (metadata is dirty) {
  up_write(&mmap_sem);
  sync the metadata;
  down_write(&mmap_sem);
  return 0;  /* retry the fault */
} else {
  return whatever success code;
}

This might require returning VM_FAULT_RETRY instead of 0 and it might
require auditing the core mm code to make sure that it can handle
mmap_sem being dropped like this.  I don't see why it couldn't work in
principle, though.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
