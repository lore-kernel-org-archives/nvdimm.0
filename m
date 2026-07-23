Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD7217DFFA;
	Thu, 23 Jul 2026 00:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766768; cv=none; b=XnkvpAD2ZTnLAzTF3Xo0m/j8On+KJ4hIPvwlbPjuwgFARX3LSzmhfsPv4HvUnFwoY8JEAcglEuZ5X414CPfCaHQtAQJKHC7hILCKf+vtdmcrmmep4cBpLEqeTPCSNcAPvufTR6AW7kEh+TW7yL7jL7TIFDhtJBbXJVDD29jDQ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766768; c=relaxed/simple;
	bh=M9B31YLQtpF4cz1ZHqD33idr8KjQadhKu42Qbpq5Lrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T9KQ2PCgNXu/cqjMkrpIbE7AWFaHj3fvdsTUgI3DI5FYPTS5tn3XPDl0vvLc9fupB9Z9Xpglfs+/XjepLqQ2hP3040XTGJiaPg14pttCMX7XlusWsV18NHWecMJjoq2/hr4/dIwNEYsEZ5bNPH17k9ZywY5m4ubgfuX+vdhChNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA2631A02DD;
	Thu, 23 Jul 2026 00:32:36 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf01.hostedemail.com (Postfix) with ESMTPA id B43DA60011;
	Thu, 23 Jul 2026 00:32:24 +0000 (UTC)
Date: Wed, 22 Jul 2026 19:32:23 -0500
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, John Groves <john@jagalactic.com>, 
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH V11 0/9] famfs: port into fuse
Message-ID: <amFMUtTB4SmHdYZx@groves.net>
References: <20260720034358.68714-1-john@jagalactic.com>
 <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <CAOQ4uxiEzP2e=cRw-AiGxtSv6WMSA5yR3cmgrF97s7ggU6wzqg@mail.gmail.com>
 <CAJfpegt9PwHksYhsQZeCsW0eooXVVihyieTpeHMmC-+Pq8BWaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt9PwHksYhsQZeCsW0eooXVVihyieTpeHMmC-+Pq8BWaw@mail.gmail.com>
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: B43DA60011
X-Stat-Signature: 7yr1sarh6hzcmabc5jh4fdgk6g17o9r7
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX19PLbwf5afhZYu7h/oU37HdgP6ZNBNAzIg=
X-HE-Tag: 1784766744-980457
X-HE-Meta: U2FsdGVkX1+odIWLjAHw/PDf22XXSEFf+/xiKe4A+w5oYnabDwp1+vQnLGdBFVEGfX0EnfDgOj5KaiE54GiHPvksAFYhngTBrn/zjDaXw86/zYubmfz2O2zJLsVu8Uy72vcGjQrb64+z+tzDk3OeUSmVwA+l2eY5et0gVe8Z7ClhvlqrzJ8p2NIYcoGxYoT03+KXGLyponLeh+fbWSweq14mEJ2TiJXaRqtnsTXmvt8yZJg16d5M7PYpn55bDKBKeeG/65osjlxqmT0iZFj0PeobY+ASF+tPedASLJ+jPARv7o/6I6tz5pwO/dzmVIuNmJLfEGxtBEQhFADtDXCY5+RUubagCNDm

On 26/07/22 12:46PM, Miklos Szeredi wrote:
> On Mon, 20 Jul 2026 at 12:07, Amir Goldstein <amir73il@gmail.com> wrote:
> 
> > It's not about this ioctl, it's about infrastructure reuse.
> > It's about the fact that there is NOTHING special about dax_devlist;
> > and no reason not to manage it via backing_files_map.
> >
> > The reason you stated was that you want userspace to determine the
> > daxdev_index/backing_id - fine, no problem - this is why I asked that
> > you pass it the desired backing_id in the ioctl.
> > In fact I think that all fuse backing_ids would be better assigned by user space
> > so the extension of padding => backing_id is not unique to famfs.
> 
> Right, so I suggest to just reuse FUSE_DEV_IOC_BACKING_OPEN and add
> two flags: one to enable user supplied backing ID and the other to
> indicate that fd refers to DAX device.  The changes to do compared to
> the current patchset are quite minimal.
> 
> > And the best part is that this request requires no changes to your userspace.
> > You already bite the bullet and maintain the new/old uapi but changing the
> > kernel implementation does not require this burden from you, so to be honest
> > I really don't understand why you did not follow Miklos' suggestion.
> 
> Code reuse is also important, but I understand John's position to want
> to separate famfs from existing codebase as much as possible.  And
> because this is an implementation detail I don't want to make this a
> show stopper.  We can easily fix it later.
> 
> > > - Lose the famfs interleaved extent format. I have complied with this request.
> > >   It makes some things worse, but we'll discuss that later.
> > >
> >
> > I am really not aware of a request to lose the interleaved extent format.
> > How can this patch [2] from Miklos which reimplements this format as a generic
> > uapi be mistaken for a request to lose this format?
> 
> Let's not care.  We can easily add this later if famfs (or any other
> use case) decides to want this after all.
> 
> Making the initial patchset smaller is win in any case.
> 
> > Let me recap the former review requests as I understand them:
> >
> > 1. Use ioctl instead of GET_DAXDEV
> 
> This is done, just need to reuse the existing ioctl instead of add a
> new one with the same semantics (okay not true because of the fixed
> backing ID extension...)
> 
> > 2. Use backing files infra for daxdev table
> 
> Leave this later.
> 
> > 3. Use ioctl instead of GET_FMAP
> 
> Not sure we agreed to use an ioctl for extent mapping.   What we did
> agree on was to use a generic interface that doesn't have anything
> famfs specific in it.
> 
> John, can you please also look at review comments provided by Sashiko?
> 
> Thanks,
> Miklos

This a quick acknowledgment that I appreciate your reply Miklos. I'll respond
to individual points as soon as I can without rushing.

Re: Sashiko - of course! The series has been through /kreview in Chris'
review-prompts repo. Weird that I didn't get any email directly from Sashiko 
this time, but I know how to get to it online.

I will make this high-level comment: After reading Amir's initial reply, I 
concluded that the requested changes push famfs past the breaking point, 
and therefore the only way to keep famfs suitable for its intended usage is 
to pivot back to standalone. I do think that may be best all-around for fuse, 
famfs and Linux. I don't see any way famfs makes fuse better - it's a very 
specialized pattern that doesn't fit in a passthrough-filesystem or 
block-filesystem shaped hole. And I don't think it can comply with the 
"nothing famfs-specific in GET_FMAP" objective.

If famfs is standalone, it can only ever affect customers who use it, and it
cannot be used as a general purpose file system. When famfs is in fuse, it's 
mashed up with code for hundreds or thousands of other use cases. That's not 
a win from a risk management standpoint, and it doesn't make famfs better - 
certainly not in any way that would mitigate adding a lot of state / 
complexity / baggage to famfs.

In good faith,
John

