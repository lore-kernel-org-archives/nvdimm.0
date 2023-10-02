Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1809D37A
	for <nvdimm@lists.linux.dev>; Mon,  2 Oct 2023 12:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F59C433C7;
	Mon,  2 Oct 2023 12:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696250518;
	bh=zuUfd+8TMR3+fWuYWxk1LHVHTCdM75d/xuG3AqMTpow=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=b9Fd5Ps33xWaDQsNi0jC+LdGavVoNK1Zym0jPfv0X1q9AXKz/1IxHxksDRH06KPpZ
	 tm5q1ztBTEzdb8lNxAdIrQjZ/axnnJyhO3Q+Ph/bE0K8ZtO7W5i2/nzDT5MUnCuODl
	 PNAhCyz9FaxqUYqcB/4V9+qE8GHdlIYlIzJiS31MgU6UyUbN6/5ngprQscsQkTVQcy
	 P8Nn4Il33Dg0u8grfQbralN7rzXAMQdzTSV4XcOKbL51iXSvuevqtr8PQEf8Llpm2H
	 SiLK45VbSqvPdl0P8oyVFofmk8Q5kDoHBn1O6qG2ceFiNlWNkhL96qGsF/Kf+kZMvI
	 /4RQCqVmhzqDg==
References: <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
 <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
 <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
 <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
 <20230928171339.GJ11439@frogsfrogsfrogs>
 <99279735-2d17-405f-bade-9501a296d817@fujitsu.com>
 <651718a6a6e2c_c558e2943e@dwillia2-xfh.jf.intel.com.notmuch>
 <ec2de0b9-c07d-468a-bd15-49e83cba1ad9@fujitsu.com>
User-agent: mu4e 1.8.10; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, Dan Williams
 <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Date: Mon, 02 Oct 2023 18:09:56 +0530
In-reply-to: <ec2de0b9-c07d-468a-bd15-49e83cba1ad9@fujitsu.com>
Message-ID: <87y1gltcvg.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 02, 2023 at 08:15:57 PM +0800, Shiyang Ruan wrote:
> =E5=9C=A8 2023/9/30 2:34, Dan Williams =E5=86=99=E9=81=93:
>> Shiyang Ruan wrote:
>>>
>>>
>>> =E5=9C=A8 2023/9/29 1:13, Darrick J. Wong =E5=86=99=E9=81=93:
>>>> On Thu, Sep 28, 2023 at 09:20:52AM -0700, Andrew Morton wrote:
>>>>> On Thu, 28 Sep 2023 16:44:00 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.=
com> wrote:
>>>>>
>>>>>> But please pick the following patch[1] as well, which fixes failures=
 of
>>>>>> xfs55[0-2] cases.
>>>>>>
>>>>>> [1]
>>>>>> https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fns=
t@fujitsu.com
>>>>>
>>>>> I guess I can take that xfs patch, as it fixes a DAX patch.  I hope t=
he xfs team
>>>>> are watching.
>>>>>
>>>>> But
>>>>>
>>>>> a) I'm not subscribed to linux-xfs and
>>>>>
>>>>> b) the changelog fails to describe the userspace-visible effects of
>>>>>      the bug, so I (and others) are unable to determine which kernel
>>>>>      versions should be patched.
>>>>>
>>>>> Please update that changelog and resend?
>>>>
>>>> That's a purely xfs patch anyways.  The correct maintainer is Chandan,
>>>> not Andrew.
>>>>
>>>> /me notes that post-reorg, patch authors need to ask the release manag=
er
>>>> (Chandan) directly to merge their patches after they've gone through
>>>> review.  Pull requests of signed tags are encouraged strongly.
>>>>
>>>> Shiyang, could you please send Chandan pull requests with /all/ the
>>>> relevant pmem patches incorporated?  I think that's one PR for the
>>>> "xfs: correct calculation for agend and blockcount" for 6.6; and a
>>>> second PR with all the non-bugfix stuff (PRE_REMOVE and whatnot) for
>>>> 6.7.
>>>
>>> OK.  Though I don't know how to send the PR by email, I have sent a list
>>> of the patches and added description for each one.
>> If you want I can create a signed pull request from a git.kernel.org
>> tree.
>> Where is that list of patches? I see v15 of preremove.
>
> Sorry, I sent the list below to Chandan, didn't cc the maillist
> because it's just a rough list rather than a PR:
>
>
> 1. subject: [v3]  xfs: correct calculation for agend and blockcount
>    url:
>    https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@=
fujitsu.com/
>    note:    This one is a fix patch for commit: 5cf32f63b0f4 ("xfs:
>    fix the calculation for "end" and "length"").
>             It can solve the fail of xfs/55[0-2]: the programs
>             accessing the DAX file may not be notified as expected,
>            because the length always 1 block less than actual.  Then
>           this patch fixes this.
>
>
> 2. subject: [v15] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
>    url:
>    https://lore.kernel.org/linux-xfs/20230928103227.250550-1-ruansy.fnst@=
fujitsu.com/T/#u
>    note:    This is a feature patch.  It handles the pre-remove event
>    of DAX device, by notifying kernel/user space before actually
>   removing.
>             It has been picked by Andrew in his
>             mm-hotfixes-unstable. I am not sure whether you or he will
>            merge this one.
>
>
> 3. subject: [v1]  xfs: drop experimental warning for FSDAX
>    url:
>    https://lore.kernel.org/linux-xfs/20230915063854.1784918-1-ruansy.fnst=
@fujitsu.com/
>    note:    With the patches mentioned above, I did a lot of tests,
>    including xfstests and blackbox tests, the FSDAX function looks
>   good now.  So I think the experimental warning could be dropped.

Darrick/Dave, Could you please review the above patch and let us know if you
have any objections?

--=20
Chandan
