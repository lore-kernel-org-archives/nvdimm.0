Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3244B40DFB0
	for <nvdimm@lists.linux.dev>; Sun, 19 Apr 2026 20:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776631020; cv=none; b=cX/8zUF2TBnjL+cnFqN0jopUk/nNqj7kMWpKqAgujD/K3JJSeahgSY+Qgxa6PoINy4dR3PU1oB+9D12rPW0fhoHbdbQXEanHIEOZhfezldRLvUJhHc1Y51bFgQPtRV6K2gqCGjU6CHXugZXnt6CyMk0l7fxdNGGiKO6gnabOCbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776631020; c=relaxed/simple;
	bh=PL4WUHDuO2XDvYw/1SiTDHlRV1uxOuaOS5Dr6aCsj4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KnJYojinij6wJbns7ZndFONF4GkLuNbr2Etxhy2qOIXjiMY9bYRXIl/OFw9AkigIoOCFS1jgfu1zIcBjpprX/TX4KAFxM3u5Rj0hO/jXGilMWO3+LMkU69dW23qlIDnfTO85pAg25TxqD7hiwmSTZJZ06ll5DAazWhpulkdKtGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A5FF140817;
	Sun, 19 Apr 2026 20:36:47 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf13.hostedemail.com (Postfix) with ESMTPA id 3EC6220013;
	Sun, 19 Apr 2026 20:36:37 +0000 (UTC)
Date: Sun, 19 Apr 2026 15:36:30 -0500
From: John Groves <John@groves.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, 
	"Darrick J. Wong" <djwong@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bernd@bsbernd.com>, 
	John Groves <john@jagalactic.com>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <aeUU8hMwPij2WvfF@groves.net>
References: <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F>
 <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
X-Rspamd-Queue-Id: 3EC6220013
X-Stat-Signature: jyrwpu48m896o9xunm3es93gxwmuzu3b
X-Rspamd-Server: rspamout03
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/+B/koa7/BHl08i+zDSxwL6oICIJTnqmk=
X-HE-Tag: 1776630997-811227
X-HE-Meta: U2FsdGVkX18WkNiRoGCXrg1FJlRo7G2CwhvPBa+180EBmhjtaNDGUrdVGCiYO4Moozc87bNQvYo=

On 26/04/15 10:16AM, David Hildenbrand (Arm) wrote:
> On 4/15/26 00:20, Gregory Price wrote:
> > On Tue, Apr 14, 2026 at 11:57:40AM -0700, Darrick J. Wong wrote:
> >>>
> >>> I very strongly object to making this a prerequisite to merging. This
> >>> is an untested idea that will certainly delay us by at least a couple
> >>> of merge windows when products are shipping now, and the existing approach
> >>> has been in circulation for a long time. It is TOO LATE!!!!!!
> >>
> > ...
> >>
> >> That said, you're clearly pissed at the goalposts changing yet again,
> >> and that's really not fair that we collectively keep moving them.
> >>
> > 
> > This seems a bit more than moving a goalpost.
> > 
> > We're now gating working software, for real working hardware, on a novel,
> > unproven BPF ops structure that controls page table mappings on page table
> > faults which would be used by exactly 1 user : FAMFS.
> 
> Are MM people on board with even letting BPF do that? Honest question,
> if someone has a pointer to how that should work, that would be appreciated.

David, that question is pivotal!! How can we get at least a preliminary
answer sooner rather than later? If the answer is "Hell No", a lot of 
this thread (but not all) becomes moot.

Prior to today this entire discussion has happened in the absence, to my
knowledge, of anybody actually hooking famfs for BPF-based fault handling. 
But today Gregory has shared some code with me that does that. However,
the code doesn't build for me so I guess I'll have to debug that as soon 
as I can. 

Gregory's code, in the current form, still uses two new fuse messages,
GET_FMAP and GET_DAXDEV, but it makes the fmap message format opaque by
removing fmap format structs from the uapi. It also uses two BPF programs.
One BPF program parses and validates the GET_FMAP payload for every file,
and hangs it from a 'void *' in each fuse_inode (just like the current famfs
code). The other BPF program is called during vma faults and reads the 
fuse_inode->'void *' in order to handle faults the same way famfs-fuse does
today, but via BPF instead.

As with all vma "providers", famfs services zillions of faults. But famfs
faults never involve blocking or retrieving from storage, so we don't 
have that to amortize a less efficient fault handling code path over. 
As I've said many times, we're enabling memory and it must run at
"memory speeds". Gregory's code includes a BPF invocation to resolve 
each vma fault, but does avoid the BPF hashmap lookup that would be 
required with a generalized implementation of Joanne's ideas.

The first question (very much unanswered) is whether a BPF fault handler 
can resolve vma faults with performance equivalent to hugetlbfs or 
anonymous mmap performance. If not, the famfs community will assert that 
BPF would defeat or degrade the purpose of famfs. Added 
overhead/latency/cache misses in a fault handler will serialize into the 
stall time that software sees for a virtual address to be resolved - 
it really is performance critical. If BPF is slower, we'll be able to 
measure it, but one benchmark or test case does not fit all, so this
won't be a one-and-done test...

I'll share performance measurements as soon as I can build Gregory's code, 
test, get time on a proper big-memory cluster, and measure something that 
makes sense. This will take some days, but I'm working it.

Hopefully Monday I plan to try to do a substantial on-list reply that
attempts to summarize the various objections to my current famfs fuse 
implementation as well as the open questions and my specific performance
and complexity concerns.

Thanks,
John

