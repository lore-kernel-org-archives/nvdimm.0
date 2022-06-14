Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B46B7C
	for <nvdimm@lists.linux.dev>; Tue, 14 Jun 2022 12:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gdQNv3H02tLJyNTWKuZB1Pun4d0Yppvy9PsduYHadVU=; b=htPwzWNBUQ+6KH93emBqdgCHcP
	edy5Qq3D4SjFxNnxqapMHYEdX0urLwxC2lK+BXnvXyNZ8X23OjsD74VManmBvG1InroTibh4lpoGU
	cvQnb0eWImOz5GP0GRt8zhwrQBWZXTkfsG6SEH/jAbeq2ngYXZPM8Dgu3dM6TseTrgiBWQkb9+Tz+
	sBJE5C+n6WbZaxvleQ4u6kbq+vwvZwOmxxeWu/HGjRqufgpVDM7/CbaGdiqdWkA5Pkxp4DkL4fO94
	nsi3GX3uEAHaeD/U80bOI8UOwQpw5z+HtFSYtuwLyUja3Jk0xNftGRqfvcDADCpyOR4ORR+8mi1Zg
	1XiE6cGw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
	id 1o15Oh-000Gd2-Px;
	Tue, 14 Jun 2022 12:11:51 +0000
Date: Tue, 14 Jun 2022 13:11:51 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	nvdimm@lists.linux.dev
Subject: Re: [RFC][PATCH] fix short copy handling in copy_mc_pipe_to_iter()
Message-ID: <Yqh7B+tVDutCwuG1@ZenIV>
References: <Yqe6EjGTpkvJUU28@ZenIV>
 <YqaAcKsd6uGfIQzM@zeniv-ca.linux.org.uk>
 <CAHk-=wjmCzdNDCt6L8-N33WSRaYjnj0=yTc_JG8A_Pd7ZEtEJw@mail.gmail.com>
 <1586153.1655188579@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586153.1655188579@warthog.procyon.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Jun 14, 2022 at 07:36:19AM +0100, David Howells wrote:
> Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> > What's wrong with
> >         p_occupancy = pipe_occupancy(head, tail);
> >         if (p_occupancy >= pipe->max_usage)
> >                 return 0;
> > 	else
> > 		return pipe->max_usage - p_occupancy;
> 
> Because "pipe->max_usage - p_occupancy" can be negative.

Sure can.  And in that case you return 0; no problem wiht that.
It's what happens when occupancy is below max_usage that is weird.

> post_one_notification() is limited by pipe->ring_size, not pipe->max_usage.
> 
> The idea is to allow some slack in a watch pipe for the watch_queue code to
> use that userspace can't.

Sure.  And if this function is supposed to report how many times would
userspace be able to grab a slot, it's returning the wrong value.

Look: 32-slot ring.  max_usage is 16.  14 slots are already occupied.
Userland (sure as hell, anything in iov_iter.c) will be able to occupy
two more before it runs into the pipe_full().  And your function returns
min(32 - 14, 16), i.e. 16.

What am I missing here?
