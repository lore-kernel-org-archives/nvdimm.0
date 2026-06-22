Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43120131E49
	for <nvdimm@lists.linux.dev>; Mon, 22 Jun 2026 02:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782094097; cv=none; b=TqnOdQIKIkQvLYSAKZBblK4Z2TVtOxR5CjnGFvVNUI5abBDWieDM6r5xfql1zIxWJX7gCT64g0+CbE/zFhT620NfuwFj3sn/fhO7WNHj7rd34am7bLGz11MwVaBOoW0tCpbRCKYSwdBUOC5ZjOHxw30wmgxKqEjCYie4lZuyzQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782094097; c=relaxed/simple;
	bh=k4vdXfma5+11oG4eQxESIe6je9EkBQNZ4oMNfSBZ8uI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Ekl2tahiYJzlCpA+itNgXITsTjjcb4gmZB1Bg4TXJurfXMoXcqEi/EsvmY6ORIbWnQDw+/shk3+YZUBB7XiQXqlLYCm7t3fO2wxC5qbkSRXBB7/GgDyQlcvirx8YDOSst0e3Y/8CSrqUfPq57fbOOXr3NOUibBFhqBGPg4hvubg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XAOcycqs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XAOcycqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52971F00A3D;
	Mon, 22 Jun 2026 02:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782094096;
	bh=Pbga8je2xu45ed9XQXm2FiYm97CBqkXu6S9kwh45f0Q=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=XAOcycqsQ9b/relw6RpLXuJo+4nRU0LEU9VlDXNZQ/SN61b/R5dET2F24j673HHoM
	 Lz1T+ZHOXu+3RbOpgncgIYjzVeyzwS0sUrbONgvOupaKwRmXI0J0LTEDZYDWxAGqgT
	 RxKfSPOkGKI77b7rF77xIE7jxuZLcXpVMGt1gDSlpFS+7+cdmJnEOBARUOGWSQDXUe
	 VReweq25VrDN8LKD8zj6QyoLb6nyTGpseh/ADaddywCLZmXzUs5xk3lj+iBn+bc/6Q
	 T3lHFZ/aRxaMG/hXMcdJKj1YcM0X/zJnQchSRcGZ/2P2esABGe/qdymya3LZnhijLr
	 WHzGf/91FT2BA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 17FE1F40068;
	Sun, 21 Jun 2026 22:08:15 -0400 (EDT)
Received: from phl-imap-10 ([10.202.2.85])
  by phl-compute-05.internal (MEProxy); Sun, 21 Jun 2026 22:08:15 -0400
X-ME-Sender: <xms:D5k4atINjJyl5eG7LW_0FwzB2IhvqBaT3tm3tPebpJRlIeCLsGqscw>
    <xme:D5k4aj9iMzGXVV88HVkDB2qiW1kFUlTdOXZ7wKIHNT2wRyLpuvChjNRNBPQqALi28
    PqlF2rW8jYXAETcrT1HjzAMWpQX5Ve2ChFF_BUb9kr93pJzdJmOfq0>
X-ME-Proxy-Cause: dmFkZTEqp5PbI8W/fg4jA8yEu3z63pwEHW/SfaQUwYpdYeGBuEMteK2EZCPwgDoFkZZySn
    nptB49FXQNjXCMsEt583pu/bISj9VwWCZnE+F6Q3u4MRcBMOAD4KpwzzF1TvcUOFTVz0jV
    CsQePa4TiMKvG8GKOLxCEdRFe+pHwI/bLMZypTFozFh2FOa2s1dcmhAoGP+3DUGSC9rTO7
    u4purM/cL0QSLp3sXMisp9Er0omuMJhAYpNJVtIE/4U3WRUSbIVXYRE60OoglPVmcYwZ+E
    omQJ4uFCH/5+TmIOeIj3s1D1Rm/WGu+7j/VNE3htaN/Ph/BCPYgb6jPP0lHgTQOaKaSySl
    m1PS74SvlZEsA6pxrIp/6KIRbMsTcJsDU6ByT24rJp3L5gwoey6jT7D+BzH4/rn0TNI/xc
    m8AERGZVTtbqpAo6dnmoYwZrh3/w2p/woiMh/sOFlyH/SQOSMx0m3BcC8ILpmk+tG/ChgO
    hDi9OFSj3mtywogDhCaE5GXHEdJClBnii3GRPrP1cATj6LsJA5vV2uLLkaYz/Aq70qqgpl
    DsmZGcnSyh8IGz9wzmB2xOUi6pdPH3Sm3Wg6v8IWCuFpHxTe7owdGO5Y2IUC4Da64dBh1v
    Y4+YT16OR6/x2Ai8jSnkzaiCcNiD5cbxEsqJDl4+K7m002q7i6dtFyLO9g5A
X-ME-Proxy: <xmx:D5k4agW2y118ywgDZ6F7RpTQsOqbZZYfTI27nVgR6TtnhR-t6JcBLw>
    <xmx:D5k4asNZu4trwjO1wiEcJfVuFy6dWynQ-SB8zplJGjjz5wXTt0D6Xw>
    <xmx:D5k4aiBllzmaN6OOxnF1bOEkeBgEAQQY8nDqiNBO-TF-RLFPTCnqrg>
    <xmx:D5k4apeMXRcjEcsUMxAGLx98E7yELcR9LCbgdLVOATSYZq0jCfAzkA>
    <xmx:D5k4ahOkQQFs3NjjNWhzBTKfgfU9WB-hj6I6L6T1X7SUiPXe_BeAj4Ao>
Feedback-ID: i6c764b6b:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E9B04216008A; Sun, 21 Jun 2026 22:08:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AsMRFVFyfdEo
Date: Sun, 21 Jun 2026 21:07:54 -0500
From: "Ira Weiny" <iweiny@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Alison Schofield" <alison.schofield@intel.com>
Cc: "Dan Williams" <djbw@kernel.org>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Message-Id: <0c692784-b09d-40cf-ad6b-abf067f72b20@app.fastmail.com>
In-Reply-To: 
 <CAHk-=whPaVoqWyFEgTYW7LNZOegBmP3YFcrbxCmXTgqVjytdyA@mail.gmail.com>
References: <ajQnMABCFUbVndvc@aschofie-mobl2.lan>
 <CAHk-=whPaVoqWyFEgTYW7LNZOegBmP3YFcrbxCmXTgqVjytdyA@mail.gmail.com>
Subject: Re: [GIT PULL] NVDIMM and DAX for 7.2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Jun 18, 2026, at 6:35 PM, Linus Torvalds wrote:
> On Thu, 18 Jun 2026 at 10:13, Alison Schofield
> <alison.schofield@intel.com> wrote:
>>
>> Please pull to receive a small set of NVDIMM and DAX changes. Also
>> included are updates to the MAINTAINER file, one which adds me as
>> I'm picking up the patch wrangling role from Ira Weiny.
>
> So I've pulled this, but generally I really prefer to have a heads-up
> ahead of time that I should expect to get pull requests from new
> maintainers.
>
> Yes, yes, I see the updates to maintainer files etc, but a "expect the
> next pull from Xyz" from the previous maintainer just makes me not
> have to wonder what's going on...

This is totally my fault as the last PR I did I was not ready to announce this change.  I should have just sent an additional note about this.

Apologies,
Ira

>
>             Linus
