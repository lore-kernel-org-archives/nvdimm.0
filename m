Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857AC1A6808;
	Mon, 24 Aug 2026 23:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787615645; cv=none; b=GtK2SP9/B4JTvAs5YsV1XCJ5B/ePrdRS25LusdMLYaCURg9q4I54f7i+c9E80qkttjZQgolo+n4uaWRMk3krReBzy+ip4stExBJVF6mhnJQVCoxIjD/+yt2hbYEzaNtfNdts9FHuQ8DZvSCHYmohQ1guHODl6eCVveUm6ox+Hm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787615645; c=relaxed/simple;
	bh=YMtsvaPMhaJLi9vMElcaik8XpWsWPo0DE60Oo8CIAC8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=sW+BxmtN6cRb0LqlxPRC7TTe2WKAgTw01ilxtriBt6xAWMYRQUI3/Sb6cBaxgPQZLlL99m0tD6K/UyZbQsYCDhLQWNcl7WJGwZ2HXlEo4UGod4RaI9W4QblMUBw8BtaflWhDSmRSd7/MfQb70rS29TJiVRX1ZF16B2z4JECzIBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66E2AA028D;
	Mon, 24 Aug 2026 23:53:59 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf17.hostedemail.com (Postfix) with ESMTPA id BA4E117;
	Mon, 24 Aug 2026 23:53:46 +0000 (UTC)
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1DEB2F40067;
	Mon, 24 Aug 2026 19:53:46 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Mon, 24 Aug 2026 19:53:46 -0400
X-ME-Sender: <xms:idmMauRPrtUla9qRbhvt2_0s-gOtSXQJ6oW6QWzI4RYdfWKeXayTTg>
    <xme:idmMaumvvdBBLt3x0JiN9Geb0OQe_taMdqTLqJd4Mq039O7VWz71Lnq9W55yIp8pj
    Zx9DgY8f9Rx3fGP9TVFuMhkiwauLuxySxTBravrSpVNXrDycOq9MP0_>
X-ME-Proxy-Cause: dmFkZTFNdvBIYoqkIophUMonGCfqR072dJfXrrSBykjE0PcM8D01g5aR2SyokIQ/29dWMV
    +MpQ4Pd0AvzqaA3zAW7dQe1gLVJpFLwFO9Epoebc5cxJ+b9UdYVw6/cNTZIMrxvQFAH2OH
    2M7mhaArg46OGgg3mMGu1sm3SaF/xv+Fm0dxq+tYSTWYcbWTMTeX2kgo96SMfnMnqoBLFk
    zFnAhbFBYag4FBV6zUGEr8v1PBur7ayBAYs4kCpCVwyQG3VtEpfMMQTUU1g+Vi8zymicPl
    NeOEkVKkd4fKLigg0edc5ZuIxSSXjv04NcSZt0l8e9URq7iG9UcXrC3mJ9a/dU8LH2pTj7
    J4WPMxqpzGHdhO+v8lh37u9DfbVGu8EEzhvkVKbkSWnAAwqG8OBHiuConeJ45woHQ5FYx+
    52uZ8fHY2DRTBH0qzBo/RPsqDYNmPm8K04dYGvd4zRJlmhjHSBsth4t/RelGt+mmKIT/NQ
    2f5y4WnsRrQoMofmLuPkxeTEJ58wIoifaka0XMYRu4MNHUjXt4saQXWbHwBzthVVdjpHSt
    IvJPP9vrf1r1pC9VveY2zScooLw4hepc4++nRXbUA3qwV0R4+tVngu9nhV+15D0K041z1d
    WPHl1UIrzPwCoTb+ntgEvpPDm/7JViS2OFuqKy512teb2ShZC1fC/x9ZedTg
X-ME-Proxy: <xmx:itmMapHx4ry7FcmOjVfJveQlbJbyuvXgVkhAr0jqSbYuzw8MC1y-Sw>
    <xmx:itmMasAAsWov3rD-6ZER_fYrnKjY-cVv1aJJo_prum4A3z7WB1lzLA>
    <xmx:itmMajO5mBMiGuP1GfHx73urD-cFZkU1ikJ1fMKOgnrNyuqXEE2BMQ>
    <xmx:itmManeP3766O-mcCV15NJudbj-o19HeOuNh9-dENXDVv5l7ivCWPQ>
    <xmx:itmMamgsfMaeL3UKtVOAurP9TNOCVtyWB9rL5Z90ld3thvFiGrcqGgh4>
Feedback-ID: i3a164872:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D36F8700069; Mon, 24 Aug 2026 19:53:45 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 24 Aug 2026 18:53:25 -0500
From: "John Groves" <john@groves.net>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Cc: "David Hildenbrand" <david@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>,
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
Message-Id: <ed2ce261-50af-4515-99f0-51f69dc206af@app.fastmail.com>
In-Reply-To: 
 <CAJfpeguuL8He4dKC0+CQU3c=Ss9nDEH=9VckB5mqxOr01X2q4Q@mail.gmail.com>
References: 
 <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
 <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
 <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
 <ea56c85b-d564-4451-b704-58448a07bfa6@app.fastmail.com>
 <CAJfpeguuL8He4dKC0+CQU3c=Ss9nDEH=9VckB5mqxOr01X2q4Q@mail.gmail.com>
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BA4E117
X-Stat-Signature: q7byakz5pg5nc7rqry5nhs79cmtepzsf
X-Rspamd-Server: rspamout03
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/MFztRw88PMkWUbpQaFPOCrF1W5rOUeEY=
X-HE-Tag: 1787615626-627444
X-HE-Meta: U2FsdGVkX1/nUAzRQZz9GChlN55Gfmuc8oQWAgHe/Cuzkpc9Pkjw+7PIbX0QRcOgKA6VqrTNRiTzwhx9fRhfEm+dkWphA42Gu+nLBKwP5bi1GQrd9PRoxWku3ODNBeIDENBSWvM/nuZrAw1S8O/dx11pEkMOZnfysTpOj1G7DZtUPSTdVMVBMcHx5U07HpuLModoV46KznPRh+Tlj29wlLPdlPJmgovUk4dSp8xv4oBKcZx+eZXLa8E6W8jjUXb3vskpEuZQN7WV+OlaI19eEunOd4lv8gyi7DRdD/os9/Vwz5O0zSWCMv0KHY+Tr3P8i7gYkSS/oXNvIZ9lN34XHKw0D5GNEvoUZeTSPfeW7MLyEPc/B84jtUK2bl/zAPY3



On Mon, Aug 24, 2026, at 2:41 AM, Miklos Szeredi wrote:
> On Sat, 22 Aug 2026 at 23:55, John Groves <john@groves.net> wrote:
> 
> > Famfs does work in fuse, but some of the asks are things that I don't see
> > how I can agree to. I think Miklos and I should discuss those 1:1, to figure
> > out if there is a way forward.
> >
> > I think the virtual backing-dev thing is a non-starter,
> 
> The virtual backing-dev is an abstraction.
> 
> Is it sufficient for you if I promise that this is going to do the
> same thing as the standalone famfs at the same performance level?
> 
> >  and I think that the famfs
> > portion of the fuse ABI basically can't live without extents that are
> > (daxdev, offset, length).
> 
> Sigh.  My proposal was (backing-id, offset, length).  Again this is an
> abstraction.  A backing ID can be a daxdev, a striped logical device
> or it can be a block dev or even a plain file.
> 
> > Also, I'm curious: if you don't know of a use case for the striping code outside
> > of famfs, why ask famfs to completely rewrite that?  (and I agree, other
> > than the eventual remote possibility of competing 'famfs-ng' fuse servers,
> > I don't see much likelihood that this piece will be shared.)
> 
> Because the striping feature fits much better into a virtual device
> API than the extent mapping API.  This is how striping has worked in
> linux for the last 30 years.
> 
> > Miklos, I trust that you are a good faith actor, although you seem to be
> > spread pretty thin. Can you commit to a series of 1:1 conversations with
> > me to try to work through the disconnects?
> 
> Fine, let's find a time.
> 
> Thanks,
> Miklos
> 

I'll ping you directly about times to talk. Thank you for being willing to do that.

Regards,
John
