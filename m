Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7FA22D4E9
	for <nvdimm@lists.linux.dev>; Tue, 14 Apr 2026 13:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776174120; cv=none; b=rXkdvSQXE8tcpt1q87kPRU129nSjtLh9lEEN81eRLq3uGcA+js+ind5q/aqr39sjTx8XmOQ7JMuXoFycdk8w1u+xwUheaxiicbzGQSRRC6wHU16NXGfG7X9JpXHmC/pfPeXh7aoMgHYK71cN9Ov5USLrXzGmVUJpqCnz8YCI4ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776174120; c=relaxed/simple;
	bh=RHpptF+atO/Rhx/afsgSrALZFOyszUomvjg2Qi2fN+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ViQFIUKmbC9AXvh8+IkzM9zHYGivjAsadgmW+80Be64zD9++7U/rNc/+77O51UEwgAr63MpsCBrXDq1EFe1odouty1mdmutNTJAp1F2LhIyD6SNJeF/qpnx1F/fuWkl39EU/ybKuCxhWbHJSz/6YUGECWbCurHAlhNRNZlolzMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 730F9B9CAA;
	Tue, 14 Apr 2026 13:41:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf06.hostedemail.com (Postfix) with ESMTPA id 834B820011;
	Tue, 14 Apr 2026 13:41:43 +0000 (UTC)
Date: Tue, 14 Apr 2026 08:41:42 -0500
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Joanne Koong <joannelkoong@gmail.com>, 
	Bernd Schubert <bernd@bsbernd.com>, John Groves <john@jagalactic.com>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <ad4_jFsR951c2Mtn@groves.net>
References: <20260331123702.35052-1-john@jagalactic.com>
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
 <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
X-Rspamd-Queue-Id: 834B820011
X-Stat-Signature: osob67n6eeczx8asmfbkzmfutkb4digx
X-Rspamd-Server: rspamout03
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+SVXLkp0hdoyxt/nYLVnuiJzgDSoB6drE=
X-HE-Tag: 1776174103-201279
X-HE-Meta: U2FsdGVkX1+o+SRZZyzbR/R8njSUkeQWUwyoCzq04hU35apA7vVzWjjcQZgAMC9iX79jqY5MWMkP/7pWmCK235zT8/aTsAsxYhxiuuOis90g52GWRjdVEgaJBEp9UNimWGcgLUYYf6q9bHFUP+zOcgei1JxxtJhIQPLOUUKv1fwweYnXqZo4S4DUdr5ll+JmdYAv/ic1UFSt8hMutBQLUuvY55NXZrJCZmjY0ehh+oC8FM7aRMt1KdWwS0XdOI3Isx2fv8ky16IEl496GV+NavoLMO6BLWPyHunqtIojvdpcTGM0qcW50KufiA7H/0pWXdI1ozUIbRKaisJT7LybGrmMWmGeL8mK

On 26/04/14 03:19PM, Miklos Szeredi wrote:
> On Fri, 10 Apr 2026 at 21:44, Joanne Koong <joannelkoong@gmail.com> wrote:
> 
> > Overall, my intention with bringing this up is just to make sure we're
> > at least aware of this alternative before anything is merged and
> > permanent. If Miklos and you think we should land this series, then
> > I'm on board with that.
> 
> TBH, I'd prefer not to add the famfs specific mapping interface if not
> absolutely necessary.  This was the main sticking point originally,
> but there seemed to be no better alternative.
> 
> However with the bpf approach this would be gone, which is great.
> 
> So let us please at least have a try at this. I'm not into bpf yet,
> but willing to learn.
> 
> Thanks,
> Miklos

Thanks for responding...

My short response: Noooooooooo!!!!!!

I very strongly object to making this a prerequisite to merging. This
is an untested idea that will certainly delay us by at least a couple
of merge windows when products are shipping now, and the existing approach
has been in circulation for a long time. It is TOO LATE!!!!!!

Famfs is not a science project, it's enablement for actual products and
early versions are available now!!!

That doesn't mean we couldn't convert later IF THERE ARE NO HIDDEN PROBLEMS.

What are the risks of converting to BPF?

- I don't know how to do it - so it'll be slow (kinda like my fuse learning
  curve cost about a year because this is not that similar to anything
  else that was already in fuse.

- Those of us who are involved don't fully understand either the security
  or performance implications of this. It 

- Famfs is enabling access to memory and mapping fault handling must be
  at "memory speed". We know that BPF walks some data structures when a 
  program executes. That exposes us to additional serialized L3 cache 
  misses each time we service a mapping fault (any TLB & page table miss).
  This should be studied side-by-side with the existing approach under
  multiple loads before being adopted for production.

- This has never been done in production, and we're throwing it in the way
  of a project that has been soaking for years and needs to support early
  shipments of products.

If this is the only path, I'd like to revive famfs as a standalone file
system. I'm still maintaining that and it's still in use.

Please reconsider Miklos. To use an American football metaphor, this moves
the goal posts by a mile, and that's not reasonable!!!

Thanks,
John


