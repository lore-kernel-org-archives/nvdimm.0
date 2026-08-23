Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509EA2F693B;
	Sun, 23 Aug 2026 02:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787452616; cv=none; b=Vat1YQbLhNhCZTmb6ah2dSYtceCLEzXdRTRI+L8B8/OmRcVUBdd6ebE656yOdKQl6iFoaZcRzdGU0qbYjREad18H9twuHGGuOzmD4cgVDvL/9ahUcihEuVs4q/Sq3oEPH/apbGloAPABjuJVdWKy+rhfBeRU/ALsyNrtX67gzao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787452616; c=relaxed/simple;
	bh=BRGgKT/KGJLXr2r/FA4J7e0XJ+oisImpwbAy3ym6sYo=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Rog+1IhMA06yj+jH6EDe2SwqeYbHsm2Sb18PExEtjN7lSzSFPDzSlpSZSdc/BT7LwiNZV/DXIL0r9Tdv5dPIPR5Qv2TMbiqkgbCloIFeGWEEDjkiNYhKN2hg/8ZHzRpuTxIRrWf0U8G2yvd3GZCMEs70x1AncEOJddA2ZjEPu6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DE668024D;
	Sun, 23 Aug 2026 02:36:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf05.hostedemail.com (Postfix) with ESMTPA id 064C62000E;
	Sun, 23 Aug 2026 02:36:37 +0000 (UTC)
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5408FF40069;
	Sat, 22 Aug 2026 22:36:37 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Sat, 22 Aug 2026 22:36:37 -0400
X-ME-Sender: <xms:tVyKaj-AbkeGW0SOTQOTpJGPmQvAsIwnhu9d8QWBQCLKMnYELzUVwA>
    <xme:tVyKaqgI6GjoTvfxXKT_6SW-Z4ME89vZUOuyaNsDoaBFVPCneMwv0UTYDmeFpDJIN
    piK7DBsVOAP0uJkIHDoXQyMULwIvfML-gVB5ah5ToVEO89pm-If1w0f>
X-ME-Proxy-Cause: dmFkZTGtZf/lfES6h8o9yqexpKVK4xvM5tpLm4eTAUwmzJGFS7bOLbxIJ+8+M2xuS0HN64
    voE2C5KJ4UPgs+QJapUv8/1SlsT6ZVbJbGdjMe8S2bGgeGaWRfE39AQUjVOyibU/ipbVIE
    uo+tLQrmny0kHZvYViXrynBHVqUX+nb1UVJ1KbJNepBMlj6aO92gweoKeuS57UnnCertxz
    QbQ40WQJkSqsiN+5o2powbqehutjUiey2BOf1PHuwdeiFCLUdUxOvTpW2DFBf3pFDoG6ej
    r1veuCwHGF7EMnhDs3E8BbVZDnktDGseyFeF8+SPG8dRwIRSwrGcO/dvXft+fZ6+B7HZfU
    2eeaXUK0EqUsjbRXmZevfNQ4VbGJvFozk5LBxBQufPiJJCgHaqWoPEZLy+Y9C0Y2s54erX
    y1UQZZxSDxRHxLGUo9wehLH3qGvyL/10lojJ284Gu4uIlYAcaXxNE0mFNAhoSJc+F0WIps
    L37mpg+6yffnhCV9Wu3Vjejk8oOP4WJQh/AlmmX+ADSTVuk5uZviO8NAdDdwFRkCIcBDOf
    /6gkdb7pyHgBHNrVFdfdc6OlNTTMOHG9R1j4sGkuw3EwG60tACs3Oy6ZaplRjU7w3RQ9AV
    P9vhhGbEiShp6S9QnhQpZYyJ9J954QAa/ndQexT2ITP4PGxRxc+M1X1O5AoQ
X-ME-Proxy: <xmx:tVyKaox8g5zh8Qh2KT6dUTQrr-0q2SzvWUOxVmU0qkQ1JLT0sZxTlg>
    <xmx:tVyKap-vTah2xUkB7lg5FgZtk0XKXy5yvNx36yFI6n5JAoeg-7dEsA>
    <xmx:tVyKaiaI_6vsN7bQG2J16KhcNJ2DgaHTVtqnTUgs3sEMAc4VjuAFbQ>
    <xmx:tVyKau7-l4KNk_twwaG_8dvQgCdlH6QtDgudCB3b4M8kPtpwpSSlWg>
    <xmx:tVyKahOM3MMycOok_HufW2RbxepJhibD2xQhM9zzlUOa0QqTRNHgPz7b>
Feedback-ID: i3a164872:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D2AFB700065; Sat, 22 Aug 2026 22:36:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Sat, 22 Aug 2026 21:36:16 -0500
From: "John Groves" <john@groves.net>
To: "Darrick J . Wong" <djwong@kernel.org>,
 "Miklos Szeredi" <miklos@szeredi.hu>
Cc: "David Hildenbrand" <david@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>,
 "John Groves" <john@jagalactic.com>, "Dan Williams" <djbw@kernel.org>,
 "Bernd Schubert" <bschubert@ddn.com>,
 "Alison Schofield" <alison.schofield@intel.com>,
 "John Groves (jgroves)" <jgroves@micron.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Jake Edge" <jake@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
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
 "Gregory Price" <gourry@gourry.net>,
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
Message-Id: <e05d0dac-06d8-48e8-a2da-3b48fc9917ef@app.fastmail.com>
In-Reply-To: <20260822002111.GA6110@frogsfrogsfrogs>
References: 
 <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
 <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
 <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
 <20260822002111.GA6110@frogsfrogsfrogs>
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 064C62000E
X-Stat-Signature: ikorms1toyeggykj19odas8xcwmthe3p
X-Rspamd-Server: rspamout03
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18cnVkOYMe8rkIyUfyMNORk7KDaeVRkDkw=
X-HE-Tag: 1787452597-321759
X-HE-Meta: U2FsdGVkX1/cGO3Rj6iSrXlJ/8L8zSmLETSU83DwPGXQ4D74XJhEvKMLgqX9/mp+Pl29G0jeFErm9Mj+jTQbUPN/OCkJwv8iPWk51UYAAd30rPK/Z1C1qZl5Co8S2pXbyDrFnzEL7rlQ/0qXlldeidh/sVfb4ul/u3KtvX1K5QtlbEMyjfPJEoB5e9padL/y3sMlwMVG9KIek8S52kTkBJt0ur88FgaJocvr+6/p5Gl/8EsKOXNhdlpJGR3+076uTMSlAeAym/GBmaYPMGgG1Kj/mbcvwER4pN1Yf4L2cx3oS993d1jVNtmU9651uT0dZMwqsjOT/THBo4PZnZb1sDWZwXBVS89O



On Fri, Aug 21, 2026, at 7:21 PM, Darrick J. Wong wrote:
> On Fri, Aug 21, 2026 at 09:39:26PM +0200, Miklos Szeredi wrote:
> > On Fri, 21 Aug 2026 at 13:40, David Hildenbrand (Arm) <david@kernel.org> wrote:
> > 
> > > (a) Whether a fuse-based approach is feasible.
> > >
> > >     Are there any major blockers remaining?
> > 
> > No.
> > 
> > > (b) Whether a fuse-based approach is inefficient.
> > >
> > >     Are there scenarios remaining where performance or metadata overhead would
> > >     be bad without an easy way to improve the situation?
> > 
> > Lookups can be cached, extent mappings can also be cached.   After the
> > inode is in cache and the mapping is set up zero requests are needed
> > for open/mmap/read/write/close.
> > 
> > > (c) Whether a fuse-based approach is a bad conceptual fit.
> > >
> > >     Will fuse have to carry a lot of famfs special sauce that cannot
> > >     really be used elsewhere / generalized?
> > 
> > None.
> > 
> > But "can" and "will" are not the same.  The striping code might not be
> > very useful outside of famfs.
> > 
> > > (d) Whether a fuse-based approach is too invasive.
> > >
> > >     Will fuse extensions to support famfs actually make it harder to maintain or
> > >     slower on some paths?
> > 
> > No.
> > 
> > > (e) Whether a fuse-based approach will make famfs harder to extend.
> > >
> > >     Is there known follow-up work that will be hard/impossible to model in fuse?
> > 
> > It would actually make famfs much easier to extend, since the
> > directory structure, metadata, etc. is now controllable within the
> > userspace server.
> > 
> > > (f) Whether a fuse-based approach will reduce maintenance effor
> > >
> > >     Will maintaining fuse extensions possibly be harder than maintaining
> > >     standalone famfs?
> > 
> > Testing is a key point.  Famfs needs special hardware or emulation, so
> > it's not straightforward to test.  This could be solved by adding a
> > "dummy" mode to famfs server that exercises the same fuse API, but
> > instead of special hardware would just use plain memory.
> > 
> > > (g) Whether a fuse-based approach would make famfs more complex.
> > >
> > >     Will the shift to user space result in a significantly more complicated
> > >     overall solution that must be maintained?
> > 
> > The server would be somewhat more complex, since it's now implementing
> > things like pathname lookup, etc.  But the other stuff (managing file
> > maps) should be very similar.
> > 
> > > (h) Who would help drive the fuse approach?
> > >
> > >     Fuse people seem to be willing to help, but I expect that there must be a
> > >     close cooperation with John to make this fly. I don't expect that John
> > >     himself can easily (or understandably wants to :) ) do the heavy fuse
> > >     lifting.
> > 
> > Yes, this is where previous efforts seem to have gone off the rails.
> > So I agree to take responsibility for implementing the kernel side and
> > help with the server side on the condition that John has trust in
> > this.   I'm not promising -7.4, but can at least try.
> > 
> > Without John's trust I'm not taking this on.
> 
> Whatever path you and John decide on, I would very much like to see the
> question of Which famfs driver do we merge? to be resolved for 7.4.
> 
> --D

I certainly support this plan!

Thanks,
John

<snip>
