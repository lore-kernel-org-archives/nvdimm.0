Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9ACF581C8B
 for <linux-nvdimm@lists.01.org>; Fri, 16 Dec 2016 17:35:37 -0800 (PST)
Received: by mail-oi0-x230.google.com with SMTP id v84so95225589oie.3
 for <linux-nvdimm@lists.01.org>; Fri, 16 Dec 2016 17:35:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4giLyY8pWP09V5BmUM+sfGO-VJCtkfV6L-RFS+0XQsT9Q@mail.gmail.com>
References: <20161212164708.23244-1-jack@suse.cz>
 <20161213115209.GG15362@quack2.suse.cz>
 <CAPcyv4giLyY8pWP09V5BmUM+sfGO-VJCtkfV6L-RFS+0XQsT9Q@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Dec 2016 17:35:35 -0800
Message-ID: <CAPcyv4jqN+GkO7pL0QE0vM50MmqPZ1aD2G3YmziKvp+4+oh5gQ@mail.gmail.com>
Subject: Re: [PATCH 0/6 v3] dax: Page invalidation fixes
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
To: Jan Kara <jack@suse.cz>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 13, 2016 at 10:57 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Dec 13, 2016 at 3:52 AM, Jan Kara <jack@suse.cz> wrote:
>> On Mon 12-12-16 17:47:02, Jan Kara wrote:
>>> Hello,
>>>
>>> this is the third revision of my fixes of races when invalidating hole pages in
>>> DAX mappings. See changelogs for details. The series is based on my patches to
>>> write-protect DAX PTEs which are currently carried in mm tree. This is a hard
>>> dependency because we really need to closely track dirtiness (and cleanness!)
>>> of radix tree entries in DAX mappings in order to avoid discarding valid dirty
>>> bits leading to missed cache flushes on fsync(2).
>>>
>>> The tests have passed xfstests for xfs and ext4 in DAX and non-DAX mode.
>>>
>>> Johannes, are you OK with patch 2/6 in its current form? I'd like to push these
>>> patches to some tree once DAX write-protection patches are merged.  I'm hoping
>>> to get at least first three patches merged for 4.10-rc2... Thanks!
>>
>> OK, with the final ack from Johannes and since this is mostly DAX stuff,
>> can we take this through NVDIMM tree and push to Linus either late in the
>> merge window or for -rc2? These patches require my DAX patches sitting in mm
>> tree so they can be included in any git tree only once those patches land
>> in Linus' tree (which may happen only once Dave and Ted push out their
>> stuff - this is the most convoluted merge window I'd ever to deal with ;-)...
>> Dan?
>>
>
> I like the -rc2 plan better than sending a pull request based on some
> random point in the middle of the merge window. I can give Linus a
> heads up in my initial nvdimm pull request for -rc1 that for
> coordination purposes we'll be sending this set of follow-on DAX
> cleanups for -rc2.

So what's still pending for -rc2? I want to be explicit about what I'm
requesting Linus be prepared to receive after -rc1. The libnvdimm pull
request is very light this time around since I ended up deferring the
device-dax-subdivision topic until 4.11 and sub-section memory hotplug
didn't make the cutoff for -mm. We can spend some of that goodwill on
your patches ;-).

I can roll them into libnvdimm-for-next now for the integration
testing coverage, rebase to -rc1 when it's out, wait for your thumbs
up on the testing and send a pull request on the 23rd.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
