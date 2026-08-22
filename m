Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B47331207;
	Sat, 22 Aug 2026 21:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787435881; cv=none; b=C33xafuaoqQAYRyJmxYiGH2Oz8aPO+wOGly1dDFNhQN8eEeaUOgNITmNmMzo4x5DGbl67ddtZXrt1vIyM6SHwR5JJdGqrjGlokWASyONtYqDFn25ixx2s8yFuNkj8ZKyTj+bVTLhwCEHwlRVuyL2TjEgEQSRJ6IqZys9UnELEjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787435881; c=relaxed/simple;
	bh=Fa6a65HZ3RxcrVRRoa2P5lQwMaQVfLRw48XBBZ0ZQoU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Iq1L5fdOckaVVurnIRANwtDYxqd2viwlBagqqiqJ74Ur+Cziz4Q0vXr7C4mjs38osD1Tmtd4INixn7+wM10GPbnIPYk2yiaHvUxUZlg7qawjkSAqoyIDJcMWwpljW/eDf/JndemNIsc12fPnyUVt1ZbLANvy6zX+PQARVGFal+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0E741A022E;
	Sat, 22 Aug 2026 21:57:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf03.hostedemail.com (Postfix) with ESMTPA id 2AFDF6000C;
	Sat, 22 Aug 2026 21:57:43 +0000 (UTC)
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 85625F40067;
	Sat, 22 Aug 2026 17:57:42 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Sat, 22 Aug 2026 17:57:42 -0400
X-ME-Sender: <xms:VhuKal_cwpvwd5VnaIBK2DY78LizdBC5ymugeIsarPZc1KLDTWgGaQ>
    <xme:VhuKakgCGMm7-YQGxFbzR3HVPLF8J8le2w7YCgywnkdq1aU7z8XLi99443xDbaSjg
    2kVNtoW4qHVlpLBAsFlLWcgPuqjgKxLjZZ7UbO6K-_Bi7QWwHCoaDQ>
X-ME-Proxy-Cause: dmFkZTE0kI/dc6kTeJU9mdqIQFfV7ZdDS5XYIxaIUyVo0xVe3L7RgklMYkDwd8plBqJcfM
    NLvakOonhq/T6f2WleklERxGfLMWL56giphCnxwv4/jwzNgekfg7IJtGiHUQCaqldipv6j
    xEhjEEwztG0EEHO2Ef/2xwzMkInNcwhuQWrxpbB9Np55v63xCbuI9nSMAdOSTC0YNrdxT+
    Fy4t93jYSEkGVQoe9BvBSmrwuywhYr+X6NEQP4J38JXa/EaxA7gj2Y7Ai+WC5mQ3XRQHnw
    tKDsY0yDL/LhmMwTUQgMnFP7zVCpOaveFK98eNJc8Oncf2BN2Yld8jgvRR/s74fGpMrJKC
    ivuXIjxkE6+70AnYI1PyB5+ehBjV1UePkajeSgDUK02WFv4JMg3HD3yIGpA+BW1hLuUGzT
    o3xWZTOY0Z7lBxm52+bPw+wrBZYuBxzJlPuJPGLbQNHC+wiu9INS45w9bkD/rnk1LOV6sx
    xjhUsbGEQoUnZlhu/gzidEQwER5z+4Gv5uhIr6QdR3fhUjLwR15gl2BqgJm6hXcmhhvLFF
    O8t0+AsHUTmXGMOpZeY5UhXlee8D5biGSSpc3CYFMdrJjQV7CB84BGjvnZw2lEOcxThXaw
    dYiNpkw9S9wh/XghvaJQVWy7OZIEpYIOZuvJrYD21xbMUlyb6K3I/jBGVHWQ
X-ME-Proxy: <xmx:VhuKaj-1C5Jwo-4KdaXQZ-uvztQZGD_3Ws1Dm3Whfh1G41fybVp-ng>
    <xmx:VhuKakatddqii5JcwrnEekvyxXJloakx1vXZzUmZQuhfAlw85Q_aiQ>
    <xmx:VhuKao6NwGkmCNzG3KCgx8ll4dX1fXXEwRta0vT2pQplOpv5bw481Q>
    <xmx:VhuKajMGxduIj0mfw3OVKB7t1TfmdGxyTh8e8qaPPaQhHnoC-4uSsQ>
    <xmx:VhuKamPA9vUR7kzdx6PtNNuBndoPjBOJJ1fBDhgYo3_8NsKCUiYnVnya>
Feedback-ID: i3a164872:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 4B1D5700065; Sat, 22 Aug 2026 17:57:42 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Sat, 22 Aug 2026 16:57:22 -0500
From: "John Groves" <john@groves.net>
To: "Darrick J . Wong" <djwong@kernel.org>,
 "Gregory Price" <gourry@gourry.net>
Cc: "John Groves" <john@jagalactic.com>,
 "Miklos Szeredi" <miklos@szeredi.hu>, "Dan Williams" <djbw@kernel.org>,
 "Bernd Schubert" <bschubert@ddn.com>,
 "Alison Schofield" <alison.schofield@intel.com>,
 "John Groves (jgroves)" <jgroves@micron.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Jake Edge" <jake@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "David Hildenbrand" <david@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Jeff Layton" <jlayton@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>,
 "Jonathan Cameron" <jic23@kernel.org>,
 "Stefan Hajnoczi" <shajnocz@redhat.com>,
 "Joanne Koong" <joannelkoong@gmail.com>,
 "Josef Bacik" <josef@toxicpanda.com>,
 "Bagas Sanjaya" <bagasdotme@gmail.com>,
 "Chen Linxuan" <chenlinxuan@uniontech.com>,
 "James Morse" <james.morse@arm.com>, "Fuad Tabba" <tabba@google.com>,
 "Sean Christopherson" <seanjc@google.com>,
 "Shivank Garg" <shivankg@amd.com>,
 "Ackerley Tng" <ackerleytng@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Ira Weiny" <iweiny@kernel.org>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Haren Myneni" <haren@linux.ibm.com>,
 "Pratyush Yadav" <pratyush@kernel.org>,
 "Giovanni Cabiddu" <giovanni.cabiddu@intel.com>,
 "Jiri Slaby" <jirislaby@kernel.org>,
 "Ethan Nelson-Moore" <enelsonmoore@gmail.com>,
 "Gabriel Whigham" <gabewhigham@gmail.com>,
 "Aravind Ramesh" <arramesh@micron.com>,
 "Ajay Joshi" <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Message-Id: <de0be5a5-d171-4032-b162-c7bd9b95220e@app.fastmail.com>
In-Reply-To: <20260822174029.GC6110@frogsfrogsfrogs>
References: 
 <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
 <20260810202539.96378-1-john@jagalactic.com>
 <0100019fed5a5210-a09f1bdb-c705-44fc-8108-a7e7995a7af0-000000@email.amazonses.com>
 <20260822000728.GB6047@frogsfrogsfrogs>
 <aokdSo9li0RtEt35@gourry-fedora-PF4VCD3F>
 <20260822174029.GC6110@frogsfrogsfrogs>
Subject: Re: [PATCH v13 10/12] famfs: Add runtime operation-permission (opts) framework
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r5saipzkyapribsk8ox7foc7poqb6yxt
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 2AFDF6000C
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+IJHM9Wx96JQOmrw3aSBS9Xz0w7W81Mt0=
X-HE-Tag: 1787435863-546942
X-HE-Meta: U2FsdGVkX190X/fsPw/dU0OAlyVjkuMcc304uScGpk7Lfkd83aaqAWrsDnh6FUbgDT80g5MGlOSw0tUEUWoA2McmQhwb/pwjnBNmP2CA3OWBJHqMDs76R2YMOe4dtBAwkDvM2ALbhkK3wNCfNf9hagf98jOGtp4f/U78a5h8EXPT0g6pkAfariqSF2TOBW3rR3YApybVdulp8iFSK3xVBO3ehzcI6VZ55tzpPXifFYn6WFvuQ7k8X0mSa6+0zC9cjhIscpzQNgt6ehYodszYfktveC+bdc7xDY94sMToKjf3L/YU5BfPxQUX9RKjr+oE



On Sat, Aug 22, 2026, at 12:40 PM, Darrick J. Wong wrote:
> On Sat, Aug 22, 2026 at 12:18:58AM -0400, Gregory Price wrote:
> > On Fri, Aug 21, 2026 at 05:07:28PM -0700, Darrick J. Wong wrote:
> > > 
> > > But what prevents a malicious program that is /not/ the famfs client
> > > software but has CAP_SYS_ADMIN from doing that?
> > > 
> > 
> > Such a program can already unmount famfs, rebind the device to
> > device_dax, and mmap the whole range directly. MAP_CREATE isn't
> > handing it reach it didn't have. 

Gregory is right, but also: this is possible with fuse too, since the log
needs to be played into a tree that the fuse server consumes - in order
to avoid searching the log (order n) on every lookup. 

> 
> Thinking about this a little more -- some random root process that
> accidentally tries to create/modify a directory tree on a famfs mount
> will just end up with fmap-less files that won't work for IO or
> mmapping.  That's dorky, but I think you're right that it's no big deal.

I've had users do that, and yes it's dorky but NBD.  It can be locked
down tighter by turning off FAMFS_OPT_CREATE except during 
log play etc., but the main thing is "don't do that: it won't harm the 
system, but it also it won't do what you want".

'famfs fsck' finds those, and the famfs cli can clean them up.

> 
> 
> A bigger question I just thought of is sharing cxlmem between files (aka
> reflink).  Is that allowed?  I could see a theoretical usecase for
> programs A and B wanting to share some cxlmem for communication or
> heartbeats whilst having their own /a and /b files for their private
> memory.  Probably you'd just create a /common file to do that and not
> map the same cxlmem page into /a and /b, right?

Famfs doesn't support reflinks - I don't think there's a use case.

There is a pcq.c and libpcq.c in the famfs user space specifically for
using file pairs as producer/consumer queues - one file contains the
fields written by the producer, the other contains the fields written
by the consumer. This use case works great, but without cache-coherent
cxl memory (which is coming but not here yet AFAIK) libpcq has to verify
message sequence numbers and checksums to avoid reading messages 
from stale cache lines (i.e. loaded before valid).

I do have CI that creates cross linked files, which are detected by 
'famfs fsck'. 

> 
> But having said that, the fsdax code /can/ support sharing between
> files, so I wonder if famfs is prepared either (a) to enable that
> sharing or (b) reject a mapping that would overlap with an existing
> mapping?  Things will go very badly in the kernel if famfs doesn't set
> up the dax_folio state correctly.
> 
> --D
> 

Last I checked, if cross linked files get created (as test_errors.sh in my
smoke test suite does), you trigger a WARN_ONCE from dax,
but otherwise it does no harm to the system.

Thanks,
John

