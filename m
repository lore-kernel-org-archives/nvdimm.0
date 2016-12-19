Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5DFA820A4
 for <linux-nvdimm@lists.01.org>; Mon, 19 Dec 2016 01:56:26 -0800 (PST)
Date: Mon, 19 Dec 2016 10:56:23 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/6 v3] dax: Page invalidation fixes
Message-ID: <20161219095623.GE17598@quack2.suse.cz>
References: <20161212164708.23244-1-jack@suse.cz>
 <20161213115209.GG15362@quack2.suse.cz>
 <CAPcyv4giLyY8pWP09V5BmUM+sfGO-VJCtkfV6L-RFS+0XQsT9Q@mail.gmail.com>
 <CAPcyv4jqN+GkO7pL0QE0vM50MmqPZ1aD2G3YmziKvp+4+oh5gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jqN+GkO7pL0QE0vM50MmqPZ1aD2G3YmziKvp+4+oh5gQ@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 16-12-16 17:35:35, Dan Williams wrote:
> On Tue, Dec 13, 2016 at 10:57 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Tue, Dec 13, 2016 at 3:52 AM, Jan Kara <jack@suse.cz> wrote:
> >> On Mon 12-12-16 17:47:02, Jan Kara wrote:
> >>> Hello,
> >>>
> >>> this is the third revision of my fixes of races when invalidating hole pages in
> >>> DAX mappings. See changelogs for details. The series is based on my patches to
> >>> write-protect DAX PTEs which are currently carried in mm tree. This is a hard
> >>> dependency because we really need to closely track dirtiness (and cleanness!)
> >>> of radix tree entries in DAX mappings in order to avoid discarding valid dirty
> >>> bits leading to missed cache flushes on fsync(2).
> >>>
> >>> The tests have passed xfstests for xfs and ext4 in DAX and non-DAX mode.
> >>>
> >>> Johannes, are you OK with patch 2/6 in its current form? I'd like to push these
> >>> patches to some tree once DAX write-protection patches are merged.  I'm hoping
> >>> to get at least first three patches merged for 4.10-rc2... Thanks!
> >>
> >> OK, with the final ack from Johannes and since this is mostly DAX stuff,
> >> can we take this through NVDIMM tree and push to Linus either late in the
> >> merge window or for -rc2? These patches require my DAX patches sitting in mm
> >> tree so they can be included in any git tree only once those patches land
> >> in Linus' tree (which may happen only once Dave and Ted push out their
> >> stuff - this is the most convoluted merge window I'd ever to deal with ;-)...
> >> Dan?
> >>
> >
> > I like the -rc2 plan better than sending a pull request based on some
> > random point in the middle of the merge window. I can give Linus a
> > heads up in my initial nvdimm pull request for -rc1 that for
> > coordination purposes we'll be sending this set of follow-on DAX
> > cleanups for -rc2.
> 
> So what's still pending for -rc2? I want to be explicit about what I'm
> requesting Linus be prepared to receive after -rc1. The libnvdimm pull
> request is very light this time around since I ended up deferring the
> device-dax-subdivision topic until 4.11 and sub-section memory hotplug
> didn't make the cutoff for -mm. We can spend some of that goodwill on
> your patches ;-).

;-) So I'd like all these 6 patches to go for rc2. The first three patches
fix invalidation of exceptional DAX entries (a bug which is there for a
long time) - without these patches data loss can occur on power failure
even though user called fsync(2). The other three patches change locking of
DAX faults so that ->iomap_begin() is called in a more relaxed locking
context and we are safe to start a transaction there for ext4.

> I can roll them into libnvdimm-for-next now for the integration
> testing coverage, rebase to -rc1 when it's out, wait for your thumbs
> up on the testing and send a pull request on the 23rd.

Yup, all prerequisites are merged now so you can pick these patches up.
Thanks! Note that I'll be on vacation on Dec 23 - Jan 1.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
