Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B538A1FC3
	for <nvdimm@lists.linux.dev>; Mon, 12 May 2025 23:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747091567; cv=none; b=s2HtDuoiiqb2qWPPsqmBNbI1FQNnPHKYoxMkdBKnThXPTRrVLsjwE4WbwVHO0ecckQG6Bj054lTjSo1pnryamh4NTcG0EihpR5VUfRyBe80g3xTfeYLMLZ2KVHKH4vIgmzVlVtQuBSp+bz6gmghIadUsPnWIvPudjI7h96GFTUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747091567; c=relaxed/simple;
	bh=mT0j3WCK/jvX+5GoG0x17TyuaepSVBrwlhgtq6VnQMI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WkUcx8Wz9KDwGbUNYHoasE3hiSgUBluO4OH5DTzXxRNR9iy6kKBIdCC3MTibYhxcEJ4rN3YSoLgdRqq6FykXiyTZNVpBJzqpyiDCtgRIyJY9jG7UsVRyIBUlJtl9JGFxiVuGd5sBygRNNojju6ioE1jMGkAFhFaQdcJzQqOp/oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EQrDPCPj; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EQrDPCPj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747091566; x=1778627566;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=mT0j3WCK/jvX+5GoG0x17TyuaepSVBrwlhgtq6VnQMI=;
  b=EQrDPCPj89knInvKEu/cHlqE+rPrj/O037RLd/nLbP0B5Ms7hrgs+5tU
   rCWyWEy49TogxjfB2XArnsNXnqVBmDGXSR+k+gI8KR/s8gC/vGhi8SkoC
   e5/gtwVOx+MWWJviUl9Uo71zYXmEBlr+ntk/GuDl2yYuZHBnHHJ/rUxLX
   ZwHbavB9JE+yJaqBy02r/j8fdq1G079nrRfAFH+nR5sG7OsKuiVgTCZlo
   YTN2oOGDmI9K981JjHmVDqp3lfrmupFqxJgg28xVh9I0Q7nUf12BvxCgD
   BwXHpZQXKQ7z3/6F4NSuRvbZHwdLpooVSzpy4Y0Va3Yj9vggllsBIk0cT
   Q==;
X-CSE-ConnectionGUID: i2o9W4BmRqOhRYyLpmvrkQ==
X-CSE-MsgGUID: 1VYkZnLWRvm3vVdc+5duWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="52567780"
X-IronPort-AV: E=Sophos;i="6.15,283,1739865600"; 
   d="scan'208";a="52567780"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 16:12:46 -0700
X-CSE-ConnectionGUID: sZ+0+7y7Q164RMg7bWqgew==
X-CSE-MsgGUID: 9Tbf+Tw4R/WVKtpviLdzzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,283,1739865600"; 
   d="scan'208";a="137537333"
Received: from unknown (HELO [10.24.8.159]) ([10.24.8.159])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 16:12:44 -0700
Message-ID: <4c923c9d-7e41-42f5-802d-0199c91ec188@linux.intel.com>
Date: Mon, 12 May 2025 16:12:35 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Marc Herbert <marc.herbert@linux.intel.com>
Subject: Re: [ndctl PATCH] test: fail on unexpected kernel error & warning,
 not just "Call Trace"
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <20250510012046.1067514-1-marc.herbert@linux.intel.com>
 <aCI_ZxeC7r3UpkvZ@aschofie-mobl2.lan>
Content-Language: en-US
In-Reply-To: <aCI_ZxeC7r3UpkvZ@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thanks for the prompt feedback!

On 2025-05-12 11:35, Alison Schofield wrote:

> Since this patch is doing 2 things, the the journalctl timing, and
> the parse of additional messages, I would typically ask for 2 patches,
> but - I want to do even more. I want to revive an old, unmerged set
> tackling similar work and get it all tidy'd up at once.
> 
> https://lore.kernel.org/all/cover.1701143039.git.alison.schofield@intel.com/
>   cxl/test: add and use cxl_common_[start|stop] helpers
>   cxl/test: add a cxl_ derivative of check_dmesg()
>   cxl/test: use an explicit --since time in journalctl
> 
> Please take a look at how the prev patch did journalctl start time.

We've been using a "start time" in
https://github.com/thesofproject/sof-test for many years and it's been
only "OK", not great. I did not know about the $SECONDS magic variable
at the time, otherwise I would have tried it in sof-test! The main
advantage of $SECONDS: there is nothing to do, meaning there is no
"cxl_common_start()" to forget or do wrong. Speaking of which: I tested
this patch on the _entire_ ndctl/test, not just with --suite=cxl whereas
https://lore.kernel.org/all/d76c005105b7612dc47ccd19e102d462c0f4fc1b.1701143039.git.alison.schofield@intel.com/
seems to have a CXL-specific "cxl_common_start()" only?

Also, in my experience some sort of short COOLDOWN is always necessary
anyway for various reasons:
- Some tests can sometimes have "after shocks" and a cooldown helps
  with most of these.
- A short gap in the logs really help with their _readability_.
- Clocks can shift, especially inside QEMU (I naively tried to increase
  the number of cores in run_qemu.sh but had to give up due so "clock skew")
- Others I probably forgot.

On my system, the average, per-test duration is about 10s and I find that
10% is an acceptable price to pay for the peace of mind. But a starttime
should hopefully work too, at least for the majority of the time.


> I believe the kmesg_fail... can be used to catch any of the failed
> sorts that the old series wanted to do.

Yes it does, I tried to explain that but afraid my English wasn't good
enough?

> Maybe add a brief write up of how to use the kmesg choices per
> test and in the common code.

Q.E.D ;-)

> Is the new kmesg approach going to fail on any ERROR or WARNING that
> we don't kmesg_no_fail_on ?

Yes, this is the main purpose. The other feature is failing when
any of the _expected_ ERROR or WARNING is not found.

> And then can we simply add dev_dbg() messages to fail if missing.

I'm afraid you just lost me at this point... my patch already does that
without any dev_dbg()...?

> I'll take a further look for example at the poison test. We want
> it to warn that the poison is in a region. That is a good and
> expected warning.  However, if that warn is missing, then the test
> is broken! It might not 'FAIL', but it's no longer doing what we
> want.

I agree: the expected "poison inject" and "poison clear" messages should
be in the kmsg_fail_if_missing array[], not in the kmsg_no_fail_on[]
array. BUT in my experience this makes cxl-poison.sh fail when run
multiple times.  So yes: there seems to be a problem with this test.  (I
should probably file a bug somewhere?) So I put them in
kmsg_fail_if_missing[] for now because I don't have time to look into it
now and I don't think a problem in a single test should hold back the
improvement for the entire suite that exposes it. Even with just
kmsg_no_fail_on[], this test is still better than now.

BTW this is a typical game of whack-a-mole every time you try to tighten
a test screw. In SOF it took 4-5 years to finally catch all firmware
errors: https://github.com/thesofproject/sof-test/issues/297



> So, let's work on a rev 2 that does all the things of both our
> patches. I'm happy to work it with you, or not.

I agree the COOLDOWN / starttime is a separate feature. But... I needed it
for the tests to pass! I find it important to keep the tests all passing
in every commit for bisectability etc., hope you agree. Also, really hard
to submit anything that does not pass the tests :-)

As of now, the tests tolerate cross-test pollution. Being more
demanding when inspecting the logs obviously makes them fail, at least
sometimes. I agree the "timing" solution should go first, so here's
a suggested plan:

1. a) Either I resubmit my COOLDOWN alone,
   b) or you generalize your cxl_common_start()/starttime to non-CXL tests.

No check_dmesg() change yet. "cxl_check_dmesg()" is abandoned forever.

Then:

2. I rebase and resubmit my kmsg_no_fail_on=...

This will give more time for people to try and report any issue in the
timing fix 1. - whichever is it.

In the 1.a) case, I think your [cxl_]common_start() de-duplication is
99% independent and can be submitted at any point.


Thoughts?

PS: keep in mind I may be pulled in other priorities at any time :-(
