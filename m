Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CBB18631
	for <nvdimm@lists.linux.dev>; Fri, 29 Sep 2023 15:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7296DC433C8;
	Fri, 29 Sep 2023 15:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696001489;
	bh=UBnQLkyMwJ0gO+olpHYeY+ZMuhKl8EoM6kdTFhmwz/s=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=R/sqdHKyuqtQHjohm2q3XpPdH9F5e6WW21yJ4/YJKozNhLxg5hLvFKckgGafPjK5J
	 cGqN4RPAunqIHqEWf5UQVAwvnDDlXEhONgt9Z8kbhmI3P8kbkEpYG7AWU+pxgEY+8x
	 3k9+qKtxfVw5yYnsOdlUdGkKzSs1bzpwlIOotUJWOQYeOudwR6+9LgCMknjvCpzcDr
	 o59wXtgaZW9P2J5+4ogaDRSRT8rHkFzTXZOq4adP2JMxT3rKyH9yFd3Qc6bj/O1E+1
	 tuR1QPs4v2BTs5Z8gRhPOE70ysFOei/5GK/xbqfuxYifvX5IILtXXSWPwnTZbcbMc2
	 ZKR4nm/kSY1UA==
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
 <20230926145519.GE11439@frogsfrogsfrogs>
 <ZROC8hEabAGS7orb@dread.disaster.area>
 <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
 <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
 <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
 <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
 <87msx5f4a8.fsf@debian-BULLSEYE-live-builder-AMD64>
 <4c985608-39f6-1a6e-ec95-42d7c3581d8d@sandeen.net>
User-agent: mu4e 1.8.10; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shiyang Ruan
 <ruansy.fnst@fujitsu.com>, "Darrick J. Wong" <djwong@kernel.org>, Dave
 Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
 nvdimm@lists.linux.dev, dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Date: Fri, 29 Sep 2023 20:57:53 +0530
In-reply-to: <4c985608-39f6-1a6e-ec95-42d7c3581d8d@sandeen.net>
Message-ID: <87bkdlf12r.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 29, 2023 at 09:35:17 AM -0500, Eric Sandeen wrote:
> On 9/29/23 9:17=E2=80=AFAM, Chandan Babu R wrote:
>> On Thu, Sep 28, 2023 at 09:20:52 AM -0700, Andrew Morton wrote:
>>> On Thu, 28 Sep 2023 16:44:00 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.co=
m> wrote:
>>>
>>>> But please pick the following patch[1] as well, which fixes failures o=
f=20
>>>> xfs55[0-2] cases.
>>>>
>>>> [1]=20
>>>> https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@=
fujitsu.com
>>>
>>> I guess I can take that xfs patch, as it fixes a DAX patch.  I hope the=
 xfs team
>>> are watching.
>>>
>>> But
>>>
>>> a) I'm not subscribed to linux-xfs and
>>>
>>> b) the changelog fails to describe the userspace-visible effects of
>>>    the bug, so I (and others) are unable to determine which kernel
>>>    versions should be patched.
>>>
>>> Please update that changelog and resend?
>>=20
>> I will apply "xfs: correct calculation for agend and blockcount" patch to
>> xfs-linux Git tree and include it for the next v6.6 pull request to Linu=
s.
>>=20
>> At the outset, It looks like I can pick "mm, pmem, xfs: Introduce
>> MF_MEM_PRE_REMOVE for unbind"
>> (i.e. https://lore.kernel.org/linux-xfs/20230928103227.250550-1-ruansy.f=
nst@fujitsu.com/T/#u)
>> patch for v6.7 as well. But that will require your Ack. Please let me kn=
ow
>> your opinion.
>>=20
>> Also, I will pick "xfs: drop experimental warning for FSDAX" patch for v=
6.7.
>
> While I hate to drag it out even longer, it seems slightly optimistic to
> drop experimental at the same time as the "last" fix, in case it's not
> really the last fix.
>
> But I don't have super strong feelings about it, and I would be happy to
> finally see experimental go away. So if those who are more tuned into
> the details are comfortable with that 6.7 plan, I'll defer to them on
> the question.

Sorry, I now realize that the patch doesn't yet have a Reviewed-by tag. I w=
ill
pick the patch for v6.7 only if get its one.

--=20
Chandan
